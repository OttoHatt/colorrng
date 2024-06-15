--[=[
	@class ScreenFade

	Managed screen-wide fade.
]=]

local require = require(script.Parent.loader).load(script)

local RunService = game:GetService("RunService")

local BaseObject = require("BaseObject")
local Promise = require("Promise")
local RxInstanceUtils = require("RxInstanceUtils")
local SpringObject = require("SpringObject")
local ValueObject = require("ValueObject")

local ScreenFade = setmetatable({}, BaseObject)
ScreenFade.ClassName = "ScreenFade"
ScreenFade.__index = ScreenFade

function ScreenFade.new(obj)
	local self = setmetatable(BaseObject.new(obj), ScreenFade)

	self._color = self._maid:Add(ValueObject.new(Color3.new(0, 0, 0), "Color3"))

	self._pane = Instance.new("Frame")
	self._pane.Size = UDim2.new(1, 0, 1, 0)
	self._pane.BackgroundColor3 = Color3.new(0, 0, 0)
	self._pane.BorderSizePixel = 0
	self._pane.ZIndex = 9999
	self._pane.Parent = self._screen
	self._maid:GiveTask(self._pane)

	self._spring = SpringObject.new(1, 35, 1)
	self._maid:GiveTask(self._spring:Observe():Subscribe(function(fac: number)
		self._pane.BackgroundTransparency = fac
		self._pane.Visible = fac < 0.99
	end))
	self._maid:GiveTask(self._spring)

	return self
end

function ScreenFade:FadeIn()
	self:_transitionTo(true)
end

function ScreenFade:FadeOut()
	self:_transitionTo(false)
end

function ScreenFade:PromiseCovered()
	return self:_promiseState(true)
end

function ScreenFade:ObserveVisible()
	return RxInstanceUtils.observeProperty(self._pane, "Visible")
end

function ScreenFade:_transitionTo(covered: boolean)
	self._spring.Target = if covered then 0 else 1
end

function ScreenFade:_promiseState(covered: boolean)
	local target = if covered then 0 else 1

	if self._spring.Position == target then
		return Promise.resolved()
	end

	local promise = Promise.new()

	local conn = RunService.RenderStepped:Connect(function()
		if math.abs(target - self._spring.Position) < self._spring.Epsilon then
			promise:Resolve()
		end
	end)
	promise:Finally(function()
		conn:Disconnect()
	end)

	return self._maid:GivePromise(promise)
end

function ScreenFade:SetParent(obj: Instance)
	self._pane.Parent = obj
end

function ScreenFade:SetSpeed(speed: number)
	self._spring.Speed = speed
end

function ScreenFade:SetBlockInput(block: boolean)
	self._pane.Active = block
end

return ScreenFade
