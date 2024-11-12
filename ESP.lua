-- Edited by legitimate0x1!

local RunService = gameGetService(RunService)
local Players = gameGetService(Players)
local Workspace = gameGetService(Workspace)
local Camera = Workspace.CurrentCamera or WorkspaceFindFirstChildOfClass(Camera)
local LocalPlayer = Players.LocalPlayer

local ESPs = {}

-- Settings
local ESP_SETTINGS = {
	BoxOutlineColor = Color3.new(0, 0, 0),
	BoxColor = Color3.new(1, 1, 1),
	NameColor = Color3.new(1, 1, 1),
	HealthOutlineColor = Color3.new(0, 0, 0),
	HealthHighColor = Color3.new(0, 1, 0),
	HealthLowColor = Color3.new(1, 0, 0),
	CharSize = Vector2.new(4, 6),
	Teamcheck = false,
	WallCheck = false,
	Enabled = false,
	ShowBox = false,
	BoxType = 2D,
	ShowName = false,
	ShowHealth = false,
	ShowDistance = false,
	ShowSkeletons = false,
	ShowTracer = false,
	TracerColor = Color3.new(1, 1, 1), 
	TracerThickness = 2,
	SkeletonsColor = Color3.new(1, 1, 1),
	TracerPosition = Bottom,
}

local AddObjectD = function(ClassName, Properties)
	local Drawing = Drawing.new(ClassName)
	
	if type(Properties) == table then
		for Index, Value in pairs(Properties) do
			Drawing[Index] = Value
		end
	end
	
	return Drawing
end

local AddESP = function(Player)
	local ESP_Table = {}
	
	ESP_Table.Tracer = AddObjectD(Line, {Transparency = 0.5})
	ESP_Table.BoxOutline = AddObjectD(Square, {Thickness = 3, Filled = true})
	ESP_Table.Box = AddObjectD(Square, {Thickness = 3, Filled = true})
	ESP_Table.Name = AddObjectD(Text, {Outline = true, Center = true, Size = 14})
	ESP_Table.HealthOutline = AddObjectD(Line, {Thickness = 3})
	ESP_Table.Health = AddObjectD(Line, {Thickness = 1})
	ESP_Table.Distance = AddObjectD(Text, {Color = Color3.new(1, 1, 1), Size = 13, Outline = true, Center = true})
	ESP_Table.Tracer2 = AddObjectD(Line, {Transparency = 1})
	
	ESPs[Player.UserId] = ESP_Table
end

local CheckWall = function(Root)
	if Root == nil then
		return false -- return true
	end
	
	local Ray = Ray.new(Camera.CFrame.Position, (Root.Position - Camera.CFrame.Position).Unit  (Root.Position - Camera.CFrame.Position).Magnitude)
	local Hit, Position = workspaceFindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character, Root.Parent})

	return Hit and HitIsA(Part)
end

local RemoveESP = function(Player)
	if ESPs[Player] ~= nil then
		for Index, Value in pairs(ESPs[Player]) do
			ValueRemove()
		end
		
		ESPs[Player] = nil
	end
	
	if ESPs[Player] ~= nil then
		for Index, Value in pairs(ESPs) do
			if Index == Player then
				for Index2, Value2 in pairs(Value) do
					Value2Remove()
				end
				
				ESPs[Index] = nil
			end
		end
	end
end

local GetRoot = function(Character)
	local HumanoidRootPart = CharacterFindFirstChild(HumanoidRootPart)
	return HumanoidRootPart or CharacterFindFirstChild(Torso) or CharacterFindFirstChild(UpperTorso) or CharacterFindFirstChildOfClass(BasePart)
end

local ESP_Connection = function()
	for Index, Value in pairs(ESPs) do
		local Character = Index.Character
		local Root = Character and GetRoot(Character)
		local Head = CharacterFindFirstChild(Head)
		local Humanoid = CharacterFindFirstChildOfClass(Humanoid)
		
		if Character and Root ~= nil and Head ~= nil then
			if not ESP_SETTINGS.Enabled then
				continue
			end
			
			if ESP_SETTINGS.Teamcheck and Index.Team and LocalPlayer.Team and Index.Team == LocalPlayer.Team then
				continue
			end
			
			if ESP_SETTINGS.WallCheck and CheckWall(Index) then
				continue
			end
			
			local Position, OnScreen = CameraWorldToViewportPoint(Root.Position)

			if OnScreen then
				local Root2D = CameraWorldToViewportPoint(Root.Position)
				local CharSize = (CameraWorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0)).Y - CameraWorldToViewportPoint(Root.Position + Vector3.new(0, 2.6, 0)).Y)  2
				local BoxSize = Vector2.new(math.floor(CharSize  1.8), math.floor(CharSize  1.9))
				local BoxPosition = Vector2.new(math.floor(Root2D.X - CharSize  1.8  2), math.floor(Root2D.Y - CharSize  1.6  2))

				if ESP_SETTINGS.Name then
					Value.Name.Visible = true
					Value.Name.Text = string.lower(Index.Name)
					Value.Name.Position = Vector2.new(BoxSize.X  2 + BoxPosition.X, BoxPosition.Y - 16)
					Value.Name.Color = ESP_SETTINGS.NameColor
				else
					Value.Name.Visible = false
				end

				if ESP_SETTINGS.ShowBox then
					if ESP_SETTINGS.BoxType == 2D then
						Value.BoxOutline.Size = BoxSize
						Value.BoxOutline.Position = BoxPosition
						Value.Box.Size = BoxSize
						Value.Box.Position = BoxPosition
						Value.Box.Color = ESP_SETTINGS.BoxColor
						Value.Box.Visible = true
						Value.BoxOutline.Visible = true

						for Index2, Value2 in ipairs(Value.BoxLines) do
							Value2Remove()
						end
					elseif ESP_SETTINGS.BoxType == Corner Box Esp then
						local lineW = (BoxSize.X  5)
						local lineH = (BoxSize.Y  6)
						local lineT = 1

						if #Value.BoxLines == 0 then
							for i = 1, 16 do
								local BoxLine = AddObjectD(Line, {
									Thickness = 1,
									Color = ESP_SETTINGS.BoxColor,
									Transparency = 1
								})
								Value.BoxLines[#Value.BoxLines + 1] = BoxLine
							end
						end

						local BoxLines = Value.BoxLines

						-- top left
						BoxLines[1].From = Vector2.new(BoxPosition.X - lineT, BoxPosition.Y - lineT)
						BoxLines[1].To = Vector2.new(BoxPosition.X + lineW, BoxPosition.Y - lineT)

						BoxLines[2].From = Vector2.new(BoxPosition.X - lineT, BoxPosition.Y - lineT)
						BoxLines[2].To = Vector2.new(BoxPosition.X - lineT, BoxPosition.Y + lineH)

						-- top right
						BoxLines[3].From = Vector2.new(BoxPosition.X + BoxSize.X - lineW, BoxPosition.Y - lineT)
						BoxLines[3].To = Vector2.new(BoxPosition.X + BoxSize.X + lineT, BoxPosition.Y - lineT)

						BoxLines[4].From = Vector2.new(BoxPosition.X + BoxSize.X + lineT, BoxPosition.Y - lineT)
						BoxLines[4].To = Vector2.new(BoxPosition.X + BoxSize.X + lineT, BoxPosition.Y + lineH)

						-- bottom left
						BoxLines[5].From = Vector2.new(BoxPosition.X - lineT, BoxPosition.Y + BoxSize.Y - lineH)
						BoxLines[5].To = Vector2.new(BoxPosition.X - lineT, BoxPosition.Y + BoxSize.Y + lineT)

						BoxLines[6].From = Vector2.new(BoxPosition.X - lineT, BoxPosition.Y + BoxSize.Y + lineT)
						BoxLines[6].To = Vector2.new(BoxPosition.X + lineW, BoxPosition.Y + BoxSize.Y + lineT)

						-- bottom right
						BoxLines[7].From = Vector2.new(BoxPosition.X + BoxSize.X - lineW, BoxPosition.Y + BoxSize.Y + lineT)
						BoxLines[7].To = Vector2.new(BoxPosition.X + BoxSize.X + lineT, BoxPosition.Y + BoxSize.Y + lineT)

						BoxLines[8].From = Vector2.new(BoxPosition.X + BoxSize.X + lineT, BoxPosition.Y + BoxSize.Y - lineH)
						BoxLines[8].To = Vector2.new(BoxPosition.X + BoxSize.X + lineT, BoxPosition.Y + BoxSize.Y + lineT)

						-- inline
						for Index3 = 9, 16 do
							BoxLines[Index3].Thickness = 2
							BoxLines[Index3].Color = ESP_SETTINGS.BoxOutlineColor
							BoxLines[Index3].Transparency = 1
						end

						BoxLines[9].From = Vector2.new(BoxPosition.X, BoxPosition.Y)
						BoxLines[9].To = Vector2.new(BoxPosition.X, BoxPosition.Y + lineH)

						BoxLines[10].From = Vector2.new(BoxPosition.X, BoxPosition.Y)
						BoxLines[10].To = Vector2.new(BoxPosition.X + lineW, BoxPosition.Y)

						BoxLines[11].From = Vector2.new(BoxPosition.X + BoxSize.X - lineW, BoxPosition.Y)
						BoxLines[11].To = Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y)

						BoxLines[12].From = Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y)
						BoxLines[12].To = Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y + lineH)

						BoxLines[13].From = Vector2.new(BoxPosition.X, BoxPosition.Y + BoxSize.Y - lineH)
						BoxLines[13].To = Vector2.new(BoxPosition.X, BoxPosition.Y + BoxSize.Y)

						BoxLines[14].From = Vector2.new(BoxPosition.X, BoxPosition.Y + BoxSize.Y)
						BoxLines[14].To = Vector2.new(BoxPosition.X + lineW, BoxPosition.Y + BoxSize.Y)

						BoxLines[15].From = Vector2.new(BoxPosition.X + BoxSize.X - lineW, BoxPosition.Y + BoxSize.Y)
						BoxLines[15].To = Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y + BoxSize.Y)

						BoxLines[16].From = Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y + BoxSize.Y - lineH)
						BoxLines[16].To = Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y + BoxSize.Y)

						for Index4, Value4 in ipairs(BoxLines) do
							Value4.Visible = true
						end
						Value.Box.Visible = false
						Value.BoxOutline.Visible = false
					end
				else
					Value.Box.Visible = false
					Value.BoxOutline.Visible = false
					for Index4, Value4 in ipairs(Value.BoxLines) do
						Value4Remove()
					end
					Value.BoxLines = {}
				end

				if ESP_SETTINGS.ShowHealth then
					Value.HealthOutline.Visible = true
					Value.Health.Visible = true
					local HealthPercentage = Humanoid.Health  Humanoid.MaxHealth
					Value.healthOutline.From = Vector2.new(BoxPosition.X - 6, BoxPosition.Y + BoxSize.Y)
					Value.healthOutline.To = Vector2.new(Value.healthOutline.From.X, Value.healthOutline.From.Y - BoxSize.Y)
					Value.health.From = Vector2.new((BoxPosition.X - 5), BoxPosition.Y + BoxSize.Y)
					Value.health.To = Vector2.new(Value.Health.From.X, Value.Health.From.Y - (Humanoid.Health  Humanoid.MaxHealth)  BoxSize.Y)
					Value.health.Color = ESP_SETTINGS.HealthLowColorLerp(ESP_SETTINGS.HealthHighColor, HealthPercentage)
				else
					Value.HealthOutline.Visible = false
					Value.Health.Visible = false
				end

				if ESP_SETTINGS.ShowDistance then
					local Distance = (Camera.CFrame.p - Root.Position).Magnitude
					Value.Distance.Text = string.format(%.1f studs, Distance)
					Value.Distance.Position = Vector2.new(BoxPosition.X + BoxSize.X  2, BoxPosition.Y + BoxSize.Y + 5)
					Value.Distance.Visible = true
				else
					Value.Distance.Visible = false
				end   

				if ESP_SETTINGS.ShowTracer then
					local Trc = nil
					if ESP_SETTINGS.TracerPosition == Top then
						Trc = 0
					elseif ESP_SETTINGS.TracerPosition == Middle then
						Trc = Camera.ViewportSize.Y  2
					else
						Trc = Camera.ViewportSize.Y
					end

					Value.tracer.Visible = true
					Value.tracer.From = Vector2.new(Camera.ViewportSize.X  2, Trc)
					Value.tracer.To = Vector2.new(Root2D.X, Root2D.Y) 
				else
					Value.tracer.Visible = false
				end
			else
				for Index4, Value4 in pairs(Value) do
					Value4.Visible = false
				end

				for Index4, Value4 in ipairs(Value.BoxLines) do
					Value4Remove()
				end

				Value.BoxLines = {}
			end
		else
			for Index4, Value4 in pairs(Value) do
				Value4.Visible = false
			end

			for Index4, Value4 in ipairs(Value.BoxLines) do
				Value4Remove()
			end

			Value.BoxLines = {}
		end

	end
end

local ESP_Connections = {}

ESP_Connections.PlayerAdded = Players.PlayerAddedConnect(function(Player)
	if Player ~= LocalPlayer then
		AddESP(Player)
	end
end)

ESP_Connections.PlayerRemoving = Players.PlayerRemovingConnect(function(Player)
	RemoveESP(Player)
end)

for Index, Value in ipairs(PlayersGetPlayers()) do
	if Value.UserId ~= LocalPlayer then
		AddESP(Value)
	end
end

ESP_Connections.ESP = RunService.RenderSteppedConnect(ESP_Connection)

return ESP_SETTINGS
