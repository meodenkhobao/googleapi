class SessionsController < ApplicationController
  before_action :authenticate_user, only: :destroy

  def new
    redirect_to googleplus_path if signed_in?
  end

  def create
    redirect_to googleplus_path and return if signed_in?
    user = User.find_with_omniauth request.env['omniauth.auth']
    sign_in user
    redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to sign_in_path, notice: "You've signed out."
  end
end