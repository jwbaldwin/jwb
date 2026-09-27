export default {
  mounted() {
    this.panel = this.el.querySelector("#mobile-menu")
    this.trigger = this.el.querySelector("#mobile-button")
    this.closeButton = this.el.querySelector("#close-navigation")
    this.main = document.querySelector("main")
    this.desktop = matchMedia("(min-width: 768px)")
    this.open = false
    this.onClick = event => {
      if (event.target.closest("#mobile-button")) this.setOpen(true, event.detail === 0)
      else if (event.target.closest("#close-navigation, #mobile-backdrop, a[href]")) {
        this.setOpen(false, event.detail === 0)
      }
    }
    this.onKeydown = event => {
      if (!this.open) return
      if (event.key === "Escape") {
        event.preventDefault()
        this.setOpen(false, true)
      } else if (event.key === "Tab") {
        const controls = [...this.panel.querySelectorAll("button, a[href]")]
        const first = controls[0], last = controls.at(-1)
        if (event.shiftKey && document.activeElement === first) {
          event.preventDefault()
          last.focus()
        } else if (!event.shiftKey && document.activeElement === last) {
          event.preventDefault()
          first.focus()
        }
      }
    }
    this.onResize = () => {
      const focusNeedsReturn = this.panel.contains(document.activeElement) || document.activeElement === document.body
      this.setOpen(false, true)
      if (!this.desktop.matches && focusNeedsReturn) this.trigger.focus({preventScroll: true})
    }
    this.onNavigate = event => {
      if (event.type === "popstate" || ["redirect", "patch"].includes(event.detail?.kind)) {
        this.setOpen(false, true)
      }
    }
    this.el.addEventListener("click", this.onClick)
    document.addEventListener("keydown", this.onKeydown)
    this.desktop.addEventListener("change", this.onResize)
    window.addEventListener("phx:page-loading-start", this.onNavigate)
    window.addEventListener("popstate", this.onNavigate)
    this.setOpen(false, true)
  },

  updated() {
    this.setOpen(this.open, this.el.hasAttribute("data-instant"))
    if (this.open) this.main.inert = true
  },

  setOpen(open, instant = false) {
    open = open && !this.desktop.matches
    const wasOpen = this.open
    this.open = open
    this.el.toggleAttribute("data-instant", instant)
    this.el.toggleAttribute("data-open", open)
    this.trigger.setAttribute("aria-expanded", String(open))
    this.trigger.inert = open
    this.panel.inert = !this.desktop.matches && !open
    if (this.desktop.matches) {
      this.panel.removeAttribute("role")
      this.panel.removeAttribute("aria-modal")
    } else {
      this.panel.setAttribute("role", "dialog")
      this.panel.setAttribute("aria-modal", "true")
    }
    if (open && !wasOpen) {
      this.savedScroll = window.scrollY
      this.bodyStyle = {
        position: document.body.style.position,
        top: document.body.style.top,
        width: document.body.style.width
      }
      this.mainWasInert = this.main.inert
      this.main.inert = true
      Object.assign(document.body.style, {position: "fixed", top: `-${this.savedScroll}px`, width: "100%"})
      this.closeButton.focus({preventScroll: true})
    } else if (!open && wasOpen) {
      this.main.inert = this.mainWasInert
      Object.assign(document.body.style, this.bodyStyle)
      window.scrollTo(0, this.savedScroll)
      const focusTarget = this.desktop.matches ? this.panel.querySelector("a[aria-current]") : this.trigger
      focusTarget?.focus({preventScroll: true})
    }
  },

  destroyed() {
    this.setOpen(false, true)
    this.el.removeEventListener("click", this.onClick)
    document.removeEventListener("keydown", this.onKeydown)
    this.desktop.removeEventListener("change", this.onResize)
    window.removeEventListener("phx:page-loading-start", this.onNavigate)
    window.removeEventListener("popstate", this.onNavigate)
  }
}
