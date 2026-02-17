--[[
    ⚡ ABYSS FARMING HUB - LUAU SUPPORTED
    Version: bd08027bb04e4045 Compatible
    Game: 127794225497302
]]

-- Services with type annotations (Luau supported)
local Players: Players = game:GetService("Players")
local Replicated: ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace: Workspace = game:GetService("Workspace")
local Input: UserInputService = game:GetService("UserInputService")
local Virtual: VirtualInputManager = game:GetService("VirtualInputManager")
local Core: CoreGui = game:GetService("CoreGui")
local RunService: RunService = game:GetService("RunService")
local Lighting: Lighting = game:GetService("Lighting")

-- Type definitions
type RemoteCache = {
    [string]: RemoteFunction
}

type Toggles = {
    Fishing: boolean,
    Combat: boolean,
    Selling: boolean,
    AntiAFK: boolean
}

-- Game verification
local TARGET_GAME_ID: number = 127794225497302
if game.PlaceId ~= TARGET_GAME_ID then
    warn(string.format("❌ Wrong game! This script only works on Abyss (ID: %d)", TARGET_GAME_ID))
    return
end

-- Wait for game to load properly
repeat task.wait() until game:IsLoaded() and Players.LocalPlayer
task.wait(3)

local Player: Player = Players.LocalPlayer
local PlayerGui: Instance = Player:FindFirstChildOfClass("PlayerGui") or Core

-- Clean up existing GUI
pcall(function()
    local existing: Instance? = PlayerGui:FindFirstChild("AbyssHub")
    if existing then existing:Destroy() end
end)

-- ==================== LUAU GUI WITH PROPER TYPING ====================
local Hub: ScreenGui = Instance.new("ScreenGui")
Hub.Name = "AbyssHub"
Hub.ResetOnSpawn = false
Hub.Parent = PlayerGui
Hub.Enabled = true

local Main: Frame = Instance.new("Frame")
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.Size = UDim2.new(0, 400, 0, 260)
Main.Active = true
Main.Draggable = true
Main.Parent = Hub

-- Corner with proper Luau syntax
local Corner: UICorner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

-- Title bar
local TitleBar: Frame = Instance.new("Frame")
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Parent = Main

local TitleCorner: UICorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title: TextLabel = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "⚡ ABYSS FARM"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn: TextButton = Instance.new("TextButton")
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    Hub.Enabled = false
end)

-- Status bar
local StatusBar: Frame = Instance.new("Frame")
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusBar.BorderSizePixel = 0
StatusBar.Size = UDim2.new(1, 0, 0, 30)
StatusBar.Position = UDim2.new(0, 0, 1, -30)
StatusBar.Parent = Main

local StatusCorner: UICorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusText: TextLabel = Instance.new("TextLabel")
StatusText.BackgroundTransparency = 1
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Text = "● READY"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.TextSize = 12
StatusText.Font = Enum.Font.Gotham
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar

-- Toggle storage with proper typing
local Toggles: Toggles = {
    Fishing = false,
    Combat = false,
    Selling = false,
    AntiAFK = true
}

-- Button container
local ButtonContainer: Frame = Instance.new("Frame")
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Size = UDim2.new(1, -20, 1, -90)
ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
ButtonContainer.Parent = Main

local ButtonList: UIListLayout = Instance.new("UIListLayout")
ButtonList.Padding = UDim.new(0, 8)
ButtonList.FillDirection = Enum.FillDirection.Vertical
ButtonList.HorizontalAlignment = Enum.HorizontalAlignment.Left
ButtonList.VerticalAlignment = Enum.VerticalAlignment.Top
ButtonList.Parent = ButtonContainer

-- Button factory function
local function CreateToggleButton(name: string, varName: string, color: Color3): TextButton
    local btn: TextButton = Instance.new("TextButton")
    btn.Name = varName .. "Btn"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Size = UDim2.new(0, 180, 0, 32)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ButtonContainer
    
    local btnCorner: UICorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local indicator: Frame = Instance.new("Frame")
    indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(1, -25, 0.5, -8)
    indicator.Parent = btn
    
    local indCorner: UICorner = Instance.new("UICorner")
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
    
    return btn
end

-- Create buttons
CreateToggleButton("FISHING", "Fishing", Color3.fromRGB(0, 170, 255))
CreateToggleButton("COMBAT", "Combat", Color3.fromRGB(255, 70, 100))
CreateToggleButton("AUTO SELL", "Selling", Color3.fromRGB(100, 255, 100))
CreateToggleButton("ANTI AFK", "AntiAFK", Color3.fromRGB(255, 200, 0))

-- ==================== REMOTE SYSTEM WITH TYPE SAFETY ====================
local Remotes: RemoteCache = {}
local FishingEvent: RemoteEvent? = nil

-- Safe remote finder with error handling
local function FindRemote(path: {string}): Instance?
    local current: Instance = Replicated
    for _, part: string in ipairs(path) do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

-- Cache remotes with proper error handling
local function CacheRemotes(): boolean
    local success = pcall(function()
        local common = FindRemote({"common"})
        if common then
            local packages = common:FindFirstChild("packages")
            if packages then
                local knit = packages:FindFirstChild("Knit")
                if knit then
                    local services = knit:FindFirstChild("Services")
                    if services then
                        for _, service: Instance in ipairs(services:GetChildren()) do
                            local rf = service:FindFirstChild("RF")
                            if rf then
                                for _, remote: Instance in ipairs(rf:GetChildren()) do
                                    if remote:IsA("RemoteFunction") then
                                        Remotes[remote.Name] = remote :: RemoteFunction
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- Get fishing event safely
        if type(getnilinstances) == "function" then
            for _, v: Instance in ipairs(getnilinstances()) do
                if v:IsA("RemoteEvent") and v.Name == "RemoteEvent" then
                    FishingEvent = v :: RemoteEvent
                    break
                end
            end
        end
    end)
    
    return success
end

-- Call remote with type checking
local function CallRemote(name: string, ...: any): boolean
    local remote: RemoteFunction? = Remotes[name]
    if not remote then return false end
    
    local success = pcall(function()
        remote:InvokeServer(...)
    end)
    
    return success
end

-- Fire event with type checking
local function FireEvent(...: any): boolean
    if not FishingEvent then return false end
    
    local success = pcall(function()
        FishingEvent:FireServer(...)
    end)
    
    return success
end

-- Initialize remotes
CacheRemotes()

-- ==================== FARMING SYSTEMS WITH PROPER THREADING ====================
local Systems = {
    Fishing = false,
    Combat = false,
    Selling = false,
    AFK = false
}

-- Fishing system
local function FishingLoop()
    Systems.Fishing = true
    local castCount: number = 0
    
    while Systems.Fishing and Toggles.Fishing do
        -- Cast line
        local camera: Camera? = Workspace.CurrentCamera
        if camera then
            FireEvent("use", 
                camera.CFrame.Position + Vector3.new(0, -5, -15),
                camera.CFrame.LookVector
            )
        end
        
        task.wait(3)
        castCount += 1
        
        -- Reel and minigame
        if castCount >= 2 then
            CallRemote("StartCatching", "05ff3e20e6304b01b922803875ef07d8")
            
            for i: number = 1, 3 do
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

-- Combat system
local function CombatLoop()
    Systems.Combat = true
    
    while Systems.Combat and Toggles.Combat do
        local target: Instance? = nil
        local character: Model? = Player.Character
        
        if character then
            local root: Part? = character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos: Vector3 = root.Position
                local closestDist: number = 50
                
                for _, obj: Instance in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") then
                        local hum: Humanoid? = obj:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            local part: Part? = obj:FindFirstChild("HumanoidRootPart")
                            if part then
                                local dist: number = (part.Position - pos).Magnitude
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

-- Auto sell system
local function SellLoop()
    Systems.Selling = true
    
    while Systems.Selling and Toggles.Selling do
        task.wait(60)
        CallRemote("SellInventory")
    end
    Systems.Selling = false
end

-- Anti-AFK system
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
        local active: {string} = {}
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
        
        -- Start/stop systems
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

-- ==================== DRAGGABLE WINDOW ====================
local dragging: boolean = false
local dragStart: Vector2
local startPos: UDim2

TitleBar.InputBegan:Connect(function(input: InputObject)
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

Input.InputChanged:Connect(function(input: InputObject)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta: Vector2 = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ==================== TOGGLE GUI ====================
Input.InputBegan:Connect(function(input: InputObject, gp: boolean)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        Hub.Enabled = not Hub.Enabled
    end
end)

-- ==================== CLEANUP ====================
Player.AncestryChanged:Connect(function()
    if not Player.Parent then
        Hub:Destroy()
        Remotes = {}
        FishingEvent = nil
    end
end)

-- ==================== INITIALIZATION CHECK ====================
print("✅ Abyss Hub (Luau) loaded successfully!")
print("📡 Remotes found: " .. tostring(#Remotes))
print("🎣 Fishing event: " .. tostring(FishingEvent and "Found" or "Not Found"))
print("🎮 Press RightShift to toggle GUI")

-- Version compatibility check
print(string.format("🖥️ Roblox Version: %s", game:GetService("ChangeHistoryService"):GetServerGuid() or "Unknown"))
