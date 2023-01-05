class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    return "200"
  end
end
