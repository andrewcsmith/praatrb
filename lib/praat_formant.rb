module Praat
  def self.dominant_frame item
    dominant_frame = item.frames.max {|a, b|
      a.intensity <=> b.intensity
    }
    item.add_property :dominant_frame, dominant_frame
    item
  end

  class MetaObject; end
  class Item < MetaObject
    def map_formant_frequencies
      self.framess.map {|frame|
        frame.formants.map(&:frequency)
      }
    end
  end
end

