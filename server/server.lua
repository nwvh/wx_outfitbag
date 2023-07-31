RegisterServerEvent('wx_outfitbag:placedBag')
AddEventHandler('wx_outfitbag:placedBag',function ()
	exports.ox_inventory:RemoveItem(source, wx.NeededItem, 1, nil, nil, nil)
end)

RegisterServerEvent('wx_outfitbag:pickedupBag')
AddEventHandler('wx_outfitbag:pickedupBag',function ()
	exports.ox_inventory:AddItem(source, wx.NeededItem, 1, nil, nil, nil)
end)