module ActiveStorage
  # Extracts width and height in pixels from an image blob, plus cutout (white/transparent background).
  #
  # Example:
  #
  #   ActiveStorage::Analyzer::ExtendedImageAnalyzer.new(blob).metadata
  #   # => { width: 4104, height: 2736, cutout: false }
  class Analyzer::ExtendedImageAnalyzer < Analyzer::ImageAnalyzer
    def metadata
      meta = super
      meta[:cutout] = cutout?
      # TODO square, horizontal, vertical
      meta
    end

    private

    def cutout?
      white_or_transparent?(top_left) &&
        white_or_transparent?(top_right) &&
        white_or_transparent?(bottom_left) &&
        white_or_transparent?(bottom_right)
    end

    def image
      @image ||= MiniMagick::Image.read blob.download
    end

    def pixels
      unless @pixels
        # get_pixels would be simpler, but it does not send alpha values
        # https://github.com/minimagick/minimagick/blob/c08a6d4447735f3f41db83e2954e97c0e422d71a/lib/mini_magick/image.rb#L348
        convert = MiniMagick::Tool::Convert.new
        convert << image.path
        convert.depth(8)
        convert << "RGBA:-"

        shell = MiniMagick::Shell.new
        output, * = shell.run(convert.command)

        pixels_array = output.unpack("C*")
        @pixels = pixels_array.each_slice(4).each_slice(image.width).to_a

        output.clear
        pixels_array.clear
      end
      @pixels
    end

    def top_left
      pixels.first.first
    end

    def top_right
      pixels.last.first
    end

    def bottom_left
      pixels.first.last
    end

    def bottom_right
      pixels.last.last
    end

    def white_or_transparent?(pixel)
      if pixel[3].nil?
        # No alpha, check white
        pixel[0] > 250 && pixel[1] > 250 && pixel[2] > 250
      else
        # Alpha
        pixel[3] == 0
      end
    end
  end
end