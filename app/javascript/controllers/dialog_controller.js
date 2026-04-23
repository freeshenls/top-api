import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]
  static values = { open: Boolean }

  connect() {
    if (this.openValue) {
      this.open()
    }
  }

  open(e) {
    if (e) e.preventDefault()
    if (this.hasDialogTarget) {
      this.dialogTarget.showModal()
    }
  }

  // 监听 Turbo 提交结束，如果成功则关闭弹窗
  submitEnd(e) {
    if (e.detail.success) {
      this.close()
    }
  }

  close(e) {
    if (e) e.preventDefault()
    if (this.hasDialogTarget) {
      this.dialogTarget.close()
    }
  }

  clickOutside(e) {
    if (e.target === this.dialogTarget) {
      this.close()
    }
  }
}
