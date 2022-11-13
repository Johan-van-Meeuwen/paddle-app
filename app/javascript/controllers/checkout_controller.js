import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthlyCheckout", "annualCheckout", "checkoutId"]

  // checkoutComplete() {
  //   alert("Thanks!")
  // }

  openCheckout() {
    Paddle.Checkout.open({
      product: event.target.getAttribute('data-product'),
      // successCallback: checkoutComplete,
      success: '/success'
    });
  }
}
