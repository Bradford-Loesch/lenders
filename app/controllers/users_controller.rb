class UsersController < ApplicationController
  skip_before_action :require_login
  def index
    render 'users/index'
  end
  def signin
    render 'users/login'
  end
  def login
    user = Lender.find_by_email(params[:email])
    if user
      session[:user] = 'lender'
    else
      user = Borrower.find_by_email(params[:email])
      if user
        session[:user] = 'borrower'
      end
    end
    if user && user.authenticate(params[:password])
      session[:login] = user.id
      redirect_to "/lending/#{session[:user]}/#{user.id}"
    else
      flash[:error] = "Password or username invalid"
      redirect_to '/lending/login'
    end
  end
  def createlender
    user = Lender.new(lender_params)
    saveuser(user, 'lender')
  end
  def createborrower
    user = Borrower.new(borrower_params)
    user.raised = 0
    saveuser(user, 'borrower')
  end
  def logout
    session[:user] = false
    session[:login] = false
    redirect_to '/lending/login'
  end

  private

  def saveuser(user, type)
    if user.valid?
      user.save
      session[:user] = type
      session[:login] = user.id
      redirect_to "/lending/#{session[:user]}/#{user.id}"
    else
      flash[:error] = user.errors.full_messages
      redirect_to '/lending/register'
    end
  end
  def lender_params
    params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
  end
  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :purpose, :description, :money)
  end
end
