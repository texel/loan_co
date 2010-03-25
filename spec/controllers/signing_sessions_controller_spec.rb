require 'spec_helper'

describe SigningSessionsController do
  integrate_views
  
  describe "#new" do
    context "with no signing_url in the session" do
      it "should redirect to root" do
        get :new
        response.should redirect_to(root_path)
      end
    end
    
    context "with a signing_url in the session" do
      before(:each) do
        session[:signing_url] = 'http://foo.bar.baz'
      end
      
      it "should redirect to the signing url" do
        get :new
        response.should redirect_to(assigns(:signing_url))
      end
      
      it "should set @signing_url" do
        get :new
        assigns(:signing_url).should == 'http://foo.bar.baz'
      end
    end
  end
  
  describe "#show" do
    context "with a valid status code" do
      before(:each) do
        get :show, :status => 'signing_complete'
      end
      
      it "should set the @status_message" do
        assigns(:status_message).should == SigningSessionsController::STATUS_MESSAGES[:signing_complete]
      end
      
      it "should render show" do
        response.should render_template('show')
      end
    end
    
    context "with no valid status code" do
      it "should redirect to root" do
        get :show, :status => 'bologna'
        response.should redirect_to(root_path)
      end
    end

  end
end
