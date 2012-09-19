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

  end
end