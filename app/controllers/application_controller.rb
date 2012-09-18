#encoding: utf-8

class ApplicationController

  before do
    
  end


  get '/' do
    client = WeiboOAuth2::Client.new
    if session[:access_token] && !client.authorized?
      token = client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]}) 
      p "*" * 80 + "validated"
      p token.inspect
      p token.validated?
      
      unless token.validated?
        clear_session
        redirect '/connect'
        return
      end
    end
    if session[:uid]
      @user = client.users.show_by_uid(session[:uid]) 
      @statuses = client.statuses
    end
    erb(:'index', :layout => false)
  end


  get '/connect/?' do
    client = WeiboOAuth2::Client.new
    redirect client.authorize_url
  end


  get '/callback/?' do
    client = WeiboOAuth2::Client.new
    access_token = client.auth_code.get_token(params[:code].to_s)
    session[:uid] = access_token.params['uid']
    session[:access_token] = access_token.token
    session[:expires_at] = access_token.expires_at
    p "*" * 80 + "callback"
    p access_token.inspect
    @user = client.users.show_by_uid(session[:uid].to_i)
    if session[:uid]
      access_user = client.users.show_by_uid(session[:uid])
      if User.find_by(:uid => access_user.id).nil?
        create_user = User.create(:uid => session[:uid], 
                                  :username => access_user.screen_name,
                                  :gender => access_user.gender == "m" ? 0 : 1, 
                                  :location => access_user.location,
                                  :description => access_user.description,
                                  :avatar => access_user.profile_image_url)
        if create_user.save
          session[:user_id] = User.find_by(:uid => access_user.id).id
          flash[:notice] = "成功建立用户：）"
          redirect('/')
        else
          flash[:error] = "建立失败"
          redirect('/')
        end
      else
        session[:user_id] = User.find_by(:uid => access_user.id).id
        redirect('/')
      end
    end
  end


  get '/logout/?' do
    clear_session
    redirect('/')
  end

end