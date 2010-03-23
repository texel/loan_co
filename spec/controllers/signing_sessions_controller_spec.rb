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
      
      it "should render new" do
        get :new
        response.should render_template('new')
      end
      
      it "should set @signing_url" do
        get :new
        assigns(:signing_url).should == 'http://foo.bar.baz'
      end
    end
  end
end
