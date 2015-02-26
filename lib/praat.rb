require "praat_lexer.rb"
require "praat_parser.rb"
require "praat_pitch.rb"
require "praat_formant.rb"
require "praat_textgrid.rb"

module Praat
  VERSION = "1.0.0"

  require 'json'

  begin 
    require 'nmatrix'
    HAS_NMATRIX = true
  rescue LoadError
    HAS_NMATRIX = false
  end

  # Parses a file given a specified encoding, returning an object containing
  # nested objects
  def self.parse_file filename, encoding = 'utf-8'
    f = File.open(filename, "rb", {encoding: "#{encoding}:utf-8"})
    Praat::Parser.new.parse(Praat::Lexer.new.parse(f.read))
  end

  # Turns a hz reading into a midi value.
  #
  # hz - The input value in hz
  # base_hz - The frequency for tuning (i.e., A=440)
  # base_midi - The midi key that the tuning pitch corresponds to
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

    def to_json opts = {}
      properties.inject Hash.new do |h, v|
        property = instance_variable_get "@#{v}"
        if property.is_a? MetaCollection
          h[v] = property.map {|f| JSON.parse(f.to_json(opts))}
        elsif property.is_a? MetaObject
          h[v] = JSON.parse(property.to_json(opts))
        else
          h[v] = property
        end
        h
      end.to_json(opts)
    end

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

    def properties
      instance_variables.reject {|f| f == :@parent}.map do |v|
        v.to_s.gsub "@", ""
      end
    end
  end
  
  class Root < MetaObject
    include FormantMethods
  end

  class Item < MetaObject
    include FormantMethods
  end
end

