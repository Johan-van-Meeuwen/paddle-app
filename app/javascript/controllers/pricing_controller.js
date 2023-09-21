import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthly", "annual"]

  connect() {
    this.getMonthlyPrice();
  }

  getMonthlyPrice() {
    // const priceId = "pri_01h28bhhe6aak08v7dtm64fskx"
    // const url = `https://sandbox-api.paddle.com/prices/${priceId}`

    // console.log(priceId)
    // fetch(url)
    //   .then(response => response.json())
    //   .then(data => {
    //     console.log(data)
    //   })
    //   .catch(error => {
    //     console.error('Error loading price:', error)
    //   });

    // let monthlyPrice = this.monthlyTarget
    // $.ajax({
    //   url: 'https://sandbox-checkout.paddle.com/api/2.0/prices',
    //   dataType: 'jsonp',
    //   data: {
    //     product_ids: "42490"
    //   },
    //   success: function (data) {
    //     monthlyPrice.innerText = `${data.response.products[0].currency} ${data.response.products[0].price.gross}`;
    //   }
    // });
  }

  getAnnualPrice() {
    let annualPrice = this.annualTarget
    $.ajax({
      url: 'https://sandbox-checkout.paddle.com/api/2.0/prices',
      dataType: 'jsonp',
      data: {
        product_ids: "42491"
      },
      success: function (data) {
        annualPrice.innerText = `${data.response.products[0].currency} ${data.response.products[0].price.gross}`;
      }
    });
  }
}
