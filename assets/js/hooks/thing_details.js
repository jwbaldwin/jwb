export default {
  mounted() {
    this.dialog = null
    this.animation = null
    this.listeners = new AbortController()
    const options = {signal: this.listeners.signal}
    this.content = this.el.closest(".site-content")
    this.contentResize = new ResizeObserver(() => this.positionDetails())
    this.contentResize.observe(this.content)
    window.addEventListener("resize", () => this.positionDetails(), options)

    this.el.addEventListener("click", event => {
      const trigger = event.target.closest("[data-thing-open]")
      if (trigger) this.openDetails(trigger, event.detail === 0)
      if (event.target.closest("[data-thing-close]")) this.closeDetails(event.detail === 0)
    }, options)

    this.el.addEventListener("pointerdown", event => {
      this.backdropPress = this.outsideDialog(event)
    }, options)

    this.el.addEventListener("pointerup", event => {
      if (this.backdropPress && this.outsideDialog(event)) this.closeDetails(false)
      this.backdropPress = false
    }, options)

    this.el.addEventListener("keydown", event => {
      if (!this.dialog || event.key !== "Tab") return
      const controls = [...this.dialog.querySelectorAll("button, a[href]")]
      const current = controls.indexOf(document.activeElement)
      const next = (current + (event.shiftKey ? -1 : 1) + controls.length) % controls.length
      event.preventDefault()
      controls[next].focus()
    }, options)

    for (const dialog of this.el.querySelectorAll("dialog")) {
      dialog.addEventListener("cancel", event => {
        event.preventDefault()
        this.closeDetails(true)
      }, options)
    }
  },

  outsideDialog(event) {
    if (!this.dialog || event.target !== this.dialog) return false
    const rect = this.dialog.getBoundingClientRect()
    return event.clientX < rect.left || event.clientX > rect.right ||
      event.clientY < rect.top || event.clientY > rect.bottom
  },

  openDetails(trigger, instant) {
    if (this.dialog) return
    this.trigger = trigger
    this.dialog = [...this.el.querySelectorAll("dialog")]
      .find(dialog => dialog.dataset.thingDialog === trigger.dataset.thingOpen)
    this.scrollPosition = {x: window.scrollX, y: window.scrollY}
    this.bodyStyles = Object.fromEntries(
      ["position", "top", "left", "width", "overflow"].map(key => [key, document.body.style[key]])
    )
    Object.assign(document.body.style, {
      position: "fixed", top: `-${this.scrollPosition.y}px`,
      left: `-${this.scrollPosition.x}px`, width: "100%", overflow: "hidden"
    })
    this.dialog.toggleAttribute("data-instant", instant)
    this.positionDetails()
    this.dialog.showModal()
    this.dialog.scrollTop = 0
    this.animateDetails(true, instant)
  },

  positionDetails() {
    if (!this.dialog) return
    const rect = this.content.getBoundingClientRect()
    this.dialog.style.setProperty("--thing-content-center", `${rect.left + rect.width / 2}px`)
    this.dialog.style.setProperty("--thing-content-width", `${rect.width}px`)
  },

  animateDetails(opening, instant) {
    const dialog = this.dialog
    const current = this.animation ? getComputedStyle(dialog) : null
    const start = current
      ? {opacity: current.opacity, transform: current.transform}
      : {opacity: opening ? 0 : 1, transform: opening ? "translateY(8px) scale(0.97)" : "none"}
    this.animation?.cancel()
    this.animation = null
    dialog.toggleAttribute("data-visible", opening)
    dialog.toggleAttribute("data-instant", instant)
    if (instant || window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      if (!opening) this.finishClose()
      return
    }
    const animation = dialog.animate([
      start,
      {opacity: opening ? 1 : 0, transform: opening ? "none" : "translateY(4px) scale(0.98)"}
    ], {duration: opening ? 220 : 160, easing: "cubic-bezier(0.23, 1, 0.32, 1)", fill: "forwards"})
    this.animation = animation
    animation.onfinish = () => {
      if (this.animation !== animation) return
      if (!opening) this.finishClose()
      else {
        animation.cancel()
        this.animation = null
      }
    }
  },

  closeDetails(instant) {
    if (this.dialog) this.animateDetails(false, instant)
  },

  finishClose() {
    this.animation?.cancel()
    this.animation = null
    this.dialog.close()
    this.dialog = null
    Object.assign(document.body.style, this.bodyStyles)
    window.scrollTo({left: this.scrollPosition.x, top: this.scrollPosition.y, behavior: "instant"})
    if (this.trigger.isConnected) this.trigger.focus({preventScroll: true})
  },

  destroyed() {
    this.listeners.abort()
    this.contentResize.disconnect()
    if (this.dialog) this.finishClose()
  }
}
