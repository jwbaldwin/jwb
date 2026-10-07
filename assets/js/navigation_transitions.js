export function installNavigationTransitions() {
  const reducedMotion = matchMedia("(prefers-reduced-motion: reduce)")
  let pending = null
  let active = null

  const selectSharedElement = name => {
    for (const element of document.querySelectorAll("[data-transition-name]")) {
      element.toggleAttribute("data-transition-active", element.style.getPropertyValue("--transition-name") === name)
    }
  }

  const finish = () => {
    if (!pending) return
    clearTimeout(pending.timeout)
    selectSharedElement(pending.name)
    pending.resolve()
    pending = null
  }

  const cancel = () => {
    active?.skipTransition()
    finish()
  }

  window.addEventListener("phx:page-loading-start", event => {
    if (!["redirect", "patch"].includes(event.detail?.kind)) return
    cancel()
    if (!document.startViewTransition || reducedMotion.matches || document.hidden) return

    const destination = new URL(event.detail.to, location.href).pathname
    const detail = destination.split("/").length === 3 ? destination : location.pathname
    const [, section, slug] = detail.split("/")
    const prefix = {projects: "project", blog: "post"}[section]
    const name = prefix && slug ? `${prefix}-${slug}` : null
    selectSharedElement(name)

    let resolve
    const navigation = new Promise(done => { resolve = done })
    const transition = document.startViewTransition(() => navigation)
    active = transition
    pending = {resolve, name, timeout: setTimeout(cancel, 700)}
    transition.ready.catch(() => {})
    transition.finished.finally(() => {
      if (active === transition) active = null
    })
  })

  window.addEventListener("phx:page-loading-stop", event => {
    if (!["redirect", "patch"].includes(event.detail?.kind)) return
    const navigation = pending
    queueMicrotask(() => {
      if (pending === navigation) finish()
    })
  })
  window.addEventListener("pagehide", cancel)
  reducedMotion.addEventListener("change", cancel)
  document.addEventListener("pointerdown", cancel, {capture: true})
  document.addEventListener("keydown", cancel, {capture: true})
  document.addEventListener("wheel", cancel, {capture: true, passive: true})
}
