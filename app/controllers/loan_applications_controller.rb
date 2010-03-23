require 'pp'

class LoanApplicationsController < ApplicationController
  def new; end
  
  def create
    @loan_application = LoanApplication.new(params[:loan_application])
    if @loan_application.valid?
      session[:loan_application_id] = @loan_application.id
      
      response = LoanCo.connection.create_and_send_envelope :envelope => @loan_application.envelope
      envelope_status = response.create_and_send_envelope_result
      
      token = generate_token @loan_application.signer, envelope_status
      
      debugger
      
      response = LoanCo.connection.request_recipient_token token
      
      logger.info(pp response)
      
      render :nothing => true
    else
      render 'new'
    end
  end
  
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
        %w(access_code_failed cancel decline exception id_check_failed session_timeout signing_complete ttl_expired viewing_complete).each do |result|
          u.send "on_#{result}=", "http://loanco.example.com?status=#{result}"
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
