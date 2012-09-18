# encoding: utf-8

module UploaderHelper
  helpers do
    def crop_image(file)
      image = MiniMagick::Image.new(file)
      if image[:width] > 600 || image[:height] > 600
        begin
          image.strip # 删除Exif多余信息，压缩图片
          image.resize("600x600")
        rescue MiniMagick::Error
          flash[:errors] = "我的水平不高，这张图片可能我没办法处理，请换一张"
          pass redirect back
        rescue MiniMagick::Invalid
          flash[:errors] = "你很坏，你上传的文件很可能不是一张图片！"
          pass redirect back
        else
          image.path
        end
      end
    end

    def crop_thumbnail(file)
      image = MiniMagick::Image.new(file)

    end
  end
end