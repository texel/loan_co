class LoanApplicationsController < ApplicationController
  def new; end
  
  def create
    @loan_application = LoanApplication.new(params[:loan_application])
    if @loan_application.save
      session[:loan_application_id] = @loan_application.id
      render :nothing => true
    else
      render 'new'
    end
  end
end
