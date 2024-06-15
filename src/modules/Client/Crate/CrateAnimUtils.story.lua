local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).bootstrapStory(script)

local CrateAnimUtils = require("CrateAnimUtils")
local Maid = require("Maid")
local CrateConstants = require("CrateConstants")

return function(target)
	local maid = Maid.new()

	CrateAnimUtils.animate(target, math.random(1, #CrateConstants))

	return function()
		maid:DoCleaning()
	end
end