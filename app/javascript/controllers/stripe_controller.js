// app/javascript/controllers/stripe_controller.js
import { Controller } from "@hotwired/stimulus"
import { loadStripe } from "@stripe/stripe-js"

export default class extends Controller {
  static targets = ["card", "form", "receiverName", "address", "city", "zip", "provinceId", "shippingTypeId"]

  async connect() {
    this.stripe = await loadStripe("your-publishable-key-here")

    const elements = this.stripe.elements()
    this.card = elements.create("card")
    this.card.mount(this.cardTarget)
  }

  async submit(event) {
    event.preventDefault()

    const { paymentMethod, error } = await this.stripe.createPaymentMethod({
      type: "card",
      card: this.card,
    })

    if (error) {
      console.error(error)
      this.displayError(error.message)
    } else {
      this.createOrder(paymentMethod.id)
    }
  }

  async createOrder(paymentMethodId) {
    const response = await fetch("/orders", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
      body: JSON.stringify({
        payment_method_id: paymentMethodId,
        order: {
          receiver_name: this.receiverNameTarget.value,
          address: this.addressTarget.value,
          city: this.cityTarget.value,
          zip: this.zipTarget.value,
          province_id: this.provinceIdTarget.value,
          shipping_type_id: this.shippingTypeIdTarget.value,
        },
      }),
    })

    const data = await response.json()
    if (data.error) {
      this.displayError(data.error)
    } else {
      console.log("Order placed successfully:", data)
      // Redirect or update the UI accordingly
    }
  }

  displayError(message) {
    const errorElement = document.getElementById("card-errors")
    errorElement.textContent = message
  }
}
