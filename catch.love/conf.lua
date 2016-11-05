function love.conf(t)
	t.modules.joystick = true
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.title = "Catch"
	t.author = "Claudet Family"
	t.window.vsync = false
	t.window.fsaa = 0
	t.window.height = 448
	t.window.width = 576
end
