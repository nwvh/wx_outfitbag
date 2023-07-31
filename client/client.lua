local outfitbags = {}

function DebugPrint(text)
	if wx.Debug then print("[DEBUG] "..text) end
end

RegisterNetEvent('wx_outfitbag:open')
AddEventHandler('wx_outfitbag:open',function ()
	DebugPrint('Bag has been opened')
	TriggerEvent(wx.Trigger)
end)
RegisterNetEvent('wx_outfitbag:placed')
AddEventHandler('wx_outfitbag:placed',function ()
	DebugPrint('Bag has been placed')
	TriggerServerEvent('wx_outfitbag:placedBag')
end)
RegisterNetEvent('wx_outfitbag:pickedup')
AddEventHandler('wx_outfitbag:pickedup',function ()
	DebugPrint('Progress bar for picking up bag has started')
	lib.progressCircle({
		duration = 1000,
		position = 'bottom',
		label = wx.Locale['picking'],
		useWhileDead = false,
		canCancel = false,
		disable = {
			car = true,
			move = true,
			combat = true
		},
		anim = {
			dict = 'random@domestic',
			clip = 'pickup_low'
		}
	})
	DebugPrint('Progress bar for picking up bag has completed')
	TriggerServerEvent('wx_outfitbag:pickedupBag')
	DebugPrint('Bag has been added to player\'s inventory')
	local outfitbag = lib.getClosestObject(GetEntityCoords(PlayerPedId()), 2.0)
	DebugPrint('Bag has been deleted')
	DeleteEntity(outfitbag)
end)

local options = {
	{
		canInteract = function(_, distance, _)
			if IsEntityDead(PlayerPedId()) then
				return false
			end
			if distance >= 2.0 then
				return false
			end
			return true
		end,
		event = 'wx_outfitbag:open',
		icon = 'fa-solid fa-shirt',
		label = wx.Locale['open'],
		distance = 2.1
	},
	{
		canInteract = function(_, distance, _)
			if IsEntityDead(PlayerPedId()) then
				return false
			end
			if distance >= 2.0 then
				return false
			end
			return true
		end,
		event = 'wx_outfitbag:pickedup',
		icon = 'fa-solid fa-hand',
		label = wx.Locale['pickup'],
		distance = 2.1
	},
}
DebugPrint('Added bag model to target options')
exports.ox_target:addModel("bkr_prop_duffel_bag_01a", options)

RegisterNetEvent('wx_outfitbag:place')
AddEventHandler('wx_outfitbag:place',function ()
	while not HasModelLoaded(GetHashKey("bkr_prop_duffel_bag_01a")) do Citizen.Wait(10) DebugPrint('Loading bag model...') end
	local ped = PlayerPedId()
	local count = lib.callback.await('ox_inventory:getItemCount', false, wx.NeededItem, {})
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if count >= 1 then
		DebugPrint('Player has '..count..' outfit bags')
		lib.progressCircle({
			duration = 1000,
			position = 'bottom',
			label = wx.Locale['placing'],
			useWhileDead = false,
			canCancel = false,
			disable = {
				car = true,
				move = true,
				combat = true
			},
			anim = {
				dict = 'random@domestic',
				clip = 'pickup_low'
			},
			prop = {
				model = `bkr_prop_duffel_bag_01a`,
				pos = vec3(0.3, 0.03, 0.02),
				rot = vec3(0.05, 0.3, 0.15)
			},
		})
		TriggerEvent('wx_outfitbag:placed')
		local outfitbag = CreateObject( "bkr_prop_duffel_bag_01a", x, y, z-1, true, false, false)
		SetEntityHeading(outfitbag, GetEntityHeading(ped))
		PlaceObjectOnGroundProperly(outfitbag)
		table.insert(outfitbags,outfitbag)
	else
		DebugPrint('Player doesn\'t have the required item: '..wx.NeededItem)
		Notify(wx.Locale['error'],wx.Locale['noitem'],'#f38ba8')
	end

end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		DebugPrint('Resource is stopping...')
		for k, bag in pairs(outfitbags) do
			DebugPrint('Trying to deleted outfitbag with hash key: '..bag)
			if DoesEntityExist(bag) then DeleteEntity(bag) DebugPrint('Deleted '..bag) end
		end
		DebugPrint('Resource has been stopped')
	end
end)