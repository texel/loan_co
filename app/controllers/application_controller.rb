# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'loan_co'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  
  def generate_token(signer, envelope_status)
    token = Docusign::RequestRecipientToken.new.tap do |t|
      t.authentication_assertion = Docusign::RequestRecipientTokenAuthenticationAssertion.new.tap do |a|
        a.assertion_id           = Time.now.to_i.to_s
        a.authentication_instant = Time.now
        a.authentication_method  = Docusign::RequestRecipientTokenAuthenticationAssertionAuthenticationMethod::Biometric # because let's be honest, biometrics are awesome.
        a.security_domain        = "#{request.domain}:80"
      end
            
      # Set all the callback URLs in one fell swoop..
      t.client_urls = Docusign::RequestRecipientTokenClientURLs.new.tap do |u|
        Docusign::RequestRecipientTokenClientURLs::CALLBACKS.each do |result|
          u.send "on_#{result}=", signing_session_url(:status => result)
        end
      end
      
      t.client_user_id = signer.captive_info.client_user_id
      t.email          = signer.email
      t.envelope_id    = envelope_status.envelope_id
      t.username       = signer.user_name
    end
    
    token
  end
end
