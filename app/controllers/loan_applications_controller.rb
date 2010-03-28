class LoanApplicationsController < ApplicationController
  def new; end
  
  def create
    @loan_application = LoanApplication.new(params[:loan_application])
    if @loan_application.save
      session[:loan_application_id] = @loan_application.id
      
      response        = LoanCo.connection.create_and_send_envelope :envelope => @loan_application.envelope
      envelope_status = response.create_and_send_envelope_result
      
      session[:envelope_id] = envelope_status.envelope_id
      
      # generate_token helper is in application_controller.rb
      token    = generate_token @loan_application.signer, envelope_status
      response = LoanCo.connection.request_recipient_token token
      
      session[:signing_url] = response.request_recipient_token_result
            
      redirect_to new_signing_session_path
    else
      render 'new'
    end
  end
end
