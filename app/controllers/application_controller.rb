class ApplicationController < ActionController::Base

  before_action :background_image

  def background_image
    if params[:controller] == 'customers/homes' && params[:action] == 'top'
      @classname = 'top-body'
    else
      @classname = 'top-except'
    end
  end
end
