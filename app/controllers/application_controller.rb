class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action CASClient::Frameworks::Rails::Filter
  before_filter :cas_filter, :current_user

  def cas_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def current_user
    unless @current_user
      @current_user = User.new(
      	session[:cas_user],
        session[:cas_extra_attributes]["id"], 
        session[:cas_extra_attributes]["name_and_surname"], 
        session[:cas_extra_attributes]["email"], 
        session[:cas_extra_attributes]["agency_id"]
      )
    else
      @current_user
    end
  end
end
