--[=[
	@class ColorRngService

	Server entry point.
]=]

local require = require(script.Parent.loader).load(script)

local ColorRngService = {}
ColorRngService.ServiceName = "ColorRngService"

function ColorRngService:Init(serviceBag)
	-- External.
	serviceBag:GetService(require("HideService"))

	-- Internal.
	serviceBag:GetService(require("CrateService"))
end

return ColorRngService
