const WritingHighlight = {
  mounted() {
    this.indicator = this.el.querySelector(".writing-highlight")
    this.hover = window.matchMedia("(hover: hover) and (pointer: fine)")
    this.listeners = new AbortController()
    const options = {signal: this.listeners.signal}

    this.el.addEventListener("pointermove", event => {
      if (!this.hover.matches || event.pointerType === "touch") return
      const entry = event.target.closest(".writing-entry")
      if (entry && entry !== this.entry) {
        this.moveHighlight(entry)
      }
    }, options)
    this.el.addEventListener("pointerleave", () => this.hideHighlight(), options)
    this.el.addEventListener("pointerdown", event => {
      if (event.pointerType === "touch") this.hideHighlight(true)
    }, options)
    document.addEventListener("keydown", () => this.hideHighlight(true), options)
    this.hover.addEventListener("change", () => this.hideHighlight(true), options)
    this.resizeObserver = new ResizeObserver(() => {
      if (this.entry) this.moveHighlight(this.entry, true)
    })
    this.observeEntries()
  },

  moveHighlight(entry, instant = false) {
    const snap = instant || getComputedStyle(this.indicator).opacity === "0"
    if (snap) this.indicator.style.transition = "none"

    const row = entry.getBoundingClientRect()
    const list = this.el.getBoundingClientRect()
    this.indicator.style.transform = `translateY(${row.top - list.top}px)`
    this.indicator.style.height = `${row.height}px`

    if (snap) {
      this.indicator.getBoundingClientRect()
      this.indicator.style.transition = ""
    }
    this.indicator.setAttribute("data-visible", "")
    this.entry = entry
  },

  hideHighlight(instant = false) {
    this.indicator.style.transition = instant ? "none" : ""
    this.indicator.removeAttribute("data-visible")
    this.entry = null
  },

  observeEntries() {
    this.resizeObserver.disconnect()
    this.resizeObserver.observe(this.el)
    this.el.querySelectorAll(".writing-entry").forEach(entry => {
      this.resizeObserver.observe(entry)
    })
  },

  updated() {
    this.indicator = this.el.querySelector(".writing-highlight")
    this.observeEntries()
    if (this.entry && this.el.contains(this.entry)) {
      this.moveHighlight(this.entry, true)
    } else {
      this.hideHighlight(true)
    }
  },

  destroyed() {
    this.listeners.abort()
    this.resizeObserver.disconnect()
  }
}

export default WritingHighlight
