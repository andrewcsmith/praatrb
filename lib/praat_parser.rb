module Praat; end

class Praat::Parser
  def parse input
    output = []
    input.each do |item|
      case item.first
      when :collection
        output << create_collection(item[1])
      when :object
      when :property
      end
    end
    output
  end

  private

  def create_collection klass
    klass = klass.capitalize
    unless Object.const_defined? "Praat::#{klass}"
      Praat.class_eval "class #{klass} < Praat::MetaCollection; end"
    end
    (Praat.const_get "#{klass}").new
  end
end

