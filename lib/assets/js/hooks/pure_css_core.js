/**
 * Pure CSS — shared foundation runtime namespace (window.pureCss)
 *
 * ONE global for the foundation layer. The app-shell engines (fit,
 * navbar-dropdown, sidebar-resize, container-breakpoint) and every downstream
 * framework hang their public handle, cross-component signals, and diagnostics
 * off this object instead of scattering `window.PaThing` globals.
 *
 * This is the FOUNDATION half of what used to be pure-admin.js. It installs the
 * parts that must exist exactly once — the event bus, the debug registry, the
 * viewport source, the OS colour-scheme source, capability-first device
 * classification, the overlay primitives, the open-menu registry, the
 * components registry + initAll, and the FOUNDATION config defaults
 * (mobileBreakpoint, typingDebounceDelay, tabletMinShortSide, fit,
 * containerBreakpoint — the ones the moved engines read).
 *
 * pure-admin.js (the admin facade) ADOPTS these buses by reference when it
 * loads on top, and layers the admin-only config defaults (transition, toast,
 * severity) onto the shared config. When pure-admin is absent (pure-css loaded
 * standalone) this runtime stands on its own.
 *
 * Load-order-safe by construction: this file, and every engine, opens with
 *
 *     var pc = (window.pureCss = window.pureCss || {});
 *
 * so the namespace exists no matter which script parses first.
 *
 * Surface:
 *   pureCss.events        on(topic,fn)->off / once / off / emit(topic,payload)
 *   pureCss.viewport      { width, height, orientation } live snapshot; emits
 *                         'viewport:resize' (rAF-throttled) + 'viewport:orientation'
 *   pureCss.colorScheme   { mode: 'light'|'dark' } live OS preference; emits
 *                         'colorscheme:change'
 *   pureCss.device        { class: 'mobile'|'tablet'|'desktop', isTouchPrimary }
 *   pureCss.overlay       lockBodyScroll() -> release; observeKeyboardInset(el)
 *   pureCss.config        shared UI-behavior baseline (foundation half)
 *   pureCss.components     per-component handles ({init, initAll, …}); initAll(scope)
 *   pureCss.menus          open-menu coordination registry (register/closeOthers)
 *   pureCss.debug          enable/disable/isEnabled/log/aspects
 */
(function () {
  'use strict';

  var pa = (window.pureCss = window.pureCss || {});
  pa.components = pa.components || {};

  // --- events: a tiny topic bus -----------------------------------------
  if (!pa.events) {
    var topics = {}; // { [topic]: Set<fn> }
    pa.events = {
      on: function (topic, fn) {
        (topics[topic] || (topics[topic] = new Set())).add(fn);
        return function off() { if (topics[topic]) topics[topic].delete(fn); };
      },
      once: function (topic, fn) {
        var off = pa.events.on(topic, function (payload) { off(); fn(payload); });
        return off;
      },
      off: function (topic, fn) { if (topics[topic]) topics[topic].delete(fn); },
      emit: function (topic, payload) {
        if (!topics[topic]) return;
        topics[topic].forEach(function (fn) {
          try { fn(payload); } catch (e) { pa.debug.log('events', 'listener threw for', topic, e); }
        });
      },
      // Introspection for the future debug console.
      topics: function () { return Object.keys(topics); },
      listenerCount: function (topic) { return topics[topic] ? topics[topic].size : 0; }
    };
  }

  // --- debug: per-aspect toggles + log --------------------------------------
  if (!pa.debug) {
    var enabled = {}; // { [aspect]: true }
    var known = {};   // every aspect name ever seen (for aspects())
    pa.debug = {
      enable: function (aspect) { enabled[aspect] = true; known[aspect] = true; },
      disable: function (aspect) { enabled[aspect] = false; },
      isEnabled: function (aspect) { known[aspect] = true; return enabled[aspect] === true; },
      log: function (aspect) {
        known[aspect] = true;
        if (enabled[aspect] !== true) return;
        var args = Array.prototype.slice.call(arguments, 1);
        console.log.apply(console, ['[pc:' + aspect + ']'].concat(args));
      },
      // { aspect: enabled } for every aspect that's been enabled or probed.
      aspects: function () {
        var out = {};
        Object.keys(known).forEach(function (k) { out[k] = enabled[k] === true; });
        return out;
      }
    };
  }

  // --- viewport: the single owner of window-level resize/orientation --------
  if (!pa.viewport) {
    var vp = pa.viewport = { width: 0, height: 0, orientation: 'landscape' };
    var raf = null;
    function measure() {
      vp.width = window.innerWidth;
      vp.height = window.innerHeight;
      // CSS-parity: "portrait" == taller-than-wide, device-agnostic.
      vp.orientation = vp.height >= vp.width ? 'portrait' : 'landscape';
    }
    measure();
    window.addEventListener('resize', function () {
      if (raf) return; // coalesce a burst of resizes into one frame
      raf = requestAnimationFrame(function () {
        raf = null;
        measure();
        pa.events.emit('viewport:resize', vp);
      });
    }, { passive: true });

    // Orientation via matchMedia — well-supported and fires on desktop pivot too.
    var mq = window.matchMedia('(orientation: portrait)');
    var onOrient = function () { measure(); pa.events.emit('viewport:orientation', vp); };
    if (mq.addEventListener) mq.addEventListener('change', onOrient);
    else if (mq.addListener) mq.addListener(onOrient); // Safari <14
  }

  // --- colorScheme: the single owner of the OS light/dark preference --------
  if (!pa.colorScheme) {
    var cs = pa.colorScheme = { mode: 'light' };
    var csmq = window.matchMedia('(prefers-color-scheme: dark)');
    var readScheme = function () { cs.mode = csmq.matches ? 'dark' : 'light'; };
    readScheme();
    var onScheme = function () { readScheme(); pa.events.emit('colorscheme:change', cs); };
    if (csmq.addEventListener) csmq.addEventListener('change', onScheme);
    else if (csmq.addListener) csmq.addListener(onScheme); // Safari <14
  }

  // --- config: the shared UI-behavior baseline (foundation half) ------------
  // The engines that moved here (fit, container-breakpoint) + the shell pieces
  // (device classification, sidebar-resize, search debounce) read these. The
  // admin facade layers transition/toast/severity on top of this same object.
  if (!pa.config) pa.config = {};
  (function initConfig(cfg) {
    // Read a numeric CSS variable off :root (px / ms / unitless → number).
    function readCssNumber(name, fallback) {
      try {
        var raw = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
        var n = parseFloat(raw);
        return isNaN(n) ? fallback : n;
      } catch (e) { return fallback; }
    }

    // Fill only the keys a consumer hasn't already set (shallow).
    function fillDefaults(target, defs) {
      Object.keys(defs).forEach(function (k) {
        if (target[k] === undefined) target[k] = defs[k];
      });
    }

    // mobileBreakpoint (px) — SINGLE-SOURCED from SCSS $mobile-breakpoint via the
    // --pc-mobile-breakpoint CSS var. Honour an explicit consumer override; else
    // derive from CSS; else 768.
    if (cfg.mobileBreakpoint == null) {
      cfg.mobileBreakpoint = readCssNumber('--pc-mobile-breakpoint', 768);
    }

    // typingDebounceDelay (ms) — debounce for search / autocomplete / filter inputs.
    if (cfg.typingDebounceDelay == null) {
      cfg.typingDebounceDelay = 300;
    }

    // tabletMinShortSide (px) — the phone/tablet boundary applied to the SHORTER
    // viewport side (Material sw600dp), consumed by pureCss.device.
    if (cfg.tabletMinShortSide == null) {
      cfg.tabletMinShortSide = 600;
    }

    // fit.* — the Fit engine (fit.js). defaultPriority is the priority a slot
    // falls back to when it declares data-pc-fit but no data-pc-fit-priority.
    cfg.fit = cfg.fit || {};
    fillDefaults(cfg.fit, {
      defaultPriority: 0
    });

    // containerBreakpoint.* — the Container Breakpoint engine. hysteresis is the
    // dead-band applied at every threshold; hiddenClass is the utility class the
    // engine toggles on [data-pc-show] descendants to hide them outside their mode(s).
    cfg.containerBreakpoint = cfg.containerBreakpoint || {};
    fillDefaults(cfg.containerBreakpoint, {
      hysteresis: 1,
      hiddenClass: 'd-none'
    });
  })(pa.config);

  // --- device: capability-first device classification -----------------------
  // Capability decides FIRST: a non-touch-primary pointer (a real mouse) is
  // ALWAYS 'desktop' at any width. Only touch-primary devices consult the size
  // line: SHORTER viewport side below config.tabletMinShortSide => 'mobile',
  // else 'tablet'. Feature detection (matchMedia), not UA sniffing.
  if (!pa.device) {
    var dev = pa.device = { class: 'desktop', isTouchPrimary: false };
    var coarseMq = window.matchMedia('(pointer: coarse)');
    var hoverMq = window.matchMedia('(hover: hover)');
    var classifyDevice = function () {
      var touchPrimary = coarseMq.matches && !hoverMq.matches;
      dev.isTouchPrimary = touchPrimary;
      if (!touchPrimary) return 'desktop';
      var shortSide = Math.min(window.innerWidth, window.innerHeight);
      var line = (pa.config && pa.config.tabletMinShortSide) || 600;
      return shortSide < line ? 'mobile' : 'tablet';
    };
    var reclassify = function () {
      var next = classifyDevice();
      if (next === dev.class) return;
      dev.class = next;
      pa.events.emit('device:change', dev);
    };
    dev.class = classifyDevice();
    pa.events.on('viewport:resize', reclassify);
    pa.events.on('viewport:orientation', reclassify);
    if (coarseMq.addEventListener) {
      coarseMq.addEventListener('change', reclassify);
      hoverMq.addEventListener('change', reclassify);
    } else if (coarseMq.addListener) { // Safari <14
      coarseMq.addListener(reclassify);
      hoverMq.addListener(reclassify);
    }
  }

  // --- overlay: fullscreen-sheet primitives (scroll lock + keyboard inset) ---
  if (!pa.overlay) {
    var lockCount = 0;
    var stashedOverflow = null;
    pa.overlay = {
      // Ref-counted body-scroll lock. Returns an idempotent release fn.
      lockBodyScroll: function () {
        if (lockCount === 0) {
          stashedOverflow = document.body.style.overflow;
          document.body.style.overflow = 'hidden';
        }
        lockCount++;
        var released = false;
        return function () {
          if (released) return;
          released = true;
          lockCount = Math.max(0, lockCount - 1);
          if (lockCount === 0 && stashedOverflow !== null) {
            document.body.style.overflow = stashedOverflow;
            stashedOverflow = null;
          }
        };
      },
      // Pin a fixed fullscreen panel's bottom edge above the soft keyboard by
      // tracking window.visualViewport. Returns a cleanup. No-op where
      // visualViewport is unavailable.
      observeKeyboardInset: function (panel) {
        var vv = window.visualViewport;
        if (!vv || !panel) return function () {};
        var raf = null;
        var apply = function () {
          raf = null;
          panel.style.height = vv.height + 'px';
          panel.style.top = vv.offsetTop + 'px';
        };
        var schedule = function () {
          if (raf) return;
          raf = requestAnimationFrame(apply);
        };
        vv.addEventListener('resize', schedule);
        vv.addEventListener('scroll', schedule);
        schedule();
        return function () {
          vv.removeEventListener('resize', schedule);
          vv.removeEventListener('scroll', schedule);
          panel.style.height = '';
          panel.style.top = '';
        };
      }
    };
  }

  // --- menus: open-menu coordination ----------------------------------------
  if (!pa.menus) {
    pa.menus = {
      closers: [],
      register: function (fn) { this.closers.push(fn); return fn; },
      closeOthers: function (self) {
        this.closers.forEach(function (fn) {
          if (fn !== self) { try { fn(); } catch (e) { /* ignore */ } }
        });
        pa.events.emit('menu:opened', { id: self && self.paMenuId });
      }
    };
  }

  // --- components.initAll: init every registered component under a scope -----
  if (!pa.components.initAll) {
    pa.components.initAll = function (scope) {
      Object.keys(pa.components).forEach(function (name) {
        if (name === 'initAll') return;
        var c = pa.components[name];
        if (!c) return;
        try {
          if (typeof c.initAll === 'function') c.initAll(scope);
          else if (typeof c.init === 'function') c.init(scope);
        } catch (e) { pa.debug.log('components', name + '.initAll threw', e); }
      });
    };
  }
})();
