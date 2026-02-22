local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "IMPACTO BR v1.1",
    LoadingTitle = "Obrigado Pelo Apoio!!",
    LoadingSubtitle = "By Duuio",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Create a custom folder for your hub/game
        FileName = "Duuio_YT"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})

local MainTab = Window:CreateTab("🚜Auto Farm🚜", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Farming")

local player = game.Players.LocalPlayer
local autoFarmEnabled = false
local autoFarmCoroutine
local autoUsePotionsEnabled = false
local autoUsePotionsCoroutine
local fastRollEnabled = false
local fastRollCoroutine
local antiAfkEnabled = false
local antiAfkConnection

-- Function to teleport the player
local function teleportToPosition(position)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Function to interact with a specific proximity prompt
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

-- Main Auto Farm Loop
local function autoFarm()
    while autoFarmEnabled do
        teleportToPosition(Vector3.new(139.45489501953125, -85.32718658447266, -263.533447265625))
        wait(3)
        interactWithProximityPrompt("getNil('Game', 'DataModel').Workspace.MapFolder.Obby_CrystalCaves.PromptPart.ProximityPrompt")
        wait(5)

        teleportToPosition(Vector3.new(18.52592658996582, -87.82718658447266, -26.418466567993164))
        wait(3)
        interactWithProximityPrompt("getNil('Game', 'DataModel').Workspace.MapFolder.Obby_FloodedCaves.PromptPart.ProximityPrompt")
        wait(5)

        teleportToPosition(Vector3.new(150.34710693359375, -87.82718658447266, 11.305421829223633))
        wait(3)
        interactWithProximityPrompt("getNil('Game', 'DataModel').Workspace.MapFolder.Obby_CrystalCaves.PromptPart.ProximityPrompt")
        wait(3)

        teleportToPosition(Vector3.new(171.65078735351562, -85.32718658447266, -61.73625183105469))
        wait(3)
        interactWithProximityPrompt("getNil('Game', 'DataModel').Workspace.MapFolder.Obby_FloodedCaves.PromptPart.ProximityPrompt")
        wait(20)
    end
end

-- Function to auto-use potions
local function autoUsePotions()
    while autoUsePotionsEnabled do
        -- Use "Broken Dreams" potion
        local args = {
            [1] = "use_potion",
            [2] = "Broken Dreams"
        }
        game:GetService("ReplicatedStorage").CORE_RemoteEvents.SendEquipRequest:FireServer(unpack(args))

        -- Use "Mega Sunburst" potion
        local args = {
            [1] = "use_potion",
            [2] = "Mega Sunburst"
        }
        game:GetService("ReplicatedStorage").CORE_RemoteEvents.SendEquipRequest:FireServer(unpack(args))

        -- Notify the user
        Rayfield:Notify({
            Title = "Potion Used",
            Content = "Using a potion...",
            Duration = 2,
            Image = 4483362458,
        })

        -- Wait for 5 minutes before using the next potion
        wait(300)
    end
end

-- Function to handle Fast Roll
local function fastRoll()
    while fastRollEnabled do
       while wait(0) do game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer("Equip","Super Luck Potion","Usable")
    end
end

-- Anti AFK function
local function enableAntiAfk()
    if not antiAfkConnection then
        local VirtualUser = game:GetService('VirtualUser')
        antiAfkConnection = game:GetService('Players').LocalPlayer.Idled:connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Roblox tried to kick you. Anti AFK is active.",
                Duration = 2,
                Image = 4483362458,
            })
        end)
    end
end

local function disableAntiAfk()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
        Rayfield:Notify({
            Title = "Anti AFK",
            Content = "Anti AFK disabled.",
            Duration = 2,
            Image = 4483362458,
        })
    end
end

local function toggleAntiAfk()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        enableAntiAfk()
    else
        disableAntiAfk()
    end
end

-- Function to start or stop auto farming
local function toggleAutoFarm()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        Rayfield:Notify({
            Title = "Auto Farm",
            Content = "Auto farm enabled.",
            Duration = 2,
            Image = 4483362458,
        })
        autoFarmCoroutine = coroutine.create(autoFarm)
        coroutine.resume(autoFarmCoroutine)
    else
        Rayfield:Notify({
            Title = "Auto Farm",
            Content = "Auto farm disabled.",
            Duration = 2,
            Image = 4483362458,
        })
        if autoFarmCoroutine then
            coroutine.yield(autoFarmCoroutine)
            autoFarmCoroutine = nil
        end
    end
end

-- Integration with the toggle for auto farm
local Toggle = MainTab:CreateToggle({
    Name = "Chest Farm",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoFarmEnabled = Value
        if autoFarmEnabled then
            Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Auto farm enabled.",
                Duration = 2,
                Image = 4483362458,
            })
            autoFarmCoroutine = coroutine.create(autoFarm)
            coroutine.resume(autoFarmCoroutine)
        else
            Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Auto farm disabled.",
                Duration = 2,
                Image = 4483362458,
            })
            if autoFarmCoroutine then
                coroutine.yield(autoFarmCoroutine)
                autoFarmCoroutine = nil
            end
        end
    end,
})

local Section = MainTab:CreateSection("⚗️Potions⚗️")

-- Button to buy "Broken Dreams" potion
local Button = MainTab:CreateButton({
    Name = "Buy Broken Dreams Potion ✅",
    Callback = function()
        local args = {
            [1] = "Broken Dreams"
        }
        game:GetService("ReplicatedStorage").CORE_RemoteEvents.SendPurchaseRequest:FireServer(unpack(args))
        Rayfield:Notify({
            Title = "Purchase",
            Content = "Purchased Broken Dreams Potion.",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Button to buy "Mega Sunburst" potion
local Button = MainTab:CreateButton({
    Name = "Buy Mega Sunburst Potion ✅",
    Callback = function()
        local args = {
            [1] = "Mega Sunburst"
        }
        game:GetService("ReplicatedStorage").CORE_RemoteEvents.SendPurchaseRequest:FireServer(unpack(args))
        Rayfield:Notify({
            Title = "Purchase",
            Content = "Purchased Mega Sunburst Potion.",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Integration with the toggle for auto-use potions
local Toggle = MainTab:CreateToggle({
    Name = "⚗️Auto Use Potions⚗️",
    CurrentValue = false,
    Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoUsePotionsEnabled = Value
        if autoUsePotionsEnabled then
            Rayfield:Notify({
                Title = "Auto Use Potions",
                Content = "Auto use potions enabled.",
                Duration = 2,
                Image = 4483362458,
            })
            autoUsePotionsCoroutine = coroutine.create(autoUsePotions)
            coroutine.resume(autoUsePotionsCoroutine)
        else
            Rayfield:Notify({
                Title = "Auto Use Potions",
                Content = "Auto use potions disabled.",
                Duration = 2,
                Image = 4483362458,
            })
            if autoUsePotionsCoroutine then
                coroutine.yield(autoUsePotionsCoroutine)
                autoUsePotionsCoroutine = nil
            end
        end
    end,
})

local Section = MainTab:CreateSection("💸Summon💸")

-- Integration with the toggle for fast roll
local Toggle = MainTab:CreateToggle({
    Name = "⚡Fast Roll⚡",
    CurrentValue = false,
    Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        fastRollEnabled = Value
        if fastRollEnabled then
            Rayfield:Notify({
                Title = "Fast Roll",
                Content = "Fast roll enabled.",
                Duration = 2,
                Image = 4483362458,
            })
            fastRollCoroutine = coroutine.create(fastRoll)
            coroutine.resume(fastRollCoroutine)
        else
            Rayfield:Notify({
                Title = "Fast Roll",
                Content = "Fast roll disabled.",
                Duration = 2,
                Image = 4483362458,
            })
            if fastRollCoroutine then
                coroutine.yield(fastRollCoroutine)
                fastRollCoroutine = nil
            end
        end
    end,
})

local Section = MainTab:CreateSection("Anti AFK")

-- Integration with the toggle for anti AFK
local Toggle = MainTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        toggleAntiAfk()
    end,
})
