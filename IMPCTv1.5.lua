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
-- LÓGICA DO AIMLOCK LISTA (ZERO DELAY)
-----------------------------------------------------------
local TargetPlayer = nil
local LockActive = false
local Camera = workspace.CurrentCamera

-- Rodando a 60FPS+ para grudar sem delay
game:GetService("RunService").RenderStepped:Connect(function()
    if LockActive and TargetPlayer and TargetPlayer.Character then
        local head = TargetPlayer.Character:FindFirstChild("Head")
        if head then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, head.Position)
        end
    else
        LockActive = false
    end
end)

-----------------------------------------------------------
-- FUNÇÃO PARA CRIAR A LISTA DE PLAYERS NA ABA 
-----------------------------------------------------------
local function CreatePlayerList(parent)
    local ListContainer = Instance.new("ScrollingFrame")
    ListContainer.Size = UDim2.new(1, 0, 1, 0)
    ListContainer.BackgroundTransparency = 1
    ListContainer.ScrollBarThickness = 2
    ListContainer.Parent = parent
    
    local Layout = Instance.new("UIListLayout", ListContainer)
    Layout.Padding = UDim.new(0, 5)

    local function UpdateButtons()
        for _, child in pairs(ListContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -5, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                btn.Text = p.DisplayName
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 12
                btn.Parent = ListContainer
                Instance.new("UICorner", btn)

                btn.MouseButton1Click:Connect(function()
                    if TargetPlayer == p then
                        TargetPlayer = nil
                        LockActive = false
                        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                        btn.Text = p.DisplayName
                    else
                        TargetPlayer = p
                        LockActive = true
                        -- Limpa outros botões
                        for _, b in pairs(ListContainer:GetChildren()) do
                            if b:IsA("TextButton") then 
                                b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) 
                            end
                        end
                        btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100) -- Verde
                        btn.Text = "LOCKED: " .. p.DisplayName
                    end
                end)
            end
        end
    end

    game.Players.PlayerAdded:Connect(UpdateButtons)
    game.Players.PlayerRemoving:Connect(UpdateButtons)
    UpdateButtons()
end

-----------------------------------------------------------
-- SISTEMA DE ESP FRUIT (VISUAL)
-----------------------------------------------------------
local FruitESP_Enabled = false
local ESP_Objects = {}

local function CreateFruitESP(fruit)
    if not fruit:FindFirstChild("Handle") then return end
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "FruitESP"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 100, 0, 50)
    Billboard.Adornee = fruit:FindFirstChild("Handle")
    Billboard.Parent = fruit
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "🍎 " .. fruit.Name
    Label.TextColor3 = Color3.fromRGB(255, 50, 50)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.Parent = Billboard
end

-----------------------------------------------------------
-- ADICIONE SEUS JOGOS E SCRIPTS AQUI
-----------------------------------------------------------

-- ABA 1: ALL BATTLEGROUNDS (INTEGRADA COM LISTA)
local CombatPage = nil
AddGameTab("AIMLOCK", {}) -- Criamos a aba vazia primeiro

-- Pegamos a página criada para injetar a lista customizada
for _, child in pairs(PagesContainer:GetChildren()) do
    if child:IsA("ScrollingFrame") then CombatPage = child end
end
CreatePlayerList(CombatPage) -- Injeta a lista de players aqui

-- ABA 2: HORROR RNG
AddGameTab("HORROR RNG", {
    {
        Name = "Super Luck", 
        Func = function() 
            game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip", "Super Luck Potion", "Usable")
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
    {
        Name = "ESP Frutas (ON/OFF)", 
        Func = function() 
            FruitESP_Enabled = true -- Ativa o loop de busca
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                    if not v:FindFirstChild("FruitESP") then
                        CreateFruitESP(v)
                    end
                end
            end
            task.wait(2) -- Atualiza a cada 2 segundos para não dar lag
        end
    },
    {
        Name = "Ver Estoque (Pop-up)", 
        Func = function() 
            -- Criando uma Janela de Pop-up (Aba Extra)
            local PopUp = Instance.new("Frame")
            PopUp.Size = UDim2.new(1, 0, 1, 0)
            PopUp.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            PopUp.ZIndex = 10
            PopUp.Parent = PagesContainer -- Abre dentro do seu menu atual

            local CloseBtn = Instance.new("TextButton")
            CloseBtn.Size = UDim2.new(1, 0, 0, 30)
            CloseBtn.Text = "[ FECHAR ESTOQUE ]"
            CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            CloseBtn.TextColor3 = Color3.new(1,1,1)
            CloseBtn.Parent = PopUp
            CloseBtn.MouseButton1Click:Connect(function() PopUp:Destroy() end)

            local StockList = Instance.new("ScrollingFrame")
            StockList.Position = UDim2.new(0,0,0,35)
            StockList.Size = UDim2.new(1,0,1,-35)
            StockList.BackgroundTransparency = 1
            StockList.Parent = PopUp
            Instance.new("UIListLayout", StockList)

            -- Pegando Estoque Real
            local success, stock = pcall(function() 
                return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits") 
            end)

            if success and type(stock) == "table" then
                for _, f in pairs(stock) do
                    if f.OnSale then
                        local l = Instance.new("TextLabel")
                        l.Size = UDim2.new(1,0,0,25)
                        l.Text = f.Name .. " - $" .. f.Price
                        l.TextColor3 = Color3.new(1,1,1)
                        l.BackgroundTransparency = 1
                        l.Parent = StockList
                    end
                end
            else
                local err = Instance.new("TextLabel")
                err.Text = "Erro ao carregar (Vá para o Jogo)"
                err.Parent = StockList
            end
        end
    }
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
