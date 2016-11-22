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

sketchUpSelect = hs.hotkey.bind({}, hs.keycodes.map['space'], function()
  hs.application.frontmostApplication():selectMenuItem({"Tools", "Select"})
end)
sketchUpSelect:disable()

sketchUpShowRestOfModel = hs.hotkey.bind({"ctrl", "shift"}, 's', function()
  hs.application.frontmostApplication():selectMenuItem({"View", "Component Edit", "Hide Rest of Model"})
end)
sketchUpShowRestOfModel:disable()

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

control_tap:start()
