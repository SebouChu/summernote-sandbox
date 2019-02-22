module ActiveStorage
  class VariantService
    def initialize(blob, area_width = nil, area_height = nil)
      @blob = blob
      @area = {
        width: area_width,
        height: area_height
      }

      @area[:width] ||= image_width
      @area[:height] ||= image_height
    end

    def get_variant(screen_width)
      @screen_width = screen_width
      return nil if should_not_generate_variant?
      cutout? ? cutout_variant
              : normal_variant
    end

    private

    def should_not_generate_variant?
      @screen_width > image_width || (image_width < variant_area_width && image_height < variant_area_height)
    end

    def big_enough?
      image_width >= variant_area_width && image_height >= variant_area_height
    end

    def normal_variant
      big_enough? ? resize_to_fill
                  : crop_and_extent
    end

    def cutout_variant
      # MiniMagick's resize_to_limit equivalent
      # https://github.com/janko/image_processing/blob/28b078ff0f86aadb28fb0429c54e7a73990d3db9/lib/image_processing/mini_magick.rb#L61
      @blob.variant(resize:  "#{variant_area_width}x#{variant_area_height}>", quality: 95)
    end

    def resize_to_fill
      # From MiniMagick
      # https://github.com/janko/image_processing/blob/28b078ff0f86aadb28fb0429c54e7a73990d3db9/lib/image_processing/mini_magick.rb#L72
      @blob.variant(
        combine_options: {
          resize: "#{variant_area_width}x#{variant_area_height}^",
          gravity: 'North',
          background: 'None',
          extent: "#{variant_area_width}x#{variant_area_height}",
          quality: 95
        }
      )
    end

    def crop_and_extent
      # resize_to_fill without resize
      @blob.variant(
        combine_options: {
          gravity: 'North',
          background: 'None',
          extent: "#{variant_area_width}x#{variant_area_height}",
          quality: 95
        }
      )
    end

    def cutout?
      @blob.metadata[:cutout] == true
    end

    def image_width
      @blob.metadata[:width].to_i
    end

    def image_height
      @blob.metadata[:height].to_i
    end

    def variant_area_width
      [@area[:width], @screen_width].min
    end

    def variant_area_height
      @area[:height] * variant_area_width / @area[:width]
    end
  end
end