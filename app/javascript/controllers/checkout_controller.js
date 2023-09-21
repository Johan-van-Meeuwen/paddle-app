import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthlyCheckout", "annualCheckout"]
  connect() {
    Paddle.Environment.set('sandbox');
    Paddle.Setup({
      seller: 9943,
      eventCallback: function(data) {
        if (data.name == "checkout.completed") {
          console.log(data)
          let createdBusinessId

          // Saving the below variables to session data to use in my account area
          let createdCustomerId = data.data.customer.id;
          console.log(createdCustomerId)
          let createdAddressId = data.data.customer.address.id;
          console.log(createdAddressId)
          let createdCheckoutId = data.data.id;
          console.log(createdCheckoutId)
          let createdTransactionId = data.data.transaction_id;
          console.log(createdTransactionId)
          if (data.data.customer.business) {
            createdBusinessId = data.data.customer.business.id
            console.log(createdBusinessId)
          } else {
            console.log("No business info provided")
          }
          let createdQuantity = data.data.items[0].quantity

          let params = new URLSearchParams();
          params.append("createdCustomerId", createdCustomerId)
          params.append("createdAddressId", createdAddressId)
          params.append("createdCheckoutId", createdCheckoutId)
          params.append("createdTransactionId", createdTransactionId)
          if (typeof createdBusinessId !== 'undefined') {
            params.append("createdBusinessId", createdBusinessId)
          } else {
            console.log("No business info provided")
          }
          params.append("createdQuantity", createdQuantity)

          fetch("/save_customer?" + params)
            .then(response => response.json())
            .then(data => {
              console.log(data)
            })
            .catch(error => {
              console.error("Error saving customer", error);
            });
        }
      }
    });
  }

  openCheckout() {
    let monthlyQuantity = document.getElementById("monthly-users").value;
    let monthlyCheckboxValue = document.getElementById("monthly-onboarding-support").checked;

    let params = new URLSearchParams();
    params.append("monthlyQuantity", monthlyQuantity);
    params.append("monthlyCheckboxValue", monthlyCheckboxValue);

    fetch("/create_monthly_transaction?" + params)
      .then(response => response.json())
      .then(data => {
        let createdTransactionId = data.data.id
        console.log(createdTransactionId)

        Paddle.Checkout.open({
          settings: {
            theme: "light"
          },
          transactionId: createdTransactionId,
          // discountId: "dsc_01h2bnv663v06e2g65cx8crg8m",
        });
      })
      .catch(error => {
        console.error("Error creating transaction:", error);
      });
  }
}
