class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def home
    render("home/index")
  end

  def require_admin
    unless current_user&.is_admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
