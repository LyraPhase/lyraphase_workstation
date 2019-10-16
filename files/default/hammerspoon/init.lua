-- hyper(Alt, Ctrl, Cmd) and shift_hyper(Shift, Alt, Ctrl, Cmd) are the hotkeys to be used with the modifiers
-- Default MiroWindowsManager keybindings
-- hyper + c = Center focused window x and y
-- hyper + x = Center focused window y
-- hyper + v = Center focused window x
-- hyper + [ = Maximize focused window y
-- hyper + ] = Maximize focused window x
-- shift_hyper + left = Move focused window left 1 monitor
-- shift_hyper + right = Move focused window right 1 monitor

-- spoon.MiroWindowsManager.sizes = { 6/5, 4/3, 3/2, 2/1, 3/1, 4/1, 6/1 }

hs.window.animationDuration = 0

hyper = { 'alt', 'ctrl', 'cmd' }
shift_hyper = { 'shift', 'ctrl', 'cmd', 'alt'}

hs.loadSpoon("MiroWindowsManager")
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "f"}
})

-- center focused x and y
hs.hotkey.bind(hyper, 'c', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = ((max.w - f.w) / 2) + max.x
	x.y = ((max.h - f.h) / 2) + max.y
	win:setFrame(x)
end)

-- center focused y
hs.hotkey.bind(hyper, 'x', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.y = ((max.h - f.h) / 2) + max.y
	win:setFrame(x)
end)

-- center focused x
hs.hotkey.bind(hyper, 'v', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = ((max.w - f.w) / 2) + max.x
	win:setFrame(x)
end)

-- maximize vertically
hs.hotkey.bind(hyper, '[', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.y = max.y
	x.h = max.h
	win:setFrame(x)
end)

-- maximize horizontally
hs.hotkey.bind(hyper, ']', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = max.x
	x.w = max.w
	win:setFrame(x)
end)

-- move focused window to other screen
hs.hotkey.bind(shift_hyper, 'right', function() hs.window.focusedWindow():moveOneScreenEast(true, true) end)
hs.hotkey.bind(shift_hyper, 'left', function() hs.window.focusedWindow():moveOneScreenWest(true, true) end)

hs.hotkey.bind(shift_hyper, 'i', function() hs.alert.show(hs.window.focusedWindow()) end)
