import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  toggle(event) {
    event.preventDefault()
    
    // 切换内容显隐
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle("hidden")
    }

    // 切换图标旋转
    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle("rotate-90")
    }
  }
}
