# encoding: utf-8

module UploaderHelper
  helpers do

    def dir_format_to_date
      date = Time.now
      date.strftime("%Y/%m/%d").to_s
    end


    def crop_medium_image(file)
      begin
        image = MiniMagick::Image.new(file)
        image_width,image_height = image[:width],image[:height]
        if image_width.to_f > 600 || image_height.to_f > 600
          image.strip
          image.resize("600x600")
        end
      rescue MiniMagick::Error
        flash[:errors] = "我的水平不高，这张图片可能我没办法处理，请换一张"
        redirect back
      rescue MiniMagick::Invalid
        flash[:errors] = "你很坏，你上传的文件很可能不是一张图片！"
        redirect back
      else
        image.path
      end
    end

    def crop_thumb_image(file)
      begin
        image = MiniMagick::Image.new(file)
        image_width,image_height = image[:width],image[:height]
        if image_width > image_height
          shaved = (image_width-image_height).abs / 2
          image.shave("#{shaved}x0")
        else
          shaved = (image_height-image_width).abs / 2
          image.shave("0x#{shaved}")
        end
      rescue MiniMagick::Error
        flash[:errors] = "我的水平不高，这张图片可能我没办法处理，请换一张"
        redirect back
      rescue MiniMagick::Invalid
        flash[:errors] = "你很坏，你上传的文件很可能不是一张图片！"
        redirect back
      else
        image.resize("200x200")
        image.path
      end
    end

    def crop_image_fixed_size(file, file_width, file_height)
      begin
        image = MiniMagick::Image.new(file)
        original_width,original_height = image[:width],image[:height]
        if original_width*file_height != original_height*file_width
          if original_width*file_height >= original_height*file_width
            original_height_clone = original_height
            original_width_clone = original_height_clone * (file_width.to_f / file_height)
          elsif original_width*file_height <= original_height * file_width
            original_width_clone = original_width
            original_height_clone = original_width_clone * (file_height.to_f / file_width)
          end
        else
          original_height_clone = original_height
          original_width_clone = original_width
        end
        if original_width_clone != original_width || original_height_clone != original_height
          x = ((original_width - original_width_clone)/2).round
          y = ((original_height - original_height_clone)/2).round
          image.crop("#{original_width_clone}x#{original_height_clone}+#{x}+#{y}")
        end
      rescue MiniMagick::Error
        flash[:errors] = "我的水平不高，这张图片可能我没办法处理，请换一张"
        redirect back
      rescue MiniMagick::Invalid
        flash[:errors] = "你很坏，你上传的文件很可能不是一张图片！"
        redirect back
      else
        image.resize("#{file_width}x#{file_height}")
        return image
      end
    end

  end
end