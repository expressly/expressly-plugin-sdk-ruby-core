module Expressly
  class CustomerImport
    attr_accessor :metadata, :primary_email, :customer, :cart
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      CustomerImport.new({
        :metadata => json['migration']['meta'],
        :primary_email => json['migration']['data']['email'],
        :customer => Customer.from_json(json['migration']['data']['customerData']),
        :cart => Cart.from_json(json['cart'])})
    end
  end

  class CustomerExport
    attr_accessor :metadata, :primary_email, :customer
    
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def to_json(state = nil)
      JSON.generate({
        :meta => @metadata,
        :data => {
          :email => @primary_email,
          :customerData => customer
        }
      })
    end
  end
    
  class Cart
    attr_accessor :coupon_code, :product_id
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      if json.nil? then return nil end
      Cart.new({
        :coupon_code => json['couponCode'],
        :product_id => json['productId']})
    end
  end

  class Customer
    include Expressly::Helper
    attr_accessor :first_name, :last_name, :gender, :billing_address_index, :shipping_address_index,
    :company_name, :date_of_birth, :tax_number, :last_updated,
    :online_identity_list, :phone_list, :email_list, :address_list,
    :last_order_date, :number_of_orders
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def gender=(gender)
      Gender::assertValidValue(gender)
      @gender = gender
    end

    def date_of_birth=(date_of_birth)
      if blank?(date_of_birth) then return end
      @date_of_birth = if date_of_birth.is_a? Date then date_of_birth else Date.parse(date_of_birth) end
    end

    def last_updated=(last_updated)
      if blank?(last_updated) then return end
      @last_updated = if last_updated.is_a? DateTime then last_updated else DateTime.parse(last_updated) end
    end

    def last_order_date=(last_order_date)
      if blank?(last_order_date) then return end
      @last_order_date = if last_order_date.is_a? Date then last_order_date else Date.parse(last_order_date) end
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      Customer.new({
        :first_name => json['firstName'],
        :last_name => json['lastName'],
        :gender => json['gender'],
        :billing_address_index => json['billingAddress'].to_i,
        :shipping_address_index => json['shippingAddress'].to_i,
        :company_name => json['company'],
        :date_of_birth => safe_date_parse(json['dob']),
        :tax_number => json['taxNumber'],
        :last_updated => safe_datetime_parse(json['dateUpdated']),

        :online_identity_list => OnlineIdentity.from_json_list(json['onlinePresence']),
        :phone_list => Phone.from_json_list(json['phones']),
        :email_list => EmailAddress.from_json_list(json['emails']),
        :address_list => Address.from_json_list(json['addresses']),

        :last_order_date => safe_date_parse(json['dateLastOrder']),
        :number_of_orders => json['numberOrdered'].to_i
      })
    end

    def self.safe_date_parse(date)
      date.nil? ? nil : Date.parse(date)
    end

    def self.safe_datetime_parse(datetime)
      datetime.nil? ? nil : DateTime.parse(datetime)
    end

    def to_json(state = nil)
      JSON.generate({
        :firstName => @first_name,
        :lastName => @last_name,
        :gender => @gender,
        :billingAddress => @billing_address_index,
        :shippingAddress => @shipping_address_index,
        :company => @company_name,
        :dob => @date_of_birth,
        :taxNumber => @tax_number,
        :onlinePresence => @online_identity_list,
        :dateUpdated => @last_updated,
        :dateLastOrder => @last_order_date,
        :numberOrdered => @number_of_orders,
        :emails => @email_list,
        :phones => @phone_list,
        :addresses => @address_list
      })
    end
  end

  class Address
    include Expressly::Helper

    attr_accessor :first_name, :last_name, :address_1, :address_2, :city,
    :company_name, :zip, :phone_index, :address_alias, :state_province, :country
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def phone_index=(phone_index)
      if !blank?(phone_index) && !phone_index.is_a?(Integer) then
        throw("phone_index should be an integer [#{phone_index}]")
      end
      @phone_index = phone_index
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      Address.new({
        :first_name => json['firstName'],
        :last_name => json['lastName'],
        :address_1 => json['address1'],
        :address_2 => json['address2'],
        :city => json['city'],
        :company_name => json['companyName'],
        :zip => json['zip'],
        :phone_index => json['phone'],
        :address_alias => json['alias'],
        :state_province => json['stateProvince'],
        :country => json['country']
      })
    end

    def self.from_json_list(json)
      if json.nil? then return [] end

      list = []
      json.each do |entity|
        list << Address.from_json(entity)
      end
      return list
    end

    def to_json(state = nil)
      JSON.generate({
        :firstName => @first_name,
        :lastName => @last_name,
        :address1 => @address_1,
        :address2 => @address_2,
        :city => @city,
        :companyName => @company_name,
        :zip => @zip,
        :phone => @phone_index,
        :alias => @address_alias,
        :stateProvince => @state_province,
        :country => @country
      })
    end
  end

  class Phone
    include Expressly::Helper
    attr_accessor  :type, :number, :country_code
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def type=(type)
      PhoneType::assertValidValue(type)
      @type = type
    end

    def country_code=(country_code)
      if !blank?(country_code) && !country_code.is_a?(Integer) then
        throw("country_code should be an integer [#{country_code}]")
      end
      @country_code = country_code
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      Phone.new({
        :type => json['type'],
        :number => json['number'],
        :country_code => json['countryCode'].to_i
      })
    end

    def self.from_json_list(json)
      if json.nil? then return [] end

      list = []
      json.each do |entity|
        list << Phone.from_json(entity)
      end
      return list
    end

    def to_json(state = nil)
      JSON.generate({
        :type => @type.to_s,
        :number => @number,
        :countryCode => @country_code
      })
    end
  end

  class PhoneType < Enumeration
    self.add_item(:Mobile, "M")
    self.add_item(:Home, "H")
    self.add_item(:Work, "W")
    self.add_item(:Landline, "L")
    self.add_item(:Personal, "P")
  end

  class EmailAddress
    attr_accessor  :email, :alias
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      EmailAddress.new({
        :email => json['email'],
        :alias => json['alias']
      })
    end

    def self.from_json_list(json)
      if json.nil? then return [] end

      list = []
      json.each do |entity|
        list << EmailAddress.from_json(entity)
      end
      return list
    end

    def to_json(state = nil)
      JSON.generate({
        :email => @email,
        :alias => @alias
      })
    end
  end

  class OnlineIdentity
    attr_accessor  :type, :identity
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def type=(type)
      OnlineIdentityType::assertValidValue(type)
      @type = type
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      OnlineIdentity.new({
        :type => json['field'],
        :identity => json['value']
      })
    end

    def self.from_json_list(json)
      if json.nil? then return [] end

      list = []
      json.each do |entity|
        list << OnlineIdentity.from_json(entity)
      end
      return list
    end

    def to_json(state = nil)
      JSON.generate({
        :field => @type.to_s,
        :value => @identity
      })
    end

  end

  class OnlineIdentityType < Enumeration
    self.add_item(:PersonalWebsite, 'website')
    self.add_item(:CompanyWebsite, 'company_website')
    self.add_item(:Twitter, 'twitter')
    self.add_item(:Facebook, 'facebook')
    self.add_item(:LinkedIn, 'linkedin')
    self.add_item(:Pintrest, 'pintrest')
    self.add_item(:Instagram, 'instagram')
  end

  ##
  # Gender valid values
  #
  class Gender < Enumeration
    self.add_item(:Male, "M")
    self.add_item(:Female, "F")
    self.add_item(:Other, "O")
    self.add_item(:NotAvailable, "N")
  end

  class CustomerStatuses
    attr_reader :existing, :pending, :deleted
    def initialize()
      @existing = []
      @pending = []
      @deleted = []
    end

    def add_existing(email)
      @existing << email
    end

    def add_pending(email)
      @pending << email
    end

    def add_deleted(email)
      @deleted << email
    end
  end

  class CustomerInvoiceRequest
    attr_reader :email, :from, :to
    def initialize(email, from, to)
      @email = email
      @from = if from.is_a? Date then from else Date.parse(from) end
      @to = if to.is_a? Date then to else Date.parse(to) end
    end

    def self.from_json(json)
      CustomerInvoiceRequest.new(
      json['email'],
      Date.parse(json['from']),
      Date.parse(json['to']))
    end

    def self.from_json_list(json)
      if json.nil? then return [] end
      list = []
      json.each do |entity|
        list << CustomerInvoiceRequest.from_json(entity)
      end
      return list
    end
  end

  class CustomerInvoice
    attr_reader :email
    def initialize(email)
      @email = email
      @orders = []
      @pre_tax_total = 0.0
      @tax = 0.0
      @post_tax_total = 0.0
    end

    def add_order(order)
      order.freeze
      @orders << order
      @pre_tax_total += order.pre_tax_total.to_f
      @post_tax_total += order.post_tax_total.to_f
      @tax += order.tax.to_f
    end

    def to_json(state = nil)
      JSON.generate(json_attribute_map)
    end

    def self.to_json_from_list(invoice_list)
      json_invoices = []
      invoice_list.each do |invoice|
        json_invoices << invoice.json_attribute_map
      end
      JSON.generate({:invoices => json_invoices })
    end

    def json_attribute_map()
      { :email => @email,
        :orderCount => @orders.length,
        :preTaxTotal => @pre_tax_total,
        :postTaxTotal => @post_tax_total,
        :tax => @tax,
        :orders => @orders}
    end
  end

  class CustomerOrder
    attr_accessor :order_id, :order_date, :item_count, :coupon_code, :currency, :pre_tax_total, :post_tax_total, :tax
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
    end

    def order_date=(order_date)
      @order_date = if order_date.is_a? Date then order_date else Date.parse(order_date) end
    end

    def to_json(state = nil)
      JSON.generate({
        :id => @order_id,
        :date => @order_date,
        :itemCount => @item_count.to_i,
        :coupon => @coupon_code,
        :currency => @currency,
        :preTaxTotal => @pre_tax_total.to_f,
        :postTaxTotal => @post_tax_total.to_f,
        :tax => @tax.to_f})
    end
  end

end
