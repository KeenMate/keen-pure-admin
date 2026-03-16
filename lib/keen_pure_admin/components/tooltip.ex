defmodule KPureAdmin.Components.Tooltip do
  @moduledoc """
  Tooltip and Popover components for Pure Admin.

  Tooltips use CSS-only positioning via `pa-tooltip` class with `data-tooltip` attribute.
  Popovers use a click-triggered rich content overlay.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders a tooltip wrapper around content.

  The tooltip text appears on hover via CSS `::before`/`::after` pseudo-elements.

  ## Examples

      <.tooltip text="Save your changes">
        <.button variant="primary">Save</.button>
      </.tooltip>

      <.tooltip text="Tooltip on bottom" position="bottom" variant="success">
        Hover me
      </.tooltip>

      <.tooltip text="Long explanation text..." multiline>
        Hover for details
      </.tooltip>
  """
  attr(:text, :string, required: true, doc: "Tooltip text")
  attr(:position, :string, default: nil, values: [nil, "top", "end", "bottom", "start"],
    doc: "Tooltip position: top (default), end (right in LTR), bottom, start (left in LTR)")
  attr(:variant, :string, default: nil,
    doc: "Color variant (primary, success, warning, danger, color-1 through color-9)")
  attr(:multiline, :boolean, default: false, doc: "Multiline tooltip (wider, left-aligned)")
  attr(:is_help, :boolean, default: false, doc: "Help cursor (question mark)")
  attr(:is_inline, :boolean, default: false, doc: "Inline text style with dotted underline")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tooltip(assigns) do
    ~H"""
    <span
      class={build_classes("pa-tooltip", [
        {"pa-tooltip--floating", !@is_inline},
        {"pa-tooltip--#{@position}", @position != nil},
        {"pa-tooltip--#{@variant}", @variant != nil},
        {"pa-tooltip--multiline", @multiline},
        {"pa-tooltip--help", @is_help}
      ], @class)}
      data-tooltip={@text}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  @doc """
  Renders a popover trigger with rich content overlay.

  Uses a click-triggered pattern with CSS positioning.

  ## Examples

      <.popover title_text="Help" placement="bottom">
        <p>Rich content with <strong>HTML</strong>.</p>
      </.popover>

      <.popover title_text="Options" placement="bottom" size="lg">
        <:trigger>
          <.button variant="info" size="xs">Help</.button>
        </:trigger>
        <p>Detailed help content.</p>
      </.popover>
  """
  attr(:id, :string, default: nil, doc: "Unique ID (auto-generated if not provided)")
  attr(:title_text, :string, required: true)
  attr(:placement, :string, default: "top", values: ["top", "end", "bottom", "start"])
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"])
  attr(:alignment, :string, default: nil, values: [nil, "center", "end"])
  attr(:trigger_text, :string, default: "?", doc: "Default trigger button text")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, doc: "Custom trigger content")
  slot(:inner_block, required: true)

  def popover(assigns) do
    ~H"""
    <div
      class={build_classes("pa-popover", [
        {"pa-popover--#{@size}", @size != nil},
        {"pa-popover--#{@alignment}", @alignment != nil}
      ], @class)}
      data-placement={@placement}
      id={@id}
    >
      <%= if @trigger != [] do %>
        <button class="pa-popover__trigger" onclick="console.log('popover button clicked'); window.__paPopoverToggle(this); return false;">
          <%= render_slot(@trigger) %>
        </button>
      <% else %>
        <button class="pa-popover__trigger" onclick="console.log('popover button clicked'); window.__paPopoverToggle(this); return false;">
          <%= @trigger_text %>
        </button>
      <% end %>
      <div class="pa-popover__content" data-placement={@placement}>
        <div class="pa-popover__header">
          <span class="pa-popover__title"><%= @title_text %></span>
          <button class="pa-popover__close" onclick="window.__paPopoverClose(this); return false;" aria-label="Close">×</button>
        </div>
        <div class="pa-popover__body">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    <script :if={!assigns[:__popover_script_loaded]}>
    (function(){
      if (window.__paPopoverToggle) return;
      var OFFSET = 10;

      function closePopover(content) {
        content.removeAttribute('data-show');
        content.style.position = '';
        content.style.top = '';
        content.style.left = '';
        // Cleanup Floating UI auto-update if running
        if (content._cleanupAutoUpdate) {
          content._cleanupAutoUpdate();
          content._cleanupAutoUpdate = null;
        }
        // Move back to original position in DOM
        if (content._originalParent) {
          if (content._originalNext) {
            content._originalParent.insertBefore(content, content._originalNext);
          } else {
            content._originalParent.appendChild(content);
          }
          content._originalParent = null;
          content._originalNext = null;
        }
      }

      function resolveLogicalPlacement(placement) {
        var isRtl = document.documentElement.dir === 'rtl';
        if (placement === 'start') return isRtl ? 'right' : 'left';
        if (placement === 'end') return isRtl ? 'left' : 'right';
        return placement;
      }

      function positionPopover(trigger, content) {
        var placement = resolveLogicalPlacement(content.dataset.placement || 'bottom');
        content.style.position = 'fixed';
        content.style.zIndex = '9000';

        if (window.FloatingUIDOM) {
          var FUI = window.FloatingUIDOM;
          var update = function() {
            FUI.computePosition(trigger, content, {
              placement: placement,
              strategy: 'fixed',
              middleware: [FUI.offset(OFFSET), FUI.flip(), FUI.shift({ padding: 5 })]
            }).then(function(result) {
              content.style.left = result.x + 'px';
              content.style.top = result.y + 'px';
            });
          };
          update();
          // Auto-update on scroll/resize
          if (FUI.autoUpdate) {
            content._cleanupAutoUpdate = FUI.autoUpdate(trigger, content, update);
          }
        } else {
          // Manual fallback
          requestAnimationFrame(function() {
            var rect = trigger.getBoundingClientRect();
            var cRect = content.getBoundingClientRect();
            var top, left;
            switch(placement) {
              case 'top':
                top = rect.top - cRect.height - OFFSET;
                left = rect.left + (rect.width / 2) - (cRect.width / 2);
                break;
              case 'right':
                top = rect.top + (rect.height / 2) - (cRect.height / 2);
                left = rect.right + OFFSET;
                break;
              case 'left':
                top = rect.top + (rect.height / 2) - (cRect.height / 2);
                left = rect.left - cRect.width - OFFSET;
                break;
              default:
                top = rect.bottom + OFFSET;
                left = rect.left + (rect.width / 2) - (cRect.width / 2);
                break;
            }
            left = Math.max(5, Math.min(left, window.innerWidth - cRect.width - 5));
            top = Math.max(5, Math.min(top, window.innerHeight - cRect.height - 5));
            content.style.top = top + 'px';
            content.style.left = left + 'px';
          });
        }
      }

      window.__paPopoverToggle = function(trigger) {
        var content = trigger.nextElementSibling;
        var isOpen = content.hasAttribute('data-show');

        // Close all others
        document.querySelectorAll('.pa-popover__content[data-show]').forEach(function(el) {
          closePopover(el);
        });

        if (isOpen) return;

        // Move content to body to avoid containment issues with transforms/overflow
        if (content.parentNode !== document.body) {
          var popover = content.parentNode;
          content._originalParent = popover;
          content._originalNext = content.nextElementSibling;
          // Copy alignment modifier classes from parent container to content
          popover.classList.forEach(function(cls) {
            if (cls.match(/^pa-popover--/) && cls !== 'pa-popover--sm' && cls !== 'pa-popover--lg') {
              content.classList.add(cls);
            }
          });
          document.body.appendChild(content);
        }

        content.setAttribute('data-show', '');
        positionPopover(trigger, content);
      };

      window.__paPopoverClose = function(btn) {
        var content = btn.closest('.pa-popover__content');
        if (content) closePopover(content);
      };

      // Close on click outside
      document.addEventListener('click', function(e) {
        if (!e.target.closest('.pa-popover')) {
          document.querySelectorAll('.pa-popover__content[data-show]').forEach(function(el) {
            closePopover(el);
          });
        }
      });
    })();
    </script>
    """
  end
end
