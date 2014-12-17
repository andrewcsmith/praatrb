require "praat_lexer.rb"
require "praat_parser.rb"
require "praat_pitch.rb"
require "praat_formant.rb"

module Praat
  VERSION = "1.0.0"

  # Parses a file given a specified encoding, returning an object containing
  # nested objects
  def self.parse_file filename, encoding = 'utf-8'
    f = File.open(filename, "rb", {encoding: "#{encoding}:utf-8"})
    Praat::Parser.new.parse(Praat::Lexer.new.parse(f.read))
  end

  def self.hz_to_midi hz, base_hz = 440.0, base_midi = 69
    if hz && hz > 0.0
      (Math.log2(hz.to_f / base_hz) * 12.0) + base_midi
    else
      0.0
    end
  end

  # Something will be either a collection or an object. Only an object can have
  # properties.
  class MetaCollection < Array
    attr_accessor :parent

    def << object
      object.parent = self
      super object
    end

    def to_s
      self.inspect << super
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
      # Convert it to snake-case
      name = sanitize_name name.to_s

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

    def to_s
      "#{self.inspect}" 
    end

    private

    def sanitize_name name
      if name == "class"
        name = "klass"
      end
      name.downcase.sub(' ', '_')
    end
  end
  
  class Root < MetaObject; end
end

