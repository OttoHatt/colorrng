local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).bootstrapStory(script)

local CrateConstants = require("CrateConstants")
local CrateInventoryView = require("CrateInventoryView")
local Maid = require("Maid")
local ObservableMap = require("ObservableMap")

return function(target)
	local maid = Maid.new()

	local model = ObservableMap.new()
	for i = 1, #CrateConstants do
		local c = math.random(0, 6)
		if c > 0 then
			model:Set(i, c)
		end
	end
	maid:GiveTask(model)

	local frame = CrateInventoryView.new(model)
	frame.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Gui.Position = UDim2.fromScale(0.5, 0.5)
	frame.Gui.Parent = target
	maid:GiveTask(frame)

	frame:Show()

	return function()
		maid:DoCleaning()
	end
end
