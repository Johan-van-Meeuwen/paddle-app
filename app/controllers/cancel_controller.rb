class CancelController < ApplicationController
  def cancel_subscription
    puts "Cancelled!"

    redirect_to "/my_profile/cancel"
  end
end
