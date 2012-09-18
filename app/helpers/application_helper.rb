module ApplicationHelper
  helpers do
    alias_method :h, :escape_html
    def clear_session
      session[:user_id] = nil
      session[:uid] = nil
      session[:access_token] = nil
    end
  end

end