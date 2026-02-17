--[[
    ABYSS HUB - WORKING COMBAT & FISHING
]]

-- Game verification
if game.PlaceId ~= 127794225497302 then
    return
end

-- Wait for game
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
task.wait(2)

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Input = game:GetService("UserInputService")
local Virtual = game:GetService("VirtualInputManager")
local Core = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui") or Core

-- Clean up
pcall(function()
    local old = PlayerGui:FindFirstChild("AbyssHub")
    if old then old:Destroy() end
end)

-- ==================== REMOTE CACHE ====================
local Remotes = {}
local FishingEvent = nil

local function FindRemotes()
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
    
    if type(getnilinstances) == "function" then
        for _, v in ipairs(getnilinstances()) do
            if v:IsA("RemoteEvent") and v.Name == "RemoteEvent" then
                FishingEvent = v
                break
            end
        end
    end
end

FindRemotes()

-- ==================== COMBAT SYSTEM WITH COOLDOWN BYPASS ====================
local CombatActive = false
local CombatLoopRunning = false

local function StartCombat()
    if CombatActive then return end
    CombatActive = true
    
    task.spawn(function()
        CombatLoopRunning = true
        while CombatActive do
            -- Find nearest target
            local target = nil
            local character = Player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    local pos = root.Position
                    local closestDist = 100
                    
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
            
            -- Attack target repeatedly to bypass cooldown
            if target then
                local harpoonRemote = Remotes["Harpoon"]
                if harpoonRemote then
                    -- Fire multiple times rapidly to bypass cooldown
                    for i = 1, 5 do
                        pcall(function()
                            harpoonRemote:InvokeServer(target)
                        end)
                        task.wait(0.05) -- 50ms between attacks
                    end
                end
            end
            
            task.wait(0.5) -- Short wait between attack cycles
        end
        CombatLoopRunning = false
    end)
end

local function StopCombat()
    CombatActive = false
end

-- ==================== FISHING SYSTEM WITH AUTO MINIGAME ====================
local FishingActive = false
local FishingLoopRunning = false

local function StartFishing()
    if FishingActive then return end
    FishingActive = true
    
    task.spawn(function()
        FishingLoopRunning = true
        local castCount = 0
        
        while FishingActive do
            -- Cast line
            if FishingEvent then
                local camera = Workspace.CurrentCamera
                if camera then
                    pcall(function()
                        FishingEvent:FireServer(
                            "use",
                            camera.CFrame.Position + Vector3.new(0, -5, -15),
                            camera.CFrame.LookVector
                        )
                    end)
                end
            end
            
            task.wait(2)
            castCount = castCount + 1
            
            -- Start catching after 2 casts
            if castCount >= 2 then
                local startCatching = Remotes["StartCatching"]
                if startCatching then
                    pcall(function()
                        startCatching:InvokeServer("05ff3e20e6304b01b922803875ef07d8")
                    end)
                end
                
                -- AUTO MINIGAME - Fills bar to 100%
                local updateRemote = Remotes["Update"]
                if updateRemote then
                    -- Smooth progression to fill the bar
                    for progress = 0.1, 1.0, 0.1 do
                        if not FishingActive then break end
                        pcall(function()
                            updateRemote:InvokeServer("ProgressUpdate", {
                                progress = progress,
                                rewards = {}
                            })
                        end)
                        task.wait(0.2) -- Smooth animation
                    end
                    
                    -- Final push to 100%
                    pcall(function()
                        updateRemote:InvokeServer("ProgressUpdate", {
                            progress = 1.0,
                            rewards = {}
                        })
                    end)
                end
                
                castCount = 0
            end
        end
        FishingLoopRunning = false
    end)
end

local function StopFishing()
    FishingActive = false
end

-- ==================== AUTO SELL SYSTEM ====================
local SellActive = false

local function StartSelling()
    if SellActive then return end
    SellActive = true
    
    task.spawn(function()
        while SellActive do
            task.wait(60) -- Sell every minute
            local sellRemote = Remotes["SellInventory"]
            if sellRemote then
                pcall(function()
                    sellRemote:InvokeServer()
                end)
            end
        end
    end)
end

local function StopSelling()
    SellActive = false
end

-- ==================== GUI ====================
local Hub = Instance.new("ScreenGui")
Hub.Name = "AbyssHub"
Hub.ResetOnSpawn = false
Hub.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.Size = UDim2.new(0, 400, 0, 280)
Main.Active = true
Main.Draggable = true
Main.Parent = Hub

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
Title.Text = "⚡ ABYSS HUB"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0.5, -15)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.Parent = TitleBar

Close.MouseButton1Click:Connect(function()
    Hub.Enabled = false
end)

-- Status Bar
local Status = Instance.new("Frame")
Status.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Status.BorderSizePixel = 0
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 1, -40)
Status.Parent = Main

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = Status

local StatusText = Instance.new("TextLabel")
StatusText.BackgroundTransparency = 1
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Text = "● READY"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.TextSize = 14
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = Status

-- Button Container
local ButtonFrame = Instance.new("Frame")
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Size = UDim2.new(1, -20, 1, -100)
ButtonFrame.Position = UDim2.new(0, 10, 0, 45)
ButtonFrame.Parent = Main

-- Button Factory
local function CreateButton(name, yPos, color)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ButtonFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

local fishBtn = CreateButton("FISHING", 0)
local combatBtn = CreateButton("COMBAT", 45)
local sellBtn = CreateButton("AUTO SELL", 90)

-- Button click handlers
fishBtn.MouseButton1Click:Connect(function()
    if FishingActive then
        StopFishing()
        fishBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        fishBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusText.Text = "● READY"
        StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StartFishing()
        fishBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusText.Text = "🎣 FISHING ACTIVE"
        StatusText.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end)

combatBtn.MouseButton1Click:Connect(function()
    if CombatActive then
        StopCombat()
        combatBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        combatBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusText.Text = "● READY"
        StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StartCombat()
        combatBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
        combatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusText.Text = "⚔️ COMBAT ACTIVE"
        StatusText.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
end)

sellBtn.MouseButton1Click:Connect(function()
    if SellActive then
        StopSelling()
        sellBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sellBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusText.Text = "● READY"
        StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StartSelling()
        sellBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        sellBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        StatusText.Text = "💰 SELL ACTIVE"
        StatusText.TextColor3 = Color3.fromRGB(255, 255, 100)
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
        StopFishing()
        StopCombat()
        StopSelling()
    end
end)

print("✅ Abyss Hub - Fixed Combat & Fishing")
print("🎮 Press RightShift to toggle")
print("⚔️ Combat: Auto-attacks with cooldown bypass")
print("🎣 Fishing: Auto-fills green bar to 100%")
