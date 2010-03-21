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
    
  end
end
