--[=[
	@class CrateAnimUtils

	Crate animation utils.
]=]

local require = require(script.Parent.loader).load(script)

local SOUND_PLINK = "rbxassetid://3199239518"
local SOUND_FINAL = "rbxassetid://2752040675"

local SOUND_TIERS = table.freeze({
	[1] = "", -- Boo
	[2] = "rbxassetid://3199299018", -- Applause
	[3] = "rbxassetid://3199299018", -- Applause
	[4] = "rbxassetid://8068122001", -- Eerie chorus chord
})

local RunService = game:GetService("RunService")

local Blend = require("Blend")
local Color3Utils = require("Color3Utils")
local ContentProviderUtils = require("ContentProviderUtils")
local CrateConstants = require("CrateConstants")
local LuvColor3Utils = require("LuvColor3Utils")
local Maid = require("Maid")
local Observable = require("Observable")
local Promise = require("Promise")
local Rx = require("Rx")
local SoundUtils = require("SoundUtils")
local SpringObject = require("SpringObject")
local TierConstants = require("TierConstants")
local ValueObject = require("ValueObject")
local WxTheme = require("WxTheme")

local CrateAnimUtils = {}

-- This is an approximiation of how long the animation takes to reveal the unboxed color.
-- It should be kept up-to-date as the animation is tweaked.
CrateAnimUtils.ESTIMATED_TIME_REVEAL = 4.1

function CrateAnimUtils.promisePreload()
	return ContentProviderUtils.promisePreload({
		SoundUtils.createSoundFromId(SOUND_PLINK),
		SoundUtils.createSoundFromId(SOUND_FINAL),
		SoundUtils.createSoundFromId(SOUND_TIERS[1]),
		SoundUtils.createSoundFromId(SOUND_TIERS[2]),
		SoundUtils.createSoundFromId(SOUND_TIERS[3]),
		SoundUtils.createSoundFromId(SOUND_TIERS[4]),
	})
end

local function observeChaseColor(targetValue)
	return Observable.new(function(sub)
		local col = Color3.new(1, 1, 1)

		sub:Fire(col)
		return RunService.RenderStepped:Connect(function(_dt: number)
			-- TODO: Use dt lol.
			col = LuvColor3Utils.lerp(col, targetValue.Value, 0.3)
			sub:Fire(col)
		end)
	end)
end

function CrateAnimUtils.animate(parent: Instance, targetIndex: number)
	local promise = Promise.new()

	local maid = Maid.new()
	promise:Finally(function()
		maid:Destroy()
	end)

	local targetColor = ValueObject.new(Color3.new(1, 1, 1), "Color3")
	maid:GiveTask(targetColor)

	local knockSpring = SpringObject.new(Vector3.zero, 40, 0.5)
	maid:GiveTask(knockSpring)

	local scaleSpring = SpringObject.new(0, 30, 0.4)
	maid:GiveTask(scaleSpring)

	local textRevealSpring = SpringObject.new(0, 15, 1)
	maid:GiveTask(textRevealSpring)

	local coverSpring = SpringObject.new(0, 20, 1)
	maid:GiveTask(coverSpring)

	local soundPlink = SoundUtils.createSoundFromId(SOUND_PLINK)
	local soundFinal = SoundUtils.createSoundFromId(SOUND_FINAL)

	maid:GiveTask(Blend.New("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(64 + 16, 64 + 16),
		BackgroundColor3 = observeChaseColor(targetColor),
		Visible = scaleSpring:Observe():Pipe({
			Rx.map(function(scale: number)
				return scale > 0.2
			end),
		}),
		Position = knockSpring:Observe():Pipe({
			Rx.map(function(pos: Vector3)
				return UDim2.new(0.5, math.round(pos.X), 0.5, math.round(pos.Y))
			end),
		}),
		Parent = parent,
		Blend.New("UICorner")({
			CornerRadius = UDim.new(0, 999),
		}),
		Blend.New("UIScale")({
			Scale = scaleSpring:Observe(),
		}),
		Blend.New("TextLabel")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0.9, 0, 0.9, 0),
			Text = CrateConstants[targetIndex].Name:gsub("%s", "\n"),
			TextColor3 = if Color3Utils.textShouldBeBlack(CrateConstants[targetIndex].Color)
				then Color3.new(0, 0, 0)
				else Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.SemiBold),
			TextSize = 16,
			TextTransparency = textRevealSpring:Observe():Pipe({
				Rx.map(function(fac: number)
					return 1 - fac
				end),
			}),
			Visible = textRevealSpring:Observe():Pipe({
				Rx.map(function(fac: number)
					return fac > 0.01
				end),
			}),
		}),
		Blend.New("TextLabel")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1.4, 0, 1.4, 0),
			Text = TierConstants[CrateConstants[targetIndex].Tier].Name,
			TextColor3 = TierConstants[CrateConstants[targetIndex].Tier].Color,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			BackgroundTransparency = 1,
			FontFace = Font.fromId(WxTheme.ID_SANS, Enum.FontWeight.Medium),
			TextSize = 14,
			TextTransparency = textRevealSpring:Observe():Pipe({
				Rx.map(function(fac: number)
					return 1 - fac
				end),
			}),
			Visible = textRevealSpring:Observe():Pipe({
				Rx.map(function(fac: number)
					return fac > 0.01
				end),
			}),
		}),
		soundPlink,
		soundFinal,
	}):Subscribe())
	maid:GiveTask(Blend.New("Frame")({
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(4, 4),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = coverSpring:Observe():Pipe({
			Rx.map(function(fac: number)
				return 1 - fac * 0.4
			end),
		}),
		ZIndex = -1,
		Parent = parent,
	}):Subscribe())

	maid:GiveTask(task.defer(function()
		scaleSpring.Target = 0.3
		coverSpring.Target = 1
		task.wait(0.4)

		local off = 0.42
		local intensity = 1
		while off > (1 / 60) do
			local angle = math.pi * 2 * math.random()
			knockSpring.Target += (Vector3.new(math.cos(angle), math.sin(angle), 0) * 10 * intensity)
			scaleSpring:Impulse(10 * intensity)

			local randomSwatch = CrateConstants[math.random(1, #CrateConstants)]
			targetColor.Value = LuvColor3Utils.lerp(targetColor.Value, randomSwatch.Color, 1)

			soundPlink.PlaybackSpeed = intensity * 0.9
			soundPlink:Play()

			intensity *= 1.07
			off *= 0.9
			task.wait(off)
		end

		knockSpring.Target = Vector3.zero
		targetColor.Value = CrateConstants[targetIndex].Color
		scaleSpring:Impulse(-10)
		scaleSpring.Target = 1.15
		textRevealSpring.Target = 1

		SoundUtils.playFromIdInParent({
			SoundId = SOUND_TIERS[CrateConstants[targetIndex].Tier],
			Volume = 0.25 * 0.65,
		}, parent)
		soundFinal:Play()

		task.wait(2.8)

		scaleSpring.Target = 0
		textRevealSpring.Target = 0
		coverSpring.Target = 0

		task.wait(0.3)

		promise:Resolve()
	end))

	return promise
end

return CrateAnimUtils
