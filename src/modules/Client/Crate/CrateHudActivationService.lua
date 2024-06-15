--[=[
    @class CrateHudActivationService

	Hud appearence was tied to the removed "narrative" of the game.
	This service was written post-development so gameplay works out-of-the-box.
	It serves as reference for anonymously negotiating a service's state.
]=]

local require = require(script.Parent.loader).load(script)

local RunService = game:GetService("RunService")

local CrateControlsService = require("CrateControlsService")
local CrateInventoryService = require("CrateInventoryService")
local Maid = require("Maid")
local Observable = require("Observable")

local CrateHudActivationService = {}
CrateHudActivationService.ServiceName = "CrateHudActivationService"

function CrateHudActivationService:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._maid = Maid.new()

	self._crateControlsService = serviceBag:GetService(CrateControlsService)
	self._crateInventoryService = serviceBag:GetService(CrateInventoryService)
end

local function observeCameraNearPoint(point: Vector3, range: number)
	return Observable.new(function(sub)
		local last = nil

		local function update()
			local now = (workspace.CurrentCamera.CFrame.Position - point).Magnitude <= range
			if now ~= last then
				sub:Fire(now)
			end
			now = last
		end
		update()
		return RunService.RenderStepped:Connect(update)
	end)
end

function CrateHudActivationService:Start()
	self._maid:GiveTask(observeCameraNearPoint(Vector3.zero, 64):Subscribe(function(inRange: boolean)
		local maid = Maid.new()
		self._maid._push = maid
		if inRange then
			maid:GiveTask(self._crateControlsService:PushEnabled())
			maid:GiveTask(self._crateInventoryService:PushEnabled())
		end
	end))
end

function CrateHudActivationService:Destroy()
	self._maid:DoCleaning()
end

return CrateHudActivationService
