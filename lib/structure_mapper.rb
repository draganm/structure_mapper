require "structure_mapper/version"


class Object
  def self.from_structure data
    data
  end

  def to_structure
    self
  end
end

class Array

  def from_structure data
    inner_type=first
    if inner_type && data
      data.map{|x| inner_type.from_structure x}
    else
      data
    end

  end

  def to_structure
    map{|v| v.to_structure}
  end
end

class Hash

  def from_structure data
    key_type, value_type=first
    if key_type && value_type && data
      Hash[data.map{|k,v| [key_type.from_structure(k), value_type.from_structure(v)]}]
    else
      data
    end
  end

  def to_structure
    Hash[self.map do |k,v|
      [k.to_structure, v.to_structure]
    end]
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

    def to_structure
      (self.class.attributes || []).map do |name, _|
        public_send(name).to_structure
      end
    end

    module ClassMethods

      attr_reader :attributes

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

    def to_structure
      ::Hash[
        (self.class.attributes || {}).map do |name,type|
          [name.to_s,public_send(name).to_structure]
        end
      ]
    end

    def == other
      return false unless self.class == other.class
      self.class.attributes.each do |name,_|
        return false unless self.send(name) == other.send(name)
      end
      true
    end

    module ClassMethods

      attr_reader :attributes

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
          result.public_send ("%s=" % name), type.from_structure(data[name.to_s])
        end
        result
      end

    end


  end
end



