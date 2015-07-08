class UsersController < ApplicationController
  before_action :ensure_that_signed_in

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end
end
