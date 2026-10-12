import { Controller } from "@hotwired/stimulus"

// Classes that hide the mobile menu panel / backdrop; removing them plays the open transition.
const MENU_CLOSED = ["invisible", "opacity-0", "-translate-y-2"]
const BACKDROP_CLOSED = ["invisible", "opacity-0"]

// Mobile menu: a panel that drops from the header over a dimmed page. It closes from the
// toggle, a tap on the backdrop, Escape, before Turbo caches the page (so Back never restores
// it open), and when the viewport grows to the desktop nav.
export default class extends Controller {
  static targets = ["menu", "backdrop", "button", "openIcon", "closeIcon"]

  connect() {
    this.desktop = window.matchMedia("(min-width: 768px)")
    this.closeOnDesktop = (event) => event.matches && this.close()
    this.desktop.addEventListener("change", this.closeOnDesktop)
  }

  disconnect() {
    this.desktop.removeEventListener("change", this.closeOnDesktop)
    document.documentElement.classList.remove("overflow-hidden")
  }

  toggle() {
    this.render(!this.isOpen)
  }

  close() {
    if (this.isOpen) this.render(false)
  }

  closeOnEscape() {
    if (!this.isOpen) return
    this.close()
    this.buttonTarget.focus()
  }

  get isOpen() {
    return this.buttonTarget.getAttribute("aria-expanded") === "true"
  }

  render(open) {
    this.buttonTarget.setAttribute("aria-expanded", String(open))
    this.buttonTarget.setAttribute("aria-label", open ? "Close menu" : "Open menu")
    MENU_CLOSED.forEach((name) => this.menuTarget.classList.toggle(name, !open))
    BACKDROP_CLOSED.forEach((name) => this.backdropTarget.classList.toggle(name, !open))
    this.openIconTarget.classList.toggle("hidden", open)
    this.closeIconTarget.classList.toggle("hidden", !open)
    document.documentElement.classList.toggle("overflow-hidden", open)
  }
}
