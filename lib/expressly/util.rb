
module Expressly
  module Helper
    def blank?(obj)
      obj.nil? or obj == ""
    end
  end

  class ObjectHelper
    def ObjectHelper.equals(this, that)
      if this.equal?(that) then return true end
      if !this.instance_of?(that.class) then return false end
      
      allVars = Set.new(this.instance_variables).merge(that.instance_variables)
      allVars.each { |v|
        return false unless this.instance_variable_get(v) == that.instance_variable_get(v) 
      }
      
      return true
    end
    
  end
    
  class Enumeration
  
    def Enumeration.const_missing(key)
      value = @hash[key]
      
      if value
        return value
      end
      
      raise("illegal enumeration key #{key}") 
        
    end   
  
    def Enumeration.each
      @hash.each {|key,value| yield(key,value)}
    end
  
    def Enumeration.values
      @hash.values || []
    end
  
    def Enumeration.keys
      @hash.keys || []
    end
  
    def Enumeration.[](key)
      @hash[key]
    end
    
    def Enumeration.assertValidValue(value)
      
      if value == nil
        return
      end
      
      (@hash.values || []).each do |item|
        if value == item
          return
        end
      end
      
      throw("illegal enumeration value #{value}")
       
    end
    

    def Enumeration.add_item(key,value)
      @hash ||= {}
      @hash[key]=value
    end
  end

  module AbstractInterface
  
    class InterfaceNotImplementedError < NoMethodError
    end
  
    def self.included(klass)
      klass.send(:include, AbstractInterface::Methods)
      klass.send(:extend, AbstractInterface::Methods)
    end
  
    module Methods
  
      def api_not_implemented(klass)
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
        raise AbstractInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
      end
  
    end
  end
      
end