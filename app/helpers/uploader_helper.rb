# encoding: utf-8

module UploaderHelper
  helpers do


    def crop_image(file)
      image = MiniMagick::Image.new(file)
      begin
        if image[:width] > 600 || image[:height] > 600
          image.strip # 删除Exif多余信息，压缩图片
          image.resize("600x600")
        end
      rescue MiniMagick::Error
        system("rm #{file} &")
        redirect back
        flash[:errors] = "我的水平不高，这张图片可能我没办法处理，请换一张"
      rescue MiniMagick::Invalid
        system("rm #{file} &")
        redirect back
        flash[:errors] = "你很坏，你上传的文件很可能不是一张图片！"
      else
        image.path
      end
    end

  end
end