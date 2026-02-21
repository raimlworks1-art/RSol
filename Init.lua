local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/raimlworks1-art/RSol/refs/heads/main/Library.lua"))()

local Packets = require(game:GetService("ReplicatedStorage"):WaitForChild("Packets"))

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local SelectedOx = ""
local SelectedFins = ""
local SelectedWeight = ""
local SelectedTreats = ""
local toEquipOx = ""
local SelectedRarity = ""
local AutoFarm = false
local AutoSell = false
local Delay = 0

local Areas = {
  Up = CFrame.new(-1937.941650390625, 2533.493408203125, -1414.9647216796875)
}

local Window = Library:Create({
    Title = "RSol",
    Subtitle = "Dive Down🤿 ",
    Config = {
        Loader = false
    }
})

local Main = Window:Tab("Main")
Main:Section("Farm") 

Main:Dropdown("Selected Rarity", {"None", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Divine"}, function(selected)
    SelectedRarity = selected
end)

Main:Toggle("Farm Selected Rarity", false, function(state)
    AutoFarm = state
end)

local Gears = Window:Tab("Gears")
Gears:Section("Gears")

Gears:Dropdown("Oxygen Tank", {"Starter Oxygen Tank", "Double Oxygen Tank", "Aqua Oxygen Tank", "Coral Oxygen Tank", "Seaweed Oxygen Tank", "Ore Oxygen Tank", "Beach Oxygen Tank", "Golden Oxygen Tank", "Candy Oxygen Tank", "Trench Oxygen Tank", "Atlantis Oxygen Tank"}, function(selected)
    SelectedOx = selected
end)

Gears:Button("Buy Oxygen Tank", function()
    workspace.Network:FindFirstChild("BuyGear-RemoteFunction"):InvokeServer("OxygenTank", SelectedOx)
end)

Gears:Dropdown("Fins", {"Starter Fins", "Aqua Oxygen Tank", "Coral Fins", "Seaweed Fins", "Ore Fins", "Beach Fins", "Golden Fins", "Candy Fins", "Trench Fins", "Atlantis Fins"}, function(selected)
    SelectedFins = selected
end)

Gears:Button("Buy Fins", function()
    workspace.Network:FindFirstChild("BuyGear-RemoteFunction"):InvokeServer("Fins", SelectedFins)
end)

Gears:Dropdown("Weight", {"Brick", "Dumbbell", "Plate", "Barbell", "Anvil", "Anchor", "Boulder", "Torpedo", "Trident"}, function(selected)
    SelectedWeight = selected
end)

Gears:Button("Buy Weights", function()
    workspace.Network:FindFirstChild("BuyGear-RemoteFunction"):InvokeServer("Weight", SelectedWeight)
end)

Gears:Section("Equip")

Gears:Dropdown("Oxygen Tank", {"Starter Oxygen Tank", "Double Oxygen Tank", "Aqua Oxygen Tank", "Coral Oxygen Tank", "Seaweed Oxygen Tank", "Ore Oxygen Tank", "Beach Oxygen Tank", "Golden Oxygen Tank", "Candy Oxygen Tank", "Trench Oxygen Tank", "Atlantis Oxygen Tank"}, function(selected)
    toEquipOx = selected
end)

Gears:Button("Equip Selected Tank", function()
    workspace.Network:FindFirstChild("EquipGear-RemoteFunction"):InvokeServer("OxygenTank", toEquipOx)
end)

local TS = Window:Tab("Treats & Sell")

TS:Section("Treats")

TS:Dropdown("Treats", {"Worm", "Cockroach", "Snail"}, function(selected) -- ill add 3 for now
    SelectedTreats = selected
end)

TS:Button("Buy Selected Treat", function()
    Packets.BuyItem:Fire("Treats", SelectedTreats)
end)

TS:Section("Sell")

TS:Input("Sell Delay", "You already Know", function(text)
    local D = tonumber(text)
    if D then
        Delay = D
    end
end)

TS:Toggle("Auto Sell Inventory", false, function(state)
    AutoSell = state
end)

TS:Button("Sell Inventory", function()
    Packets.SellInventory:Fire()
end)

TS:Button("Sell Holding", function()
    Packets.SellItem:Fire()
end)


task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarm then
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(workspace.Game.Fishes:GetChildren()) do
                    if not AutoFarm then break end
                    local gui = v:FindFirstChildWhichIsA("BillboardGui", true)
                    if gui and gui:FindFirstChild("Frame") and gui.Frame:FindFirstChild("Rarity") then
                        if gui.Frame.Rarity.Text == SelectedRarity then
                            local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                root.CFrame = v:GetPivot()
                                task.wait(0.2)
                                fireproximityprompt(prompt)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function() 
    while true do
    	task.wait(Delay)
    	if AutoSell then
    		
    		Packets.SellInventory:Fire()
       end
    end
end)

task.spawn(function()
    while true do 
        task.wait(0.5) 
        if AutoFarm then
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local gui = LP.PlayerGui:FindFirstChild("PersistentUI")
            
            if root and gui then
                local oxyPath = gui.OxygenBar.OxygenBar.Amount
                local oxyPercent = tonumber(oxyPath.Text:match("%d+")) 

                if oxyPercent and oxyPercent <= 20 then
                    local oldPos = root.CFrame
                    root.CFrame = Areas.Up
                    
                    repeat 
                        task.wait(0.5)
                        oxyPercent = tonumber(oxyPath.Text:match("%d+"))
                    until oxyPercent >= 95 or not AutoFarm
                    
                    root.CFrame = oldPos
                end
            end
        end
    end
end)
