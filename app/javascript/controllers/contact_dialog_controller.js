import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open(e) {
    if (e) e.preventDefault()
    if (this.hasDialogTarget) {
      this.dialogTarget.showModal()
    } else {
      console.warn("Contact dialog target not found!")
    }
  }

  close(e) {
    if (e) e.preventDefault()
    this.dialogTarget.close()
  }
  
  // 点击背景关闭
  clickOutside(e) {
    if (e.target === this.dialogTarget) {
      this.close()
    }
  }
}
