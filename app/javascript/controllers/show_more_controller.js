import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "button"]
  static values = { limit: { type: Number, default: 10 } }

  connect() {
    this.updateVisibility()
  }

  updateVisibility() {
    this.itemTargets.forEach((item, index) => {
      if (index >= this.limitValue) {
        item.classList.add("hidden")
      } else {
        item.classList.remove("hidden")
      }
    })

    if (this.itemTargets.length <= this.limitValue) {
      if (this.hasButtonTarget) this.buttonTarget.classList.add("hidden")
    }
  }

  toggle() {
    this.itemTargets.forEach(item => item.classList.remove("hidden"))
    if (this.hasButtonTarget) this.buttonTarget.classList.add("hidden")
  }
}
