require "praat_lexer.rb"
require "praat_parser.rb"

module Praat
  VERSION = "1.0.0"

  # Something will be either a collection or an object. Only an object can have
  # properties.
  class MetaCollection < Array
    attr_accessor :parent

    def << object
      object.parent = self
      super object
    end
  end

  class MetaObject
    attr_accessor :parent

    # Append the object to the collection of names
    def add_to_collection name, object
      instance_variable_get("@#{name}s").instance_exec(object) { |o| self << o }
    end

    # Add the property to the object
    def add_property name, value
      # Add the attr_accessor if it doesn't exist
      unless self.respond_to? "#{name}"
        self.class.class_exec(name) do |n|
          attr_accessor n.to_sym
        end
      end

      if value.respond_to? :parent=
        value.parent = self
      end

      # Set the attribute to the value
      self.send("#{name}=", value)
    end
  end
end

