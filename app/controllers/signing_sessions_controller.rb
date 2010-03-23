class SigningSessionsController < ApplicationController
  before_filter :get_signing_url
  
  def new
  end
  
  protected
  
  def get_signing_url
    redirect_to root_path unless @signing_url = session[:signing_url]
  end
end
