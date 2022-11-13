import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthlyCheckout", "annualCheckout"]

  openCheckout() {
    Paddle.Checkout.open({
      product: event.path[0].attributes[1].nodeValue,
      success: 'success'
    });
  }
}
