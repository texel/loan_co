require 'spec_helper'

describe LoanApplicationsController do
  integrate_views
  
  describe "#new" do
    it "should render new" do
      get :new
      response.should render_template('new')
    end
  end
  
  describe "#create" do
    context "with invalid parameters" do
      it "should render new" do
        post :create
        response.should render_template('new')
      end
    end
    
    context "with valid params" do
      def post_create
        post :create, :loan_application => Factory.attributes_for(:loan_application)
      end
      
      it "should create a LoanApplication" do
        expect { post_create }.to change { LoanApplication.count }.by(1)
      end
      
      it "should set the session[:loan_application_id]" do
        post_create
        session[:loan_application_id].should be_present
      end
    end

  end
end
