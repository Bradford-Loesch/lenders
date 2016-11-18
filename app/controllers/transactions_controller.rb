class TransactionsController < ApplicationController
  def index
    if session[:user] == 'lender'
      @user = Lender.find(session[:login])
      @givens = Transaction.where(lender: @user)
      @needs = Borrower.all
    elsif session[:user] == 'borrower'
      @user = Borrower.find(session[:login])
      @lendings = Transaction.where(borrower: @user)
    else
      flash[:error] = "Login could not be verified, you have been automatically logged out"
      redirect_to '/lending/logout'
    end
  end
  def lend
    user = Lender.find(session[:login])
    if user.money < params[:amount].to_i
      flash[:error] = "Insufficient funds."
    else
      borrower = Borrower.find(params[:borrower])
      user.money -= params[:amount].to_i
      borrower.raised += params[:amount].to_i
      user.save
      borrower.save
      # transaction = Transaction.find_by_lender_id(session[:login])
      # if transaction
      #   amount = transaction.amount + params[:amount].to_i
      #   transaction.update(amount: amount)
      # else
      Transaction.create(amount: trans_amount, lender: user, borrower: borrower)
      # end
    end
    redirect_to "/lending/#{session[:user]}/#{user.id}"
  end

  private
  def trans_amount
    params.require(:amount)
  end
end
