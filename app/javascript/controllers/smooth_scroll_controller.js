import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["scrollContainer"]

  scrollTo(event) {
    // 阻止默认的跳转行为
    event.preventDefault()

    // 获取目标 ID (例如 #category_12)
    const targetId = event.currentTarget.getAttribute("href")
    const targetElement = document.querySelector(targetId)

    if (targetElement && this.hasScrollContainerTarget) {
      // 获取目标相对于滚动容器的位置
      const containerTop = this.scrollContainerTarget.getBoundingClientRect().top
      const elementTop = targetElement.getBoundingClientRect().top
      const offset = elementTop - containerTop + this.scrollContainerTarget.scrollTop

      // 执行平滑滚动
      this.scrollContainerTarget.scrollTo({
        top: offset - 20, // 留出一点边距
        behavior: "smooth"
      })

      // 更新 URL 的 hash (可选，不刷新页面)
      history.pushState(null, null, targetId)
    }
  }
}
