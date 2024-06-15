--[=[
	@class CrateInventoryView

	Render a crate inventory from simple model.
]=]

local require = require(script.Parent.loader).load(script)

local ICON_STAR = "rbxassetid://17011007654"

local PADDING = 6

local TILE_ACROSS = 5
local TILE_W = 64 + 16 + 8 + 4
local TILE_COLOR_H = TILE_W - 16
local TILE_H = TILE_COLOR_H + 36 + 8

local GRID_WIDTH = TILE_ACROSS * TILE_W + (TILE_ACROSS - 1) * PADDING

local BasicPane = require("BasicPane")
local BasicPaneUtils = require("BasicPaneUtils")
local Blend = require("Blend")
local CrateConstants = require("CrateConstants")
local Rx = require("Rx")
local RxBrioUtils = require("RxBrioUtils")
local Signal = require("Signal")
local TierConstants = require("TierConstants")
local WxPane = require("WxPane")
local WxTheme = require("WxTheme")

local CrateInventoryView = setmetatable({}, BasicPane)
CrateInventoryView.ClassName = "CrateInventoryView"
CrateInventoryView.__index = CrateInventoryView

function CrateInventoryView.new(model)
	local self = setmetatable(BasicPane.new(), CrateInventoryView)

	-- In this simple game we can just take in an ObservableMap as our "model".
	-- You'd expand this to a custom object wrapping this class to support deletion etc.
	self._model = model

	self.OnClose = self._maid:Add(Signal.new())

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

local function renderColor(index: number, count: number)
	index = tonumber(index)

	local p = Instance.new("Frame")
	p.Name = index
	p.LayoutOrder = -CrateConstants[index].Tier
	p.BackgroundColor3 = WxTheme.BG
	do
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 4)
		c.Parent = p
	end

	local f = Instance.new("Frame")
	f.Position = UDim2.fromOffset(0, 0)
	f.Size = UDim2.fromOffset(TILE_W, TILE_COLOR_H)
	f.BackgroundColor3 = CrateConstants[index].Color
	f.Parent = p
	do
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 0)
		c.Parent = f
	end

	do
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.Medium)
		l.Position = UDim2.fromOffset(PADDING, TILE_COLOR_H + PADDING)
		l.Size = UDim2.fromOffset(TILE_W - PADDING * 2, TILE_H - TILE_COLOR_H - PADDING * 2)
		l.Text = CrateConstants[index].Name
		l.TextColor3 = WxTheme.TEXT
		l.TextSize = 14
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.TextWrapped = true
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextYAlignment = Enum.TextYAlignment.Top
		l.Parent = p
	end

	if count > 1 then
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.Medium)
		l.Position = UDim2.fromOffset(PADDING, PADDING)
		l.Size = UDim2.fromOffset(TILE_W - PADDING * 2, 0)
		l.Text = `x{count}`
		l.TextColor3 = WxTheme.TEXT
		l.TextSize = 14
		l.TextXAlignment = Enum.TextXAlignment.Right
		l.TextYAlignment = Enum.TextYAlignment.Top
		l.TextTransparency = 0.78
		l.Parent = p
	end

	if CrateConstants[index].Tier > 1 then
		local sticker = Instance.new("ImageLabel")
		sticker.Size = UDim2.fromOffset(12, 12)
		sticker.Image = ICON_STAR
		sticker.Position = UDim2.new(1, -4, 1, -6)
		sticker.AnchorPoint = Vector2.new(1, 1)
		sticker.BackgroundTransparency = 1
		sticker.ImageColor3 = TierConstants[CrateConstants[index].Tier].Color
		sticker.Parent = p
	end

	return p
end

function CrateInventoryView:_render()
	return WxPane.render({
		Title = "Inventory",
		ClipsDescendants = true,
		Size = UDim2.fromOffset(GRID_WIDTH, 340),
		OnClose = self.OnClose,
		Visible = BasicPaneUtils.observeVisible(self),
		Blend.New("ScrollingFrame")({
			Size = UDim2.new(1, 24, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			HorizontalScrollBarInset = Enum.ScrollBarInset.None,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BottomImage = "rbxasset://textures/ui/InGameMenu/ScrollBottom.png",
			TopImage = "rbxasset://textures/ui/InGameMenu/ScrollTop.png",
			MidImage = "rbxasset://textures/ui/InGameMenu/ScrollMiddle.png",
			ScrollBarThickness = 12,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = WxTheme.TEXT,
			CanvasSize = self._model:ObserveCount():Pipe({
				Rx.map(function(count)
					local rows = (count + TILE_ACROSS - 1) // TILE_ACROSS
					local height = rows * TILE_H + (rows - 1) * PADDING
					return UDim2.fromOffset(GRID_WIDTH, height)
				end),
			}),
			Blend.New("UIGridLayout")({
				CellSize = UDim2.fromOffset(TILE_W, TILE_H),
				CellPadding = UDim2.fromOffset(PADDING, PADDING),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			self._model:ObservePairsBrio():Pipe({
				RxBrioUtils.map(renderColor),
			}),
		}),
	})
end

return CrateInventoryView
