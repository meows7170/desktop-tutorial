--[[
    ⚡ ABYSS FARMING HUB - COMPLETE
    Game: 127794225497302
]]

-- Game verification
if game.PlaceId ~= 127794225497302 then
    print("❌ Wrong game! This script only works on Abyss")
    return
end

-- Wait for game to load
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
wait(3)

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Input = game:GetService("UserInputService")
local Virtual = game:GetService("VirtualInputManager")
local Core = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui") or Core

-- Clean up
pcall(function() PlayerGui:FindFirstChild("AbyssHub"):Destroy() end)

-- ==================== GUI ====================
local Hub = Instance.new("ScreenGui")
Hub.Name = "AbyssHub"
Hub.ResetOnSpawn = false
Hub.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.Size = UDim2.new(0, 400, 0, 250)
Main.Active = true
Main.Draggable = true
Main.Parent = Hub

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "ABYSS FARM"
Title.TextColor3 = Color3.new(0, 0.67, 1)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0.3, 0.3)
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
Close.MouseButton1Click:Connect(function() Hub.Enabled = false end)

local Status = Instance.new("TextLabel")
Status.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
Status.Size = UDim2.new(1, -10, 0, 25)
Status.Position = UDim2.new(0, 5, 1, -30)
Status.Text = "READY"
Status.TextColor3 = Color3.new(0.4, 1, 0.4)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.Parent = Main

Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 4)

-- Toggles
local Toggles = { Fishing = false, Combat = false, Selling = false, AntiAFK = true }
local Buttons = {}

local function CreateButton(text, yPos, varName)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        Toggles[varName] = not Toggles[varName]
        btn.BackgroundColor3 = Toggles[varName] and Color3.new(0, 0.67, 1) or Color3.new(0.15, 0.15, 0.15)
        btn.TextColor3 = Toggles[varName] and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
    end)
    Buttons[varName] = btn
end

CreateButton("FISHING", 40, "Fishing")
CreateButton("COMBAT", 75, "Combat")
CreateButton("AUTO SELL", 110, "Selling")
CreateButton("ANTI AFK", 145, "AntiAFK")

-- ==================== REMOTE SYSTEM ====================
local Remotes = {}
local FishingEvent = nil

local function FindRemote(path)
    local obj = Replicated
    for _, part in ipairs(path) do
        obj = obj:FindFirstChild(part)
        if not obj then return nil end
    end
    return obj
end

-- Cache remotes
local common = FindRemote({"common"})
if common then
    local packages = common:FindFirstChild("packages")
    if packages then
        local knit = packages:FindFirstChild("Knit")
        if knit then
            local services = knit:FindFirstChild("Services")
            if services then
                for _, service in ipairs(services:GetChildren()) do
                    local rf = service:FindFirstChild("RF")
                    if rf then
                        for _, remote in ipairs(rf:GetChildren()) do
                            if remote:IsA("RemoteFunction") then
                                Remotes[remote.Name] = remote
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Get fishing event
if type(getnilinstances) == "function" then
    for _, v in ipairs(getnilinstances()) do
        if v:IsA("RemoteEvent") and v.Name == "RemoteEvent" then
            FishingEvent = v
            break
        end
    end
end

local function CallRemote(name, ...)
    local remote = Remotes[name]
    if remote then
        pcall(function() remote:InvokeServer(...) end)
    end
end

-- ==================== FARMING SYSTEMS ====================
local FishingActive = false
local CombatActive = false
local SellActive = false
local AFKActive = false

-- Fishing loop
local function StartFishing()
    if FishingActive then return end
    FishingActive = true
    local castCount = 0
    
    while FishingActive and Toggles.Fishing do
        if FishingEvent then
            local cam = Workspace.CurrentCamera
            if cam then
                pcall(function()
                    FishingEvent:FireServer("use", 
                        cam.CFrame.Position + Vector3.new(0, -5, -15),
                        cam.CFrame.LookVector
                    )
                end)
            end
        end
        
        wait(3)
        castCount = castCount + 1
        
        if castCount >= 2 then
            CallRemote("StartCatching", "05ff3e20e6304b01b922803875ef07d8")
            for i = 1, 3 do
                CallRemote("Update", "ProgressUpdate", { progress = i/3, rewards = {} })
                wait(0.3)
            end
            castCount = 0
        end
    end
    FishingActive = false
end

-- Combat loop
local function StartCombat()
    if CombatActive then return end
    CombatActive = true
    
    while CombatActive and Toggles.Combat do
        local target = nil
        local char = Player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                local closest = 999
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") then
                        local hum = obj:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            local part = obj:FindFirstChild("HumanoidRootPart")
                            if part then
                                local dist = (part.Position - pos).Magnitude
                                if dist < 50 and dist < closest then
                                    target = obj
                                    closest = dist
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if target then
            CallRemote("Harpoon", target)
        end
        wait(3)
    end
    CombatActive = false
end

-- Auto sell
local function StartSelling()
    if SellActive then return end
    SellActive = true
    while SellActive and Toggles.Selling do
        wait(60)
        CallRemote("SellInventory")
    end
    SellActive = false
end

-- Anti AFK
local function StartAntiAFK()
    if AFKActive then return end
    AFKActive = true
    while AFKActive and Toggles.AntiAFK do
        wait(60)
        Virtual:SendMouseMoveEvent(100, 100, true)
        wait(0.1)
        Virtual:SendMouseMoveEvent(200, 200, true)
    end
    AFKActive = false
end

-- Main controller
spawn(function()
    while true do
        wait(2)
        
        -- Update status
        local active = {}
        if Toggles.Fishing then table.insert(active, "F") end
        if Toggles.Combat then table.insert(active, "C") end
        if Toggles.Selling then table.insert(active, "S") end
        
        if #active > 0 then
            Status.Text = "ACTIVE: " .. table.concat(active, " ")
            Status.TextColor3 = Color3.new(1, 1, 0.4)
        else
            Status.Text = "READY"
            Status.TextColor3 = Color3.new(0.4, 1, 0.4)
        end
        
        -- Start systems
        if Toggles.Fishing and not FishingActive then
            spawn(StartFishing)
        end
        if Toggles.Combat and not CombatActive then
            spawn(StartCombat)
        end
        if Toggles.Selling and not SellActive then
            spawn(StartSelling)
        end
        if Toggles.AntiAFK and not AFKActive then
            spawn(StartAntiAFK)
        end
    end
end)

-- Toggle GUI
Input.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        Hub.Enabled = not Hub.Enabled
    end
end)

-- Cleanup
Player.AncestryChanged:Connect(function()
    if not Player.Parent then
        Hub:Destroy()
        Remotes = {}
        FishingEvent = nil
    end
end)

print("✅ Abyss Hub fully loaded!")
print("Press RightShift to toggle GUI")
