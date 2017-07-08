--

function openInterface(info)
  if player.isLounging() then
    pane.playSound("/sfx/interface/clickon_error.ogg")
    return
  end

  -- Silverfeelin: This is the bit that differs from StardustLib.
  local item = root.assetJson("/sys/stardust/quickbar/quickbarItem.config")
  item.parameters.info = info
  item.parameters.restore = player.swapSlotItem()
  player.setSwapSlotItem(item)
end

local lst = "scroll.list"

local prefix = ""

function addItem(itm)
  local li = lst .. "." .. widget.addListItem(lst)
  widget.setText(li .. ".label", prefix .. itm.label)
  widget.registerMemberCallback(li .. ".buttonContainer", "click", function()
    openInterface(itm.pane)
  end)
  local btn = li .. ".buttonContainer." .. widget.addListItem(li .. ".buttonContainer") .. ".button"
  if itm.icon then
    local icn = itm.icon
    if icn:sub(1,1) ~= "/" then icn = "/quickbar/" .. icn end
    widget.setButtonOverlayImage(btn, itm.icon)
  end
end

function init()
  widget.clearListItems(lst)
  local items = root.assetJson("/quickbar/icons.json") or {}
  prefix = "^#7fff7f;"
  for k,v in pairs(items.priority or {}) do addItem(v) end
  if player.isAdmin() then
    prefix = "^#bf7fff;"
    for k,v in pairs(items.admin or {}) do addItem(v) end
  end
  prefix = ""
  for k,v in pairs(items.normal or {}) do addItem(v) end
end