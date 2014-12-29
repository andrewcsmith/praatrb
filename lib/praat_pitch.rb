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

  def self.pitch_vector item
    pv = self.find_dominant_pitch(Marshal.load Marshal.dump item.dup)
    pv.frames.map!(&:freq)
    pv.frames.select! {|f| f > 0}
    pv.frames.to_nm unless pv.frames.empty?
  end

  def self.normalize nm, options = {}
    min = options[:min] || nm.min
    max = options[:max] || nm.max
    nm -= NMatrix.new(nm.shape, [min[0]], dtype: nm.dtype)
    nm /= NMatrix.new(nm.shape, [max[0] - min[0]], dtype: nm.dtype)
    nm
  end
end

