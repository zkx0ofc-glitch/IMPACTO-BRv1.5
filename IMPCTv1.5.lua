-- SERVIÇOS
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- CRIAÇÃO DA INTERFACE PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- FRAME PRINCIPAL (O MENU)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- BORDAS ARREDONDADAS
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "HUB DE SCRIPTS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- CONTAINER DOS BOTÕES (LISTA AUTOMÁTICA)
local ButtonList = Instance.new("ScrollingFrame")
ButtonList.Size = UDim2.new(1, -20, 1, -60)
ButtonList.Position = UDim2.new(0, 10, 0, 50)
ButtonList.BackgroundTransparency = 1
ButtonList.ScrollBarThickness = 2
ButtonList.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonList
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-----------------------------------------------------------
-- SISTEMA DE FUNÇÕES (COMO ADICIONAR NOVOS SCRIPTS)
-----------------------------------------------------------

local function CreateButton(name, callback)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -10, 0, 40)
	Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(200, 200, 200)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.AutoButtonColor = true
	Button.Parent = ButtonList
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button
	
	-- Efeito de Hover (Mouse em cima)
	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	
	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 50), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
	end)

	-- Ativação
	Button.MouseButton1Click:Connect(function()
		task.spawn(callback) -- Roda o script sem travar o menu
		Button.Text = "ATIVADO!"
		wait(1)
		Button.Text = name
	end)
end

-----------------------------------------------------------
-- ADICIONE SEUS SCRIPTS ABAIXO
-----------------------------------------------------------

-- Seu script original de Luck Potion
CreateButton("Auto Super Luck", function()
	while task.wait(0) do
		game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip","Super Luck Potion","Usable")
	end
end)

-- Exemplo de como adicionar um futuro script rapidamente:
CreateButton("Futuro Script Aqui", function()
	print("Este botão está pronto para um novo script!")
end)

-----------------------------------------------------------
-- SISTEMA DE DRAG (ARRASTAR O MENU COM O MOUSE)
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
