--[[
    ⚡ ABYSS FARMING HUB - FULLY CORRECTED
    Game: 127794225497302
]]

-- Game verification
if game.PlaceId ~= 127794225497302 then
    print("❌ Wrong game! This script only works on Abyss")
    return
end

-- Wait for game to load
repeat 
    task.wait(1) 
until game:IsLoaded() and game.Players.LocalPlayer
task.wait(3)

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Input = game:GetService("UserInputService")
local Virtual = game:GetService("VirtualInputManager")
local Core = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui") or Core

-- Clean up old GUI
pcall(function()
    local old = PlayerGui:FindFirstChild("AbyssHub")
    if old then old:Destroy() end
end)

-- ==================== GUI ====================
local Hub = Instance.new("ScreenGui")
Hub.Name = "AbyssHub"
Hub.ResetOnSpawn = false
Hub.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.Size = UDim2.new(0, 400, 0, 260)
Main.Active = true
Main.Draggable = true
Main.Parent = Hub

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "⚡ ABYSS FARM"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0.5, -15)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.Parent = TitleBar

Close.MouseButton1Click:Connect(function()
    Hub.Enabled = false
end)

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusBar.BorderSizePixel = 0
StatusBar.Size = UDim2.new(1, 0, 0, 30)
StatusBar.Position = UDim2.new(0, 0, 1, -30)
StatusBar.Parent = Main

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusText = Instance.new("TextLabel")
StatusText.BackgroundTransparency = 1
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Text = "● READY"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.TextSize = 12
StatusText.Font = Enum.Font.Gotham
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar

-- Buttons Container
local ButtonContainer = Instance.new("Frame")
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Size = UDim2.new(1, -20, 1, -100)
ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
ButtonContainer.Parent = Main

local ButtonList = Instance.new("UIListLayout")
ButtonList.Padding = UDim.new(0, 8)
ButtonList.FillDirection = Enum.FillDirection.Vertical
ButtonList.HorizontalAlignment = Enum.HorizontalAlignment.Left
ButtonList.VerticalAlignment = Enum.VerticalAlignment.Top
ButtonList.Parent = ButtonContainer

-- Toggles
local Toggles = {
    Fishing = false,
    Combat = false,
    Selling = false,
    AntiAFK = true
}

-- Button Factory
local function CreateToggleButton(name, varName, color)
    local btn = Instance.new("TextButton")
    btn.Name = varName .. "Btn"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Size = UDim2.new(0, 180, 0, 32)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ButtonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(1, -25, 0.5, -8)
    indicator.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 4)
    indCorner.Parent = indicator
    
    btn.MouseButton1Click:Connect(function()
        Toggles[varName] = not Toggles[varName]
        if Toggles[varName] then
            btn.BackgroundColor3 = color
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
    end)
end

CreateToggleButton("FISHING", "Fishing", Color3.fromRGB(0, 170, 255))
CreateToggleButton("COMBAT", "Combat", Color3.fromRGB(255, 70, 100))
CreateToggleButton("AUTO SELL", "Selling", Color3.fromRGB(100, 255, 100))
CreateToggleButton("ANTI AFK", "AntiAFK", Color3.fromRGB(255, 200, 0))

-- ==================== REMOTE SYSTEM ====================
local Remotes = {}
local FishingEvent = nil

-- Cache remotes
local function CacheRemotes()
    local common = Replicated:FindFirstChild("common")
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
end

CacheRemotes()

local function CallRemote(name, ...)
    local remote = Remotes[name]
    if remote then
        pcall(function()
            remote:InvokeServer(...)
        end)
    end
end

local function FireEvent(...)
    if FishingEvent then
        pcall(function()
            FishingEvent:FireServer(...)
        end)
    end
end

-- ==================== FARMING SYSTEMS ====================
local Systems = {
    Fishing = false,
    Combat = false,
    Selling = false,
    AFK = false
}

-- Fishing System
local function FishingLoop()
    Systems.Fishing = true
    local castCount = 0
    
    while Systems.Fishing and Toggles.Fishing do
        local camera = Workspace.CurrentCamera
        if camera then
            FireEvent("use", 
                camera.CFrame.Position + Vector3.new(0, -5, -15),
                camera.CFrame.LookVector
            )
        end
        
        task.wait(3)
        castCount = castCount + 1
        
        if castCount >= 2 then
            CallRemote("StartCatching", "05ff3e20e6304b01b922803875ef07d8")
            
            for i = 1, 3 do
                CallRemote("Update", "ProgressUpdate", {
                    progress = i / 3,
                    rewards = {}
                })
                task.wait(0.3)
            end
            
            castCount = 0
        end
    end
    Systems.Fishing = false
end

-- Combat System
local function CombatLoop()
    Systems.Combat = true
    
    while Systems.Combat and Toggles.Combat do
        local target = nil
        local character = Player.Character
        
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                local closestDist = 50
                
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") then
                        local hum = obj:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            local part = obj:FindFirstChild("HumanoidRootPart")
                            if part then
                                local dist = (part.Position - pos).Magnitude
                                if dist < closestDist then
                                    target = obj
                                    closestDist = dist
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
        
        task.wait(3)
    end
    Systems.Combat = false
end

-- Auto Sell System
local function SellLoop()
    Systems.Selling = true
    
    while Systems.Selling and Toggles.Selling do
        task.wait(60)
        CallRemote("SellInventory")
    end
    Systems.Selling = false
end

-- Anti AFK System
local function AntiAFKLoop()
    Systems.AFK = true
    
    while Systems.AFK and Toggles.AntiAFK do
        task.wait(60)
        Virtual:SendMouseMoveEvent(100, 100, true)
        task.wait(0.1)
        Virtual:SendMouseMoveEvent(200, 200, true)
    end
    Systems.AFK = false
end

-- ==================== MAIN CONTROLLER ====================
task.spawn(function()
    while true do
        task.wait(2)
        
        -- Update status
        local active = {}
        if Toggles.Fishing then table.insert(active, "F") end
        if Toggles.Combat then table.insert(active, "C") end
        if Toggles.Selling then table.insert(active, "S") end
        
        if #active > 0 then
            StatusText.Text = "● ACTIVE: " .. table.concat(active, " ")
            StatusText.TextColor3 = Color3.fromRGB(255, 255, 100)
        else
            StatusText.Text = "● READY"
            StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        -- Start/Stop systems
        if Toggles.Fishing and not Systems.Fishing then
            task.spawn(FishingLoop)
        elseif not Toggles.Fishing and Systems.Fishing then
            Systems.Fishing = false
        end
        
        if Toggles.Combat and not Systems.Combat then
            task.spawn(CombatLoop)
        elseif not Toggles.Combat and Systems.Combat then
            Systems.Combat = false
        end
        
        if Toggles.Selling and not Systems.Selling then
            task.spawn(SellLoop)
        elseif not Toggles.Selling and Systems.Selling then
            Systems.Selling = false
        end
        
        if Toggles.AntiAFK and not Systems.AFK then
            task.spawn(AntiAFKLoop)
        elseif not Toggles.AntiAFK and Systems.AFK then
            Systems.AFK = false
        end
    end
end)

-- Draggable Window
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Input.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
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

print("✅ Abyss Hub loaded successfully!")
print("🎮 Press RightShift to toggle GUI")
print("📡 Remotes found: " .. tostring(#Remotes))
print("🎣 Fishing event: " .. tostring(FishingEvent and "Found" or "Not Found"))
