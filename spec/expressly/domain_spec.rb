require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'expressly/domain'

module Expressly
  describe "CustomerImport" do
    it "initialises correctly using a hashmap and be immutable once initialised" do
      entityMap = {
        :metadata => {:sender => 'me'},
        :primary_email => 'p@test.com',
        :cart => Cart.new( { :coupon_code => 'coupon', :product_id => 'product'}),
        :customer => Customer.new({:first_name => 'adam'})
      }
      entity = CustomerImport.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
      expect { entity.primary_email = '2345@test.com' }.to raise_error
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate( {
        :migration => {
        :meta => { :sender => 'me' },
        :data => {
        :email => 'p@test.com',
        :customerData => {
        :firstName => 'adam'
        }
        }
        },
        :cart => {
        :couponCode => 'coupon',
        :productId => 'product'
        }
      })

      entity = CustomerImport.from_json(JSON.parse(payload))
      entity.metadata['sender'].should == 'me'
      entity.primary_email.should == 'p@test.com'
      entity.customer.first_name.should == 'adam'
      entity.cart.coupon_code == 'coupon'
      entity.cart.product_id.should == 'product'
    end
  end

  describe "CustomerExport" do
    it "initialises correctly using a hashmap and be immutable once initialised" do
      entityMap = {
        :metadata => {:sender => 'me'},
        :primary_email => 'p@test.com',
        :customer => Customer.new({:first_name => 'adam'})
      }
      entity = CustomerExport.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
      expect { entity.primary_email = '2345@test.com' }.to raise_error
    end

    it "can generate the json payload" do
      entityMap = {
        :metadata => {:sender => 'me'},
        :primary_email => 'p@test.com',
        :customer => Customer.new({:first_name => 'adam'})
      }
      payload = JSON.parse(CustomerExport.new(entityMap).to_json())
      payload['meta']['sender'].should == 'me'
      payload['data']['email'].should == 'p@test.com'
      payload['data']['customerData']['firstName'].should == 'adam'
    end
  end

  describe "Cart" do
    it "initialises correctly using a hashmap" do
      entityMap = { :coupon_code => 'coupon', :product_id => 'product'}
      entity = Cart.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :coupon_code => 'coupon', :product_id => 'product'}
      entity = Cart.new(entityMap)
      expect { entity.coupon_code = '2345' }.to raise_error
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :couponCode => 'coupon', :productId => 'product' })
      entity = Cart.from_json(JSON.parse(payload))
      entity.coupon_code.should == 'coupon'
      entity.product_id.should == 'product'
    end
  end

  describe "Phone" do
    it "initialises correctly using a hashmap" do
      entityMap = { :type => PhoneType::Work, :number => '1234', :country_code => 44 }
      entity = Phone.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :type => PhoneType::Work, :number => '1234' }
      entity = Phone.new(entityMap)
      expect { entity.number = '2345' }.to raise_error
    end

    it "should raise an error if phone type is not valid" do
      expect { Phone.new({ :type => "CellHomeWork" }) }.to raise_error
    end

    it "should raise an error if country_code is not an integer" do
      expect { Phone.new({ :country_code => "44" }) }.to raise_error
    end

    it "should not raise an error if country_code is supplied but blank" do
      Phone.new({ :country_code => '' })
      Phone.new({ :country_code => nil })
    end

    it "implements equals correctly" do
      phone1 = Phone.new({ :type => PhoneType::Work, :number => '1234' })
      phone2 = Phone.new({ :type => PhoneType::Work, :number => '1234' })
      phone1.should == phone2
      phone2.should == phone1

      phone3 = Phone.new({ :type => PhoneType::Home, :number => '1234' })
      phone1.should_not == phone3
      phone3.should_not == phone1

      phone4 = Phone.new({ :type => PhoneType::Work, :number => '2345' })
      phone1.should_not == phone4
      phone4.should_not == phone1

      phone5 = Phone.new({ :type => PhoneType::Work })
      phone1.should_not == phone5
      phone5.should_not == phone1

      phone6 = Phone.new({ :number => '1234' })
      phone1.should_not == phone6
      phone6.should_not == phone1

      phone7 = Phone.new({ :type => PhoneType::Work, :number => nil })
      phone8 = Phone.new({ :type => PhoneType::Work })
      phone7.should == phone8
      phone8.should == phone7

    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :type => 'W', :number => '1234', :countryCode => 44 })
      entity = Phone.from_json(JSON.parse(payload))
      entity.type.should == PhoneType::Work
      entity.number.should == '1234'
      entity.country_code.should ==  44

      entityCopy = Phone.from_json(JSON.parse(entity.to_json))
      entityCopy.type.should == PhoneType::Work
      entityCopy.number.should == '1234'
      entityCopy.country_code.should ==  44
      entity.should == entityCopy
    end
  end

  describe "EmailAddress" do
    it "initialises correctly using a hashmap" do
      entityMap = { :email => 'm@test.com', :alias => 'personal' }
      entity = EmailAddress.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :email => 'm@test.com', :alias => 'personal' }
      entity = EmailAddress.new(entityMap)
      expect { entity.email = 'n@test.com' }.to raise_error
    end

    it "implements equals correctly" do
      email1 = EmailAddress.new({ :email => 'm@test.com', :alias => 'personal' })
      email2 = EmailAddress.new({ :email => 'm@test.com', :alias => 'personal' })
      email3 = EmailAddress.new({ :email => 'n@test.com', :alias => 'personal' })
      email1.should == email2
      email2.should == email1
      email1.should_not == email3
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :email => 'm@test.com', :alias => 'personal' })
      entity = EmailAddress.from_json(JSON.parse(payload))
      entity.email.should == 'm@test.com'
      entity.alias.should ==  'personal'

      entityCopy = EmailAddress.from_json(JSON.parse(entity.to_json))
      entity.email.should == 'm@test.com'
      entity.alias.should ==  'personal'
      entity.should == entityCopy
    end
  end

  describe "Customer" do
    it "initialises correctly using a hashmap" do
      entityMap = {
        :first_name => 'First',
        :last_name => 'Last',
        :gender => Gender::Male,
        :billing_address_index => 0,
        :shipping_address_index => 1,
        :company_name => 'Company',
        :date_of_birth => Date.parse('1975-08-14'),
        :tax_number => 'Tax#',
        :last_updated => DateTime.now,

        :online_identity_list => [
        OnlineIdentity.new({ :type => OnlineIdentityType::Twitter, :identity => '@ev' }),
        OnlineIdentity.new({ :type => OnlineIdentityType::Facebook, :identity => 'fb.ev' })],

        :phone_list => [
        Phone.new({ :type => PhoneType::Work, :number => '12345' }),
        Phone.new({ :type => PhoneType::Mobile, :number => '56789' })],

        :email_list => [
        EmailAddress.new({ :email => 'm@test.com', :alias => 'personal' }),
        EmailAddress.new({ :email => 'w@test.com', :alias => 'work' })],

        :address_list => [
        Address.new({:first_name => 'f1', :address_1 => 'one'}),
        Address.new({:first_name => 'f2', :address_1 => 'two'})],

        :last_order_date => Date.parse('2015-09-14'),
        :number_of_orders => 2
      }
      entity = Customer.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }

      expect { entity.first_name = 'Donald' }.to raise_error
      entity.should == Customer.new(entityMap)
    end

    it "should raise an error if phone_index is not an integer" do
      expect { Address.new({ :phone_index => "1" }) }.to raise_error
    end

    it "should not raise an error if country_code is supplied but blank" do
      Address.new({ :phone_index => '' })
      Address.new({ :phone_index => nil })
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({
        :firstName => 'First',
        :lastName => 'Last',
        :gender => 'M',
        :billingAddress => 1,
        :shippingAddress => 0,
        :company => 'Company',
        :dob => '1975-08-14',
        :taxNumber => 'Tax#',
        :dateUpdated => '2015-08-14T08:00:00',

        :onlinePresence => [
        { :field => 'twitter', :value => '@ev' },
        { :field => 'facebook', :value => 'fb.ev' }],

        :phones => [
        { :type => 'W', :number => '12345' },
        { :type => 'M', :number => '56789' }],

        :emails => [
        { :email => 'm@test.com', :alias => 'personal' },
        { :email => 'w@test.com', :alias => 'work' } ],

        :addresses => [
        {:firstName => 'f1', :address1 => 'one'},
        {:firstName => 'f2', :address1 => 'two'}],

        :dateLastOrder => '2015-09-14',
        :numberOrdered => 2 })

      entity = Customer.from_json(JSON.parse(payload))
      entity.first_name.should == 'First'
      entity.last_name.should == 'Last'
      entity.gender.should == Gender::Male
      entity.billing_address_index.should == 1
      entity.shipping_address_index.should == 0
      entity.company_name.should == 'Company'
      entity.date_of_birth.should == Date.parse('1975-08-14')
      entity.tax_number.should == 'Tax#'
      entity.last_updated.should == DateTime.parse('2015-08-14T08:00:00')
      entity.last_order_date.should == Date.parse('2015-09-14')
      entity.number_of_orders.should == 2

      entity.online_identity_list.length.should == 2
      entity.phone_list.length.should == 2
      entity.email_list.length.should == 2
      entity.address_list.length.should == 2

      entityCopy = Customer.from_json(JSON.parse(entity.to_json))
      entity.should == entityCopy
    end
  end

  describe "OnlineIdentity" do
    it "initialises correctly using a hashmap" do
      entityMap = { :type => OnlineIdentityType::Twitter, :identity => '@ev' }
      entity = OnlineIdentity.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :type => OnlineIdentityType::Twitter, :identity => '@ev' }
      entity = OnlineIdentity.new(entityMap)
      expect { entity.identity = '@who' }.to raise_error
    end

    it "should raise an error if phone type is not valid" do
      expect { OnlineIdentity.new({ :type => "AOL" }) }.to raise_error
    end

    it "implements equals correctly" do
      entity1 = OnlineIdentity.new({ :type => OnlineIdentityType::Twitter, :identity => '@ev' })
      entity2 = OnlineIdentity.new({ :type => OnlineIdentityType::Twitter, :identity => '@ev' })
      entity3 = OnlineIdentity.new({ :type => OnlineIdentityType::Twitter, :identity => '@who' })
      entity1.should == entity2
      entity2.should == entity1
      entity1.should_not == entity3
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :field => 'twitter', :value => '@ev' })
      entity = OnlineIdentity.from_json(JSON.parse(payload))
      entity.type.should == OnlineIdentityType::Twitter
      entity.identity.should == '@ev'

      entityCopy = OnlineIdentity.from_json(JSON.parse(entity.to_json))
      entity.should == entityCopy
    end

    it "can be constructed from the json list payload" do
      payload = JSON.generate([{ :field => 'twitter', :value => '@ev' }, { :field => 'facebook', :value => 'http://fb.com/ev' }])
      entity_list = OnlineIdentity.from_json_list(JSON.parse(payload))
      entity_list[0].type.should == OnlineIdentityType::Twitter
      entity_list[0].identity.should == '@ev'
      entity_list[1].type.should == OnlineIdentityType::Facebook
      entity_list[1].identity.should == 'http://fb.com/ev'
    end

    it "nil json list payload produces an empty list" do
      entity_list = OnlineIdentity.from_json_list(nil)
      entity_list.length.should == 0
    end

  end

  describe "Address" do
    it "initialises correctly using a hashmap" do
      entityMap = {
        :first_name => 'Mickey',
        :last_name => 'Duck',
        :address_1 => 'The House',
        :address_2 => 'My Street',
        :city => 'Town',
        :company_name => 'Dosney',
        :zip => 'SW18 1AL',
        :phone_index => 1,
        :address_alias => 'alternative',
        :state_province => 'Bucks',
        :country => 'UK' }
      entity = Address.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :first_name => 'Mickey'}
      entity = Address.new(entityMap)
      expect { entity.first_name = 'Donald' }.to raise_error
    end

    it "should raise an error if phone_index is not an integer" do
      expect { Address.new({ :phone_index => "1" }) }.to raise_error
    end

    it "should not raise an error if country_code is supplied but blank" do
      Address.new({ :phone_index => '' })
      Address.new({ :phone_index => nil })
    end

    it "implements equals correctly" do
      entityMap = {
        :first_name => 'Mickey',
        :last_name => 'Duck',
        :address_1 => 'The House',
        :address_2 => 'My Street',
        :city => 'Town',
        :company_name => 'Dosney',
        :zip => 'SW18 1AL',
        :phone_index => 1,
        :address_alias => 'alternative',
        :state_province => 'Bucks',
        :country => 'UK' }
      entity1 = Address.new(entityMap)
      entity2 = Address.new(entityMap)
      entity1.should == entity2
      entity2.should == entity1

      entityMap[:first_name] = 'Who'
      entity3 = Address.new(entityMap)
      entity1.should_not == entity3
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({
        :firstName => 'Mickey',
        :lastName => 'Duck',
        :address1 => 'The House',
        :address2 => 'My Street',
        :city => 'Town',
        :companyName => 'Dosney',
        :zip => 'SW18 1AL',
        :phone => 1,
        :alias => 'alternative',
        :stateProvince => 'Bucks',
        :country => 'UK' })
      entity = Address.from_json(JSON.parse(payload))
      entity.first_name.should == 'Mickey'
      entity.last_name.should == 'Duck'
      entity.address_1.should == 'The House'
      entity.address_2.should == 'My Street'
      entity.company_name.should == 'Dosney'
      entity.zip.should == 'SW18 1AL'
      entity.phone_index.should == 1
      entity.address_alias.should == 'alternative'
      entity.state_province.should == 'Bucks'
      entity.country.should == 'UK'

      entityCopy = Address.from_json(JSON.parse(entity.to_json))
      entity.should == entityCopy
    end
  end

  describe "CustomerStatuses" do
    it "initialises correctly and emails can be added" do
      entity = CustomerStatuses.new()
      entity.add_existing("e1@test.com")
      entity.add_existing("e2@test.com")
      entity.add_pending("p1@test.com")
      entity.add_deleted("d1@test.com")

      entity.existing.should == ["e1@test.com", "e2@test.com"]
      entity.pending.should == ["p1@test.com"]
      entity.deleted.should == ["d1@test.com"]
    end
  end

  describe "CustomerInvoiceRequest" do
    it "initialises correctly" do
      entity = CustomerInvoiceRequest.new("m@test.com", "2015-06-12", "2015-07-12")
      entity.email.should == "m@test.com"
      entity.from.should == Date.parse("2015-06-12")
      entity.to.should == Date.parse("2015-07-12")
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :email => 'm@test.com', :from => '2015-06-12', :to => '2015-07-12' })
      entity = CustomerInvoiceRequest.from_json(JSON.parse(payload))
      entity.email.should == "m@test.com"
      entity.from.should == Date.parse("2015-06-12")
      entity.to.should == Date.parse("2015-07-12")
    end

    it "can be constructed from the json list payload" do
      payload = JSON.generate([
        { :email => 'm@test.com', :from => '2015-06-12', :to => '2015-07-12' },
        { :email => 'n@test.com', :from => '2016-06-12', :to => '2016-07-12' }])

      entity_list = CustomerInvoiceRequest.from_json_list(JSON.parse(payload))
      entity_list[0].email.should == "m@test.com"
      entity_list[0].from.should == Date.parse("2015-06-12")
      entity_list[0].to.should == Date.parse("2015-07-12")
      entity_list[1].email.should == "n@test.com"
      entity_list[1].from.should == Date.parse("2016-06-12")
      entity_list[1].to.should == Date.parse("2016-07-12")
    end

    it "nil json list payload produces an empty list" do
      entity_list = CustomerInvoiceRequest.from_json_list(nil)
      entity_list.length.should == 0
    end

  end

  describe "CustomerOrder" do
    it "initialises correctly" do
      entity_map = {
        :order_id => 'orderid',
        :order_date => '2015-08-14',
        :item_count => 5,
        :coupon_code => 'coupon',
        :currency => 'GBP',
        :pre_tax_total => 100.15,
        :post_tax_total => 120.65,
        :tax => 20.50 }
      entity = CustomerOrder.new(entity_map)
      entity.order_id.should == "orderid"
      entity.order_date.should == Date.parse("2015-08-14")
      entity.item_count.should == 5
      entity.coupon_code.should == "coupon"
      entity.currency.should == "GBP"
      entity.pre_tax_total.should == 100.15
      entity.post_tax_total.should == 120.65
      entity.tax.should == 20.50
    end

    it "it can generate the expected json payload" do
      entity_map = {
        :order_id => 'orderid',
        :order_date => '2015-08-14',
        :item_count => "5",
        :coupon_code => 'coupon',
        :currency => 'GBP',
        :pre_tax_total => '100.15',
        :post_tax_total => '120.65',
        :tax => '20.50' }
      json = CustomerOrder.new(entity_map).to_json()
      payload = JSON.parse(json)

      payload['id'].should == "orderid"
      payload['date'].should == "2015-08-14"
      payload['itemCount'].should == 5
      payload['coupon'].should == "coupon"
      payload['currency'].should == "GBP"
      payload['preTaxTotal'].should == 100.15
      payload['postTaxTotal'].should == 120.65
      payload['tax'].should == 20.50
    end

  end

  describe "CustomerInvoice" do
    it "initialises correctly" do
      entity = CustomerInvoice.new('email@test.com')
      entity.email.should == 'email@test.com'
    end

    it "it can generate the expected json payload" do
      entity = CustomerInvoice.new('email@test.com')

      entity.add_order(CustomerOrder.new({
        :order_id => 'orderid',
        :order_date => '2015-08-14',
        :item_count => 5,
        :coupon_code => 'coupon',
        :currency => 'GBP',
        :pre_tax_total => '100.15',
        :post_tax_total => '120.65',
        :tax => '20.50' }))

      entity.add_order(CustomerOrder.new({
        :order_id => 'orderid1',
        :order_date => '2015-08-14',
        :item_count => 2,
        :coupon_code => 'coupon',
        :currency => 'GBP',
        :pre_tax_total => '50.15',
        :post_tax_total => '60.65',
        :tax => '10.50' }))

      payload = JSON.parse(entity.to_json())
      payload['email'].should == 'email@test.com'
      payload['orderCount'].should == 2
      payload['preTaxTotal'].should == 150.30
      payload['postTaxTotal'].should == 181.30
      payload['tax'].should == 31.0

      order1 = payload['orders'][0]
      order1['id'].should == "orderid"
      order1['date'].should == "2015-08-14"
      order1['itemCount'].should == 5
      order1['coupon'].should == "coupon"
      order1['currency'].should == "GBP"
      order1['preTaxTotal'].should == 100.15
      order1['postTaxTotal'].should == 120.65
      order1['tax'].should == 20.50

      order2 = payload['orders'][1]
      order2['id'].should == "orderid1"
      order2['date'].should == "2015-08-14"
      order2['itemCount'].should == 2
      order2['coupon'].should == "coupon"
      order2['currency'].should == "GBP"
      order2['preTaxTotal'].should == 50.15
      order2['postTaxTotal'].should == 60.65
      order2['tax'].should == 10.50

      payload_list = JSON.parse(CustomerInvoice.to_json_from_list([entity, entity]))
      payload_list['invoices'].length.should == 2
      payload_list['invoices'][0]['postTaxTotal'].should == 181.30
      payload_list['invoices'][0]['orders'][0]['id'].should == 'orderid'
    end

  end

end