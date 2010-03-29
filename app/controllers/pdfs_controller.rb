class PdfsController < ApplicationController
  before_filter :ensure_envelope_id
  
  def show
    response = LoanCo.connection.request_pdf :envelopeID => session[:envelope_id]
    result   = response.request_pdf_result
    
    # Soap4r appears to base64 encode binary data, even if it's already encoded. Here, we have to do a double-decode.
    send_data Base64.decode64(Base64.decode64(result.pdf_bytes)), :type => 'application/pdf', :filename => "document.pdf"
  end
  
  protected
  
  def ensure_envelope_id
    redirect_to root_path unless session[:envelope_id]
  end
end
