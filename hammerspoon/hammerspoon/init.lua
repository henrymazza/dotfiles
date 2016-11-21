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

sketchUpShowRestOfModel = hs.hotkey.bind({"ctrl"}, 's', function()
    local app = hs.application.frontmostApplication()
    local log=hs.logger.new('example','verbose')

    if app:title() == 'SketchUp' then
      log.d('we are here!')
      app:selectMenuItem({"View", "Component Edit", "Hide Rest of Model"})
    else
      hs.eventtap.keyStroke({"ctrl"}, "s")
      log.d('we are thereeeee...e')
      log.d(app:title())
    end
end)
sketchUpShowRestOfModel:disable()

appWatcher = hs.application.watcher.new(function(appName, eventType, obj)
    local log=hs.logger.new('AppWatcher','verbose')
    if (eventType == hs.application.watcher.activated) and (appName == 'SketchUp') then
      log.d('Activated SketchUp')
      sketchUpShowRestOfModel:enable()
    end
    if (eventType == hs.application.watcher.deactivated) and (appName == 'SketchUp') then
      log.d('DEActivated SketchUp')
      sketchUpShowRestOfModel:disable()
    end
  end
)
appWatcher:start()

-- hs.window.filter.new('RubyMine')
-- :subscribe(hs.window.filter.windowFocused,function() reloadFxFromRubyMine:enable() end)
-- :subscribe(hs.window.filter.windowUnfocused,function() reloadFxFromRubyMine:disable() end)


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
