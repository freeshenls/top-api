import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { index: Number, default: 0 }

  connect() {
    // 初始显示
    this.showTab(this.indexValue)
  }

  // 点击切换事件
  switch(event) {
    event.preventDefault()
    this.indexValue = event.currentTarget.dataset.index
  }

  // 监听值变化，自动更新 UI
  indexValueChanged(index) {
    this.showTab(index)
  }

  showTab(index) {
    // 1. 切换 Tab 按钮样式
    this.tabTargets.forEach((tab, i) => {
      const activeClasses = tab.getAttribute('data-active-class')?.split(' ')
      const inactiveClasses = tab.getAttribute('data-inactive-class')?.split(' ')

      if (i == index) {
        tab.classList.add(...activeClasses)
        tab.classList.remove(...inactiveClasses)
      } else {
        tab.classList.remove(...activeClasses)
        tab.classList.add(...inactiveClasses)
      }
    })

    // 2. 切换内容面板
    this.panelTargets.forEach((panel, i) => {
      if (i == index) {
        panel.classList.remove('hidden')
      } else {
        panel.classList.add('hidden')
      }
    })
  }
}