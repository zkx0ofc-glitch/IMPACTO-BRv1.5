-- SERVIÇOS
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- CONFIGURAÇÃO DA GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernMultiHub"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.ClipsDescendants = true
MainFrame.Visible = true -- Começa visível
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- SISTEMA DE MINIMIZAR (F4)
local IsOpen = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
        IsOpen = not IsOpen
        if IsOpen then
            MainFrame.Visible = true
            MainFrame:TweenSize(UDim2.new(0, 420, 0, 380), "Out", "Quad", 0.3, true)
        else
            MainFrame:TweenSize(UDim2.new(0, 420, 0, 0), "In", "Quad", 0.3, true, function()
                if not IsOpen then MainFrame.Visible = false end
            end)
        end
    end
end)

-- TÍTULO E JOGO ATUAL
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 280, 0, 40)
Title.Position = UDim2.new(0, 130, 0, 5)
Title.Text = "MODERN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local GameStatus = Instance.new("TextLabel")
GameStatus.Size = UDim2.new(0, 280, 0, 20)
GameStatus.Position = UDim2.new(0, 130, 0, 30)
GameStatus.Text = "Pressione F4 para Minimizar"
GameStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
GameStatus.Font = Enum.Font.Gotham
GameStatus.TextSize = 12
GameStatus.BackgroundTransparency = 1
GameStatus.Parent = MainFrame

-- BARRA LATERAL PARA SELEÇÃO DE JOGOS (ABAS)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 110, 1, -20)
TabContainer.Position = UDim2.new(0, 10, 0, 10)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 2
TabContainer.Parent = MainFrame
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 10)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTAINER ONDE OS SCRIPTS APARECEM
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -140, 1, -80)
PagesContainer.Position = UDim2.new(0, 130, 0, 65)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

-----------------------------------------------------------
-- SISTEMA DE INTERRUPTORES (TOGGLES) INTEGRADO
-----------------------------------------------------------
local ActivePage = nil

local function CreateToggle(parent, name, scriptFunc)
    local active = false
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    local StatusLine = Instance.new("Frame")
    StatusLine.Size = UDim2.new(0, 4, 1, 0)
    StatusLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StatusLine.BorderSizePixel = 0
    StatusLine.Parent = Button
    Instance.new("UICorner", StatusLine)

    Button.MouseButton1Click:Connect(function()
        active = not active
        if active then
            Button.Text = name .. ": ON"
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 60, 50)}):Play()
            TweenService:Create(StatusLine, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 255, 100)}):Play()
            task.spawn(function()
                while active do
                    scriptFunc()
                    task.wait(0.1)
                end
            end)
        else
            Button.Text = name .. ": OFF"
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
            TweenService:Create(StatusLine, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
        end
    end)
end

local function AddGameTab(gameName, scriptList)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 100, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    TabBtn.Text = gameName
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 11
    TabBtn.Parent = TabContainer
    Instance.new("UICorner", TabBtn)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = PagesContainer
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabBtn.MouseButton1Click:Connect(function()
        if ActivePage then ActivePage.Visible = false end
        Page.Visible = true
        ActivePage = Page
        GameStatus.Text = "Suportado em: " .. gameName
    end)

    for _, item in ipairs(scriptList) do
        CreateToggle(Page, item.Name, item.Func)
    end
end

-----------------------------------------------------------
-- ADICIONE SEUS JOGOS E SCRIPTS AQUI
-----------------------------------------------------------

-- ABA 1: HORROR RNG
AddGameTab("HORROR RNG", {
    {
        Name = "Super Luck", 
        Func = function() 
            game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip", "Super Luck Potion", "Usable")
        end
    }
})

-- ABA 2: COMBAT (NOVO!)
local SelectedPlayer = nil
local Locked = false

AddGameTab("COMBAT", {
    {
        Name = "Aimlock Cam (Click)", 
        Func = function()
            local Player = game.Players.LocalPlayer
            local Mouse = Player:GetMouse()
            local Camera = workspace.CurrentCamera
            
            -- Função para achar player mais próximo do mouse
            local function GetClosestPlayer()
                local Target = nil
                local Distance = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                        if OnScreen then
                            local MouseDist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                            if MouseDist < Distance and MouseDist < 100 then -- Raio de 100 pixels do mouse
                                Distance = MouseDist
                                Target = v
                            end
                        end
                    end
                end
                return Target
            end

            -- Listener da tecla L (Só registra uma vez)
            if not _G.AimConnection then
                _G.AimConnection = UserInputService.InputBegan:Connect(function(input, proc)
                    if proc then return end
                    if input.KeyCode == Enum.KeyCode.L then
                        if Locked then
                            Locked = false
                            SelectedPlayer = nil
                        else
                            SelectedPlayer = GetClosestPlayer()
                            if SelectedPlayer then Locked = true end
                        end
                    end
                end)
            end

            -- Execução do Lock (Acontece no loop de 0.1s do seu Toggle)
            if Locked and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, SelectedPlayer.Character.HumanoidRootPart.Position)
            else
                Locked = false
            end
        end
    }
})

-- ABA 3: SCRIPTS GERAIS (UNIVERSAL)
AddGameTab("UNIVERSAL", {
    {Name = "Super Speed", Func = function() print("Speed EM BREVE") end},
    {Name = "Fly", Func = function() print("Fly EM BREVE") end},
    {Name = "No Clip", Func = function() print("No Clip EM BREVE") end},
    {Name = "Tp Click", Func = function() print("Tp Click EM BREVE") end}
})

-- ABA 4: BLOX FRUITS
AddGameTab("BLOX FRUITS", {
    {Name = "Auto Farm", Func = function() print("Blox Fruits Farm EM BREVE") end}
})

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
