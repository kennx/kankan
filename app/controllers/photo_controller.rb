class PhotoController < ApplicationController

  get '/photos/explore/?' do
    @photos = Photo.all
    erb(:'photos/explore')
  end

  get '/photo/:id/?' do
    @photo = Photo.find(params[:id])
    erb(:'photos/show')
  end

end