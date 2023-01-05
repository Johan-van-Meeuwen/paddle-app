import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["orderInfo"]

  displayOrderDetails({ detail: { content } }) {
    this.orderInfoTarget.innerText = content
  }
}
