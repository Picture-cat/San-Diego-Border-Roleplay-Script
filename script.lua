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
         StartOfHeightElCapo = Vector3.new(6604.92919921875, 17.2186279296875, 79.9230728149414),
         GatesElCapo = Vector3.new(6599.42578125, 61.04671096801758, -290.6493835449219),
         RightFountainElCapo = Vector3.new(6630.91455078125, 61.04671096801758, -341.9266662597656),
         EntryMansionElCapo = Vector3.new(6599.29150390625, 64.42216491699219, -412.14984130859375),
         CenterElCapo = Vector3.new(6598.87841796875, 64.49603271484375, -432.0315246582031),
         ElDiabloBoxPos = Vector3.new(6642.54638671875, 64.49603271484375, -433.93896484375),
         ["Crate Of Avacados"] = Vector3.new(6820.89990234375, 17.416330337524414, 33.121734619140625),
         ["Wagyu Beef"] = Vector3.new(6811.15380859375, 17.416330337524414, 34.29124450683594),
         ["Witches Brew"] = Vector3.new(6806.587890625, 17.416330337524414, 32.81328201293945),
         ["Fake Designer Sneakers"] = Vector3.new(6809.890625, 17.416330337524414, 20.172517776489258),
         ["Fake Diamond Ring"] = Vector3.new(6820.6767578125, 17.416330337524414, 20.180002212524414),
         ["Mona Lisa Painting"] = Vector3.new(6807.3896484375, 17.416332244873047, 22.95276641845703),
         ["El Diablo Box"] = {
            PathToBuy = {Spawn, StartOfRoad, StartOfHeightElCapo, GatesElCapo, RightFountainElCapo, EntryMansionElCapo, CenterElCapo, ElDiabloBoxPos},
            PathToBack = {CenterElCapo, EntryMansionElCapo, RightFountainElCapo, GatesElCapo, StartOfHeightElCapo, StartOfRoad}
         }
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
         ["El Diablo Box"] = workspace.WorldBuyableItems.ElCapo["El Diablo Box"]:FindFirstChild("PromptAttachment", true).ProximityPrompt,
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

function TriggerTheProximityPrompt(ProximityPrompt, PositionProx)
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
   camera.CFrame = CFrame.lookAt(camera.CFrame.Position, PositionProx)

   task.wait(0.1)
      
   while not successTrigger do
      fireproximityprompt(ProximityPrompt)
      task.wait(0.5)
      if (rootPart.Position - PositionProx).Magnitude >= 50 then
         GoToPosition(PositionProx)
      end
   end

   task.wait(0.1)

   camera.CameraType = Enum.CameraType.Custom

   ProximityPrompt.RequiresLineOfSight = CurrentLineOfSight
   ProximityPrompt.MaxActivationDistance = MaxActivationDistance
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

            local position = FarmSettings.Civilian.Positions[currentSelectedItems]

            if type(position) == "table" then
               for _, pos in position.PathToBuy do
                  GoToPosition(pos)
               end
            end

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
               TriggerTheProximityPrompt(ProximityPromptForItem, if type(position) == "table" then position.PathToBuy[#position.PathToBuy] else position)
               if CountTheQuanityOfItems(currentSelectedItems) == quanity then
                  break
               end
            end

            if type(position) == "table" then
               for _, pos in position.PathToBack do
                  GoToPosition(pos)
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
               TriggerTheProximityPrompt(FarmSettings.Civilian.ProximityPrompts.SellPlace, FarmSettings.Civilian.Positions.SellPlace)
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

            if not FarmSettings.Civilian.ProximityPrompts.LaunderCash then
               local nearestProx
               local nearestDistance = math.huge

               for _, prox in workspace.LaunderPrompts:GetChildren() do
                  local part = prox.PromptPart

                  if (part.Position - rootPart.Position).Magnitude < nearestDistance then
                     nearestProx = part.LaunderBriefcasePrompt
                     nearestDistance = (part.Position - rootPart.Position).Magnitude
                  end
               end

               FarmSettings.Civilian.ProximityPrompts.LaunderCash = nearestProx
            end

            local currentMoney = GetMoneyValue()

            while true do
               TriggerTheProximityPrompt(FarmSettings.Civilian.ProximityPrompts.LaunderCash, FarmSettings.Civilian.Positions.LaundryProx)
               if currentMoney < GetMoneyValue() then
                  break
               end
            end

            GoToPosition(FarmSettings.Civilian.Positions.EntryLaundry)
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