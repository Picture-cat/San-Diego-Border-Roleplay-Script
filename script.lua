local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

getgenv().RAYFIELD_ASSET_ID = 114586840982735

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local backpack = player.Backpack
local playerGui = player.PlayerGui
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local MoneyTextLabel = playerGui.MainHUDGui.TopRight.Money.TextLabel

local FarmSettings = {
   Civilian = {
      Quanity = 1,
      Items = "Crate Of Avacados",
      Speed = 200,
      Positions = {
         EntryBlackMargetGoodsSpawn = Vector3.new(6829.6552734375, 17.416330337524414, 28.147010803222656),
         Spawn = Vector3.new(6892.57763671875, 17.218589782714844, 36.29505920410156),
         StartOfRoad = Vector3.new(6888.51806640625, 17.218589782714844, 142.9679718017578),
         EndOfRoad = Vector3.new(2935.46044921875, 17.218589782714844, 142.9679718017578),
         StartOfExit = Vector3.new(2866.91943359375, 17.218591690063477, 158.72694396972656),
         EndOFRoadToAmerica = Vector3.new(60.19624328613281, 17.21858787536621, 140.22903442382812),
         ParkingGarageRight = Vector3.new(59.15970230102539, 17.218589782714844, 367.4576110839844),
         ParkingGarageTopRight = Vector3.new(-132.26979064941406, 17.181711196899414, 366.3923034667969),
         EntryParkingGarage = Vector3.new(-128.69837951660156, 17.181711196899414, 513.7661743164062),
         CenterFirstFloorParkingGarage = Vector3.new(-22.171096801757812, 17.21856117248535, 515.5447998046875),
         EntryFirstFloorParkingGarage = Vector3.new(54.17606735229492, 17.21856117248535, 418.3770446777344),
         SecondFloorParkingGarage = Vector3.new(56.145328521728516, 33.26091003417969, 568.1001586914062),
         CenterSecondFloorParkingGarage = Vector3.new(-22.949962615966797, 33.25065231323242, 493.00726318359375),
         EntrySecondFloorParkingGarage = Vector3.new(52.89704895019531, 33.25225067138672, 418.9273681640625),
         ThirdFloorParkingGarage = Vector3.new(54.43683624267578, 49.2608757019043, 567.277587890625),
         SellPlace = Vector3.new(-82.2566909790039, 49.247047424316406, 433.8547668457031),
         EntryLaundry = Vector3.new(6835.8427734375, 17.416330337524414, -42.792808532714844),
         LaundryProx = Vector3.new(6807.75146484375, 17.442039489746094, -34.21133041381836),
         ["Crate Of Avacados"] = Vector3.new(6820.89990234375, 17.416330337524414, 33.121734619140625),
         ["Wagyu Beef"] = Vector3.new(6811.15380859375, 17.416330337524414, 34.29124450683594),
         ["Witches Brew"] = Vector3.new(6806.587890625, 17.416330337524414, 32.81328201293945),
         ["Fake Designer Sneakers"] = Vector3.new(6809.890625, 17.416330337524414, 20.172517776489258),
         ["Fake Diamond Ring"] = Vector3.new(6820.6767578125, 17.416330337524414, 20.180002212524414),
         ["Mona Lisa Painting"] = Vector3.new(6807.3896484375, 17.416332244873047, 22.95276641845703),
         ["El Diablo Box"] = {Spawn} -- Path To El Diablo
      },
      Prices = {
         ["Crate Of Avacados"] = 150,
         ["Wagyu Beef"] = 350,
         ["Witches Brew"] = 500,
         ["Fake Designer Sneakers"] = 700,
         ["Fake Diamond Ring"] = 1000,
         ["Mona Lisa Painting"] = 3750,
         ["El Diablo Box"] = 5250
      },
      ProximityPrompts = {
         ["Crate Of Avacados"] = workspace.WorldBuyableItems.CivilianArea["Crate Of Avacados"].Handle.PromptAttachment.ProximityPrompt,
         ["Wagyu Beef"] = workspace.WorldBuyableItems.CivilianArea["Wagyu Beef"].Handle.PromptAttachment.ProximityPrompt,
         ["Witches Brew"] = workspace.WorldBuyableItems.CivilianArea["Witches Brew"].Handle.PromptAttachment.ProximityPrompt,
         ["Fake Designer Sneakers"] = workspace.WorldBuyableItems.CivilianArea["Fake Designer Sneakers"].Handle.PromptAttachment.ProximityPrompt,
         ["Fake Diamond Ring"] = workspace.WorldBuyableItems.CivilianArea["Fake Diamond Ring"].Handle.PromptAttachment.ProximityPrompt,
         ["Mona Lisa Painting"] = workspace.WorldBuyableItems.CivilianArea["Mona Lisa Painting"].MonaLisaPaint.PromptAttachment.ProximityPrompt,
         ["El Diablo Box"] = workspace.WorldBuyableItems.ElCapo["El Diablo Box"].Mesh.PromptAttachment.ProximityPrompt,
         SellPlace = workspace.NPC.Seller2.HumanoidRootPart.SellSmuggledGoodsPrompt,
         LaunderCash = nil
      }
   },
   UI = {
      CivilianFarmToogler = nil,
      SpeedSlider = nil,
      QuanitySmuggledItemsSlider = nil,
      SmuggledItemsDropdown = nil,
      SavePositionButton = nil
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

   local going = true

	RunService:BindToRenderStep("GoingPosition", 1, function(dt)
		traveledDistance = traveledDistance + (FarmSettings.Civilian.Speed * dt)
		local alpha = math.clamp(traveledDistance / totalDistance, 0, 1)

		rootPart.CFrame = startCFrame:Lerp(targetCFrame, alpha)
		rootPart.AssemblyLinearVelocity = Vector3.zero 

      local currentDistance = (targetVector3 - startCFrame.Position).Magnitude

		if alpha >= 1 then
         going = false
			RunService:UnbindFromRenderStep("GoingPosition")
		end
	end)
   while going do
      task.wait()
   end
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

   camera.CameraType = Enum.CameraType.Scriptable
   camera.CFrame = CFrame.lookAt(camera.CFrame.Position, ProximityPrompt.Parent.Position)

   task.wait(0.05)
      
   while not successTrigger do
      fireproximityprompt(ProximityPrompt)
      task.wait(1)
   end

   task.wait(0.05)

   camera.CameraType = Enum.CameraType.Custom

   ProximityPrompt.RequiresLineOfSight = CurrentLineOfSight
   ProximityPrompt.MaxActivationDistance = CurrentLineOfSight
end

function CountTheQuanityOfItems(ItemName)
   local quanity = 0
   for _, item in backpack:GetChildren() do
      if item.Name == ItemName then
         quanity += 1
      end
   end

   return quanity
end

function NotifyPlayer(TitleF, ContentF)
   Rayfield:Notify({
      Title = TitleF,
      Content = ContentF,
      Duration = 5,
      Image = "triangle-alert",
   })
end

function GetMoneyValue()
	local numbersOnly = {}
	for digit in string.gmatch(MoneyTextLabel.Text, "%d") do
		table.insert(numbersOnly, digit)
	end
	return tonumber(table.concat(numbersOnly)) or false
end

local ThreadFarm

function EnableTheCivilianFarm(Value)
   if Value then
      ThreadFarm = task.spawn(function()
         while true do
            GoToPosition(FarmSettings.Civilian.Positions.Spawn)
            GoToPosition(FarmSettings.Civilian.Positions.EntryBlackMargetGoodsSpawn)

            local currentSelectedItems = FarmSettings.Civilian.Items

            GoToPosition(FarmSettings.Civilian.Positions[currentSelectedItems])

            local quanity = FarmSettings.Civilian.Quanity
            local price = FarmSettings.Civilian.Prices[currentSelectedItems]

            if price * quanity > GetMoneyValue() then
               NotifyPlayer("Not Enough Money", tostring(price).." (Price Of Item) * "..tostring(quanity).." (Quanity) = "..tostring(price * quanity))

               if quanity - 1 == 0 then
                  NotifyPlayer("Not Enough Money", "You don't have money to buy one time")
                  FarmSettings.UI.CivilianFarmToogler:Set(false)
                  ThreadFarm = nil
                  break
               end

               NotifyPlayer("AutoChange", "Script is descreasing your quanity to "..tostring(quanity - 1))
               FarmSettings.UI.QuanitySmuggledItemsSlider:Set(quanity - 1)
               continue
            end

            local ProximityPromptForItem = FarmSettings.Civilian.ProximityPrompts[currentSelectedItems]

            while true do
               TriggerTheProximityPrompt(ProximityPromptForItem)
               if CountTheQuanityOfItems(currentSelectedItems) == quanity then
                  break
               end
            end

            GoToPosition(FarmSettings.Civilian.Positions.Spawn)
            GoToPosition(FarmSettings.Civilian.Positions.StartOfRoad)
            GoToPosition(FarmSettings.Civilian.Positions.EndOfRoad)
            GoToPosition(FarmSettings.Civilian.Positions.StartOfExit)
            GoToPosition(FarmSettings.Civilian.Positions.EndOFRoadToAmerica)
            GoToPosition(FarmSettings.Civilian.Positions.ParkingGarageRight)
            GoToPosition(FarmSettings.Civilian.Positions.ParkingGarageTopRight)
            GoToPosition(FarmSettings.Civilian.Positions.EntryParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.CenterFirstFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.EntryFirstFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.SecondFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.CenterSecondFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.EntrySecondFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.ThirdFloorParkingGarage)

            GoToPosition(FarmSettings.Civilian.Positions.SellPlace)
            while true do
               TriggerTheProximityPrompt(FarmSettings.ProximityPrompts.SellPlace)
               if CountTheQuanityOfItems("Briefcase") == 1 then
                  break
               end
            end

            GoToPosition(FarmSettings.Civilian.Positions.ThirdFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.EntrySecondFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.CenterSecondFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.SecondFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.EntryFirstFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.CenterFirstFloorParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.EntryParkingGarage)
            GoToPosition(FarmSettings.Civilian.Positions.ParkingGarageTopRight)
            GoToPosition(FarmSettings.Civilian.Positions.ParkingGarageRight)
            GoToPosition(FarmSettings.Civilian.Positions.EndOFRoadToAmerica)
            GoToPosition(FarmSettings.Civilian.Positions.StartOfExit)
            GoToPosition(FarmSettings.Civilian.Positions.EndOfRoad)
            GoToPosition(FarmSettings.Civilian.Positions.StartOfRoad)
            GoToPosition(FarmSettings.Civilian.Positions.Spawn)
            GoToPosition(FarmSettings.Civilian.Positions.EntryLaundry)
            GoToPosition(FarmSettings.Civilian.Positions.LaundryProx)

            local currentMoney = getMoneyValue()

            if not FarmSettings.ProximityPrompts.LaunderCash then
               local nearestProx
               local nearestDistance = math.huge

               for _, prox in workspace.LaunderPrompts:GetChildren() do
                  local part = prox.PromptPart

                  if (part.Position - rootPart.Position).Magnitude < nearestDistance then
                     nearestProx = part.LaunderBriefcasePrompt
                     nearestDistance = (part.Position - rootPart.Position).Magnitude
                  end
               end

               FarmSettings.ProximityPrompts.LaunderCash = nearestProx
            end

            while true do
               TriggerTheProximityPrompt(FarmSettings.ProximityPrompts.LaunderCash)
               if currentMoney < getMoneyValue() then
                  break
               end
            end

            GoToPosition(FarmSettings.Positions.EntryLaundry)
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

   FarmSettings.UI.CivilianFarmToogler = CivilianFarmToogler

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

   FarmSettings.UI.SpeedSlider = SpeedSlider

   local QuanityRange = {1,5}

   if El_Capo then
      QuanityRange = {1,8}
   end

   local QuanitySmuggledItemsSlider = FarmTab:CreateSlider({
      Name = "Quanity Of Smuggled Items",
      Range = QuanityRange,
      Increment = 1,
      Suffix = "Smuggled Items",
      CurrentValue = FarmSettings.Civilian.Quanity,
      Flag = "QuanitySmuggledItems",
      Callback = function(Value)
         FarmSettings.Civilian.Quanity = Value
      end,
   })

   FarmSettings.UI.QuanitySmuggledItemsSlider = QuanitySmuggledItemsSlider

   local Items = {"Crate Of Avacados", "Wagyu Beef", "Witches Brew", "Fake Designer Sneakers", "Fake Diamond Ring", "Mona Lisa Painting"}

   if El_Capo then
      table.insert(Items, "El Diablo Box")
   end

   local SmuggledItemsDropdown = FarmTab:CreateDropdown({
      Name = "Sell",
      Options = Items,
      CurrentOption = {FarmSettings.Civilian.Items},
      MultipleOptions = false,
      Flag = "SmuggledItems",
      Callback = function(Options)
         FarmSettings.Civilian.Items = Options[1]
      end,
   })

   FarmSettings.UI.SmuggledItemsDropdown = SmuggledItemsDropdown

   local SavePositionButton = FarmTab:CreateButton({
      Name = "Save Your Position",
      Callback = function()
         local position = rootPart.Position
         local x, y, z = tostring(position.X), tostring(position.Y), tostring(position.Z)
         setclipboard(x..", "..y..", "..z)
      end,
   })

   FarmSettings.UI.SavePositionButton = SavePositionButton

   Rayfield:SetVisibility(true)
end

initUI()

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