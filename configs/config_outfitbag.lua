wx = {}

wx.Debug = false -- If true, you will get an additional F8 prints for what's going on
wx.NeededItem = 'outfitbag' -- Recommended to keep at default
wx.Trigger = 'illenium-appearance:client:openOutfitMenu' -- Client side event for opening your clothing/outfit menu

wx.Locale = { -- Translations
    ['open'] = "Open outfit bag",
    ['pickup'] = "Pick up outfit bag",
    ['placing'] = "Placing down outfit bag...",
    ['picking'] = "Picking up outfit bag...",
    ['noitem'] = "You don't have an outfit bag on you!",
    ['error'] = "ERROR",
}

Notify = function(title,desc,color) -- You may replace this notify function
    lib.notify({
        title = title,
        description = desc,
        position = 'top',
        style = {
            backgroundColor = '#1E1E2E',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'shirt',
        iconColor = color
    })
end