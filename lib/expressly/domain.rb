module Expressly
  class Customer
    attr_accessor :first_name, :last_name, :gender, :billing_address_index, :shipping_address_index,
    :company_name, :date_of_birth, :tax_number, :last_updated,
    :online_identity_list, :phone_number_list, :email_address_list, :address_list,
    :last_order_date, :number_of_orders
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def gender=(gender)
      Gender::assertValidValue(type)
      @gender = gender
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      phone_number_list = ''
      email_address_list = ''
      address_list = ''

      Customer.new({
        :first_name => json['firstName'],
        :last_name => json['lastName'],
        :gender => json['gender'],
        :billing_address_index => json['billingAddress'].to_i,
        :shipping_address_index => json['shippingAddress'].to_i,
        :company_name => json['company'],
        :date_of_birth => json['dob'],
        :tax_number => json['taxNumber'],
        :last_updated => json['dateUpdated'],

        :online_identity_list => OnlineIdentity.from_json_list(json['onlinePresence']),
        :phone_number_list => PhoneNumber.from_json_list(json['phones']),
        :email_address_list => EmailAddress.from_json_list(json['emails']),
        :address_list => PhoneNumber.from_json_list(json['addresses']),

        :last_order_date => json['dateLastOrder'],
        :number_of_orders => json['numberOrdered'].to_i
      })
    end

    def to_json()
      JSON.generate({
        :firstName => @first_name,
        :lastName => @last_name,
        :gender => @gender,
        :shippingAddress => @billing_address_index,
        :shippingAddress => @shipping_address_index,
        :company => @company_name,
        :dob => @date_of_birth,
        :taxNumber => @tax_number,
        :onlinePresence => @online_identity_list,
        :dateUpdated => @last_updated,
        :dateLastOrder => @last_order_date,
        :numberOrdered => @number_of_orders,
        :emails => @email_address_list,
        :phones => @phone_number_list,
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
    
    def to_json()
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

  class PhoneNumber
    include Expressly::Helper
    attr_accessor  :type, :number, :country_code
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def type=(type)
      PhoneNumberType::assertValidValue(type)
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
      PhoneNumber.new({
        :type => json['type'],
        :number => json['number'],
        :country_code => json['countryCode'].to_i
      })
    end

    def self.from_json_list(json)
      if json.nil? then return [] end
      
      list = []
      json.each do |entity|
        list << PhoneNumber.from_json(entity)
      end
      return list
    end
    
    def to_json()
      JSON.generate({
        :type => @type.to_s,
        :number => @number,
        :countryCode => @country_code
      })
    end
  end

  class PhoneNumberType < Enumeration
    self.add_item(:Mobile, "M")
    self.add_item(:Home, "H")
    self.add_item(:Work, "W")
    self.add_item(:Landline, "L")
    self.add_item(:Personal, "P")
  end

  class EmailAddress
    attr_accessor  :email_address, :alias
    def initialize(attribute_value_map = {})
      attribute_value_map.map { |(k, v)| public_send("#{k}=", v) }
      self.freeze
    end

    def ==(object)
      ObjectHelper.equals(self,object)
    end

    def self.from_json(json)
      EmailAddress.new({
        :email_address => json['emailAddress'],
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

    def to_json()
      JSON.generate({
        :emailAddress => @email_address,
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

    def to_json()
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

end
