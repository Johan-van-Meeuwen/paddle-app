import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthly", "annual"]

  getMonthlyPrice() {
    let monthlyPrice = this.monthlyTarget
    $.ajax({
      url: 'https://sandbox-checkout.paddle.com/api/2.0/prices',
      dataType: 'jsonp',
      data: {
        product_ids: "38562"
      },
      success: function (data) {
        monthlyPrice.innerText = `${data.response.products[0].currency} ${data.response.products[0].price.gross}`;
      }
    });
  }

  getAnnualPrice() {
    let annualPrice = this.annualTarget
    $.ajax({
      url: 'https://sandbox-checkout.paddle.com/api/2.0/prices',
      dataType: 'jsonp',
      data: {
        product_ids: "38566"
      },
      success: function (data) {
        annualPrice.innerText = `${data.response.products[0].currency} ${data.response.products[0].price.gross}`;
      }
    });
  }
}
