#encoding: utf-8

class ControlPanelController < ApplicationController

  get '/cpanel/add_photo/?' do
    @user = User.find_by(:id => session[:user_id])
    erb(:'photos/add')
  end

  get '/cpanel/edit_user/?' do
    @user = User.find_by(:id => session[:user_id])
    erb(:'users/edit')
  end

  post '/user/:id/photo/create/?' do
    @user = User.find(params[:id])
    tags = params[:tags]
    tag_list = tags.split(" ")
    NORMAL_DIR = "./public/uploader/attachment/" + dir_format_to_date + "/"
    THUMB_DIR = "./public/uploader/attachment/" + dir_format_to_date + "/_thumb/"
    if params[:file] && (tmpfile = params[:file][:tempfile]) && (filename = params[:file][:filename])
      rename = "#{Time.now.to_i}" + File.extname(filename)
      normal_path = File.join(NORMAL_DIR, rename)
      thumb_path = File.join(THUMB_DIR, rename)
      FileUtils.mkdir_p(NORMAL_DIR) unless File.directory?(NORMAL_DIR)
      FileUtils.mkdir_p(THUMB_DIR) unless File.directory?(THUMB_DIR)
      File.open(normal_path, "wb") do |f|
        f.write(tmpfile.read)
        File.open(thumb_path, "wb") do |f2|
          f2.write(File.open(normal_path).read)
        end
      end
      normal_url = "/uploader/attachment/" + dir_format_to_date + "/" + rename
      thumbnail_url = "/uploader/attachment/" + dir_format_to_date + "/_thumb/" + rename
      if crop_medium_image(normal_path) && crop_image_fixed_size(thumb_path, 320, 220)
        create_photo = @user.photos.build(:photo_url => "#{normal_url}", :thumbnail_url => "#{thumbnail_url}", :statuse => params[:description])
        tag_list.each {|t| create_photo.tags << Tag.new(:name => t)}
        if create_photo.save
          flash[:notice] = "发布成功"
          redirect back
        else
          flash[:errors] = "发布失败"
          redirect back
        end
      end
    end
  end

  put '/cpanel/user/:id/?' do
    # PUT
  end

end