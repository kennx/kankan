#encoding: utf-8

class ControlPanelController < ApplicationController

  get '/cpanel/add_photo/?' do
    @user = User.find_by(:id => session[:user_id])
    erb(:'photos/add')
  end

  get '/cpanel/?' do
    # GET
  end

  get '/cpanel/edit_user/?' do
    # GET
  end

  post '/user/:id/photo/create/?' do
    @user = User.find(params[:id])
    directory = "./public/uploads/photos/" + @user.id.to_s + "/"
    if params[:file] && (tmpfile = params[:file][:tempfile]) && (filename = params[:file][:filename])
      rename = "#{Time.now.to_i}" + File.extname(filename)
      path = File.join(directory, rename)
      `mkdir -p #{directory}` unless File.directory?(directory)
      File.open(path, 'wb') do |f|
        f.write(tmpfile.read)
      end
      crop_image(path)
      image_path = "/uploads/photos/" + @user.id.to_s + "/" + rename
      if @user.photos.build(:middle => "#{image_path}", :statuse => params[:description]).save
        flash[:notice] = "发布成功"
        redirect back
      else
        flash[:error] = "发布失败"
        redirect back
      end
    end
  end

  put '/cpanel/user/:id/?' do
    # PUT
  end

end