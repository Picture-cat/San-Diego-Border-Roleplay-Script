local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local FarmSettings = {
   Civilian = {
      Quanity = 1,
      Items = "Avacados",
      Speed = 200,
      Positions = {
         ["Avacados"] = Vector3.new(),
         ["Wagyu Beef"] = Vector3.new(),
         ["Witches Brew"] = Vector3.new(),
         ["Fake Designer Sneakers"] = Vector3.new(),
         ["Fake Diamond Ring"] = Vector3.new(),
         ["Mona Liza"] = Vector3.new(),
         ["El Diablo"] = {}
      }
   }
}

local El_Capo = MarketplaceService:UserOwnsGamePassAsync(player.UserId, 3581977887) -- Second argument is El Capo Gamepass ID

player.CharacterAdded:Connect(function(newChar)
   character = newChar
   rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

function GoToPosition(targetVector3)
	local startCFrame = rootPart.CFrame
	local targetCFrame = CFrame.new(targetVector3) * (startCFrame - startCFrame.Position)
	local totalDistance = (targetVector3 - startCFrame.Position).Magnitude

	if totalDistance <= 0.5 then return true end

	local traveledDistance = 0

	RunService:BindToRenderStep("GoingPosition", 1, function(dt)
		traveledDistance = traveledDistance + (speed * dt)
		local alpha = math.clamp(traveledDistance / totalDistance, 0, 1)

		rootPart.CFrame = startCFrame:Lerp(targetCFrame, alpha)
		rootPart.AssemblyLinearVelocity = Vector3.zero 

      local currentDistance = (targetVector3 - startCFrame.Position).Magnitude

		if alpha >= 1 then
			RunService:UnbindFromRenderStep("GoingPosition")
		end
	end)
end

function TriggerTheProximityPrompt(ProximityPrompt)
   local CurrentLineOfSight = ProximityPrompt.RequiresLineOfSight
   local CurrentDistance = ProximityPrompt.MaxActivationDistance

   ProximityPrompt.RequiresLineOfSight = false
   ProximityPrompt.MaxActivationDistance = 10000

   local successTrigger = false

   local proximityPromptEventCheck
   proximityPromptEventCheck = ProximityPrompt.Triggered:Connect(function(triggerPlayer)
      if triggerPlayer == player then
         successTrigger = true
         proximityPromptEventCheck:Disconnect()
         proximityPromptEventCheck = nil
      end
   end)
      
   while not successTrigger do
      fireproximityprompt(ProximityPrompt)
      task.wait(1)
   end

   ProximityPrompt.RequiresLineOfSight = CurrentLineOfSight
   ProximityPrompt.MaxActivationDistance = CurrentLineOfSight
end

local ThreadFarm

function EnableTheCivilianFarm(Value)
   if Value then
      ThreadFarm = task.spawn(function()
         while true do

         end
      end)
   else
      ThreadFarm = nil
   end
end

function initUI()
   local Window = Rayfield:CreateWindow({
      Name = "San Diego Border Roleplay Script",
      Icon = "truck", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
      LoadingTitle = "San Diego Border Roleplay Script",
      LoadingSubtitle = "by Picture_cat",
      ShowText = "San Diego Border Roleplay Script", -- for mobile users to unhide Rayfield, change if you'd like
      Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

      ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

      DisableRayfieldPrompts = false,
      DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

      -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

      ConfigurationSaving = {
         Enabled = false,
         FolderName = "San Diego Border Roleplay Script Picture_cat", -- Create a custom folder for your hub/game
         FileName = "Big Hub"
      },

      Discord = {
         Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
         Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
         RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
      },

      KeySystem = false, -- Set this to true to use our key system
      KeySettings = {
         Title = "Untitled",
         Subtitle = "Key System",
         Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
         FileName = "San Diego Border Roleplay Script Picture_cat K", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
         SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
         GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
         Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
      }
   })

   local FarmTab = Window:CreateTab("Farm", "circle-dollar-sign")

   local CivilianSection = FarmTab:CreateSection("Civilian")

   local CivilianFarmToogler = FarmTab:CreateToggle({
      Name = "Farm Enabled",
      CurrentValue = false,
      Flag = "CivilianFarm",
      Callback = function(Value)
         EnableTheCivilianFarm(Value)
      end,
   })

   local SpeedSlider = FarmTab:CreateSlider({
      Name = "Speed",
      Range = {100, 250},
      Increment = 1,
      Suffix = "Speed",
      CurrentValue = FarmSettings.Civilian.Speed,
      Flag = "SpeedFarmCivilian",
      Callback = function(Value)
         FarmSettings.Civilian.Speed = Value
      end,
   })

   local QuanitySmuggledItemsSlider = FarmTab:CreateSlider({
      Name = "Quanity Of Smuggled Items",
      Range = if El_Capo then {1, 8} else {1,5},
      Increment = 1,
      Suffix = "Smuggled Items",
      CurrentValue = FarmSettings.Civilian.Quanity,
      Flag = "QuanitySmuggledItems",
      Callback = function(Value)
         FarmSettings.Civilian.Quanity = Value
      end,
   })

   local SmuggledItemsDropdown = FarmTab:CreateDropdown({
      Name = "Sell",
      Options = if El_Capo then {"Avacados", "Wagyu Beef", "Witches Brew", "Fake Designer Sneakers", "Fake Diamond Ring", "Mona Liza", "El Diablo"} else {"Avacados", "Wagyu Beef", "Witches Brew", "Fake Designer Sneakers", "Fake Diamond Ring", "Mona Liza"},
      CurrentOption = {FarmSettings.Civilian.Items},
      MultipleOptions = false,
      Flag = "SmuggledItems",
      Callback = function(Options)
         FarmSettings.Civilian.Items = Options[1]
      end,
   })

   Rayfield:SetVisibility(true)
end

initUI()

-- local plr = game.Players.LocalPlayer
-- local Camera = workspace.CurrentCamera
-- local money = plr.PlayerGui.MainHUDGui.TopRight.Money.TextLabel

-- local hasElCapoGamepass = game:GetService("MarketplaceService"):UserOwnsGamePassAsync(plr.UserId, 3581977887)

-- -- Глобальные настройки
-- _G.FarmActive = true
-- local speed = 200 -- Стартовая скорость
-- local buyAmount = 5 -- Стартовое количество закупок (от 1 до 8)

-- local char, rootPart, humanoid
-- local currentStep = 1 

-- local function updateCharacterReferences(newChar)
-- 	char = newChar or plr.Character or plr.CharacterAdded:Wait()
-- 	rootPart = char:WaitForChild("HumanoidRootPart")
-- 	humanoid = char:WaitForChild("Humanoid")
-- end

-- updateCharacterReferences()

-- plr.CharacterAdded:Connect(function(newChar)
-- 	updateCharacterReferences(newChar)
-- end)

-- local function isCharacterAlive()
-- 	return char and humanoid and humanoid.Health > 0 and rootPart
-- end

-- local function waitForRespawnAndActive()
-- 	while not isCharacterAlive() or not _G.FarmActive do
-- 		task.wait(0.5)
-- 	end
-- end

-- local function goToPosition(targetVector3)
-- 	waitForRespawnAndActive()
-- 	if not _G.FarmActive then return false end
	
-- 	local startCFrame = rootPart.CFrame
-- 	local targetCFrame = CFrame.new(targetVector3) * (startCFrame - startCFrame.Position)
-- 	local totalDistance = (targetVector3 - startCFrame.Position).Magnitude

-- 	if totalDistance <= 0.5 then return true end

-- 	local traveledDistance = 0
-- 	local isFinished = false

-- 	local connection
-- 	connection = RunService.RenderStepped:Connect(function(dt)
-- 		if not isCharacterAlive() or not _G.FarmActive then
-- 			connection:Disconnect()
-- 			isFinished = true
-- 			return
-- 		end

-- 		traveledDistance = traveledDistance + (speed * dt)
-- 		local alpha = math.clamp(traveledDistance / totalDistance, 0, 1)

-- 		rootPart.CFrame = startCFrame:Lerp(targetCFrame, alpha)
-- 		rootPart.AssemblyLinearVelocity = Vector3.zero 

-- 		if alpha >= 1 then
-- 			connection:Disconnect()
-- 			isFinished = true
-- 		end
-- 	end)

-- 	repeat task.wait() until isFinished
	
-- 	if not _G.FarmActive then return false end

-- 	if isCharacterAlive() then
-- 		rootPart.CFrame = targetCFrame
-- 		return true
-- 	else
-- 		waitForRespawnAndActive()
-- 		if _G.FarmActive then
-- 			return goToPosition(targetVector3)
-- 		end
-- 	end
-- 	return false
-- end

-- local function interactWithPrompt(prompt)
-- 	if not prompt then return false end
-- 	waitForRespawnAndActive()
-- 	if not _G.FarmActive then return false end
	
-- 	task.wait(0.2) 
-- 	if not isCharacterAlive() or not _G.FarmActive then return false end
	
-- 	local oldLOS = prompt.RequiresLineOfSight
-- 	local oldDist = prompt.MaxActivationDistance
-- 	prompt.RequiresLineOfSight = false
-- 	prompt.MaxActivationDistance = 9999

-- 	Camera.CameraType = Enum.CameraType.Scriptable
-- 	Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, prompt.Parent.Position)
	
-- 	task.wait(0.05)
-- 	if isCharacterAlive() and _G.FarmActive then
-- 		fireproximityprompt(prompt)
-- 	end
-- 	task.wait(0.05)

-- 	Camera.CameraType = Enum.CameraType.Custom

-- 	prompt.RequiresLineOfSight = oldLOS
-- 	prompt.MaxActivationDistance = oldDist
-- 	return true
-- end

-- local function getMoneyValue()
-- 	local numbersOnly = {}
-- 	for digit in string.gmatch(money.Text, "%d") do
-- 		table.insert(numbersOnly, digit)
-- 	end
-- 	return tonumber(table.concat(numbersOnly)) or 0
-- end

-- local function createUI()
-- 	-- Главный контейнер интерфейса
-- 	local screenGui = Instance.new("ScreenGui")
-- 	screenGui.Name = "FarmControlGui"
-- 	screenGui.ResetOnSpawn = false
-- 	screenGui.Parent = plr:WaitForChild("PlayerGui")

-- 	-- Увеличили высоту фрейма до 260, чтобы влез второй слайдер
-- 	local frame = Instance.new("Frame")
-- 	frame.Size = UDim2.new(0, 220, 0, 260)
-- 	frame.Position = UDim2.new(0, 20, 0, 100)
-- 	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
-- 	frame.BorderSizePixel = 0
-- 	frame.Parent = screenGui

-- 	local frameCorner = Instance.new("UICorner")
-- 	frameCorner.CornerRadius = UDim.new(0, 10)
-- 	frameCorner.Parent = frame

-- 	-- Кнопка Вкл/Выкл
-- 	local button = Instance.new("TextButton")
-- 	button.Size = UDim2.new(0, 180, 0, 40)
-- 	button.Position = UDim2.new(0, 20, 0, 15)
-- 	button.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
-- 	button.Text = "Farm: ON"
-- 	button.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	button.Font = Enum.Font.SourceSansBold
-- 	button.TextSize = 18
-- 	button.Parent = frame

-- 	local btnCorner = Instance.new("UICorner")
-- 	btnCorner.CornerRadius = UDim.new(0, 6)
-- 	btnCorner.Parent = button

-- 	button.MouseButton1Click:Connect(function()
-- 		_G.FarmActive = not _G.FarmActive
-- 		if _G.FarmActive then
-- 			button.Text = "Farm: ON"
-- 			TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
-- 		else
-- 			button.Text = "Farm: OFF"
-- 			TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(231, 76, 60)}):Play()
-- 		end
-- 	end)

-- 	-- СЛАЙДЕР СКОРОСТИ
-- 	local speedLabel = Instance.new("TextLabel")
-- 	speedLabel.Size = UDim2.new(0, 180, 0, 20)
-- 	speedLabel.Position = UDim2.new(0, 20, 0, 65)
-- 	speedLabel.BackgroundTransparency = 1
-- 	speedLabel.Text = "Скорость: " .. speed
-- 	speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
-- 	speedLabel.Font = Enum.Font.SourceSansBold
-- 	speedLabel.TextSize = 14
-- 	speedLabel.TextXAlignment = Enum.TextXAlignment.Left
-- 	speedLabel.Parent = frame

-- 	local sliderFrame = Instance.new("Frame")
-- 	sliderFrame.Size = UDim2.new(0, 180, 0, 8)
-- 	sliderFrame.Position = UDim2.new(0, 20, 0, 95)
-- 	sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
-- 	sliderFrame.BorderSizePixel = 0
-- 	sliderFrame.Parent = frame

-- 	local sliderCorner = Instance.new("UICorner")
-- 	sliderCorner.CornerRadius = UDim.new(0, 4)
-- 	sliderCorner.Parent = sliderFrame

-- 	local sliderFill = Instance.new("Frame")
-- 	sliderFill.Size = UDim2.new((speed - 10) / 490, 0, 1, 0)
-- 	sliderFill.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
-- 	sliderFill.BorderSizePixel = 0
-- 	sliderFill.Parent = sliderFrame

-- 	local fillCorner = Instance.new("UICorner")
-- 	fillCorner.CornerRadius = UDim.new(0, 4)
-- 	fillCorner.Parent = sliderFill

-- 	local sliderButton = Instance.new("ImageButton")
-- 	sliderButton.Size = UDim2.new(0, 16, 0, 16)
-- 	sliderButton.Position = UDim2.new((speed - 10) / 490, -8, 0.5, -8)
-- 	sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
-- 	sliderButton.BorderSizePixel = 0
-- 	sliderButton.Parent = sliderFrame

-- 	local btnRound = Instance.new("UICorner")
-- 	btnRound.CornerRadius = UDim.new(1, 0)
-- 	btnRound.Parent = sliderButton

-- 	-- СЛАЙДЕР КОЛИЧЕСТВА КУПОК
-- 	local amountLabel = Instance.new("TextLabel")
-- 	amountLabel.Size = UDim2.new(0, 180, 0, 20)
-- 	amountLabel.Position = UDim2.new(0, 20, 0, 115)
-- 	amountLabel.BackgroundTransparency = 1
-- 	amountLabel.Text = "Кол-во закупки: " .. buyAmount
-- 	amountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
-- 	amountLabel.Font = Enum.Font.SourceSansBold
-- 	amountLabel.TextSize = 14
-- 	amountLabel.TextXAlignment = Enum.TextXAlignment.Left
-- 	amountLabel.Parent = frame

-- 	local amountSliderFrame = Instance.new("Frame")
-- 	amountSliderFrame.Size = UDim2.new(0, 180, 0, 8)
-- 	amountSliderFrame.Position = UDim2.new(0, 20, 0, 145)
-- 	amountSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
-- 	amountSliderFrame.BorderSizePixel = 0
-- 	amountSliderFrame.Parent = frame

-- 	local amountSliderCorner = Instance.new("UICorner")
-- 	amountSliderCorner.CornerRadius = UDim.new(0, 4)
-- 	amountSliderCorner.Parent = amountSliderFrame

-- 	local amountSliderFill = Instance.new("Frame")
-- 	amountSliderFill.Size = UDim2.new((buyAmount - 1) / 9, 0, 1, 0)
-- 	amountSliderFill.BackgroundColor3 = Color3.fromRGB(155, 89, 182) -- Фиолетовый цвет для отличия
-- 	amountSliderFill.BorderSizePixel = 0
-- 	amountSliderFill.Parent = amountSliderFrame

-- 	local amountFillCorner = Instance.new("UICorner")
-- 	amountFillCorner.CornerRadius = UDim.new(0, 4)
-- 	amountFillCorner.Parent = amountSliderFill

-- 	local maxAmount = if hasElCapoGamepass then 8 else 5

-- 	local amountSliderButton = Instance.new("ImageButton")
-- 	amountSliderButton.Size = UDim2.new(0, 16, 0, 16)
-- 	amountSliderButton.Position = UDim2.new((buyAmount - 1) / 9, -8, 0.5, -8)
-- 	amountSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
-- 	amountSliderButton.BorderSizePixel = 0
-- 	amountSliderButton.Parent = amountSliderFrame

-- 	local amountBtnRound = Instance.new("UICorner")
-- 	amountBtnRound.CornerRadius = UDim.new(1, 0)
-- 	amountBtnRound.Parent = amountSliderButton

-- 	-- Предупреждение об античите (сместили вниз)
-- 	local warningLabel = Instance.new("TextLabel")
-- 	warningLabel.Size = UDim2.new(0, 180, 0, 40)
-- 	warningLabel.Position = UDim2.new(0, 20, 0, 175)
-- 	warningLabel.BackgroundTransparency = 1
-- 	warningLabel.Text = "На этой скорости чаще всего срабатывает анти чит"
-- 	warningLabel.TextColor3 = Color3.fromRGB(231, 76, 60)
-- 	warningLabel.Font = Enum.Font.SourceSansItalic
-- 	warningLabel.TextSize = 13
-- 	warningLabel.TextWrapped = true
-- 	warningLabel.TextYAlignment = Enum.TextYAlignment.Top
-- 	warningLabel.TextTransparency = (speed >= 250) and 0 or 1
-- 	warningLabel.Parent = frame

-- 	-- Логика перетаскивания слайдеров
-- 	local minSpeed, maxSpeed = 10, 500
-- 	local minAmount = 1
-- 	local draggingSpeed = false
-- 	local draggingAmount = false

-- 	sliderButton.InputBegan:Connect(function(input)
-- 		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
-- 			draggingSpeed = true
-- 		end
-- 	end)

-- 	amountSliderButton.InputBegan:Connect(function(input)
-- 		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
-- 			draggingAmount = true
-- 		end
-- 	end)

-- 	UserInputService.InputChanged:Connect(function(input)
-- 		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
-- 			if draggingSpeed then
-- 				local percentage = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
-- 				speed = math.floor(minSpeed + (percentage * (maxSpeed - minSpeed)))
-- 				speedLabel.Text = "Скорость: " .. speed
-- 				sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
-- 				sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
				
-- 				if speed >= 250 then
-- 					TweenService:Create(warningLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
-- 				else
-- 					TweenService:Create(warningLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
-- 				end
-- 			elseif draggingAmount then
-- 				local percentage = math.clamp((input.Position.X - amountSliderFrame.AbsolutePosition.X) / amountSliderFrame.AbsoluteSize.X, 0, 1)
-- 				buyAmount = math.floor(minAmount + (percentage * (maxAmount - minAmount)))
-- 				amountLabel.Text = "Кол-во закупки: " .. buyAmount
-- 				amountSliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
-- 				amountSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
-- 			end
-- 		end
-- 	end)

-- 	local function stopDrag()
-- 		draggingSpeed = false
-- 		draggingAmount = false
-- 	end

-- 	UserInputService.InputEnded:Connect(function(input)
-- 		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
-- 			stopDrag()
-- 		end
-- 	end)
-- end

-- createUI()

-- -- Основной цикл фарма
-- task.spawn(function()
-- 	while true do
-- 		waitForRespawnAndActive()

-- 		if currentStep == 1 and _G.FarmActive then
-- 			local currentValue = getMoneyValue()
-- 			local currentProxTrigger = nil
-- 			local targetPos = nil
			
-- 			-- Проверяем баланс на основе динамического множителя buyAmount
-- 			if currentValue >= 5250 * buyAmount and hasElCapoGamepass and 
-- 			   goToPosition(Vector3.new(6834.425, 17.416, 28.148)) and 
-- 			   goToPosition(Vector3.new(6892.229, 17.218, 83.438)) and 
-- 			   goToPosition(Vector3.new(6599.39501953125, 17.218589782714844, 91.19527435302734)) and 
-- 			   goToPosition(Vector3.new(6605.2392578125, 60.83428955078125, -281.3045959472656)) and 
-- 			   goToPosition(Vector3.new(6598.93115234375, 61.04671096801758, -366.0216369628906)) and 
-- 			   goToPosition(Vector3.new(6599.041015625, 64.49603271484375, -428.1905822753906)) then
-- 				targetPos = Vector3.new(6642.404296875, 64.49603271484375, -434.1622314453125)
-- 				currentProxTrigger = workspace.WorldBuyableItems.ElCapo["El Diablo Box"].Mesh.PromptAttachment.ProximityPrompt
-- 			elseif currentValue >= 3750 * buyAmount then
-- 				targetPos = Vector3.new(6807, 17, 23)
-- 				currentProxTrigger = workspace.WorldBuyableItems.CivilianArea["Mona Lisa Painting"].MonaLisaPaint.PromptAttachment.ProximityPrompt
-- 			elseif currentValue >= 5000 * buyAmount then
-- 				targetPos = Vector3.new(6820.433, 17.416, 20.724)
-- 				currentProxTrigger = workspace.WorldBuyableItems.CivilianArea["Fake Diamond Ring"].Handle.PromptAttachment.ProximityPrompt
-- 			elseif currentValue >= 3500 * buyAmount then
-- 				targetPos = Vector3.new(6810.491, 17.416, 20.924)
-- 				currentProxTrigger = workspace.WorldBuyableItems.CivilianArea["Fake Designer Sneakers"].Handle.PromptAttachment.ProximityPrompt
-- 			elseif currentValue >= 2500 * buyAmount then
-- 				targetPos = Vector3.new(6807.023, 17.416, 33.321)
-- 				currentProxTrigger = workspace.WorldBuyableItems.CivilianArea["Witches Brew"].Handle.PromptAttachment.ProximityPrompt
-- 			elseif currentValue >= 1750 * buyAmount then
-- 				targetPos = Vector3.new(6811.713, 17.416, 34.469)
-- 				currentProxTrigger = workspace.WorldBuyableItems.CivilianArea["Wagyu Beef"].Handle.PromptAttachment.ProximityPrompt
-- 			elseif currentValue >= 750 * buyAmount then
-- 				targetPos = Vector3.new(6821.278, 17.416, 33.421)
-- 				currentProxTrigger = workspace.WorldBuyableItems.CivilianArea["Crate Of Avacados"].Handle.PromptAttachment.ProximityPrompt
-- 			end

-- 			local success = true

-- 			if targetPos then
-- 				success = goToPosition(targetPos)
-- 			end

-- 			if success and currentProxTrigger and _G.FarmActive then
-- 				-- Цикл совершает ровно столько кликов, сколько выбрано на слайдере buyAmount
-- 				for _ = 1, buyAmount do
-- 					if not _G.FarmActive then
-- 						success = false
-- 						break 
-- 					end
-- 					interactWithPrompt(currentProxTrigger)
-- 					task.wait(0.15)
-- 				end
-- 			end
			
-- 			if success and _G.FarmActive then
-- 				currentStep = 2
-- 			end
-- 		end
		
-- 		if currentStep == 2 and _G.FarmActive then
-- 			if goToPosition(Vector3.new(6834.425, 17.416, 28.148)) and 
-- 			   goToPosition(Vector3.new(6892.229, 17.218, 83.438)) and 
-- 			   goToPosition(Vector3.new(6889.687, 17.218, 140.958)) and 
-- 			   goToPosition(Vector3.new(2877.611, 17.218, 163.101)) and 
-- 			   goToPosition(Vector3.new(728.977, 17.218, 142.617)) and 
-- 			   goToPosition(Vector3.new(53.398, 17.218, 135.798)) and 
-- 			   goToPosition(Vector3.new(65.588, 17.218, 380.733)) and 
-- 			   goToPosition(Vector3.new(-82.826, 49.246, 436.481)) then
-- 				if _G.FarmActive then
-- 					currentStep = 3
-- 				end
-- 			end
-- 		end

-- 		if currentStep == 3 and _G.FarmActive then
-- 			local sellPrompt = workspace.NPC.Seller2.HumanoidRootPart.SellSmuggledGoodsPrompt
-- 			if interactWithPrompt(sellPrompt) and _G.FarmActive then
-- 				task.wait(0.5)
-- 				if _G.FarmActive then
-- 					currentStep = 4 
-- 				end
-- 			end
-- 		end
		
-- 		if currentStep == 4 and _G.FarmActive then
-- 			if goToPosition(Vector3.new(65.588, 17.218, 380.733)) and 
-- 			   goToPosition(Vector3.new(53.398, 17.218, 135.798)) and 
-- 			   goToPosition(Vector3.new(728.977, 17.218, 142.617)) and 
-- 			   goToPosition(Vector3.new(2877.611, 17.218, 163.101)) and 
-- 			   goToPosition(Vector3.new(6889.687, 17.218, 140.958)) and 
-- 			   goToPosition(Vector3.new(6840.44140625, 17.416536331176758, -41.43973922729492)) and 
-- 			   goToPosition(Vector3.new(6808.86181640625, 17.442039489746094, -35.175113677978516)) then
-- 				if _G.FarmActive then
-- 					currentStep = 5 
-- 				end
-- 			end
-- 		end
		
-- 		if currentStep == 5 and _G.FarmActive then
-- 			local moneyBeforeLaunder = getMoneyValue()
-- 			local launderPrompt = nil
-- 			local children = workspace.LaunderPrompts:GetChildren()
-- 			local targetBriefcase
-- 			local nearestDistance = math.huge

-- 			for _, laundry in ipairs(children) do
-- 				local promptPart = laundry:FindFirstChild("PromptPart")
-- 				if promptPart and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
-- 					local distance = (plr.Character.HumanoidRootPart.Position - promptPart.Position).Magnitude
-- 					if distance < nearestDistance then
-- 						targetBriefcase = laundry
-- 						nearestDistance = distance
-- 					end
-- 				end
-- 			end
			
-- 			if targetBriefcase then
-- 				local promptPart = targetBriefcase:FindFirstChild("PromptPart")
-- 				if promptPart then
-- 					launderPrompt = promptPart:FindFirstChild("LaunderBriefcasePrompt")
-- 				end
-- 			end
			
-- 			if launderPrompt and interactWithPrompt(launderPrompt) then
-- 				local startTime = os.clock()
-- 				while getMoneyValue() <= moneyBeforeLaunder and (os.clock() - startTime) < 5 and _G.FarmActive do
-- 					task.wait(0.1)
-- 				end
				
-- 				if _G.FarmActive then
-- 					task.wait(0.2)
-- 					currentStep = 1
-- 				end
-- 			else
-- 				task.wait(0.5)
-- 			end
-- 		end
		
-- 		task.wait()
-- 	end
-- end)

-- Rayfield:LoadConfiguration()