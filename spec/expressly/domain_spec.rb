require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'expressly/domain'

module Expressly

  describe "PhoneNumber" do
    it "initialises correctly using a hashmap" do
      entityMap = { :type => PhoneNumberType::Work, :number => '1234', :country_code => 44 }
      entity = PhoneNumber.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :type => PhoneNumberType::Work, :number => '1234' }
      entity = PhoneNumber.new(entityMap)
      expect { entity.number = '2345' }.to raise_error
    end

    it "should raise an error if phone type is not valid" do
      expect { PhoneNumber.new({ :type => "CellHomeWork" }) }.to raise_error
    end

    it "should raise an error if country_code is not an integer" do
      expect { PhoneNumber.new({ :country_code => "44" }) }.to raise_error
    end

    it "should not raise an error if country_code is supplied but blank" do
      PhoneNumber.new({ :country_code => '' })
      PhoneNumber.new({ :country_code => nil })
    end

    it "implements equals correctly" do
      phone1 = PhoneNumber.new({ :type => PhoneNumberType::Work, :number => '1234' })
      phone2 = PhoneNumber.new({ :type => PhoneNumberType::Work, :number => '1234' })
      phone1.should == phone2
      phone2.should == phone1

      phone3 = PhoneNumber.new({ :type => PhoneNumberType::Home, :number => '1234' })
      phone1.should_not == phone3
      phone3.should_not == phone1

      phone4 = PhoneNumber.new({ :type => PhoneNumberType::Work, :number => '2345' })
      phone1.should_not == phone4
      phone4.should_not == phone1

      phone5 = PhoneNumber.new({ :type => PhoneNumberType::Work })
      phone1.should_not == phone5
      phone5.should_not == phone1

      phone6 = PhoneNumber.new({ :number => '1234' })
      phone1.should_not == phone6
      phone6.should_not == phone1

      phone7 = PhoneNumber.new({ :type => PhoneNumberType::Work, :number => nil })
      phone8 = PhoneNumber.new({ :type => PhoneNumberType::Work })
      phone7.should == phone8
      phone8.should == phone7

    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :type => 'W', :number => '1234', :countryCode => 44 })
      entity = PhoneNumber.from_json(JSON.parse(payload))
      entity.type.should == PhoneNumberType::Work
      entity.number.should == '1234'
      entity.country_code.should ==  44

      entityCopy = PhoneNumber.from_json(JSON.parse(entity.to_json))
      entityCopy.type.should == PhoneNumberType::Work
      entityCopy.number.should == '1234'
      entityCopy.country_code.should ==  44
      entity.should == entityCopy
    end
  end

  describe "EmailAddress" do
    it "initialises correctly using a hashmap" do
      entityMap = { :email_address => 'm@test.com', :alias => 'personal' }
      entity = EmailAddress.new(entityMap)
      entityMap.map { |(k, v)| entity.public_send("#{k}").should == v }
    end

    it "should be immutable once initialised" do
      entityMap = { :email_address => 'm@test.com', :alias => 'personal' }
      entity = EmailAddress.new(entityMap)
      expect { entity.email_address = 'n@test.com' }.to raise_error
    end

    it "implements equals correctly" do
      email1 = EmailAddress.new({ :email_address => 'm@test.com', :alias => 'personal' })
      email2 = EmailAddress.new({ :email_address => 'm@test.com', :alias => 'personal' })
      email3 = EmailAddress.new({ :email_address => 'n@test.com', :alias => 'personal' })
      email1.should == email2
      email2.should == email1
      email1.should_not == email3
    end

    it "can be constructed from the json payload and generate a payload" do
      payload = JSON.generate({ :emailAddress => 'm@test.com', :alias => 'personal' })
      entity = EmailAddress.from_json(JSON.parse(payload))
      entity.email_address.should == 'm@test.com'
      entity.alias.should ==  'personal'

      entityCopy = EmailAddress.from_json(JSON.parse(entity.to_json))
      entity.email_address.should == 'm@test.com'
      entity.alias.should ==  'personal'
      entity.should == entityCopy
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
  
end