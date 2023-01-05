class PlansController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    render json: {}.to_json, status: 200
  end
end
