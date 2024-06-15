--[=[
	@class CrateButton

	Press this button to open a crate.
]=]

local require = require(script.Parent.loader).load(script)

local SOUND_CLICK = 9113878560

local BasicPane = require("BasicPane")
local BasicPaneUtils = require("BasicPaneUtils")
local Blend = require("Blend")
local Rx = require("Rx")
local SoundUtils = require("SoundUtils")
local TextServiceUtils = require("TextServiceUtils")
local WxTheme = require("WxTheme")

local CrateButton = setmetatable({}, BasicPane)
CrateButton.ClassName = "CrateButton"
CrateButton.__index = CrateButton

function CrateButton.new(obj)
	local self = setmetatable(BasicPane.new(obj), CrateButton)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	self.Activated = self.Gui.Activated

	local sound = SoundUtils.createSoundFromId(SOUND_CLICK)
	sound.Parent = self.Gui
	self._maid:GiveTask(self.Activated:Connect(function()
		sound:Play()
	end))

	return self
end

function CrateButton:_render()
	local PADDING = 16
	local TEXT_HEIGHT = 16

	local textProps = {
		Text = "Unbox!!",
		TextColor3 = WxTheme.TEXT,
		TextSize = TEXT_HEIGHT,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.SemiBold),
	}

	local observeDesiredSize = TextServiceUtils.observeSizeForLabelProps(textProps):Pipe({
		Rx.map(function(size: Vector3)
			return Vector3.new(size.X + PADDING * 2, size.Y + PADDING)
		end),
		Rx.defaultsTo(Vector3.new(0, TEXT_HEIGHT + PADDING)),
	})

	local observeAnimSize = Blend.Computed(
		BasicPaneUtils.observeVisible(self),
		observeDesiredSize,
		function(vis: boolean, size: Vector3)
			return if vis then size else Vector3.new(0, size.Y)
		end
	)
	local observeSpringSize = Blend.Spring(observeAnimSize, 25, 0.7):Pipe({
		Rx.map(function(size: Vector3)
			-- Springs accumulate floating point error, causing jitter because UDim2s store offset as integers.
			-- For the width, we want a multiple of 2 because we're going to centre this element across the X-axis.
			-- Multiples of 1 will cause the contents to shift a pixel over in some direction while animating.
			local width = math.round(size.X / 2) * 2
			local height = math.round(size.Y)
			return UDim2.fromOffset(width, height)
		end),
	})

	return Blend.New("ImageButton")({
		ClipsDescendants = true,
		Image = WxTheme.PATTERN_STRIPE,
		BackgroundColor3 = WxTheme.BG,
		ImageColor3 = WxTheme.BG_MID,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(32, 32),
		Visible = observeSpringSize:Pipe({
			Rx.map(function(size: UDim2)
				return size.X.Offset > 8
			end),
		}),
		Size = observeSpringSize,
		Blend.New("UICorner")({
			CornerRadius = UDim.new(0, 4),
		}),
		Blend.New("UIStroke")({
			Thickness = 2,
			Color = WxTheme.TEXT,
		}),
		Blend.New("TextLabel")(textProps),
	})
end

return CrateButton
