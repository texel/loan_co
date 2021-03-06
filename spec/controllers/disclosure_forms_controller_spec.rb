require 'spec_helper'

describe DisclosureFormsController do
  integrate_views

  describe "#new" do
    it "should render new" do
      get :new
      response.should render_template('new')
    end
  end
  
  describe "#create" do
    before(:each) do
      LoanCo.connection.stub(:createAndSendEnvelope).and_return(
        Docusign::CreateAndSendEnvelopeResponse.new(
          stub(:envelope_id => 1)
        )
      )
      
      LoanCo.connection.stub(:requestRecipientToken).and_return(
        Docusign::RequestRecipientTokenResponse.new('http://docusign.url')
      )
    end
    
    context "with invalid parameters" do
      it "should render new" do
        post :create
        response.should render_template('new')
      end
    end
    
    context "with valid params" do
      def post_create
        post :create, :disclosure_form => Factory.attributes_for(:disclosure_form)
      end
      
      it "should create a DisclosureForm" do
        expect { post_create }.to change { DisclosureForm.count }.by(1)
      end
      
      it "should set the session[:disclosure_form_id]" do
        post_create
        session[:disclosure_form_id].should be_present
      end
      
      it "should set the session[:signing_url]" do
        post_create
        session[:signing_url].should == 'http://docusign.url'
      end
      
      it "should store the envelope_id in the session" do
        post_create
        session[:envelope_id].should == 1
      end
      
      it "should redirect to new_session" do
        post_create
        response.should redirect_to(new_signing_session_path)
      end
    end
  end

end
