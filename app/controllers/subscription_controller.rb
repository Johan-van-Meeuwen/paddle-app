require 'uri'
require 'net/http'
require 'openssl'

class SubscriptionController < ApplicationController
  # def show_subscription
  #   @sub_transaction_id = session[:session_transaction_id]
    # This was going to call the Checkout Controller action get_all_info to use in this controller
    # @all_info = CheckoutController.new.get_all_info
    # render json: response, content_type: 'text/html'
  end
end
