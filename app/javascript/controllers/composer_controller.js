import { Controller } from "@hotwired/stimulus"

// Tweet composer: counts down the characters left and keeps submit off while the body is blank.
export default class extends Controller {
  static targets = ["input", "count", "submit"]
  static values = { max: { type: Number, default: 140 }, warnAt: { type: Number, default: 20 } }

  connect() {
    this.update()
  }

  update() {
    const left = this.maxValue - this.inputTarget.value.length
    this.countTarget.textContent = left
    this.countTarget.classList.toggle("text-primary-600", left <= this.warnAtValue)
    this.countTarget.classList.toggle("font-semibold", left <= this.warnAtValue)
    this.submitTarget.disabled = this.inputTarget.value.trim() === ""
  }
}
