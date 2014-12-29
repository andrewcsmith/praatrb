module Praat; end

class Praat::Parser
  def parse input
    output = Praat::Root.new
    @current_node = output
    @current_indent = 0
    input.each do |item|
      begin
        case item.shift
        when :indent
          process_indent item
        when :collection
          @current_node.add_property "#{item.first}s", create_collection(item.first)
          @current_node = @current_node.send("#{item.first}s")
        when :object
          @current_node << create_object(item.first)
          @current_node.last.parent = @current_node
          @current_node = @current_node.last
        when :property
          @current_node.add_property(*item)
        end
      rescue Exception => ex
        puts
        print "item: #{item}\n"
        print "current node: #{@current_node}\n"
        raise ex
      end
    end
    output
  end

  private

  def process_indent item
    indent = item.first
    # If the new indent is a backstep
    if indent < @current_indent
      # Go back
      (@current_indent - indent).times do
        @current_node = @current_node.parent
      end
    end
    @current_indent = item.first
  end

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

