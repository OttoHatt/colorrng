local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).bootstrapStory(script)

local Maid = require("Maid")
local CrateButton = require("CrateButton")

return function(target)
	local maid = Maid.new()

	local frame = CrateButton.new()
	frame.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Gui.Position = UDim2.fromScale(0.5, 0.5)
	frame.Gui.Parent = target
	maid:GiveTask(frame)

	frame:Show()

	return function()
		maid:DoCleaning()
	end
end