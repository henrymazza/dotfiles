require 'hammerspoon-move-resize'

hs.window.animationDuration = 0.1

hs.hotkey.bind({"ctrl", "shift"}, 'q',
  function()
    hs.grid.show()
  end
)

hs.console.alpha(0.90)
--
-- hs.loadSpoon('ColorPicker')

-- spoon.ColorPicker.bindHotkeys({"ctrl", "shift", 's'})

ctrl_table = {
    sends_escape = true,
    last_mods = {}
}

control_key_timer = hs.timer.delayed.new(0.10, function()
    ctrl_table["send_escape"] = false
    -- log.i("timer fired")
    -- control_key_timer:stop()
end
)

last_mods = {}

sketchUpSelect = hs.hotkey.bind({'shift'}, hs.keycodes.map['space'], function()
  if hs.window.focusedWindow():isStandard() then
    hs.application.frontmostApplication():selectMenuItem({"Tools", "Select"})
  else
    hs.eventtap.event.newKeyEvent({}, string.lower('space'), true):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent({}, string.lower('space'), false):post()
  end
end)
sketchUpSelect:disable()

sketchUpShowRestOfModel = hs.hotkey.bind({"ctrl", "shift"}, 's', function()
  hs.application.frontmostApplication():selectMenuItem({"View", "Component Edit", "Hide Rest of Model"})
end)
sketchUpShowRestOfModel:disable()

local wf=hs.window.filter
-- sketchup_wf.allowedWindowRoles = {AXStandardWindow=true,AXDialog=true}

sketchup_wf = wf.new()
sketchup_wf.allowedWindowRoles = {AXStandardWindow=true,AXDialog=true}
sketchup_wf:setAppFilter('SketchUp')
sketchup_wf:subscribe(wf.windowFocused,
                      function(window, appName, eventName)
                        log = hs.logger.new('jujuba', 'verbose')
                        log.d(window:subrole(), appName, eventName)


                        -- sketchUpShowRestOfModel:enable()
                        -- sketchUpSelect:enable()
                        -- log.d('unfocused')
                        -- sketchUpShowRestOfModel:disable()
                        -- sketchUpSelect:disable()
                      end
)
sketchup_wf:subscribe(wf.windowUnfocused,
                      function(window, appName, eventName)
                        log = hs.logger.new('jujuba', 'verbose')
                        log.d(window:isStandard(), appName, eventName)

                        -- sketchUpShowRestOfModel:enable()
                        -- sketchUpSelect:enable()
                        -- log.d('unfocused')
                        -- sketchUpShowRestOfModel:disable()
                        -- sketchUpSelect:disable()
                      end
)

appWatcher = hs.application.watcher.new(function(appName, eventType, obj)
    if (eventType == hs.application.watcher.activated) and (appName == 'SketchUp') then
      sketchUpShowRestOfModel:enable()
      sketchUpSelect:enable()
    end
    if (eventType == hs.application.watcher.deactivated) and (appName == 'SketchUp') then
      sketchUpShowRestOfModel:disable()
      sketchUpSelect:disable()
    end
  end
)
appWatcher:start()

control_handler = function(evt)
  local new_mods = evt:getFlags()
  if last_mods["ctrl"] == new_mods["ctrl"] then
      return false
  end
  if not last_mods["ctrl"] then
    -- log.i("control pressed")
    last_mods = new_mods
    ctrl_table["send_escape"] = true
    -- log.i("starting timer")
    control_key_timer:start()
  else
    -- log.i("contrtol released")
    -- log.i(ctrl_table["send_escape"])
    if ctrl_table["send_escape"] then
      -- log.i("send escape key...")
      hs.eventtap.keyStroke({}, "ESCAPE")
    end
    last_mods = new_mods
    control_key_timer:stop()
  end
  return false
end

control_tap = hs.eventtap.new({12}, control_handler)

--control_tap:start()

---------------------------------

local function keyCode(key, modifiers)
  modifiers = modifiers or {}

  return function()
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
  end
end

hs.hotkey.bind({'ctrl'}, 'n', keyCode('down'), nil, keyCode('down'))
hs.hotkey.bind({'ctrl'}, 'p', keyCode('up'), nil, keyCode('up'))

-- hs.hotkey.bind({'ctrl'}, 'h', keyCode('left'), nil, keyCode('left'))
-- hs.hotkey.bind({'ctrl'}, 'j', keyCode('down'), nil, keyCode('down'))
-- hs.hotkey.bind({'ctrl'}, 'k', keyCode('up'), nil, keyCode('up'))
-- hs.hotkey.bind({'ctrl'}, 'l', keyCode('right'), nil, keyCode('right'))

-- hs.hotkey.bind({'ctrl', 'shift'}, 'h', keyCode('left', {'shift'}), nil, keyCode('left', {'shift'}))
-- hs.hotkey.bind({'ctrl', 'shift'}, 'j', keyCode('down', {'shift'}), nil, keyCode('down', {'shift'}))
-- hs.hotkey.bind({'ctrl', 'shift'}, 'k', keyCode('up', {'shift'}), nil, keyCode('up', {'shift'}))
-- hs.hotkey.bind({'ctrl', 'shift'}, 'l', keyCode('right', {'shift'}), nil, keyCode('right', {'shift'}))

-- hs.hotkey.bind({'ctrl', 'cmd'}, 'h', keyCode('left', {'cmd'}), nil, keyCode('left', {'cmd'}))
-- hs.hotkey.bind({'ctrl', 'cmd'}, 'j', keyCode('down', {'cmd'}), nil, keyCode('down', {'cmd'}))
-- hs.hotkey.bind({'ctrl', 'cmd'}, 'k', keyCode('up', {'cmd'}), nil, keyCode('up', {'cmd'}))
-- hs.hotkey.bind({'ctrl', 'cmd'}, 'l', keyCode('right', {'cmd'}), nil, keyCode('right', {'cmd'}))

-- hs.hotkey.bind({'ctrl', 'alt'}, 'h', keyCode('left', {'alt'}), nil, keyCode('left', {'alt'}))
-- hs.hotkey.bind({'ctrl', 'alt'}, 'j', keyCode('down', {'alt'}), nil, keyCode('down', {'alt'}))
-- hs.hotkey.bind({'ctrl', 'alt'}, 'k', keyCode('up', {'alt'}), nil, keyCode('up', {'alt'}))
-- hs.hotkey.bind({'ctrl', 'alt'}, 'l', keyCode('right', {'alt'}), nil, keyCode('right', {'alt'}))

-- hs.hotkey.bind({'ctrl', 'shift', 'cmd'}, 'h', keyCode('left', {'shift', 'cmd'}), nil, keyCode('left', {'shift', 'cmd'}))
-- hs.hotkey.bind({'ctrl', 'shift', 'cmd'}, 'j', keyCode('down', {'shift', 'cmd'}), nil, keyCode('down', {'shift', 'cmd'}))
-- hs.hotkey.bind({'ctrl', 'shift', 'cmd'}, 'k', keyCode('up', {'shift', 'cmd'}), nil, keyCode('up', {'shift', 'cmd'}))
-- hs.hotkey.bind({'ctrl', 'shift', 'cmd'}, 'l', keyCode('right', {'shift', 'cmd'}), nil, keyCode('right', {'shift', 'cmd'}))

-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'h', keyCode('left', {'shift', 'alt'}), nil, keyCode('left', {'shift', 'alt'}))
-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'j', keyCode('down', {'shift', 'alt'}), nil, keyCode('down', {'shift', 'alt'}))
-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'k', keyCode('up', {'shift', 'alt'}), nil, keyCode('up', {'shift', 'alt'}))
-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'l', keyCode('right', {'shift', 'alt'}), nil, keyCode('right', {'shift', 'alt'}))

-- hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'h', keyCode('left', {'cmd', 'alt'}), nil, keyCode('left', {'cmd', 'alt'}))
-- hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'j', keyCode('down', {'cmd', 'alt'}), nil, keyCode('down', {'cmd', 'alt'}))
-- hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'k', keyCode('up', {'cmd', 'alt'}), nil, keyCode('up', {'cmd', 'alt'}))
-- hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'l', keyCode('right', {'cmd', 'alt'}), nil, keyCode('right', {'cmd', 'alt'}))
