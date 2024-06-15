--[=[
	@class CrateInventoryService

	Render UI hud for the client.
]=]

local require = require(script.Parent.loader).load(script)

local BasicPaneUtils = require("BasicPaneUtils")
local ColorRngScreenProvider = require("ColorRngScreenProvider")
local CrateControlsService = require("CrateControlsService")
local CrateInventoryButton = require("CrateInventoryButton")
local CrateInventoryView = require("CrateInventoryView")
local CrateServiceClient = require("CrateServiceClient")
local GameScalingUtils = require("GameScalingUtils")
local Maid = require("Maid")
local Rx = require("Rx")
local StateStack = require("StateStack")
local ValueObject = require("ValueObject")

local CrateInventoryService = {}
CrateInventoryService.ServiceName = "CrateInventoryService"

function CrateInventoryService:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._maid = Maid.new()

	self._crateControlsService = serviceBag:GetService(CrateControlsService)
	self._crateServiceClient = serviceBag:GetService(CrateServiceClient)
	self._colorRngScreenProvider = serviceBag:GetService(ColorRngScreenProvider)

	self._enabled = self._maid:Add(StateStack.new(false, "boolean"))
	self._inventoryOpen = self._maid:Add(ValueObject.new(false))
end

function CrateInventoryService:PushEnabled()
	return self._enabled:PushState(true)
end

function CrateInventoryService:Start()
	-- Hide inventory when unboxing.
	-- No technical reason, I just think it looks better.
	self._maid:GiveTask(self._crateControlsService.AnimationActive.Changed:Connect(function(active: boolean)
		if active then
			self._inventoryOpen.Value = false
		end
	end))

	self._maid:GiveTask(self._enabled
		:Observe()
		:Pipe({
			BasicPaneUtils.whenVisibleBrio(function(maid)
				return self:_mountSidebar(maid)
			end),
		})
		:Subscribe())

	self._maid:GiveTask(Rx.combineLatest({
		a = self._enabled:Observe(),
		b = self._inventoryOpen:Observe(),
	})
		:Pipe({
			Rx.map(function(state)
				return state.a and state.b
			end),
			Rx.distinct(),
			BasicPaneUtils.whenVisibleBrio(function(maid)
				return self:_mountInventory(maid)
			end),
		})
		:Subscribe())
end

function CrateInventoryService:_makeScreen(maid): ScreenGui
	local screen = self._colorRngScreenProvider:Get("CRATEINVENTORY") :: ScreenGui
	screen.IgnoreGuiInset = true
	maid:GiveTask(GameScalingUtils.renderDialogPadding({ ScreenGui = screen, Parent = screen }):Subscribe())
	maid:GiveTask(screen)
	return screen
end

function CrateInventoryService:_mountSidebar(maid)
	local screen = self:_makeScreen(maid)

	local btn = CrateInventoryButton.new()
	btn.Gui.AnchorPoint = Vector2.new(0, 0.5)
	btn.Gui.Position = UDim2.fromScale(0, 0.5)
	btn.Gui.Parent = screen
	maid:GiveTask(GameScalingUtils.renderUIScale({ ScreenGui = screen, Parent = btn.Gui }):Subscribe())
	maid:GiveTask(self._inventoryOpen:Mount(btn.State))
	maid:GiveTask(self._inventoryOpen.Changed:Connect(function(...)
		btn.State.Value = ...
	end))
	maid:GiveTask(btn)

	return btn
end

function CrateInventoryService:_mountInventory(maid)
	local screen = self:_makeScreen(maid)

	local view = CrateInventoryView.new(self._crateServiceClient:GetModel())
	view.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
	view.Gui.Position = UDim2.fromScale(0.5, 0.5)
	view.Gui.Parent = screen
	maid:GiveTask(GameScalingUtils.renderUIScale({ ScreenGui = screen, Parent = view.Gui }):Subscribe())
	maid:GiveTask(view.OnClose:Connect(function()
		self._inventoryOpen.Value = false
	end))
	maid:GiveTask(view)

	return view
end

function CrateInventoryService:Destroy()
	self._maid:DoCleaning()
end

return CrateInventoryService
