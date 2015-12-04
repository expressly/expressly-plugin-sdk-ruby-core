require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Expressly
  merchant_uuid = '61c8c55e-9365-11e5-ac6c-281878baaac8'
  campaign_customer_uuid = '140d190c-b73c-4e59-aa01-c838c4ddde9d'
  api_key = '61c8c55e-9365-11e5-ac6c-281878baaac8:d62e517165bf86562d7fe0dbf8ac2076'
  api_url = 'http://localhost:8080/api'
  api = Expressly::Api.new(api_key, api_url)
  FakeWeb.allow_net_connect = false

  describe "Api" do

    it "can ping" do
      FakeWeb.register_uri(:get, "http://#{api_key}@localhost:8080/api/v1/merchant/ping",
                           :body => '{"success":true,"msg":"61c8c55e-9365-11e5-ac6c-281878baaac8"}')
      api.ping?.should == true
    end

    it "it can install" do
      FakeWeb.register_uri(:post, "http://#{api_key}@localhost:8080/api/v2/plugin/merchant",
                           :status => ["204", "No Content"])
      api.install("http://localhost:3000")
    end

    it "it can uninstall" do
      FakeWeb.register_uri(:delete, "http://#{api_key}@localhost:8080/api/v2/plugin/merchant/#{merchant_uuid}",
                           :body => '{"success":true,"msg":"Merchant uninstalled"}')
      api.uninstall?.should == true
    end

    it "it can fetch poup html" do
      FakeWeb.register_uri(:get, "http://#{api_key}@localhost:8080/api/v2/migration/#{campaign_customer_uuid}",
                           :body => '<b>pop</b>')
      response = api.fetch_migration_confirmation_html(campaign_customer_uuid)
      response.should == '<b>pop</b>'
    end

    it "it can fetch customer data" do
      FakeWeb.register_uri(:get, "http://#{api_key}@localhost:8080/api/v2/migration/#{campaign_customer_uuid}/user",
                           :body => '{ "migration":{"meta":{"sender":"2"},"data":{"email":"m@9ls.com","customerData":' +
                               '{"firstName":"Marc","lastName":"Smith","gender":"M","billingAddress":0,"shippingAddress":0,' +
                               '"dateUpdated":"2015-11-25T13:21:04.000Z","numberOrdered":0,' +
                               '"onlinePresence":[{"field":"twitter","value":"mgsmith57"}],"emails":[{"email":"someone@test.com"}],' +
                               '"phones":[{"type":"L","number":"020 7946 0975","countryCode":44}],' +
                               '"addresses":[{"firstName":"Marc","lastName":"SMith","address1":"61 Wellfield Road","city":"Roath","zip":"CF24 3DG","phone":0,"stateProvince":"Cardiff","country":"GB"}]}}},' +
                               '"cart":{"couponCode":"coupon","productId":"product"}}')
      customer_import = api.fetch_customer_data(campaign_customer_uuid)
      customer_import.metadata.should == {"sender" => "2"}
      customer_import.cart.coupon_code.should == 'coupon'
      customer_import.cart.product_id.should == 'product'
      customer_import.primary_email.should == 'm@9ls.com'
      customer_import.customer.first_name.should == 'Marc'
      customer_import.customer.last_name.should == 'Smith'
      customer_import.customer.gender.should == Gender::Male
      customer_import.customer.billing_address_index.should == 0
      customer_import.customer.shipping_address_index.should == 0
      customer_import.customer.last_updated.should == DateTime.parse('2015-11-25T13:21:04+00:00')
      customer_import.customer.online_identity_list[0].type.should == OnlineIdentityType::Twitter
      customer_import.customer.online_identity_list[0].identity.should == 'mgsmith57'
      customer_import.customer.email_list[0].email.should == 'someone@test.com'
      customer_import.customer.phone_list[0].number.should == '020 7946 0975'
      customer_import.customer.phone_list[0].type.should == PhoneType::Landline
      customer_import.customer.phone_list[0].country_code.should == 44
      customer_import.customer.address_list[0].first_name.should == 'Marc'
      customer_import.customer.address_list[0].last_name.should == 'SMith'
      customer_import.customer.address_list[0].address_1.should == '61 Wellfield Road'
      customer_import.customer.address_list[0].city.should == 'Roath'
      customer_import.customer.address_list[0].zip.should == 'CF24 3DG'
      customer_import.customer.address_list[0].phone_index.should == 0
      customer_import.customer.address_list[0].state_province.should == 'Cardiff'
      customer_import.customer.address_list[0].country.should == 'GB'
    end

    it "it can report the migration was successful" do
      FakeWeb.register_uri(:post, "http://#{api_key}@localhost:8080/api/v2/migration/#{campaign_customer_uuid}/success",
                           :body => '{"success":true,"msg":"User registered as migrated"}')
      response = api.confirm_migration_success?(campaign_customer_uuid)
      response.should == true
    end

    it "it can parse the expressly error payload" do
      FakeWeb.register_uri(:get, "http://#{api_key}@localhost:8080/api/v1/merchant/ping",
                           :status => ["400", "Bad Request"],
                           :content_type => "application/json",
                           :body => '{' +
                               '"id":"tid",' +
                               '"message":"Bad Request",' +
                               '"code":"USER_ALREADY_MIGRATED",' +
                               '"description":"ON NO",' +
                               '"causes":["cause"],' +
                               '"actions":["action"]}')
      begin
        api.ping?
      rescue ExpresslyError => e
        e.id.should == 'tid'
        e.message.should == 'Bad Request'
        e.code.should == 'USER_ALREADY_MIGRATED'
        e.description.should == 'ON NO'
        e.causes[0].should == 'cause'
        e.actions[0].should == 'action'
      end
    end

    it "if it can parse the expressly error payload it will throw an http error" do
      FakeWeb.register_uri(:get, "http://#{api_key}@localhost:8080/api/v1/merchant/ping",
                           :status => ["400", "Bad Request"],
                           :body => 'WOW')
      begin
        api.ping?
      rescue HttpError => e
        e.code.should == "400"
        e.body.should == 'WOW'
      end
    end
  end
end

