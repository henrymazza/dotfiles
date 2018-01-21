-- Inspired by Linux alt-drag or Better Touch Tools move/resize functionality

function get_window_under_mouse()
  -- Invoke `hs.application` because `hs.window.orderedWindows()` doesn't do it
  -- and breaks itself
  local _ = hs.application

  local my_pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local my_screen = hs.mouse.getCurrentScreen()

  return hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return my_screen == w:screen() and my_pos:inside(w:frame())
  end)
end

dragging_win = nil
dragging_mode = 1

accX = 0
accY = 0
dragMinimum = 5

logger = hs.logger.new('xy', 'verbose')

drag_event = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function(e)
  if dragging_win then
    local dx = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX)
    local dy = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
    local mods = hs.eventtap.checkKeyboardModifiers()
    logger.i(accX, accY)

    if math.abs(accX) > dragMinimum or math.abs(accY) > dragMinimum then
      dx = accX + dx
      dy = accY + dy
      -- Ctrl + Shift to move the window under cursor
      if dragging_mode == 1 and mods.ctrl and mods.shift then
        dragging_win:move({1*dx, 1*dy}, nil, false, 0)

      -- Alt + Shift to resize the window under cursor
      elseif mods.alt and mods.shift then
        local sz = dragging_win:size()
        local w1 = sz.w + 1*dx
        local h1 = sz.h + 1*dy
        dragging_win:setSize(w1, h1)
      end
      accX = 0
      accY = 0
    else
      accX = accX + dx
      accY = accY + dy
    end
  end
  return nil
end)

flags_event = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
  local flags = e:getFlags()
  if flags.ctrl and flags.shift and dragging_win == nil then
    dragging_win = get_window_under_mouse()
    dragging_mode = 1
    drag_event:start()
  elseif flags.alt and flags.shift and dragging_win == nil then
    dragging_win = get_window_under_mouse()
    dragging_mode = 2
    drag_event:start()
  else
    drag_event:stop()
    dragging_win = nil
  end
  return nil
end)
flags_event:start()
