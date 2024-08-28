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
		self:_handlePlayer(brio:ToMaidAndValue())
	end))

	local remoteFunction = GetRemoteFunction(REMOTE_FUNCTION_NAME) :: RemoteFunction
	remoteFunction.OnServerInvoke = function(player: Player, msg: string)
		-- Typically a service has one remote, switching on the "msg" field.
		if msg ~= "Unbox" then
			return
		end

		-- Cooldown.
		local prev = player:GetAttribute(ATTR_COOLDOWN) :: number?
		local now = workspace:GetServerTimeNow()
		if prev and now - prev < COOLDOWN_TIME then
			return
		end
		player:SetAttribute(ATTR_COOLDOWN, now)

		-- The data (CrateConstants) is populated with decreasingly few high-tier items.
		-- Perhaps you'd want unboxing chances disproportional? See "RandomUtils.weightedRandom".
		local idx = math.random(1, #CrateConstants)
		self:_awardColor(player, idx)
		return idx
	end
	self._maid:GiveTask(function()
		remoteFunction.OnServerInvoke = nil
	end)
end

local function setKey(parent: Instance, key: string, value: number?)
	local r = parent:FindFirstChild(key)

	if value == nil then
		if r then
			r:Destroy()
		end
		return
	end

	if r then
		r.Value = value
	else
		r = Instance.new("IntValue")
		r.Name = key
		r.Archivable = false
		r.Value = value
		r.Parent = parent
	end
end

function CrateService:_handlePlayer(maid, player: Player)
	maid:GivePromise(self._playerDataStoreService:PromiseDataStore(player)):Then(function(root)
		-- The client will receive data by looking for an instance under their LocalPlayer.
		-- This is typical. Sometimes it's a binder.
		-- We observe by the instance name. You could store it in a Shared module; I typically don't bother.
		local repr = Instance.new("Folder")
		repr.Archivable = false
		repr.Name = "ColorInventory"
		repr.Parent = player

		local store = root:GetSubStore(SUBSTORE_KEY)

		local lastSnapshot = nil
		maid:GiveTask(store:Observe():Subscribe(function(newSnapshot)
			-- Interacting with the datamodel is slow, we try to avoid it.
			-- Rather than calling "setKey" on everything in the snapshot, just apply the difference.
			-- This method is an implementation detail... but it's pure, and the DataStore module is mature.
			-- So risk of this breaking with an update is minimal.
			-- It's not that much code anyways, could always clone it.
			local delta = store._computeChangedKeys(nil, lastSnapshot, newSnapshot)
			for key, _ in delta do
				setKey(repr, key, newSnapshot[key])
			end
		end))
	end)
end

function CrateService:_awardColor(player: Player, index: number)
	-- We convert the index to a string.
	-- The Json encoder must determine what the Lua table becomes; array or object?
	-- If it has a "[1]" index, it assumes an array, and discards anything discontinuous.
	-- So with number keys, if the user unboxed item index "1", their data would be corrupted.
	-- Strings are always safe.
	return self._playerDataStoreService:PromiseDataStore(player):Then(function(root)
		local store = root:GetSubStore(SUBSTORE_KEY)
		return store:Load(tostring(index), 0):Then(function(count: number)
			store:Store(tostring(index), count + 1)
		end)
	end)
end

function CrateService:Destroy()
	self._maid:DoCleaning()
end

return CrateService
