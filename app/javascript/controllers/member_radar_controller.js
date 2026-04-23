import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "container", "tooltip"]
  static values = {
    center: Object,
    members: Array
  }

  connect() {
    this.map = null
    this.markers = []
    this.activeMemberId = null
    
    // 防止点击名片内容时触发地图点击事件导致名片关闭
    this.tooltipTarget.addEventListener('click', (e) => {
      e.stopPropagation()
    })
  }

  open() {
    this.dialogTarget.showModal()
    setTimeout(() => {
      this.initMap()
    }, 300)
  }

  close() {
    this.dialogTarget.close()
    this.destroyMap()
  }

  destroyMap() {
    if (this.map) {
      this.map.destroy()
      this.map = null
    }
  }

  initMap() {
    if (typeof AMap === 'undefined') return
    if (this.map) return

    const center = [parseFloat(this.centerValue.lng), parseFloat(this.centerValue.lat)]
    
    this.map = new AMap.Map(this.containerTarget, {
      zoom: 11,
      center: center,
      viewMode: '3D',
      mapStyle: 'amap://styles/darkblue'
    })

    // 中心点
    const centerMarker = new AMap.Marker({
      position: center,
      content: `
        <div class="relative">
          <div class="absolute -inset-4 bg-amber-500/30 rounded-full animate-ping"></div>
          <div class="h-5 w-5 bg-amber-500 rounded-full border-2 border-white shadow-lg flex items-center justify-center">
            <div class="h-2 w-2 bg-white rounded-full"></div>
          </div>
        </div>
      `,
      offset: new AMap.Pixel(-10, -10),
      zIndex: 100
    })
    this.map.add(centerMarker)

    // 其他会员
    this.markers = []
    this.membersValue.forEach(m => {
      const pos = [parseFloat(m.lng), parseFloat(m.lat)]
      
      const marker = new AMap.Marker({
        position: pos,
        content: `
          <div class="group relative cursor-pointer">
            <div class="h-3 w-3 bg-sky-400 rounded-full border border-white/50 shadow-sm hover:scale-125 hover:bg-white transition-all"></div>
          </div>
        `,
        offset: new AMap.Pixel(-6, -6),
        extData: m
      })

      marker.on('click', (e) => {
        // 停止事件冒泡，防止触发 map.on('click')
        if (e.originEvent) e.originEvent.stopPropagation()
        this.showMemberCard(m, pos)
      })

      this.markers.push(marker)
    })

    this.map.add(this.markers)

    // 点击地图空白处关闭名片
    this.map.on('click', () => {
      this.hideMemberCard()
    })

    if (this.markers.length > 0) {
      setTimeout(() => {
        this.map.setFitView(null, false, [60, 60, 60, 60])
      }, 500)
    }
  }

  async showMemberCard(member, pos) {
    this.activeMemberId = member.id
    
    this.tooltipTarget.classList.remove('hidden')
    this.tooltipTarget.classList.remove('pointer-events-none') // 彻底移除禁用
    this.tooltipTarget.classList.add('pointer-events-auto')    // 确保启用
    
    this.tooltipTarget.innerHTML = `
      <div class="w-64 bg-white rounded-2xl shadow-2xl border border-slate-100 overflow-hidden p-8 flex items-center justify-center">
        <div class="h-6 w-6 border-2 border-sky-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
    `
    
    const pixel = this.map.lngLatToContainer(pos)
    this.tooltipTarget.style.left = `${pixel.getX() + 15}px`
    this.tooltipTarget.style.top = `${pixel.getY() - 120}px`

    try {
      const response = await fetch(`/members/${member.id}/card`)
      const html = await response.text()
      
      const wrapper = document.createElement('div')
      wrapper.className = 'relative'
      wrapper.innerHTML = `
        <button class="absolute top-3 right-3 z-20 h-6 w-6 bg-slate-100 hover:bg-slate-200 rounded-full flex items-center justify-center text-slate-500 transition-colors shadow-sm" id="close-card-btn">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        ${html}
      `
      this.tooltipTarget.innerHTML = ''
      this.tooltipTarget.appendChild(wrapper)

      wrapper.querySelector('#close-card-btn').onclick = (e) => {
        e.preventDefault()
        e.stopPropagation()
        this.hideMemberCard()
      }
    } catch (error) {
      this.tooltipTarget.innerHTML = '<div class="p-4 text-xs text-red-400">加载失败</div>'
    }
  }

  hideMemberCard() {
    this.activeMemberId = null
    this.tooltipTarget.classList.add('hidden')
    this.tooltipTarget.classList.add('pointer-events-none')
    this.tooltipTarget.classList.remove('pointer-events-auto')
  }
}
