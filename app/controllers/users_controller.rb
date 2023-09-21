require 'uri'
require 'net/http'
require 'openssl'
require 'sleep'

class UsersController < ApplicationController
  def my_profile
    # Below calls the GET endpoints and retrieves the all information from the checkout
    @customer_id = session[:session_customer_id]
    @address_id = session[:session_address_id]
    @business_id = session[:session_business_id]
    @checkout_id = session[:session_checkout_id]
    @transaction_id = session[:session_transaction_id]
    @quantity = session[:session_quantity]

    # Customer Details
    url = URI.parse("https://sandbox-api.paddle.com/customers/#{@customer_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

<<<<<<< HEAD
    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&plan_id=&state=&page=&results_per_page="
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

    response = http.request(request)
    response = JSON.parse(response.read_body)

    # Email to display on welcome message
    @customer_email = response['data']['email']

    show_subscription_id
    show_subscription
    show_business
    list_transaction_information
    list_addresses
    list_businesses
  end

  def show_subscription_id
    url = URI.parse("https://sandbox-api.paddle.com/transactions/#{@transaction_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

<<<<<<< HEAD
    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'

    response = http.request(request)
    response = JSON.parse(response.read_body)

    # Subscription ID
    @subscription_id = response['data']['subscription_id']
    session[:session_subscription_id] = @subscription_id
  end

  def show_subscription
    url = URI.parse("https://sandbox-api.paddle.com/subscriptions/#{@subscription_id}?include=next_transaction")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'

    response = http.request(request)
    response = JSON.parse(response.read_body)

    # Subscription status:
    @subscription_status = response['data']['status']

    # Next billing date & amount
    next_billing_date_unformatted = response['data']['next_transaction']['billing_period']['starts_at']
    datetime_str = "2023-07-26T17:24:38.961845Z"
    datetime = DateTime.parse(next_billing_date_unformatted)
    @next_billing_date = datetime.strftime("%d %b")  # "26 Jul"

    next_billing_amount_unformatted = response['data']['next_transaction']['details']['totals']['grand_total'].to_i
    @next_billing_amount = sprintf("$%.2f", next_billing_amount_unformatted / 100.0)

    @current_quantity_transaction = response['data']['items'][0]['quantity']
    @current_product_description = response['data']['items'][0]['price']['description']
    @quantity = response['data']['items'][0]['quantity']
    session[:session_quantity] = @quantity
  end

  def show_business
    url = URI.parse("https://sandbox-api.paddle.com/customers/#{@customer_id}/businesses/#{@business_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'

    response = http.request(request)
    response = JSON.parse(response.read_body)

    @business_name = response['data']['name']
  end

  def preview_pro_upgrade
    subscription_id = params[:subscription_id]
    pro_quantity = params[:numberOfProUsers]
    support_checked = params[:supportBoxChecked]

    items = [
      {
        "quantity": "#{pro_quantity}".to_i,
        "price_id": "pri_01h3q11evma4bndbm0d5zh1cxa"
      }
    ]

    if support_checked == "true"
      items << {
        "quantity": "#{pro_quantity}".to_i,
        "price_id": "pri_01h3wezgzssv5j973aye2kspxb"
      }
    end

    @discount_id

    if pro_quantity.to_i > 10
      endpoint = URI("https://sandbox-api.paddle.com/discounts")
      method = 'POST'
      headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
      }
      body = {
        "amount": "20",
        "description": "Discount for above 10 seats",
        "type": "percentage",
        "recur": true
      }.to_json

      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(endpoint.path, headers)
      request.body = body
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    if @last_subscription
      request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&plan=#{@last_subscription['plan_id']}"
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

      response = http.request(request)
      response_body = response.body

      parsed_response = JSON.parse(response_body)

      @discount_id = parsed_response['data']['id']
    end

    endpoint = URI("https://sandbox-api.paddle.com/subscriptions/#{subscription_id}/preview")
    method = 'PATCH'
    headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
    }

    body

    if pro_quantity.to_i > 10
      body = {
        "items": items,
        "proration_billing_mode": "prorated_immediately",
        "discount": {
          "id": @discount_id,
          "effective_from": "immediately"
        }
      }.to_json
    else
      body = {
        "items": items,
        "proration_billing_mode": "prorated_immediately"
      }.to_json
    end

    http = Net::HTTP.new(endpoint.host, endpoint.port)
    http.use_ssl = true

    request = Net::HTTP::Patch.new(endpoint.path, headers)
    request.body = body

    response = http.request(request)
    response_body = response.body

    parsed_response = JSON.parse(response_body)

    p parsed_response

    render json: parsed_response
    # TODO: Give more data aback in response to display on page
  end

  def pro_upgrade
    subscription_id = params[:subscription_id]
    pro_quantity = params[:upgradeNumberOfUsers]
    support_checked = params[:supportBoxChecked]

    items = [
      {
        "quantity": "#{pro_quantity}".to_i,
        "price_id": "pri_01h3q11evma4bndbm0d5zh1cxa"
      }
    ]

    if support_checked == "true"
      items << {
        "quantity": "#{pro_quantity}".to_i,
        "price_id": "pri_01h3wezgzssv5j973aye2kspxb"
      }
    end

    @discount_id

    if pro_quantity.to_i > 10
      endpoint = URI("https://sandbox-api.paddle.com/discounts")
      method = 'POST'
      headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
      }
      body = {
        "amount": "20",
        "description": "Discount for above 10 seats",
        "type": "percentage",
        "recur": true
      }.to_json

      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(endpoint.path, headers)
      request.body = body

      response = http.request(request)
      response_body = response.body

      parsed_response = JSON.parse(response_body)

      @discount_id = parsed_response['data']['id']
    end

    endpoint = URI("https://sandbox-api.paddle.com/subscriptions/#{subscription_id}")
    method = 'PATCH'
    headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
    }

    body

    if pro_quantity.to_i > 10
      body = {
        "items": items,
        "proration_billing_mode": "prorated_immediately",
        "discount": {
          "id": @discount_id,
          "effective_from": "immediately"
        }
      }.to_json
    else
      body = {
        "items": items,
        "proration_billing_mode": "prorated_immediately"
      }.to_json
    end

    http = Net::HTTP.new(endpoint.host, endpoint.port)
    http.use_ssl = true

    request = Net::HTTP::Patch.new(endpoint.path, headers)
    request.body = body

    response = http.request(request)
    response_body = response.body

    parsed_response = JSON.parse(response_body)

    # Might need to remove this
    render json: parsed_response

    url = URI.parse("https://sandbox-api.paddle.com/transactions?subscription_id=#{subscription_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'

    response = http.request(request)
    response = JSON.parse(response.read_body)

    # Updating txn_id
    @transaction_id = response['data'].first['id']
    session[:session_transaction_id] = @transaction_id
  end

  def pro_priority_upgrade
    # Perhaps no need to do this - can use other methods and just pass params
  end

  def cancel_subscription
    @subscription_id = session[:session_subscription_id]

    endpoint = URI("https://sandbox-api.paddle.com/subscriptions/#{@subscription_id}/cancel")
    method = 'POST'
    headers = {
      'Authorization': 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
    }
    body = {
      "effective_from": "immediately"
    }.to_json

    http = Net::HTTP.new(endpoint.host, endpoint.port)
    http.use_ssl = true

<<<<<<< HEAD
    request = Net::HTTP::Post.new(endpoint.path, headers)
    request.body = body
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&plan_id=&state=&page=&results_per_page="
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

    response = http.request(request)

    response_body = response.body

    parsed_response = JSON.parse(response_body)

<<<<<<< HEAD
    redirect_to "/"
=======
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&subscription_id=#{@subscription_id}"

    response = http.request(request)
    puts response.read_body
    redirect_to "/my_profile"
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d
  end

  def list_transaction_information
    # Wait until other updates have been made!
    puts "Getting list of transactions"

    url = URI.parse("https://sandbox-api.paddle.com/transactions?subscription_id=#{@subscription_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

<<<<<<< HEAD
    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&plan_id=&state=&page=&results_per_page="
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

    response = http.request(request)
    response = JSON.parse(response.read_body)

    @transaction_list = response['data']

    @amended_transaction_list = []

    @transaction_list.each do |transaction|
      id = transaction['id']
      status = transaction['status']
      grand_total = transaction['details']['totals']['grand_total']
      item_prices = transaction['items']

<<<<<<< HEAD
      url = URI.parse("https://sandbox-api.paddle.com/transactions/#{id}/invoice")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      request["Content-Type"] = 'application/json'
      request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
      response = http.request(request)
      response = JSON.parse(response.read_body)
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&subscription_id=#{@subscription_id}&pause=true"
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

      receipt_url = response['data']['url']

      id_hash = id
      status_hash = status
      grand_total_hash = grand_total
      receipt_url_hash = receipt_url
      item_prices_hash = item_prices

      amended_transaction = {
        id: id_hash,
        status: status_hash,
        grand_total: grand_total_hash,
        receipt_url: receipt_url_hash,
        item_prices: item_prices_hash
      }

      @amended_transaction_list << amended_transaction
    end
  end

  def list_addresses
    @customer_id = session[:session_customer_id]

    url = URI.parse("https://sandbox-api.paddle.com/customers/#{@customer_id}/addresses")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

<<<<<<< HEAD
    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&plan_id=&state=&page=&results_per_page="
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

    response = http.request(request)
    response = JSON.parse(response.read_body)

<<<<<<< HEAD
    @address_list =  response['data']
=======
    @subscription_id = @last_subscription["subscription_id"]

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users/update")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&subscription_id=#{@subscription_id}&pause=false"

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @paused_at = @response["paused_at"]
    redirect_to "/my_profile"
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d
  end

  def list_businesses
    @customer_id = session[:session_customer_id]

    url = URI.parse("https://sandbox-api.paddle.com/customers/#{@customer_id}/businesses")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

<<<<<<< HEAD
    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Bearer 7b8536d92a0e8545ba487fef4befc868342164c89cad96090b'
=======
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&plan_id=&state=&page=&results_per_page="
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d

    response = http.request(request)
    response = JSON.parse(response.read_body)

<<<<<<< HEAD
    @business_list =  response['data']
=======
    @subscription_id = @last_subscription["subscription_id"]

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users/update")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id={VENDOR_ID}&vendor_auth_code={VENDOR_AUTH_CODE}&subscription_id=#{@subscription_id}&plan_id=42491&prorate=false&bill_immediately=true"

    response = http.request(request)
    puts response.read_body
    redirect_to "/my_profile"
>>>>>>> bbef108fa99e47f657f715d110776e9e89ed685d
  end
end
