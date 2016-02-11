class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user, :cause_color, :cause_label, :category_label, :update_helper

  def current_user
    return nil if session[:user_id].nil? or User.all.find_by(id:session[:user_id]).nil?
    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'You should be signed in to do this' if current_user.nil?
  end

  def thing_label(thing, colors)
    if thing == nil then return "default" end
    if (not colors.has_key?(thing.downcase)) then return "default" end
    colors[thing.downcase]
  end

  def cause_label(cause)
    colors = {"fixed" => "success", "spam" => "danger", "other" => "info"}
    thing_label(cause, colors)
  end

  def category_label(category)
    colors = {"poikkeusreitti" => "success", "talvikunnossapito" => "info"}
    thing_label(category, colors)
  end

  def update_helper(object, params)
    respond_to do |format|
      if object.update(params)
        format.html { redirect_to object, notice: "#{object.class.name} was successfully updated." }
        format.json { render :show, status: :ok, location: object }
      else
        format.html { render :edit }
        format.json { render json: object.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_helper(object)
    object.destroy
    respond_to do |format|
      format.html { redirect_to polymorphic_url(object.class), notice: "#{object.class.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

end
