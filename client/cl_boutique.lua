ESX = nil

local isMenuOpened = false
local ancienne = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

RMenu.Add("boutique", "menu", RageUI.CreateMenu("Boutique", "~b~Actions :", nil, nil, "aLib", "black"))
RMenu:Get("boutique", "menu").Closed = function()
	isMenuOpened = false
end

RMenu.Add("boutique", "voiture", RageUI.CreateSubMenu(RMenu:Get("boutique", "menu"), "Boutique", "~b~Voiture :"))
RMenu:Get("boutique", "voiture").Closed = function()end

RMenu.Add("boutique", "infovoiture", RageUI.CreateSubMenu(RMenu:Get("boutique", "voiture"), "Boutique", "~b~Voiture :"))
RMenu:Get("boutique", "infovoiture").Closed = function()end

RMenu.Add("boutique", "armes", RageUI.CreateSubMenu(RMenu:Get("boutique", "menu"), "Boutique", "~b~Armes :"))
RMenu:Get("boutique", "armes").Closed = function()end

RMenu.Add("boutique", "infoarmes", RageUI.CreateSubMenu(RMenu:Get("boutique", "armes"), "Boutique", "~b~Armes :"))
RMenu:Get("boutique", "infoarmes").Closed = function()end

RMenu.Add("boutique", "argent", RageUI.CreateSubMenu(RMenu:Get("boutique", "menu"), "Boutique", "~b~Argent :"))
RMenu:Get("boutique", "argent").Closed = function()end

RMenu.Add("boutique", "infoargent", RageUI.CreateSubMenu(RMenu:Get("boutique", "argent"), "Boutique", "~b~Argent :"))
RMenu:Get("boutique", "infoargent").Closed = function()end

local function openMenu(coin)

    if isMenuOpened then return end
    isMenuOpened = true

	RageUI.Visible(RMenu:Get("boutique","menu"), true)

	Citizen.CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(RMenu:Get("boutique","menu"),true,true,true,function()
                RageUI.Separator("~r~→~s~ ID : ~b~"..GetPlayerServerId(PlayerId()).."~s~ ~r~←~s~")
                RageUI.Separator('~r~→~s~ '..Configboutique.coinname..' : ~b~'..ESX.Math.GroupDigits(coin)..'~s~ ~r~←~s~')
                RageUI.ButtonWithStyle("Voitures", nil, {RightLabel = "→→→"}, true,function(a,h,s)
                end, RMenu:Get("boutique", "voiture"))
                RageUI.ButtonWithStyle("Armes", nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                end, RMenu:Get("boutique", "armes"))
                RageUI.ButtonWithStyle("Argent", nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                end, RMenu:Get("boutique", "argent"))
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("boutique","voiture"),true,true,true,function()
                RageUI.Separator("~r~↓~s~ Voitures ~b~disponibles ~r~↓~s~")
                for k, v in pairs(Configboutique.voiture) do
                    RageUI.ButtonWithStyle(v.titre, nil, {RightLabel = "~r~"..v.point.." "..Configboutique.coinname}, true,function(a,h,s)
                        if s then
                            selected = k
                        end 
                    end, RMenu:Get("boutique", "infovoiture"))
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("boutique","infovoiture"),true,true,true,function()
                local price = Configboutique.voiture[selected].point
                if bol then price = price + Configboutique.fullcustomprix end
                RageUI.Separator("~r~→~s~ Voiture : ~b~"..Configboutique.voiture[selected].titre.."~s~ ~r~←~s~")
                RageUI.Separator("~r~→~s~ "..Configboutique.coinname.." : ~b~"..price.."~s~ ~r~←~s~")
                RageUI.Separator("~r~→~s~ Nombre de places : ~b~"..Configboutique.voiture[selected].place.."~s~ ~r~←~s~")
                RageUI.ButtonWithStyle("Tester ~b~"..Configboutique.voiture[selected].titre, nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                    if s then
                        ancienne = GetEntityCoords(PlayerPedId())
                        testvoiture(Configboutique.voiture[selected].model)
                    end
                end)
                RageUI.Checkbox("Acheter avec le ~b~Full Custom~s~ (+"..Configboutique.fullcustomprix..")", nil, bol, { Style = RageUI.CheckboxStyle.Tick }, function(h, s, a, c)
                    bol = c;
                end, function()
                end, function()
                end)
                RageUI.ButtonWithStyle("Acheter ~b~"..Configboutique.voiture[selected].titre, nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                    if s then
                        if coin >= price then
                            TriggerServerEvent("aScript:moindecoin", coin, price)
                            givecarboutique(Configboutique.voiture[selected].model, coin, price)
                            RageUI.CloseAll()
                            isMenuOpened = false
                        else
                            ESX.ShowNotification("~r~Problème~s~ : Vous n'avez pas les ~r~"..Configboutique.coinname.."~s~ nécessaire !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Annuler", nil, {}, true,function(a,h,s) 
                    if s then
                        RageUI.GoBack()
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("boutique","armes"),true,true,true,function()
                RageUI.Separator("~r~↓~s~ Armes ~b~disponibles ~r~↓~s~")
                for k, v in pairs(Configboutique.armes) do
                    RageUI.ButtonWithStyle(v.titre, nil, {RightLabel = "~r~"..v.point.." "..Configboutique.coinname}, true,function(a,h,s)
                        if s then
                            selectedWeapon = k
                        end 
                    end, RMenu:Get("boutique", "infoarmes"))
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("boutique","argent"),true,true,true,function()
                RageUI.Separator("~r~↓~s~ Argent ~b~disponibles ~r~↓~s~")
                for k, v in pairs(Configboutique.argent) do
                    RageUI.ButtonWithStyle(v.titre, nil, {RightLabel = "~r~"..v.point.." "..Configboutique.coinname}, true,function(a,h,s) 
                        if s then
                            selectedThune = k
                        end
                    end, RMenu:Get("boutique", "infoargent"))
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("boutique","infoarmes"),true,true,true,function()
                local price = Configboutique.armes[selectedWeapon].point
                RageUI.Separator("~r~→~s~ Arme : ~b~"..Configboutique.armes[selectedWeapon].titre.."~s~ ~r~←~s~")
                RageUI.Separator("~r~→~s~ "..Configboutique.coinname.." : ~b~"..price.."~s~ ~r~←~s~")
                RageUI.ButtonWithStyle("Tester ~b~"..Configboutique.armes[selectedWeapon].titre, nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                    if s then
                        ancienne = GetEntityCoords(PlayerPedId())
                        testarme(Configboutique.armes[selectedWeapon].model)
                    end
                end)
                RageUI.ButtonWithStyle("Acheter ~b~"..Configboutique.armes[selectedWeapon].titre, nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                    if s then
                        if coin >= price then
                            TriggerServerEvent("aScript:moindecoin", coin, price)
                            TriggerServerEvent("aScript:arme", "achat", Configboutique.armes[selectedWeapon].model)
                            RageUI.CloseAll()
                            isMenuOpened = false                        
                        else
                            ESX.ShowNotification("~r~Problème~s~ : Vous n'avez pas les ~r~"..Configboutique.coinname.."~s~ nécessaire !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Annuler", nil, {}, true,function(a,h,s) 
                    if s then
                        RageUI.GoBack()
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("boutique","infoargent"),true,true,true,function()
                local price = Configboutique.argent[selectedThune].point
                RageUI.Separator("~r~→~s~ Argent : ~b~"..Configboutique.argent[selectedThune].titre.."~s~ ~r~←~s~")
                RageUI.Separator("~r~→~s~ "..Configboutique.coinname.." : ~b~"..price.."~s~ ~r~←~s~")
                RageUI.ButtonWithStyle("Acheter ~b~"..Configboutique.argent[selectedThune].titre, nil, {RightLabel = "→→→"}, true,function(a,h,s) 
                    if s then
                        if coin >= price then
                            TriggerServerEvent("aScript:achatargent", Configboutique.argent[selectedThune].money)
                            ESX.ShowNotification("Achat de ~b~"..Configboutique.argent[selectedThune].titre.."~s~ ~g~éffectue~s~ !")
                            TriggerServerEvent("aScript:moindecoin", coin, price)
                            RageUI.CloseAll()
                            isMenuOpened = false  
                        else
                            ESX.ShowNotification("~r~Problème~s~ : Vous n'avez pas les ~r~"..Configboutique.coinname.."~s~ nécessaire !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Annuler", nil, {}, true,function(a,h,s) 
                    if s then
                        RageUI.GoBack()
                    end
                end)
            end, function()end, 1)
            Wait(0)
        end
    end)
end

RegisterCommand('boutique', function()
    ESX.TriggerServerCallback("aBoutique:verifcoin", function(coin)
        coin = coin
        openMenu(coin)
    end)
end, false)

RegisterKeyMapping('boutique', 'Boutique', 'keyboard', 'F2')

-- function
function testvoiture(voiture)
    local model = GetHashKey(voiture)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    local vehicle = CreateVehicle(model, Configboutique.testvoiture.x, Configboutique.testvoiture.y, Configboutique.testvoiture.z, 90.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true) 
    SetVehicleDoorsLocked(vehicle, 4)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    local temps = Configboutique.tempsessai/1000
    ESX.ShowNotification("Vous avez ~g~"..temps.." secondes~s~ pour tester le véhicule !")
    Wait(Configboutique.tempsessai)
    ESX.ShowNotification("Votre essai est ~r~terminé~s~ !")
    DeleteEntity(vehicle)
    SetEntityCoords(PlayerPedId(), ancienne, false, false, false, false)
end

function testarme(arme)
    local temps = Configboutique.tempsessai/1000
    SetEntityCoords(PlayerPedId(), Configboutique.testarme.x, Configboutique.testarme.y, Configboutique.testarme.z, false, false, false, false)
    TriggerServerEvent("aScript:arme", "test", arme)
    ESX.ShowNotification("Vous avez ~g~"..temps.." secondes~s~ pour tester l'arme !")
    SetEntityAsMissionEntity(PlayerPedId(), true, true)
    Wait(Configboutique.tempsessai)
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(arme))
    ESX.ShowNotification("Votre essai est ~r~terminé~s~ !")
    SetEntityAsMissionEntity(PlayerPedId(), false, false)
    SetEntityCoords(PlayerPedId(), ancienne, false, false, false, false)
end

function FullVehicleBoost(vehicle)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 14, 0, true)
	ToggleVehicleMod(vehicle, 18, true)
	ToggleVehicleMod(vehicle, 22, true)
	SetPlayersLastVehicle(vehicle)
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleTyresCanBurst(vehicle, false)
	SetVehicleCanBeTargetted(vehicle, false)
	SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
	SetVehicleHasStrongAxles(vehicle, true)
	SetVehicleDirtLevel(vehicle, 0)
	SetVehicleCanBeVisiblyDamaged(vehicle, false)
	IsVehicleDriveable(vehicle, true)
	SetVehicleEngineOn(vehicle, true, true)
	SetVehicleStrong(vehicle, true)
	SetPedCanBeDraggedOut(PlayerPedId(), false)
	SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
	SetPedRagdollOnCollision(PlayerPedId(), false)
	ResetPedVisibleDamage(PlayerPedId())
	ClearPedDecorations(PlayerPedId())
	SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
end

local voituregive = {}
function givecarboutique(veh, coin, price)
	ESX.ShowNotification("Votre voiture vous a était ~g~livrée~s~ !")
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    Citizen.Wait(10)
    ESX.Game.SpawnVehicle(veh, {x = plyCoords.x+2 ,y = plyCoords.y, z = plyCoords.z+2}, 313.4216, function (vehicle)
        if bol then FullVehicleBoost(vehicle) end
		local plate = exports.esx_vehicleshop:GeneratePlate()
		table.insert(voituregive, vehicle)		
		local vehicleProps = ESX.Game.GetVehicleProperties(voituregive[#voituregive])
		vehicleProps.plate = plate
		SetVehicleNumberPlateText(voituregive[#voituregive] , plate)
		TriggerServerEvent('aBoutique:achateffectue', vehicleProps, plate, coin, price)
        RageUI.CloseAll()
        isMenuOpened = false
	end)
end 
