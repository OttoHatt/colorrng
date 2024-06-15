--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.ColorRng:FindFirstChild("LoaderUtils", true).Parent
local packages = require(loader).bootstrapGame(ServerScriptService.ColorRng)

local serviceBag = require(packages.ServiceBag).new()

serviceBag:GetService(packages.ColorRngService)

serviceBag:Init()
serviceBag:Start()