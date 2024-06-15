--[[
	@class ClientMain
]]
local loader = game:GetService("ReplicatedStorage"):WaitForChild("ColorRng"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)

local serviceBag = require("ServiceBag").new()

serviceBag:GetService(require("ColorRngServiceClient"))

serviceBag:Init()
serviceBag:Start()