defmodule PureAdmin.Components.Popconfirm do
  @moduledoc """
  Popconfirm component for Pure Admin.

  Small confirmation dialogs anchored to trigger buttons.
  Perfect for delete confirmations and quick yes/no decisions.
  Uses Floating UI for positioning with automatic collision detection.
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @doc """
  Renders a popconfirm with a trigger button and confirmation dialog.

  ## Examples

      <.popconfirm
        id="delete-item"
        message="Are you sure you want to delete this item?"
        confirm_event="delete"
        confirm_value={%{id: @item.id}}
      >
        <.button variant="danger" size="xs">Delete</.button>
      </.popconfirm>

      <.popconfirm
        id="archive"
        message="Archive this item?"
        icon_variant="warning"
        confirm_text="Archive"
        confirm_variant="warning"
        confirm_event="archive"
      >
        <.button variant="warning">Archive</.button>
      </.popconfirm>
  """
  attr(:id, :string, required: true)
  attr(:message, :string, required: true, doc: "Confirmation message text")
  attr(:placement, :string, default: "bottom", values: ["top", "bottom", "start", "end"])
  attr(:icon_variant, :string, default: nil, values: [nil, "danger", "warning", "info"],
    doc: "Icon style for the message")
  attr(:is_compact, :boolean, default: false, doc: "Compact variant for table actions")
  attr(:confirm_text, :string, default: "Confirm", doc: "Confirm button text")
  attr(:cancel_text, :string, default: "Cancel", doc: "Cancel button text")
  attr(:confirm_variant, :string, default: "danger",
    values: ["primary", "secondary", "success", "warning", "danger", "info"],
    doc: "Confirm button color variant")
  attr(:confirm_event, :string, default: nil, doc: "LiveView event to push on confirm")
  attr(:confirm_value, :map, default: %{}, doc: "Value to send with confirm event")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true, doc: "Trigger content (usually a button)")

  def popconfirm(assigns) do
    ~H"""
    <div
      class="pa-popconfirm-wrapper"
      style="display: inline-block; position: relative;"
      onclick={"window.__paPopconfirmToggle(event, '#{@id}')"}
    >
      <%= render_slot(@inner_block) %>
    </div>
    <div
      id={@id}
      class={build_classes("pa-popconfirm", [
        {"pa-popconfirm--compact", @is_compact}
      ], @class)}
      data-placement={@placement}
      {@rest}
    >
      <div class="pa-popconfirm__arrow"></div>
      <div class="pa-popconfirm__content">
        <div class={build_classes("pa-popconfirm__message", [
          {"pa-popconfirm__icon", @icon_variant != nil},
          {"pa-popconfirm__icon--#{@icon_variant}", @icon_variant != nil}
        ])}>
          <p><%= @message %></p>
        </div>
        <div class="pa-popconfirm__actions">
          <button
            class="pa-btn pa-btn--secondary"
            onclick={"window.__paPopconfirmClose('#{@id}'); return false;"}
          >
            <%= @cancel_text %>
          </button>
          <button
            class={"pa-btn pa-btn--#{@confirm_variant}"}
            phx-click={@confirm_event}
            phx-value-id={@confirm_value[:id]}
            onclick={"window.__paPopconfirmClose('#{@id}'); return false;"}
          >
            <%= @confirm_text %>
          </button>
        </div>
      </div>
    </div>
    <script :if={!assigns[:__popconfirm_script_loaded]}>
    (function(){
      if (window.__paPopconfirmToggle) return;

      var currentPopconfirm = null;
      var currentTrigger = null;

      function resolveLogicalPlacement(placement) {
        var isRtl = document.documentElement.dir === 'rtl';
        if (placement === 'start') return isRtl ? 'right' : 'left';
        if (placement === 'end') return isRtl ? 'left' : 'right';
        return placement;
      }

      function positionPopconfirm(trigger, popconfirm) {
        var rawPlacement = popconfirm.dataset.placement || 'bottom';
        var placement = resolveLogicalPlacement(rawPlacement);

        popconfirm.style.position = 'fixed';
        popconfirm.style.zIndex = '9000';

        if (window.FloatingUIDOM) {
          var FUI = window.FloatingUIDOM;
          var update = function() {
            FUI.computePosition(trigger, popconfirm, {
              placement: placement,
              strategy: 'fixed',
              middleware: [FUI.offset(8), FUI.flip(), FUI.shift({ padding: 10 })]
            }).then(function(result) {
              popconfirm.style.left = result.x + 'px';
              popconfirm.style.top = result.y + 'px';
              // Update class to match actual placement
              popconfirm.className = popconfirm.className
                .replace(/pa-popconfirm--(top|bottom|left|right)/g, '')
                .trim() + ' pa-popconfirm--' + result.placement;
            });
          };
          update();
          if (FUI.autoUpdate) {
            popconfirm._cleanupAutoUpdate = FUI.autoUpdate(trigger, popconfirm, update);
          }
        } else {
          // Manual fallback
          requestAnimationFrame(function() {
            var rect = trigger.getBoundingClientRect();
            var pRect = popconfirm.getBoundingClientRect();
            var top, left;
            switch(placement) {
              case 'top':
                top = rect.top - pRect.height - 8;
                left = rect.left + (rect.width / 2) - (pRect.width / 2);
                break;
              case 'right':
                top = rect.top + (rect.height / 2) - (pRect.height / 2);
                left = rect.right + 8;
                break;
              case 'left':
                top = rect.top + (rect.height / 2) - (pRect.height / 2);
                left = rect.left - pRect.width - 8;
                break;
              default:
                top = rect.bottom + 8;
                left = rect.left + (rect.width / 2) - (pRect.width / 2);
                break;
            }
            left = Math.max(5, Math.min(left, window.innerWidth - pRect.width - 5));
            top = Math.max(5, Math.min(top, window.innerHeight - pRect.height - 5));
            popconfirm.style.top = top + 'px';
            popconfirm.style.left = left + 'px';
          });
        }
      }

      function closePopconfirm(popconfirm) {
        popconfirm.classList.remove('is-open');
        popconfirm.style.position = '';
        popconfirm.style.top = '';
        popconfirm.style.left = '';
        if (popconfirm._cleanupAutoUpdate) {
          popconfirm._cleanupAutoUpdate();
          popconfirm._cleanupAutoUpdate = null;
        }
        // Move back to original position in DOM
        if (popconfirm._originalParent) {
          if (popconfirm._originalNext) {
            popconfirm._originalParent.insertBefore(popconfirm, popconfirm._originalNext);
          } else {
            popconfirm._originalParent.appendChild(popconfirm);
          }
          popconfirm._originalParent = null;
          popconfirm._originalNext = null;
        }
        if (currentPopconfirm === popconfirm) {
          currentPopconfirm = null;
          currentTrigger = null;
        }
      }

      window.__paPopconfirmToggle = function(event, popconfirmId) {
        event.stopPropagation();
        var trigger = event.currentTarget;
        var popconfirm = document.getElementById(popconfirmId);
        if (!popconfirm) return;

        // Close current if different
        if (currentPopconfirm && currentPopconfirm !== popconfirm) {
          closePopconfirm(currentPopconfirm);
        }

        var isOpen = popconfirm.classList.contains('is-open');
        if (isOpen) {
          closePopconfirm(popconfirm);
        } else {
          // Move to body to avoid containment issues with transforms/overflow
          if (popconfirm.parentNode !== document.body) {
            popconfirm._originalParent = popconfirm.parentNode;
            popconfirm._originalNext = popconfirm.nextElementSibling;
            document.body.appendChild(popconfirm);
          }
          // Make visible first so Floating UI can measure dimensions
          popconfirm.classList.add('is-open');
          positionPopconfirm(trigger, popconfirm);
          currentPopconfirm = popconfirm;
          currentTrigger = trigger;
        }
      };

      window.__paPopconfirmClose = function(popconfirmId) {
        var popconfirm = document.getElementById(popconfirmId);
        if (popconfirm) closePopconfirm(popconfirm);
      };

      // Close on click outside
      document.addEventListener('click', function(e) {
        if (currentPopconfirm &&
            !currentPopconfirm.contains(e.target) &&
            !e.target.closest('.pa-popconfirm-wrapper')) {
          closePopconfirm(currentPopconfirm);
        }
      });
    })();
    </script>
    """
  end
end
