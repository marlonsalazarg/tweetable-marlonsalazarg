import { Controller } from "@hotwired/stimulus"

// Self-dismissing notification. Pauses while hovered.
export default class extends Controller {
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    this.clearOnCache = () => this.element.remove()
    document.addEventListener("turbo:before-cache", this.clearOnCache)
    requestAnimationFrame(() => this.element.classList.remove("translate-y-2", "opacity-0"))
    this.resume()
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.clearOnCache)
    clearTimeout(this.timer)
  }

  pause() {
    clearTimeout(this.timer)
  }

  resume() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.dismiss(), this.delayValue)
  }

  dismiss() {
    clearTimeout(this.timer)
    this.element.classList.add("translate-y-2", "opacity-0")
    setTimeout(() => this.element.remove(), 300)
  }
}
