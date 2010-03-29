require 'spec_helper'

describe PdfsController do
  integrate_views
  
  describe "#show" do
    context "without an envelope_id in the session" do
      it "should redirect to root" do
        get :show
        response.should redirect_to(root_path)
      end
    end
    
    context "with an envelope_id in the session" do
      before(:each) do
        @pdf_stub = stub(:request_pdf_result => stub(:pdf_bytes => '12345', :subject => 'Loan Application'))        
        LoanCo.connection.stub(:request_pdf).and_return(@pdf_stub)
        
        session[:envelope_id] = '12345'
      end
      
      it "should request the envelope pdf" do
        LoanCo.connection.should_receive(:request_pdf).and_return(@pdf_stub)
        get :show
      end
    end
  end

end
