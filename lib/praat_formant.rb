module Praat
  def self.dominant_frame item
    dominant_frame = item.frames.max {|a, b|
      a.intensity <=> b.intensity
    }
    item.add_property :dominant_frame, dominant_frame
    item
  end

  module FormantMethods
    ##
    # Method mapping some sort of data frequency to a frame frequency
    def map_frequencies frame_symbol, data_symbol
      self.send(frame_symbol).map do |frame| 
        frame.send(data_symbol).map(&:frequency)
      end
    end

    def map_formant_frequencies
      map_frequencies :frames, :formants
    end

    def num_formants
      self.maxnformants
    end

    def num_frames
      self.frames.size
    end

    ##
    # Returns the least squares fit of the formants
    # log2 must be taken before least squares is calculated, or the negative
    # slopes will be out of the domain of log2
    #
    # logarithmic - if true, then the base-2 logarithm is taken before least
    #   squares is calculated. Default: true.
    #
    def least_squares_formant logarithmic = true
      raise NotImplementedError, "#least_squares_formant requries NMatrix" unless HAS_NMATRIX
      frames = map_formant_frequencies.flatten.to_nm([num_frames, num_formants]).each_column.map { |c|
        c = c.log2 if logarithmic
        if block_given? 
          c = yield c
        end
        x = NMatrix.ones(c.shape).hconcat(NMatrix.seq(c.shape))
        ((x.transpose.dot x).invert.dot(x.transpose)).dot(c)
      }.map(&:transpose)
      [self.frames.size, frames[0].vconcat(*frames[1..-1])]
    end
  end
end

