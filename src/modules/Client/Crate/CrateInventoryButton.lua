--[=[
	@class CrateInventoryButton

	Button to open the inventory.
]=]

local require = require(script.Parent.loader).load(script)

local CELL_SIZE = 60
local TEXT_PADDING = -12
local ICON_SIZE = 32 + 16

local BasicPane = require("BasicPane")
local BasicPaneUtils = require("BasicPaneUtils")
local Blend = require("Blend")
local Rx = require("Rx")
local ValueObject = require("ValueObject")
local WxTheme = require("WxTheme")

local CrateInventoryButton = setmetatable({}, BasicPane)
CrateInventoryButton.ClassName = "CrateInventoryButton"
CrateInventoryButton.__index = CrateInventoryButton

function CrateInventoryButton.new(obj)
	local self = setmetatable(BasicPane.new(obj), CrateInventoryButton)

	self.State = self._maid:Add(ValueObject.new(false))

	self._title = self._maid:Add(ValueObject.new("Safe"))
	self._icon = self._maid:Add(ValueObject.new("rbxassetid://17076317225"))

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function CrateInventoryButton:_render()
	local enterSpring = Blend.Spring(
		BasicPaneUtils.observeVisible(self):Pipe({
			Rx.map(function(visible: boolean)
				return if visible then 1 else 0
			end),
		}),
		25,
		0.7
	)

	return Blend.New("ImageButton")({
		Active = BasicPaneUtils.observeVisible(self),
		Size = UDim2.fromOffset(CELL_SIZE, CELL_SIZE),
		BackgroundTransparency = 1,
		Visible = enterSpring:Pipe({
			Rx.map(function(fac: number)
				return fac > 0.01
			end),
		}),
		[Blend.OnEvent("Activated")] = function()
			self.State.Value = not self.State.Value
		end,
		Blend.New("ImageLabel")({
			Position = enterSpring:Pipe({
				Rx.map(function(fac: number)
					local off = (1 - fac) * -(64 + 32 + 16)
					return UDim2.fromOffset(math.round(off), 0)
				end),
			}),
			Size = UDim2.fromOffset(CELL_SIZE, CELL_SIZE),
			Image = WxTheme.PATTERN_STRIPE,
			ImageColor3 = self.State:Observe():Pipe({
				Rx.map(function(selected)
					return if selected then WxTheme.PRIMARY_B else WxTheme.BG
				end),
			}),
			BackgroundColor3 = self.State:Observe():Pipe({
				Rx.map(function(selected)
					return if selected then WxTheme.PRIMARY_A else WxTheme.BG
				end),
			}),
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(32, 32),
			Blend.New("UIStroke")({
				Color = self.State:Observe():Pipe({
					Rx.map(function(selected)
						return if selected then WxTheme.PRIMARY_B else WxTheme.TEXT
					end),
				}),
				Thickness = 2,
			}),
			Blend.New("UICorner")({
				CornerRadius = UDim.new(0, 4),
			}),
			Blend.New("ImageLabel")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = self._icon,
			}),
			Blend.New("TextLabel")({
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, -TEXT_PADDING, 1, -TEXT_PADDING),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				Text = self._title,
				TextSize = 16,
				TextColor3 = WxTheme.TEXT,
				FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.SemiBold),
				Blend.New("UIStroke")({
					Color = WxTheme.BG,
					Thickness = 2,
				}),
			}),
		}),
	})
end

return CrateInventoryButton
