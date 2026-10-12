import { Controller } from "@hotwired/stimulus"

// Confirmation modal for destructive actions. Triggers pass the DELETE url (and whether to
// redirect instead of removing inline) through action params:
//   data-action="confirm-dialog#open" data-confirm-dialog-url-param="/tweets/1"
export default class extends Controller {
  static targets = ["dialog", "form", "redirect", "submit"]

  open({ params: { url, redirect } }) {
    this.formTarget.action = url
    this.redirectTarget.value = redirect ? "1" : ""
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  // A click on the ::backdrop targets the <dialog> itself, not its content.
  backdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  submitting() {
    this.submitTarget.disabled = true
    this.submitTarget.textContent = "Deleting…"
  }

  submitted() {
    this.submitTarget.disabled = false
    this.submitTarget.textContent = "Delete"
    this.close()
  }
}
