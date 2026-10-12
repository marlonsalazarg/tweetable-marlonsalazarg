// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Fade removed elements out instead of making them vanish (e.g. a deleted tweet).
document.addEventListener("turbo:before-stream-render", (event) => {
  const stream = event.target
  if (stream.action !== "remove") return

  event.preventDefault()
  stream.targetElements.forEach((element) => {
    element.classList.add("transition", "duration-300", "opacity-0", "scale-95")
    setTimeout(() => element.remove(), 300)
  })
})
