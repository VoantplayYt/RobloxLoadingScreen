local function Service(str)
	return game:GetService(str)
end

local Services = {
	
	["RUN"] = Service("RunService");
	["RS"] = Service("ReplicatedStorage");
	["RF"] = Service("ReplicatedFirst");
	["SS"] = Service("ServerStorage");
	["SG"] = Service("StarterGui");
	["SP"] = Service("StarterPlayer");
	["SSS"] = Service("ServerScriptService");
	["Debris"] = Service("Debris");
	["Sound"] = Service("SoundService");
	["LS"] = Service("LocalizationService");
	["Lighting"] = Service("Lighting");
	["Players"] = Service("Players");
	["TS"] = Service("TweenService");
	
}

return Services
