class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def authenticate_admin!
    redirect_to dashboard_index_path unless current_user.try(:admin?)
  end
end
