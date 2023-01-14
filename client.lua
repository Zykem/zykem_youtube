ESX = nil
CreateThread(function() 
    if cfg.useFramework then
        
        while ESX == nil do
            TriggerEvent('esx:init', function(obj)
                print('esx event')
                ESX = obj
            end)
            Citizen.Wait(250)
        end
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(100)
        end
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(2500)
    end
end)
RegisterCommand('youtube', function(source,args,raw)

    if cfg.useFramework then
        elements = {}
    table.insert(elements, {label = cfg.locales[cfg.lang].menuELEMENT, value = 'instructions'})
    table.insert(elements, {label = cfg.locales[cfg.lang].menuELEMENT2, value = 'redeem'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'youtubeapimenu',
		{
			title    = cfg.locales[cfg.lang].menuTITLE,
			align    = 'center',
			elements = elements
		}, function(data, menu)			
			if(data.current.value == 'instructions') then
                print('elosek :)')
				notify(cfg.locales[cfg.lang].instructions)
			end
			if (data.current.value == 'redeem') then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'youtubeapi', {
                    title = "Youtube Link"
                }, function(data3, menu3)
                    ESX.UI.Menu.CloseAll()
                    if data3.value == nil then return end;
                        ESX.TriggerServerCallback('zykem_youtube:redeemRank', function(cb)
                    
                        
                    
                        end, data3.value)
                end, function(data3, menu3)
                    menu2.close()
                end)
			end
		end, function(data, menu)
			menu.close()
		end)
    else
        if args[1] == nil then notify('Argument has to be a youtube Video!') return end;
            TriggerServerEvent('zykem_youtube:redeemRank', args[1])
    end

end,false)

function notify(msg)
    if cfg.useFramework then
        ESX.ShowNotification(msg)
    else
        -- your own notify
    end
end
