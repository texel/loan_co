class SigningSessionsController < ApplicationController
  STATUS_MESSAGES = HashWithIndifferentAccess.new(
    :signing_complete   => 'Signing was successfully completed',
    :viewing_complete   => 'Viewing was successfully completed',
    :cancel             => 'The user cancelled the signing process',
    :decline            => 'The user declined to sign the document(s)',
    :session_timeout    => 'The signing session has timed out',
    :ttl_expired        => 'The signing session TTL has expired',
    :exception          => 'The signing service raised an exception',
    :access_code_failed => 'Access code failed',
    :id_check_failed    => 'Identification check failed'
  )
  
  before_filter :get_signing_url, :only => [:new]
  
  # Rather than display an iframe wrapper, we just redirect the signer
  # to the Docusign URL in the session
  def new
    redirect_to @signing_url
  end
  
  def show
    redirect_to root_path unless @status_message = STATUS_MESSAGES[params[:status]]
  end
  
  protected
  
  def get_signing_url
    redirect_to root_path unless @signing_url = session[:signing_url]
  end
end
