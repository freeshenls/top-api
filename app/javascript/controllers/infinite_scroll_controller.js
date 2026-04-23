import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["scrollContainer"]

  connect() {
    this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
      root: null,
      rootMargin: "200px",
      threshold: 0.1
    })
    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  handleIntersect(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.loadMore()
      }
    })
  }

  loadMore() {
    if (this.isLoading) return

    const link = this.element.querySelector("a")
    if (link && link.href) {
      this.isLoading = true
      link.click()
      this.element.innerHTML = '<div class="p-4 text-center text-slate-400 text-[10px] font-bold animate-pulse">加载中...</div>'
    }
  }
}
