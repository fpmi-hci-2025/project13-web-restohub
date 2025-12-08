import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["addButton", "counter", "quantity"]

    connect() {
        this.quantity = 1
    }

    add() {
        this.quantity = 1
        this.addButtonTarget.classList.add("d-none")
        this.counterTarget.classList.remove("d-none")
        this.quantityTarget.textContent = this.quantity
    }

    increment() {
        this.quantity += 1
        this.quantityTarget.textContent = this.quantity
    }

    decrement() {
        if (this.quantity <= 1) {
            this.quantity = 1
            this.counterTarget.classList.add("d-none")
            this.addButtonTarget.classList.remove("d-none")
            return
        }

        this.quantity -= 1
        this.quantityTarget.textContent = this.quantity
    }
}
