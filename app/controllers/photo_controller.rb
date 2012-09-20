require 'digest/sha1'

class PhotoController < ApplicationController

  get '/photos/explore/?' do
    headers "Cache-Control" => "public, must-revalidate, max-age=3600", "Expires" => Time.now.to_s
    @photos = Photo.all
    erb(:'photos/explore')
  end

  get '/photo/:id/?' do
    @photo = Photo.find(params[:id])
    erb(:'photos/show')
  end

end