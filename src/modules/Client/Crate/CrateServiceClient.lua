--[=[
	@class CrateServiceClient

	Crate unboxing logic on the client.
]=]

local require = require(script.Parent.loader).load(script)

local REMOTE_FUNCTION_NAME = "CrateServiceRemoteFunction"

local Players = game:GetService("Players")

local CoreGuiEnabler = require("CoreGuiEnabler")
local Maid = require("Maid")
local ObservableMap = require("ObservableMap")
local PromiseGetRemoteFunction = require("PromiseGetRemoteFunction")
local RemoteFunctionUtils = require("RemoteFunctionUtils")
local RxBrioUtils = require("RxBrioUtils")
local RxInstanceUtils = require("RxInstanceUtils")
local RxValueBaseUtils = require("RxValueBaseUtils")

local CrateServiceClient = {}
CrateServiceClient.ServiceName = "CrateServiceClient"

function CrateServiceClient:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._maid = Maid.new()

	self._coreGuiEnabler = serviceBag:GetService(CoreGuiEnabler)

	self._remoteFunctionPromise = self._maid:Add(PromiseGetRemoteFunction(REMOTE_FUNCTION_NAME))

	self._model = ObservableMap.new()
	self._maid:GiveTask(self._model)
end

function CrateServiceClient:Start()
	self._maid:GiveTask(RxInstanceUtils.observeLastNamedChildBrio(Players.LocalPlayer, "Folder", "ColorInventory")
		:Pipe({
			RxBrioUtils.switchMapBrio(function(container: Instance)
				return RxInstanceUtils.observeChildrenOfClassBrio(container, "IntValue")
			end),
		})
		:Subscribe(function(brio)
			local maid, obj: IntValue = brio:ToMaidAndValue()
			maid:GiveTask(RxValueBaseUtils.observeValue(obj):Subscribe(function(count: number)
				-- Note that we need a string key.
				-- Writing integers can stomp maid tasks (in 'ObservableMap:_observeKeyValueChanged' et al).
				-- Triggering this bug breaks downstream observables.
				-- https://github.com/Quenty/NevermoreEngine/pull/479.
				self._model:Set(obj.Name, count)
			end))
			maid:GiveTask(function()
				self._model:Remove(obj.Name)
			end)
		end))
end

function CrateServiceClient:GetModel()
	return self._model
end

function CrateServiceClient:PromiseTryUnbox()
	return self._remoteFunctionPromise:Then(function(remoteFunction: RemoteFunction)
		return RemoteFunctionUtils.promiseInvokeServer(remoteFunction, "Unbox")
	end)
end

function CrateServiceClient:Destroy()
	self._maid:DoCleaning()
end

return CrateServiceClient
