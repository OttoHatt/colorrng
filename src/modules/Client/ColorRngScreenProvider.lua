local require = require(script.Parent.loader).load(script)

local GenericScreenGuiProvider = require("GenericScreenGuiProvider")

return GenericScreenGuiProvider.new({
	CRATECONTROL = 0,
	CRATEINVENTORY = 1,
	CRATEUNBOX = 100,
	FADE = 1000,
})
