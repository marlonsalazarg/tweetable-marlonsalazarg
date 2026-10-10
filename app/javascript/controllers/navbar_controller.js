import { Controller } from "@hotwired/stimulus"

// Mobile menu toggle for the header.
export default class extends Controller {
  static targets = ["menu", "button", "open", "close"]

  toggle() {
    const hidden = this.menuTarget.classList.toggle("hidden")
    this.buttonTarget.setAttribute("aria-expanded", String(!hidden))
    this.openTarget.classList.toggle("hidden", !hidden)
    this.closeTarget.classList.toggle("hidden", hidden)
  }
}
