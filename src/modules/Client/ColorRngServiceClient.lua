--[=[
	@class ColorRngServiceClient

	Client entry point.
]=]

local require = require(script.Parent.loader).load(script)

local ColorRngServiceClient = {}
ColorRngServiceClient.ServiceName = "ColorRngServiceClient"

function ColorRngServiceClient:Init(serviceBag)
	-- External.
	serviceBag:GetService(require("HideServiceClient"))

	-- Internal.
	serviceBag:GetService(require("CrateServiceClient"))
	serviceBag:GetService(require("CrateControlsService"))
	serviceBag:GetService(require("CrateInventoryService"))
	serviceBag:GetService(require("CrateHudActivationService"))
end

return ColorRngServiceClient
