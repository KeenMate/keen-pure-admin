/**
 * SplitterStorageClear hook — demo-only. Mirrors the upstream
 * pure-admin `clearSplitterStorage()` button: walks localStorage,
 * removes every key under the `pa-splitter:` namespace, and
 * pushes the count back to the server so the page can show a
 * status line.
 */
export const SplitterStorageClear = {
  mounted() {
    this.el.addEventListener("click", () => {
      let cleared = 0
      for (let i = localStorage.length - 1; i >= 0; i--) {
        const key = localStorage.key(i)
        if (key && key.indexOf("pa-splitter:") === 0) {
          localStorage.removeItem(key)
          cleared++
        }
      }
      this.pushEvent("storage_cleared", { cleared })
    })
  }
}
