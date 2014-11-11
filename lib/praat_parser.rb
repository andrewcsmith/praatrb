module Praat; end

class Praat::Parser
  def parse input
    output = Praat::MetaObject.new
    current_node = output
    input.each do |item|
      case item.shift
      when :collection
        current_node.add_property("#{item.first}s", create_collection(item.first))
        current_node = current_node.send("#{item.first}s")
      when :object
        unless current_node.is_a? Praat::MetaCollection
          current_node = current_node.parent
        end
        current_node << create_object(item.first)
        current_node.last.parent = current_node
        current_node = current_node.last
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

