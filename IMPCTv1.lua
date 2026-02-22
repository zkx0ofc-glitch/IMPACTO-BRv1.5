local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- PUXA AS KEYS DO GITHUB
local success, keyData = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/SEU_USUARIO/impctbr/main/keys.lua")
    return loadstring(src)()
end)

if not success then
    player:Kick("Erro ao validar key.")
    return
end

-- KEY DIGITADA PELO USUÁRIO
local USER_KEY = getgenv().IMPCT_KEY
if not USER_KEY then
    player:Kick("Key não informada.")
    return
end

-- VERIFICA KEY PERMANENTE
for _, key in ipairs(keyData.PERMANENT) do
    if USER_KEY == key then
        print("Key permanente válida")
        return
    end
end

-- VERIFICA KEY TEMPORÁRIA
local exp = keyData.TEMPORARY[USER_KEY]
if exp then
    if os.time() <= exp then
        print("Key temporária válida")
        return
    else
        player:Kick("Key expirada.")
        return
    end
end

player:Kick("Key inválida.")
--==================================================
-- IMPACTO BR v0.0.2 BETA
--==================================================

-- SERVIÇOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

--==================================================
-- PERSONAGEM
--==================================================
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local character = getChar()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end)

--==================================================
-- GUI BASE
--==================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "IMPACTO_BR_GUI"
gui.ResetOnSpawn = false

-- ÍCONE
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.05,0.07)
icon.Position = UDim2.fromScale(0.02,0.45)
icon.Text = "🌟"
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(20,20,30)
icon.TextColor3 = Color3.new(1,1,1)

-- MENU
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.65,0.55)
main.Position = UDim2.fromScale(0.18,1.3)
main.BackgroundColor3 = Color3.fromRGB(12,12,22)
main.Active = true
main.Draggable = true

local POS_FECHADO = UDim2.fromScale(0.18,1.3)
local POS_ABERTO  = UDim2.fromScale(0.18,0.22)

-- TÍTULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.1)
title.Text = "IMPACTO BR  |  v0.0.2 BETA"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

--==================================================
-- COLUNAS
--==================================================
local col1 = Instance.new("Frame", main)
col1.Size = UDim2.fromScale(0.18,0.9)
col1.Position = UDim2.fromScale(0,0.1)
col1.BackgroundColor3 = Color3.fromRGB(16,16,30)

local col2 = Instance.new("Frame", main)
col2.Size = UDim2.fromScale(0.32,0.9)
col2.Position = UDim2.fromScale(0.18,0.1)
col2.BackgroundColor3 = Color3.fromRGB(18,18,34)

local col3 = Instance.new("Frame", main)
col3.Size = UDim2.fromScale(0.5,0.9)
col3.Position = UDim2.fromScale(0.5,0.1)
col3.BackgroundColor3 = Color3.fromRGB(20,20,38)

--==================================================
-- FUNÇÕES UI
--==================================================
local function clear(frame)
	for _,v in pairs(frame:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end

local function button(parent,text,y,callback)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.fromScale(0.9,0.1)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(25,25,45)
	b.TextColor3 = Color3.fromRGB(160,160,160)
	b.MouseButton1Click:Connect(callback)
	return b
end

--==================================================
-- SESSÃO
--==================================================
local function openSession()
	clear(col2)
	clear(col3)

	local y = 0.02
	for _,plr in pairs(Players:GetPlayers()) do
		button(col2, plr.Name, y, function()
			clear(col3)

			button(col3,"Teleportar",0.2,function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					hrp.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
				end
			end)

			button(col3,"Espectar",0.35,function()
				if plr.Character and plr.Character:FindFirstChild("Humanoid") then
					camera.CameraSubject = plr.Character.Humanoid
				end
			end)
		end)
		y += 0.12
	end
end

--==================================================
-- EU (SUPER SPEED / WALK AIR / FLY / ESP / TP CLICK)
--==================================================
local walkAir = false
local tpClick = false

-- FLY (SCRIPT NOVO)
local flying = false
local flyConn
local FLY_SPEED = 70

local function openMe()
	clear(col2)
	clear(col3)

	-- SUPER SPEED
	button(col2,"Super Speed",0.05,function()
		clear(col3)

		local box = Instance.new("TextBox", col3)
		box.Size = UDim2.fromScale(0.9,0.1)
		box.Position = UDim2.fromScale(0.05,0.2)
		box.PlaceholderText = "Digite a velocidade"
		box.Text = ""

		button(col3,"Aplicar Velocidade",0.35,function()
			local v = tonumber(box.Text)
			if v then
				humanoid.WalkSpeed = v
			end
		end)
	end)

	-- WALK AIR
	button(col2,"Walk Air (ON/OFF)",0.18,function()
		walkAir = not walkAir
	end)

	-- FLY (NOVO)
	button(col2,"Fly (ON/OFF)",0.31,function()
		flying = not flying

		if flying then
			humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			flyConn = RunService.RenderStepped:Connect(function()
				local dir = Vector3.zero
				if UIS:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
				if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end

				if dir.Magnitude > 0 then
					hrp.Velocity = dir.Unit * FLY_SPEED
				end
			end)
		else
			if flyConn then flyConn:Disconnect() end
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end)

	-- ESP
	button(col2,"ESP",0.44,function()
		clear(col3)

		button(col3,"All Players",0.1,function()
			for _,p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and not p.Character:FindFirstChild("ESP") then
					local h = Instance.new("Highlight", p.Character)
					h.Name = "ESP"
					h.FillColor = Color3.fromRGB(255,0,0)
				end
			end
		end)
	end)

	-- TP CLICK
	button(col2,"TP Click (ON/OFF)",0.57,function()
		tpClick = not tpClick
	end)
end

-- WALK AIR / TP CLICK LOOP
RunService.RenderStepped:Connect(function()
	if walkAir and humanoid.FloorMaterial == Enum.Material.Air then
		hrp.Velocity = hrp.CFrame.LookVector * humanoid.WalkSpeed
	end
end)

mouse.Button1Down:Connect(function()
	if tpClick and mouse.Hit then
		hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
	end
end)

--==================================================
-- TROLL → ATAQUE SURPRESA (SCRIPT NOVO)
--==================================================
local autoAttackEnabled = false
local detectionRadius = 10
local minRadius = 5
local maxRadius = 40
local cooldown = false
local teleportDistanceBehind = 3

local circle = Instance.new("Part", workspace)
circle.Shape = Enum.PartType.Cylinder
circle.Material = Enum.Material.Neon
circle.Color = Color3.fromRGB(255,60,60)
circle.Transparency = 1
circle.Anchored = true
circle.CanCollide = false
circle.Orientation = Vector3.new(0,0,90)

local function teleportBehindEnemy(enemyHRP)
	if cooldown then return end
	cooldown = true

	local behindPosition =
		enemyHRP.Position - (enemyHRP.CFrame.LookVector * teleportDistanceBehind)

	hrp.CFrame = CFrame.new(behindPosition, enemyHRP.Position)

	task.delay(1,function()
		cooldown = false
	end)
end

RunService.RenderStepped:Connect(function()
	circle.Size = Vector3.new(0.2, detectionRadius*2, detectionRadius*2)
	circle.Position = hrp.Position - Vector3.new(0,2.9,0)
	circle.Transparency = autoAttackEnabled and 0.6 or 1

	if not autoAttackEnabled then return end

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local enemyHRP = plr.Character:FindFirstChild("HumanoidRootPart")
			if enemyHRP then
				if (hrp.Position - enemyHRP.Position).Magnitude <= detectionRadius then
					teleportBehindEnemy(enemyHRP)
				end
			end
		end
	end
end)

local function openTroll()
	clear(col2)
	clear(col3)

	button(col2,"Ataque Surpresa",0.1,function()
		clear(col3)

		local t
		t = button(col3,"Ataque Surpresa: OFF",0.15,function()
			autoAttackEnabled = not autoAttackEnabled
			t.Text = autoAttackEnabled and "Ataque Surpresa: ON" or "Ataque Surpresa: OFF"
		end)

		button(col3,"+",0.35,function()
			detectionRadius = math.clamp(detectionRadius+2,minRadius,maxRadius)
		end)

		button(col3,"-",0.5,function()
			detectionRadius = math.clamp(detectionRadius-2,minRadius,maxRadius)
		end)
	end)
end

--==================================================
-- CATEGORIAS
--==================================================
button(col1,"Sessão",0.1,openSession)
button(col1,"Eu",0.23,openMe)
button(col1,"Troll",0.36,openTroll)

--==================================================
-- ABRIR / FECHAR
--==================================================
local open = false
local function toggleMenu()
	open = not open
	TweenService:Create(
		main,
		TweenInfo.new(0.35,Enum.EasingStyle.Quart),
		{Position = open and POS_ABERTO or POS_FECHADO}
	):Play()
end

icon.MouseButton1Click:Connect(toggleMenu)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.Insert then
		toggleMenu()
	end
end)
