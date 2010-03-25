class DisclosureFormsController < ApplicationController
  def new; end
  
  def create
    @disclosure_form = DisclosureForm.new(params[:disclosure_form])
    
    if @disclosure_form.save
      session[:disclosure_form_id] = @disclosure_form.id
      
      response        = LoanCo.connection.create_and_send_envelope :envelope => @disclosure_form.envelope
      envelope_status = response.create_and_send_envelope_result
      
      session[:envelope_id] = envelope_status.envelope_id
      
      # generate_token helper is in application_controller.rb
      token    = generate_token @disclosure_form.signer, envelope_status
      response = LoanCo.connection.request_recipient_token token
      
      session[:signing_url] = response.request_recipient_token_result
      
      redirect_to new_signing_session_path
    else
      render 'new'
    end
  end
end
