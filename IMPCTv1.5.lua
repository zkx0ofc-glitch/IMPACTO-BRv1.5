local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
    Name = "IMPACTO BR v1.1",
    LoadingTitle = "Obrigado Pelo Apoio!!",
    LoadingSubtitle = "By Duuio",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, 
        FileName = "Duuio_YT"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true 
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("🚜Auto Farm🚜", nil)
local MainSection = MainTab:CreateSection("Farming")

-- [VARIÁVEIS DE CONTROLE]
local player = game.Players.LocalPlayer
local autoFarmEnabled = false
local autoFarmCoroutine
local autoUsePotionsEnabled = false
local autoUsePotionsCoroutine
local fastRollEnabled = false
local fastRollCoroutine
local antiAfkEnabled = false
local antiAfkConnection
local luckyFarmEnabled = false
local luckyFarmCoroutine

-- [FUNÇÕES AUXILIARES]
local function teleportToPosition(position)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function interactWithProximityPrompt(promptPath)
    local prompt = loadstring("return " .. promptPath)()
    if prompt and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        if (prompt.Parent.Position - rootPart.Position).magnitude < 10 then
            local startTime = tick()
            while tick() - startTime < 2 do
                fireproximityprompt(prompt, Enum.KeyCode.E)
                wait(0.1)
            end
        end
    end
end

-- [LOOPS PRINCIPAIS]
local function autoFarm()
    while autoFarmEnabled do
        teleportToPosition(Vector3.new(139.45489501953125, -85.32718658447266, -263.533447265625))
        wait(3)
        interactWithProximityPrompt("getNil('Game', 'DataModel').Workspace.MapFolder.Obby_CrystalCaves.PromptPart.ProximityPrompt")
        wait(5)
        -- (Restante do seu loop de farm original...)
    end
end

-- [NOVO: AUTO LUCKY FARM]
local function luckyFarmLoop()
    while luckyFarmEnabled do
        game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip","Super Luck Potion","Usable")
        task.wait(0.1) -- Delay pequeno para evitar lag/crash
    end
end

-- [INTERFACE - ABA FARM]
local ToggleFarm = MainTab:CreateToggle({
    Name = "Chest Farm",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        autoFarmEnabled = Value
        if autoFarmEnabled then
            autoFarmCoroutine = coroutine.create(autoFarm)
            coroutine.resume(autoFarmCoroutine)
        end
    end,
})

-- [INTERFACE - NOVO AUTO LUCKY FARM]
local LuckyToggle = MainTab:CreateToggle({
    Name = "Auto Lucky Farm",
    CurrentValue = false,
    Flag = "LuckyFarmFlag",
    Callback = function(Value)
        luckyFarmEnabled = Value
        if luckyFarmEnabled then
            Rayfield:Notify({Title = "Lucky Farm", Content = "Ativado!", Duration = 2})
            luckyFarmCoroutine = coroutine.create(luckyFarmLoop)
            coroutine.resume(luckyFarmCoroutine)
        else
            Rayfield:Notify({Title = "Lucky Farm", Content = "Desativado.", Duration = 2})
        end
    end,
})

local SectionPotions = MainTab:CreateSection("⚗️Potions⚗️")

-- Botão corrigido
local ButtonBuy = MainTab:CreateButton({
    Name = "Buy Broken Dreams Potion ✅",
    Callback = function()
        local args = {[1] = "Broken Dreams"}
        game:GetService("ReplicatedStorage").CORE_RemoteEvents.SendPurchaseRequest:FireServer(unpack(args))
        Rayfield:Notify({Title = "Compra", Content = "Poção Comprada!", Duration = 2})
    end,
})

-- [ANTI AFK]
local function toggleAntiAfk()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        local VirtualUser = game:GetService('VirtualUser')
        antiAfkConnection = player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    elseif antiAfkConnection then
        antiAfkConnection:Disconnect()
    end
end
