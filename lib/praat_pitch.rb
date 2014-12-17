module Praat
  def self.find_dominant_pitch item
    item.frames.map! do |frame|
      top = frame.candidates.max do |a, b|
        a.strength <=> b.strength
      end

      frame.add_property "freq", top.frequency
     
      # Filter out the unvoiced candidates 
      if frame.freq > item.ceiling
        frame.freq = nil
      end

      frame
    end
    item
  end
end

