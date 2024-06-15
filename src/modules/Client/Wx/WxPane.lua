--[=[
	@class WxPane

	Basic little bordered frame for holding elements.
]=]

local require = require(script.Parent.loader).load(script)

local HEADER_HEIGHT = 32 + 12
local CORNER_RADIUS = UDim.new(0, 4)
local PADDING = 16

local Blend = require("Blend")
local Rx = require("Rx")
local WxTheme = require("WxTheme")

local WxPane = {}

local function toBooleanObservable(prop)
	if typeof(prop) == "boolean" then
		return Rx.of(prop)
	else
		return Blend.toPropertyObservable(prop)
	end
end

function WxPane.render(props)
	local visSpring = Blend.Spring(
		toBooleanObservable(props.Visible or true):Pipe({
			Rx.map(function(vis)
				return if vis then 1 else 0
			end),
		}),
		65,
		1.2
	)

	local children = {}
	for i, v in props do
		if typeof(i) == "number" then
			table.insert(children, v)
		end
	end

	return Blend.New("Frame")({
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = Blend.Computed(props.Size, function(size: UDim2)
			return size + UDim2.fromOffset(PADDING * 2, HEADER_HEIGHT + PADDING * 2)
		end),
		Rotation = props.Rotation,
		BackgroundTransparency = 1,
		Visible = Blend.Computed(visSpring, function(fac)
			return fac > 0.4
		end),
		Blend.New("Frame")({
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WxTheme.BG_MID,
			Position = visSpring:Pipe({
				Rx.map(function(off)
					return UDim2.fromOffset(0, math.round((1 - off) * 16))
				end),
			}),
			Blend.New("UIStroke")({
				Color = WxTheme.TEXT,
				Thickness = 2,
			}),
			Blend.New("UICorner")({
				CornerRadius = CORNER_RADIUS,
			}),
			Blend.New("Frame")({
				Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
				BackgroundColor3 = WxTheme.BG,
				Blend.New("UICorner")({
					CornerRadius = CORNER_RADIUS,
				}),
				props.OnClose and Blend.New("ImageButton")({
					Image = "rbxassetid://14721361292",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Size = UDim2.fromOffset(22, 22),
					Position = UDim2.new(1, -16, 0.5, 0),
					[Blend.OnEvent("Activated")] = props.OnClose,
				}),
			}),
			Blend.New("TextLabel")({
				Position = UDim2.fromOffset(PADDING, 0),
				Size = UDim2.new(1, -PADDING * 2, 0, HEADER_HEIGHT),
				TextXAlignment = props.TitleAlignment or Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Text = props.Title,
				TextSize = 22,
				TextColor3 = WxTheme.TEXT,
				FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.SemiBold),
				BackgroundTransparency = 1,
			}),
			Blend.New("Frame")({
				Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT),
				Position = UDim2.fromOffset(0, HEADER_HEIGHT),
				BackgroundTransparency = 1,
				ClipsDescendants = props.ClipsDescendants,
				Blend.New("Frame")({
					Size = UDim2.new(1, -PADDING * 2, 1, -PADDING * 2),
					Position = UDim2.fromOffset(PADDING, PADDING),
					BackgroundTransparency = 1,
					[Blend.Children] = children,
				}),
			}),
		}),
	})
end

return WxPane
