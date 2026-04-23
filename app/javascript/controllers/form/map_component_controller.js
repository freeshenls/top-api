import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "map", "searchInput", "lng", "lat", "iconPath", "resultsContainer"]

  connect() {
    this.isFullScreen = false
    if (typeof AMap === 'undefined') {
      console.error("高德地图 SDK 未加载")
      return
    }
    this.initMap()
  }

  initMap() {
    // 初始化地图
    this.map = new AMap.Map(this.mapTarget, {
      zoom: 11,
      center: [116.397428, 39.90923], // 默认位置
      viewMode: '2D'
    })

    // 加载插件：工具条 + 搜索
    AMap.plugin(['AMap.ToolBar', 'AMap.AutoComplete', 'AMap.PlaceSearch'], () => {
      this.map.addControl(new AMap.ToolBar({ position: 'RB', liteStyle: true }))

      const autoComplete = new AMap.AutoComplete({ 
        input: this.searchInputTarget,
        output: this.resultsContainerTarget
      })
      const placeSearch = new AMap.PlaceSearch({ map: this.map })

      autoComplete.on("select", (e) => {
        placeSearch.search(e.poi.name, (status, result) => {
          if (status === 'complete' && result.poiList.pois.length > 0) {
            this.updateLocation(result.poiList.pois[0].location, true)
          }
        })
      })
    })

    // 点击选点
    this.map.on('click', (e) => this.updateLocation(e.lnglat, false))
  }

  // 切换全屏逻辑
  toggleFullScreen(e) {
    e.preventDefault()
    this.isFullScreen = !this.isFullScreen

    if (this.isFullScreen) {
      this.containerTarget.classList.add('fixed', 'inset-0', 'z-[110]', 'rounded-none')
      this.mapTarget.classList.add('!h-screen')
      this.iconPathTarget.setAttribute('d', 'M6 18L18 6M6 6l12 12') // 切换为关闭图标
    } else {
      this.containerTarget.classList.remove('fixed', 'inset-0', 'z-[110]', 'rounded-none')
      this.mapTarget.classList.remove('!h-screen')
      this.iconPathTarget.setAttribute('d', 'M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4')
    }

    // 必须 resize，否则地图显示会错位
    setTimeout(() => {
      this.map.resize()
      if (this.marker) this.map.setCenter(this.marker.getPosition())
    }, 400)
  }

  updateLocation(lnglat, zoomIn = false) {
    this.lngTarget.value = lnglat.getLng()
    this.latTarget.value = lnglat.getLat()

    if (this.marker) {
      this.marker.setPosition(lnglat)
    } else {
      this.marker = new AMap.Marker({ position: lnglat, map: this.map })
    }

    this.map.setCenter(lnglat)
    if (zoomIn) this.map.setZoom(16)
  }
}
