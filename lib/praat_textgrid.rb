module Praat
  ##
  # Currently, we can only extract one IntervalTier at a time
  # Intervals is actually a single interval (thx, Praat)
  class Intervals < MetaObject
    def has_text?
      self.text != ""
    end

    def minmax
      [self.xmin, self.xmax]
    end

    def range
      Range.new(self.xmin, self.xmax)
    end

    def extract_pitch pitch
      out = Marshal.load(Marshal.dump(pitch))
      out.frames.clear
      x1 = pitch.x1
      dx = pitch.dx
      # Select the frames which fall within the pitch range
      pitch.frames.each_with_index do |f, i|
        time = i * dx + x1
        if range.include? time
          out.frames << f
        end
      end
      out
    end
  end
end

