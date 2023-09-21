require 'uri'
require 'net/http'
require 'openssl'

class CheckoutController < ApplicationController
  def save_customer
    @customer_id = params[:createdCustomerId]
    @address_id = params[:createdAddressId]
    @checkout_id = params[:createdCheckoutId]
    @transaction_id = params[:createdTransactionId]
    @quantity = params[:createdQuantity]

    session[:session_customer_id] = @customer_id
    session[:session_address_id] = @address_id
    session[:session_checkout_id] = @checkout_id
    session[:session_transaction_id] = @transaction_id

    if params[:createdBusinessId].present?
      @business_id = params[:createdBusinessId]
      session[:session_business_id] = @business_id
    end

    session[:session_quantity] = @quantity

    response = {
      status: "success",
      message: "Created IDs saved to session storage!"
    }

    render json: response, content_type: 'application/json'
  end

  # This method below was going to be used to get all info on the customer, subscription etc and could be used by other controllers
  # def get_all_info
  #   {
  #     "customer_id" => @customer_id,
  #     "address_id" => @address_id,
  #     "checkout_id" => @checkout_id,
  #     "transaction_id" => @transaction_id,
  #     "business_id" => @business_id
  #   }
  # end
end
