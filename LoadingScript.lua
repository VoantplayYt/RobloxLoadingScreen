local Start = tick()

-- Grabs The Services That Are In A Module Script
local Services = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Services"))

-- Some References
local PlrGui = game:GetService("Players").LocalPlayer.PlayerGui
local Update = Services.RS:WaitForChild("Remotes"):WaitForChild("UpdateLoadingStatus")
local LoadingScreen = script:WaitForChild("LoadingScreen")

LoadingScreen.Parent = PlrGui
Services.RF:RemoveDefaultLoadingScreen()

local coreCall do
	local MAX_RETRIES = 8

	function coreCall(method, ...)
		local result = {}
		for retries = 1, MAX_RETRIES do
			result = {pcall(Services.SG[method], Services.SG, ...)}
			if result[1] then
				break
			end
			Services.RUN.Stepped:Wait()
		end
		return unpack(result)
	end
end

-- Waits Till The Core Is Loaded To Disable ResetButton
repeat
	wait()
until coreCall("SetCore", "ResetButtonCallback", false)
coreCall("SetCoreGuiEnabled", Enum.CoreGuiType.All, false)

local TextStatus = LoadingScreen.Frame.Status

local Info = TweenInfo.new(
	1,
	Enum.EasingStyle.Linear
)

-- Updates The Status Text
local UpdateStatus
UpdateStatus = Update.OnClientEvent:Connect(function(status, done)
	if not done then
		TextStatus.Text = status
	else
		UpdateStatus:Disconnect()
		UpdateStatus = nil
	end
end)

-- Changes The Transparency Of The Loading Screen
local TransparencyAffected = {}
for _, element in pairs(LoadingScreen:GetDescendants()) do
	if element:IsA("Frame") or element:IsA("TextLabel") then
		table.insert(TransparencyAffected, element)
	end
end

repeat wait() until not UpdateStatus or tick() - Start >= 5
wait()

-- Wait for the game to fully load
if not game:IsLoaded() then
	TextStatus.Text = "Loading assets..."
	repeat wait() until game:IsLoaded()
end

TextStatus.Text = "Done!"

wait(1.5)

local Tweens = {}

for _, element in pairs(TransparencyAffected) do
	local change
	if element:IsA("Frame") then
		change = {Transparency = 1}
	else
		if element.Name ~= "Dot" then
			change = {TextTransparency = 1}
		else
			change = {BackgroundTransparency = 1}
		end
	end
	local Tween = Services.TS:Create(element, Info, change)
	table.insert(Tweens, Tween)
end

for _, tween in pairs(Tweens) do
	tween:Play()
end

-- After Everything Is Loaded It Destroys The Loading Screen And Script For Optimizations
wait(1)
LoadingScreen:Destroy()
print("Finished loading in " .. tick() - Start .. " seconds")
script:Destroy()
