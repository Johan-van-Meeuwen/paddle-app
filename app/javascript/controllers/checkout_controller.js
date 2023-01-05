import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthlyCheckout", "annualCheckout"]
  connect() {
    Paddle.Environment.set('sandbox');
    Paddle.Setup({
      vendor: 9943,
      eventCallback: function(data) {
        console.log(data)
      }
    });
  }

  openCheckout() {
    Paddle.Checkout.open({
      product: event.target.getAttribute('data-product'),
      success: "/success"
    });
  }
}
