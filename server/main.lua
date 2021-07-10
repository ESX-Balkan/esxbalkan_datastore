
datastore = { 
    "policija", 
	
}



podaci = {}
local ocitano = ""

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then




	ocitano = LoadResourceFile(GetCurrentResourceName(), "podaci.json") or ""
			if ocitano ~= "" then
		podaci = json.decode(ocitano)
		else
		podaci = {}
		end

		for k,v in pairs(datastore) do
			if not podaci[v] then
			podaci[v] = {}
			end
		end


	end
end)




RegisterServerEvent('esxbalkan_datastore:updateprivatnisef')
AddEventHandler('esxbalkan_datastore:updateprivatnisef', function(ime,hex,tabela)
	podaci[hex][ime] = tabela
end)

RegisterServerEvent('esxbalkan_datastore:fetchajprivatnisef')
AddEventHandler('esxbalkan_datastore:fetchajprivatnisef', function(ime,hex,cb)
cb(podaci[hex][ime] or {})
end)



RegisterServerEvent('esxbalkan_datastore:stavioruzije')
AddEventHandler('esxbalkan_datastore:stavioruzije', function(oruzije,municija,organizacija)
	if type(podaci[organizacija][oruzije]) ~= 'table' then
		podaci[organizacija][oruzije] = {}
	end
if #podaci[organizacija][oruzije] > 0 then
	for k,v in pairs(podaci[organizacija][oruzije]) do
	v.kolicina = v.kolicina + 1
	v.municija = v.municija + municija
	break
	end
else
table.insert(podaci[organizacija][oruzije], {
					oruzije = oruzije,
					municija = municija,
					kolicina = 1
})
end
end)
RegisterServerEvent('esxbalkan_datastore:izvadioruzije')
AddEventHandler('esxbalkan_datastore:izvadioruzije', function(oruzije,municija,organizacija)
for k,v in pairs(podaci[organizacija][oruzije]) do

if (v.kolicina - 1) > 0 then
	v.kolicina = v.kolicina -1
	v.municija = v.municija - municija
else
	podaci[organizacija][oruzije] = nil
end

end
end)

RegisterServerEvent('esxbalkan_datastore:fetchajsef')
AddEventHandler('esxbalkan_datastore:fetchajsef', function(organizacija,cb)

cb(podaci[organizacija])
end)




AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	for k,v in pairs(datastore) do
		if not podaci[xPlayer.identifier] then
		podaci[xPlayer.identifier] = {}
		if not podaci[xPlayer.identifier][v] then
podaci[xPlayer.identifier][v] = {}
			end
		end
	end
end)



RegisterNetEvent('esxbalkan_datastore:sacuvaj')
AddEventHandler('esxbalkan_datastore:sacuvaj', function()
	SaveResourceFile(GetCurrentResourceName(), "podaci.json", json.encode(podaci), -1)
end)
