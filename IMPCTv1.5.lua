-- SERVIÇOS
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGURAÇÃO DA GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernToggleMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "MODERN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local ButtonList = Instance.new("ScrollingFrame")
ButtonList.Size = UDim2.new(1, -20, 1, -70)
ButtonList.Position = UDim2.new(0, 10, 0, 60)
ButtonList.BackgroundTransparency = 1
ButtonList.ScrollBarThickness = 2
ButtonList.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonList
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-----------------------------------------------------------
-- SISTEMA DE INTERRUPTORES (TOGGLES)
-----------------------------------------------------------

local function CreateToggle(name, scriptFunc)
    local active = false
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.Parent = ButtonList
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    -- Linha de status colorida lateral
    local StatusLine = Instance.new("Frame")
    StatusLine.Size = UDim2.new(0, 4, 1, 0)
    StatusLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StatusLine.BorderSizePixel = 0
    StatusLine.Parent = Button
    Instance.new("UICorner").Parent = StatusLine

    Button.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            -- Ativado
            Button.Text = name .. ": ON"
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 60, 50)}):Play()
            TweenService:Create(StatusLine, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 255, 100)}):Play()
            
            -- Executa o script em loop enquanto 'active' for true
            task.spawn(function()
                while active do
                    scriptFunc()
                    task.wait(0.1) -- Delay pequeno para não travar o jogo
                end
            end)
        else
            -- Desativado
            Button.Text = name .. ": OFF"
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
            TweenService:Create(StatusLine, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
        end
    end)
end

-----------------------------------------------------------
-- ADICIONE SEUS SCRIPTS AQUI
-----------------------------------------------------------

-- 1. Script de Luck Potion (Agora como interruptor)
CreateToggle("Super Luck", function()
    game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip", "Super Luck Potion", "Usable")
end)

-- 2. NOVO SCRIPT: SPEED (VELOCIDADE)

local WalkSpeedValue = 100 -- Altere aqui a velocidade desejada
local SpeedActive = false -- Variável de controle local

CreateToggle("Speed Hack", function()
    SpeedActive = not SpeedActive -- Alterna o estado interno
    
    local player = game.Players.LocalPlayer
    
    task.spawn(function()
        -- Enquanto estiver ativo, mantém a velocidade (evita que o jogo resete)
        while SpeedActive do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = WalkSpeedValue
            end
            task.wait(0.1)
        end
        
        -- Quando sair do loop (botão OFF), volta ao normal
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end)
end)


-----------------------------------------------------------
-- SISTEMA DE ARRASTAR (DRAG)
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
