--[=[
	@class CrateControlsService

	Client-side crate unboxing controls.
]=]

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")

local BasicPaneUtils = require("BasicPaneUtils")
local CameraStackService = require("CameraStackService")
local CharacterUtils = require("CharacterUtils")
local ColorRngScreenProvider = require("ColorRngScreenProvider")
local CoreGuiEnabler = require("CoreGuiEnabler")
local CrateAnimUtils = require("CrateAnimUtils")
local CrateButton = require("CrateButton")
local CrateConstants = require("CrateConstants")
local CrateServiceClient = require("CrateServiceClient")
local GameScalingUtils = require("GameScalingUtils")
local Maid = require("Maid")
local Signal = require("Signal")
local SpringObject = require("SpringObject")
local StateStack = require("StateStack")

local CrateControlsService = {}
CrateControlsService.ServiceName = "CrateControlsService"

function CrateControlsService:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._maid = Maid.new()

	self._colorRngScreenProvider = serviceBag:GetService(ColorRngScreenProvider)
	self._crateService = serviceBag:GetService(CrateServiceClient)
	self._coreGuiEnabler = serviceBag:GetService(CoreGuiEnabler)
	self._cameraStackService = serviceBag:GetService(CameraStackService)

	self._enabled = self._maid:Add(StateStack.new(false, "boolean"))

	self._unboxed = self._maid:Add(Signal.new())
	self.AnimationActive = self._maid:Add(StateStack.new(false))
end

function CrateControlsService:PushEnabled()
	return self._enabled:PushState(true)
end

function CrateControlsService:Start()
	self._maid:GiveTask(self._enabled
		:Observe()
		:Pipe({
			BasicPaneUtils.whenVisibleBrio(function(maid)
				return self:_makeButton(maid)
			end),
		})
		:Subscribe())

	self._maid:Add(CrateAnimUtils.promisePreload()):Then(function()
		self:_mountAnim(self._maid)
		self:_mountLight(self._maid)
		self:_mountShake(self._maid)
	end)
end

function CrateControlsService:_makeButton(maid)
	local screen = self._colorRngScreenProvider:Get("CRATECONTROL") :: ScreenGui
	screen.IgnoreGuiInset = true
	maid:GiveTask(GameScalingUtils.renderDialogPadding({ ScreenGui = screen, Parent = screen }):Subscribe())
	maid:GiveTask(screen)

	local btn = CrateButton.new()
	btn.Gui.AnchorPoint = Vector2.new(0.5, 1)
	btn.Gui.Position = UDim2.fromScale(0.5, 1)
	btn.Gui.Parent = screen
	maid:GiveTask(GameScalingUtils.renderUIScale({ ScreenGui = screen, Parent = btn.Gui }):Subscribe())
	maid:GiveTask(btn.Activated:Connect(function()
		maid._prom = self._crateService:PromiseTryUnbox()
		maid._prom:Then(function(index: number?)
			if index then
				self._unboxed:Fire(index)
			end
		end)
	end))
	maid:GiveTask(btn)

	return btn
end

function CrateControlsService:_mountAnim(maid)
	local screen = self._colorRngScreenProvider:Get("CRATEUNBOX") :: ScreenGui
	screen.IgnoreGuiInset = true
	maid:GiveTask(screen)

	local proxy = Instance.new("Frame")
	proxy.Size = UDim2.new(1, 0, 1, 0)
	proxy.AnchorPoint = Vector2.new(0.5, 0.5)
	proxy.Position = UDim2.fromScale(0.5, 0.5)
	proxy.BackgroundTransparency = 1
	proxy.Parent = screen
	maid:GiveTask(GameScalingUtils.renderUIScale({ ScreenGui = screen, Parent = proxy }):Subscribe())
	maid:GiveTask(proxy)

	maid:GiveTask(self._unboxed:Connect(function(idx: number)
		maid._anim = CrateAnimUtils.animate(proxy, idx)
		maid._hideGui = self._coreGuiEnabler:Disable(newproxy(), Enum.CoreGuiType.All)
		maid._state = self.AnimationActive:PushState(true)
		maid._anim:Finally(function()
			maid._hideGui = nil
			maid._state = false
		end)
	end))
end

function CrateControlsService:_mountLight(maid)
	local l = Instance.new("PointLight")
	l.Archivable = false
	l.Name = "CrateLight"
	l.Shadows = true
	l.Range = 48
	l.Brightness = 0
	maid:GiveTask(l)

	local spring = SpringObject.new(0, 3, 1)
	maid:GiveTask(spring:ObserveRenderStepped():Subscribe(function(fac: number)
		l.Brightness = fac * 0.3
		l.Enabled = fac > 0.01
	end))
	maid:GiveTask(spring)

	maid:GiveTask(self._unboxed:Connect(function(idx: number)
		maid._light = task.delay(CrateAnimUtils.ESTIMATED_TIME_REVEAL, function()
			local hrp = CharacterUtils.getAlivePlayerRootPart(Players.LocalPlayer)
			l.Parent = hrp

			l.Color = CrateConstants[idx].Color
			spring.Position = 1
		end)
	end))
end

function CrateControlsService:_mountShake(maid)
	maid:GiveTask(self._unboxed:Connect(function(idx: number)
		-- The higher the tier, the more violent the shake.
		maid._shake = task.delay(CrateAnimUtils.ESTIMATED_TIME_REVEAL, function()
			local impulse = Vector3.one * 0.25 * math.pow(2, CrateConstants[idx].Tier)
			self._cameraStackService:GetImpulseCamera():ImpulseRandom(impulse)
		end)
	end))
end

function CrateControlsService:Destroy()
	self._maid:DoCleaning()
end

return CrateControlsService
