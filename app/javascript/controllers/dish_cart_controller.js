// app/javascript/controllers/dish_cart_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dish-cart"
export default class extends Controller {
  static targets = ["addButton", "counter", "quantity"]
  static values = {
    dishId: Number,
    addUrl: String
  }

  add(event) {
    event.preventDefault()

    // визуально меняем кнопку
    this.addButtonTarget.classList.add("d-none")
    this.counterTarget.classList.remove("d-none")
    this.quantityTarget.textContent = "1"

    // отправляем 1 позицию на сервер
    this.sendToCart(1)
  }

  increment(event) {
    event.preventDefault()
    const newQty = this.currentQuantity + 1
    this.quantityTarget.textContent = String(newQty)
    // пока количество в реальной корзине меняем уже на экране Cart
  }

  decrement(event) {
    event.preventDefault()
    const newQty = this.currentQuantity - 1

    if (newQty <= 0) {
      // обнуляем визуально, а в реальной корзине пользователь поправит на экране Cart
      this.counterTarget.classList.add("d-none")
      this.addButtonTarget.classList.remove("d-none")
      this.quantityTarget.textContent = "1"
    } else {
      this.quantityTarget.textContent = String(newQty)
    }
  }

  get currentQuantity() {
    return parseInt(this.quantityTarget.textContent || "1", 10) || 1
  }

  sendToCart(qty) {
    const tokenMeta = document.querySelector('meta[name="csrf-token"]')
    const csrfToken = tokenMeta && tokenMeta.content

    const params = new URLSearchParams()
    params.append("dish_id", this.dishIdValue)
    params.append("quantity", String(qty))

    fetch(this.addUrlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-CSRF-Token": csrfToken
      },
      body: params.toString()
    }).catch((error) => {
      console.error("Error adding item to cart", error)
    })
  }
}