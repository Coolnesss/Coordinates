class UsersController < ApplicationController
  before_action :ensure_that_signed_in

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password_digest)
    end
end
