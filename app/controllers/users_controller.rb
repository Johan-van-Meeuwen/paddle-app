require 'uri'
require 'net/http'
require 'openssl'

class UsersController < ApplicationController
  def my_profile
    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&plan_id=&state=&page=&results_per_page="

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @last_subscription = @response["response"].last

    # Info to display
    if @last_subscription.nil?
      puts "No subscription"
    else
      p @last_subscription
      @subscription_id = @last_subscription["subscription_id"]
      @user_email = @last_subscription["user_email"]
      @state = @last_subscription["state"]
      @signup_date = @last_subscription["signup_date"]
      @payment_information = @last_subscription["payment_information"]
      if @last_subscription["next_payment"]
        @next_payment = @last_subscription["next_payment"]
        @next_payment_amount = @last_subscription["next_payment"]["amount"]
        @next_payment_currency = @last_subscription["next_payment"]["currency"]
        @next_payment_date = @last_subscription["next_payment"]["date"]
      else
        @paused_at = @last_subscription["paused_at"]
        @paused_from = @last_subscription["paused_from"]
      end
    end

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/plans")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    if @last_subscription
      request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&plan=#{@last_subscription['plan_id']}"

      response = http.request(request)
      @list_plan_response = JSON.parse(response.read_body)
      @plan_name = @list_plan_response["response"].last["name"]
    else
    end
  end

  def cancel_subscription
    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&plan_id=&state=&page=&results_per_page="

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @last_subscription = @response["response"].last

    @subscription_id = @last_subscription["subscription_id"]

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users_cancel")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&subscription_id=#{@subscription_id}"

    response = http.request(request)
    puts response.read_body
    redirect_to "/my_profile"
  end

  def pause_subscription
    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&plan_id=&state=&page=&results_per_page="

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @last_subscription = @response["response"].last

    @subscription_id = @last_subscription["subscription_id"]

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users/update")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&subscription_id=#{@subscription_id}&pause=true"

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @paused_at = @response["paused_at"]
    redirect_to "/my_profile"
  end

  def unpause_subscription
    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&plan_id=&state=&page=&results_per_page="

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @last_subscription = @response["response"].last

    @subscription_id = @last_subscription["subscription_id"]

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users/update")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&subscription_id=#{@subscription_id}&pause=false"

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @paused_at = @response["paused_at"]
    redirect_to "/my_profile"
  end

  def upgrade
    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&plan_id=&state=&page=&results_per_page="

    response = http.request(request)
    @response = JSON.parse(response.read_body)
    @last_subscription = @response["response"].last

    @subscription_id = @last_subscription["subscription_id"]

    url = URI("https://sandbox-vendors.paddle.com/api/2.0/subscription/users/update")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request.body = "vendor_id=9943&vendor_auth_code=7b8536d92a0e8545ba487fef4befc868342164c89cad96090b&subscription_id=#{@subscription_id}&plan_id=42491&prorate=false&bill_immediately=true"

    response = http.request(request)
    puts response.read_body
    redirect_to "/my_profile"
  end
end
