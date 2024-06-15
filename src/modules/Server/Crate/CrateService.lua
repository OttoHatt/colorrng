--[=[
	@class CrateService

	Manage players unboxing crates, storage.
]=]

local require = require(script.Parent.loader).load(script)

local ATTR_COOLDOWN = "CrateService_CrateCooldown"
local COOLDOWN_TIME = 8

local REMOTE_FUNCTION_NAME = "CrateServiceRemoteFunction"
local SUBSTORE_KEY = "Colors"

local CrateConstants = require("CrateConstants")
local GetRemoteFunction = require("GetRemoteFunction")
local Maid = require("Maid")
local PlayerDataStoreService = require("PlayerDataStoreService")
local RxPlayerUtils = require("RxPlayerUtils")

local CrateService = {}
CrateService.ServiceName = "CrateService"

function CrateService:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._maid = Maid.new()

	self._playerDataStoreService = serviceBag:GetService(PlayerDataStoreService)
end

function CrateService:Start()
	self._maid:GiveTask(RxPlayerUtils.observePlayersBrio():Subscribe(function(brio)
		local maid, player: Player = brio:ToMaidAndValue()

		local folder = Instance.new("Folder")
		folder.Archivable = false
		folder.Name = "ColorInventory"
		folder.Parent = player

		local function setOrCreateKey(key: string, value: number?)
			local i = folder:FindFirstChild(key)

			if value == nil then
				if i then
					i:Destroy()
				end
				return
			end

			if i then
				i.Value = value
			else
				i = Instance.new("IntValue")
				i.Name = key
				i.Archivable = false
				i.Value = value
				i.Parent = folder
			end
		end

		maid:GivePromise(self._playerDataStoreService:PromiseDataStore(player)):Then(function(root)
			local subStore = root:GetSubStore(SUBSTORE_KEY)

			local lastSnapshot = nil
			maid:GiveTask(subStore:Observe():Subscribe(function(newSnapshot)
				-- TODO: PR moving this pure method to a util.
				local delta = subStore._computeChangedKeys(nil, lastSnapshot, newSnapshot)

				for key: string, _ in delta do
					setOrCreateKey(key, newSnapshot[key])
				end
			end))
		end)
	end))

	local remoteFunction = GetRemoteFunction(REMOTE_FUNCTION_NAME) :: RemoteFunction
	remoteFunction.OnServerInvoke = function(player: Player, msg: string)
		if msg == "Unbox" then
			if
				player:GetAttribute(ATTR_COOLDOWN)
				and workspace:GetServerTimeNow() - player:GetAttribute(ATTR_COOLDOWN) < COOLDOWN_TIME
			then
				return nil
			end
			player:SetAttribute(ATTR_COOLDOWN, workspace:GetServerTimeNow())

			local idx = math.random(1, #CrateConstants)
			self:_awardColor(player, idx)
			return idx
		end

		return nil
	end
	self._maid:GiveTask(function()
		remoteFunction.OnServerInvoke = function() end
	end)
end

function CrateService:_awardColor(player: Player, index: number)
	return self._playerDataStoreService:PromiseDataStore(player):Then(function(root)
		local subStore = root:GetSubStore(SUBSTORE_KEY)
		return subStore:Load(tostring(index), 0):Then(function(count: number)
			subStore:Store(tostring(index), count + 1)
		end)
	end)
end

function CrateService:Destroy()
	self._maid:DoCleaning()
end

return CrateService
