module Praat; end

class Praat::Parser
  def parse input
    output = Praat::MetaObject.new
    current_node = output
    input.each do |item|
      case item.shift
      when :collection
        current_node.add_property("#{item.first}s", create_collection(item.first))
      when :object
        current_node.add_to_collection(item.first, create_object(item.first))
      when :property
        current_node.add_property(*item)
      end
    end
    output
  end

  private

  def create_collection klass
    klass = klass.capitalize << "s"
    unless Object.const_defined? "Praat::#{klass}"
      Praat.class_eval "class #{klass} < Praat::MetaCollection; end"
    end
    (Praat.const_get "#{klass}").new
  end

  def create_object klass
    klass = klass.capitalize
    unless Object.const_defined? "Praat::#{klass}"
      Praat.class_eval "class #{klass} < Praat::MetaObject; end"
    end
    (Praat.const_get "#{klass}").new
  end
end

