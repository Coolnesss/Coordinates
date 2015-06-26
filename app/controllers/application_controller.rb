class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user, :cause_color, :cause_label

  def current_user
    return nil if session[:user_id].nil? or User.all.find_by(id:session[:user_id]).nil?
    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'You should be signed in to view reports' if current_user.nil?
  end

  def cause_color(cause)
    colors = {"fixed" => "rgba(157, 136, 255, .3)", "spam" => "rgba(157, 136, 255, .3)", "other" => "rgba(243, 255, 136, .3)"}
    colors[cause.downcase]
  end

  def cause_label(cause)
    colors = {"fixed" => "success", "spam" => "danger", "other" => "info"}
    if (not colors.has_key?(cause.downcase)) then return "default" end
    colors[cause.downcase]
  end
end
