require 'uri'
require 'net/http'
require 'openssl'

class PricingController < ApplicationController
  def preview_monthly_transaction
    # The code below calls the Preview Transaction API to preview the transaction whenever
    monthly_quantity = params[:monthlyQuantity]

    items = [
      {
        "quantity": "#{monthly_quantity}".to_i,
        "price_id": "pri_01h3cbhh5srdgyca7p2cg658bj"
      }
    ]

    if params[:monthlyCheckboxValue] == "true"
      items << {
        "quantity": 1,
        "price_id": "pri_01h3cbqtgd8gz2bqp7nbk0v6nk"
      }
    end

    endpoint = URI('https://sandbox-api.paddle.com/transactions/preview')
    method = 'POST'
    headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
    }
    body = {
      "items": items,
      "customer_ip_address": "31.94.12.22"
    }.to_json

  http = Net::HTTP.new(endpoint.host, endpoint.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(endpoint.path, headers)
  request.body = body

  response = http.request(request)

  render json: response.body
  end

  def create_monthly_transaction
    # The code below calls the Preview Transaction API to preview the transaction whenever
    monthly_quantity = params[:monthlyQuantity]

    items = [
      {
        "quantity": "#{monthly_quantity}".to_i,
        "price_id": "pri_01h3cbhh5srdgyca7p2cg658bj"
      }
    ]

    if params[:monthlyCheckboxValue] == "true"
      items << {
        "quantity": 1,
        "price_id": "pri_01h3cbqtgd8gz2bqp7nbk0v6nk"
      }
    end

    endpoint = URI('https://sandbox-api.paddle.com/transactions')
    method = 'POST'
    headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
    }
    body = {
      "items": items,
      "currency_code": "USD"
    }.to_json

    http = Net::HTTP.new(endpoint.host, endpoint.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(endpoint.path, headers)
    request.body = body

    response = http.request(request)

    render json: response.body
  end
end
