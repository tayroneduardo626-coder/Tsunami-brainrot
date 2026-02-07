-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- LocalScript
local script = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("TsunamiHub")

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character
local Mouse = Player:GetMouse()
local camera = workspace.CurrentCamera
local cash = 0
local brainrots = {}
local selectedRarity = "Common"
local godMode = false
local killAura = false
local autoFarm = false
local autoCollect = false
local autoEvolve = false
local lockyBlock = false
local evolutionOptions = {
    ["Common"] = {cost = 100, speed = 1},
    ["Uncommon"] = {cost = 500, speed = 2},
    ["Rare"] = {cost = 1000, speed = 3},
    ["Epic"] = {cost = 5000, speed = 4},
    ["Legendary"] = {cost = 10000, speed = 5}
}

-- GUI
local gui = script:WaitForChild("GUI")
local mainFrame = gui:WaitForChild("MainFrame")
local tabs = {}
local brainrotTab = gui:WaitForChild("BrainrotTab")
local evolutionTab = gui:WaitForChild("EvolutionTab")
local cashTab = gui:WaitForChild("CashTab")
local vipTab = gui:WaitForChild("VIPTab")
local settingsTab = gui:WaitForChild("SettingsTab")

-- Event handlers
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        if autoFarm then
            autoFarm = false
            gui:WaitForChild("AutoFarmButton").Text = "Auto Farm"
        else
            autoFarm = true
            gui:WaitForChild("AutoFarmButton").Text = "Stop Auto Farm"
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if autoCollect then
            autoCollect = false
            gui:WaitForChild("AutoCollectButton").Text = "Auto Collect"
        else
            autoCollect = true
            gui:WaitForChild("AutoCollectButton").Text = "Stop Auto Collect"
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        if autoEvolve then
            autoEvolve = false
            gui:WaitForChild("AutoEvolveButton").Text = "Auto Evolve"
        else
            autoEvolve = true
            gui:WaitForChild("AutoEvolveButton").Text = "Stop Auto Evolve"
        end
    end
end)

-- Functions
local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function tweenObject(obj, duration, properties)
    local tweenInfo = TweenInfo.new(duration)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
end

local function getBrainrotPosition()
    local brainrot = brainrots[1]
    local position = brainrot.Position
    position = Vector3.new(position.X, position.Y + 10, position.Z)
    return position
end

local function getBrainrot()
    local brainrot = brainrots[1]
    local position = brainrot.Position
    local distance = (position - camera.CFrame.Position).Magnitude
    if distance < 10 then
        tweentObject(brainrot, 0.5, {Position = getBrainrotPosition()})
        return brainrot
    end
end

local function collectCash()
    local cashAmount = 100
    cash = cash + cashAmount
    gui:WaitForChild("CashLabel").Text = "Cash: " .. cash
end

local function evolveBrainrot()
    local brainrot = brainrots[1]
    local evolutionOption = evolutionOptions[selectedRarity]
    if cash >= evolutionOption.cost then
        cash = cash - evolutionOption.cost
        gui:WaitForChild("CashLabel").Text = "Cash: " .. cash
        tweenObject(brainrot, 0.5, {Size = Vector3.new(brainrot.Size.X + 0.1, brainrot.Size.Y + 0.1, brainrot.Size.Z + 0.1)})
        gui:WaitForChild("EvolutionLabel").Text = "Evolved"
    end
end

local function lockyBlockBrainrot()
    local brainrot = brainrots[1]
    local position = brainrot.Position
    local distance = (position - camera.CFrame.Position).Magnitude
    if distance < 10 then
        tweenObject(brainrot, 0.5, {Position = getBrainrotPosition()})
        return brainrot
    end
end

-- ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local brainrotsFolder = ReplicatedStorage:WaitForChild("Brainrots")
for _, brainrot in pairs(brainrotsFolder:GetChildren()) do
    table.insert(brainrots, brainrot)
end

-- GUI functions
local function openBrainrotTab()
    brainrotTab.Visible = true
    evolutionTab.Visible = false
    cashTab.Visible = false
    vipTab.Visible = false
    settingsTab.Visible = false
end

local function openEvolutionTab()
    brainrotTab.Visible = false
    evolutionTab.Visible = true
    cashTab.Visible = false
    vipTab.Visible = false
    settingsTab.Visible = false
end

local function openCashTab()
    brainrotTab.Visible = false
    evolutionTab.Visible = false
    cashTab.Visible = true
    vipTab.Visible = false
    settingsTab.Visible = false
end

local function openVIPTab()
    brainrotTab.Visible = false
    evolutionTab.Visible = false
    cashTab.Visible = false
    vipTab.Visible = true
    settingsTab.Visible = false
end

local function openSettingsTab()
    brainrotTab.Visible = false
    evolutionTab.Visible = false
    cashTab.Visible = false
    vipTab.Visible = false
    settingsTab.Visible = true
end

gui:WaitForChild("BrainrotButton").MouseButton1Click:Connect(openBrainrotTab)
gui:WaitForChild("EvolutionButton").MouseButton1Click:Connect(openEvolutionTab)
gui:WaitForChild("CashButton").MouseButton1Click:Connect(openCashTab)
gui:WaitForChild("VIPButton").MouseButton1Click:Connect(openVIPTab)
gui:WaitForChild("SettingsButton").MouseButton1Click:Connect(openSettingsTab)

-- Settings
gui:WaitForChild("GodModeButton").MouseButton1Click:Connect(function()
    godMode = not godMode
    gui:WaitForChild("GodModeLabel").Text = "God Mode: " .. tostring(godMode)
end)

gui:WaitForChild("KillAuraButton").MouseButton1Click:Connect(function()
    killAura = not killAura
    gui:WaitForChild("KillAuraLabel").Text = "Kill Aura: " .. tostring(killAura)
end)

gui:WaitForChild("AutoFarmButton").MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    gui:WaitForChild("AutoFarmLabel").Text = "Auto Farm: " .. tostring(autoFarm)
end)

gui:WaitForChild("AutoCollectButton").MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    gui:WaitForChild("AutoCollectLabel").Text = "Auto Collect: " .. tostring(autoCollect)
end)

gui:WaitForChild("AutoEvolveButton").MouseButton1Click:Connect(function()
    autoEvolve = not autoEvolve
    gui:WaitForChild("AutoEvolveLabel").Text = "Auto Evolve: " .. tostring(autoEvolve)
end)

gui:WaitForChild("LockyBlockButton").MouseButton1Click:Connect(function()
    lockyBlock = not lockyBlock
    gui:WaitForChild("LockyBlockLabel").Text = "Locky Block: " .. tostring(lockyBlock)
end)

gui:WaitForChild("SelectedRarityButton").MouseButton1Click:Connect(function()
    gui:WaitForChild("SelectedRarityLabel").Text = "Selected Rarity: " .. selectedRarity
end)

gui:WaitForChild("CommonButton").MouseButton1Click:Connect(function()
    selectedRarity = "Common"
    gui:WaitForChild("SelectedRarityLabel").Text = "Selected Rarity: " .. selectedRarity
end)

gui:WaitForChild("UncommonButton").MouseButton1Click:Connect(function()
    selectedRarity = "Uncommon"
    gui:WaitForChild("SelectedRarityLabel").Text = "Selected Rarity: " .. selectedRarity
end)

gui:WaitForChild("RareButton").MouseButton1Click:Connect(function()
    selectedRarity = "Rare"
    gui:WaitForChild("SelectedRarityLabel").Text = "Selected Rarity: " .. selectedRarity
end)

gui:WaitForChild("EpicButton").MouseButton1Click:Connect(function()
    selected
