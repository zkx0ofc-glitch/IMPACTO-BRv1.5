-- SERVIÇOS
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager") -- Simula teclado

-- CONFIGURAÇÃO DA GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernToggleMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "PREMIUM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local ButtonList = Instance.new("ScrollingFrame")
ButtonList.Size = UDim2.new(1, -20, 1, -70)
ButtonList.Position = UDim2.new(0, 10, 0, 60)
ButtonList.BackgroundTransparency = 1
ButtonList.ScrollBarThickness = 2
ButtonList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonList
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-----------------------------------------------------------
-- FUNÇÃO DE CRIAÇÃO DE INTERRUPTOR
-----------------------------------------------------------

local function CreateToggle(name, scriptFunc)
    local active = false
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Button.Text = name .. " [OFF]"
    Button.TextColor3 = Color3.fromRGB(150, 150, 150)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.Parent = ButtonList
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            Button.Text = name .. " [ON]"
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 80, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            
            task.spawn(function()
                while active do
                    scriptFunc()
                    task.wait(0.1) -- Ajuste a velocidade aqui
                end
            end)
        else
            Button.Text = name .. " [OFF]"
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
    end)
end

-----------------------------------------------------------
-- SCRIPTS DOS BOTÕES
-----------------------------------------------------------

-- 1. Script de Super Luck
CreateToggle("Super Luck", function()
    game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip", "Super Luck Potion", "Usable")
end)

-- 2. Script de Auto Roll (Aperta a tecla E)
CreateToggle("Auto Roll", function()
    -- Simula apertar e soltar a tecla E
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end)

-----------------------------------------------------------
-- SISTEMA DE MOVIMENTAÇÃO (DRAG)
-----------------------------------------------------------
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
