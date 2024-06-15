local function makeTier(name: string, color: Color3)
	return table.freeze({
		Name = name,
		Color = color,
	})
end

return table.freeze({
	[1] = makeTier("Common", Color3.fromRGB(217, 216, 212)),
	[2] = makeTier("Rare", Color3.fromRGB(97, 159, 252)),
	[3] = makeTier("Epic", Color3.fromRGB(232, 103, 232)),
	[4] = makeTier("Legendary", Color3.fromRGB(248, 202, 52)),
})
