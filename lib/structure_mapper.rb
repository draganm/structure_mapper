require "structure_mapper/version"


class Object
  def self.from_structure data
    data
  end
end

class Array
  def self.from_structure data, inner_type=nil
    if inner_type
      if data
        data.map{|x| inner_type.from_structure x}
      end
    else
      data
    end
  end
end

class Hash
  def self.from_structure data, key_type=nil, value_type=nil
    if key_type && value_type
      if data
        Hash[data.map{|k,v| [key_type.from_structure(k), value_type.from_structure(v)]}]
      end
    else
      data
    end
  end
end

module Boolean
  def self.from_structure data
    data
  end
end


module StructureMapper

  module Array
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute options
        name,type=options.first
        attr_accessor name
        @attributes=(@attributes || [])
        @attributes << [name,type]
      end

      def from_structure data
        return nil unless data
        result=self.new
        @attributes.each_with_index do |(name, type), index|
          result.public_send ("%s=" % name), type.from_structure(data[index])
        end
        result
      end
    end


  end

  module Hash

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute options
        name,type=options.first
        attr_accessor name
        @attributes=(@attributes || {})
        @attributes[name]=type
      end

      def from_structure data
        return nil unless data
        result=self.new
        @attributes.each do |name, type|
          if ::Array === type
            inner_type=type.first
            result.public_send ("%s=" % name),::Array.from_structure(data[name.to_s],inner_type)
          elsif ::Hash === type
            key_type, value_type=type.first
            result.public_send ("%s=" % name),::Hash.from_structure(data[name.to_s],key_type, value_type)
          else
            result.public_send ("%s=" % name), type.from_structure(data[name.to_s])
          end
        end
        result
      end
    end

  end
end



