import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "category", "item", "noResults"]

  perform() {
    const query = this.inputTarget.value.toLowerCase().trim()
    
    if (query === "") {
      this.reset()
      return
    }

    this.itemTargets.forEach(item => {
      const content = (item.dataset.searchContent || "").toLowerCase()
      
      if (content.includes(query)) {
        item.classList.remove("hidden")
      } else {
        item.classList.add("hidden")
      }
    })

    this.updateContainers()
  }

  updateContainers() {
    let hasAnyVisible = false

    // Handle Category visibility
    this.categoryTargets.forEach(category => {
      const visibleItems = category.querySelectorAll('[data-search-target="item"]:not(.hidden)')
      
      if (visibleItems.length > 0) {
        category.classList.remove("hidden")
        hasAnyVisible = true
      } else {
        category.classList.add("hidden")
      }
    })

    // Handle "No Results" state
    if (hasAnyVisible) {
      this.noResultsTarget.classList.add("hidden")
    } else {
      this.noResultsTarget.classList.remove("hidden")
    }
  }

  reset() {
    this.itemTargets.forEach(item => item.classList.remove("hidden"))
    this.categoryTargets.forEach(category => category.classList.remove("hidden"))
    this.noResultsTarget.classList.add("hidden")
  }
}
