-- unoptimized asf + adding saving later

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local cloneref = cloneref or function(...)
	return ... 
end

local RunService       =                            cloneref(game:GetService("RunService")) ::       RunService
local CoreGui          = not RunService:IsStudio() and cloneref(game:GetService("CoreGui"))
local UserInputService =                      cloneref(game:GetService("UserInputService")) :: UserInputService
local Lighting         =                              cloneref(game:GetService("Lighting")) ::         Lighting
local Players          =                               cloneref(game:GetService("Players")) ::          Players
local HttpService      =                           cloneref(game:GetService("HttpService")) ::      HttpService
local TweenService     =                          cloneref(game:GetService("TweenService")) ::     TweenService
local Workspace        =                             cloneref(game:GetService("Workspace")) ::        Workspace

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui") :: PlayerGui
local CAMERA = Workspace.CurrentCamera
local RESIZE_DELAY = 0.3

local library = {}
library.__index = library

function library:CreateWindow(data)
	local self = setmetatable({}, library)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = RunService:IsStudio() and PLAYER_GUI or CoreGui
	ScreenGui.Name = HttpService:GenerateGUID()

	local Window = Instance.new("Frame")
	Window.Parent = ScreenGui
	Window["BorderSizePixel"] = 0
	Window["BackgroundColor3"] = Color3.fromRGB(21, 21, 21)
	Window["AnchorPoint"] = Vector2.new(0.5, 0.5)
	Window["ClipsDescendants"] = true
	Window["Size"] = UDim2.new(0, 750, 0, 500)
	Window["Position"] = UDim2.new(0.5, 0, 0.5, 0)
	Window["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	Window["Name"] = [[Window]]
	Window["BackgroundTransparency"] = 0.2

	local TopBar = Instance.new("Frame")
	TopBar.Parent = Window
	TopBar["BorderSizePixel"] = 0
	TopBar["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	TopBar["AnchorPoint"] = Vector2.new(0.5, 0.5)
	TopBar["Size"] = UDim2.new(1, 0, 0, 40)
	TopBar["Position"] = UDim2.new(0.5, 0, 0, 20)
	TopBar["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	TopBar["Name"] = [[Topbar]]
	TopBar["BackgroundTransparency"] = 0.95

	local PageBar = Instance.new("Frame")
	PageBar.Parent = Window
	PageBar["BorderSizePixel"] = 0
	PageBar["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	PageBar["Size"] = UDim2.new(0, 152, 0, 453)
	PageBar["Position"] = UDim2.new(0, 0, 0.092, 0)
	PageBar["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	PageBar["Name"] = [[Sidebar]]
	PageBar["BackgroundTransparency"] = 1

	local Pages = Instance.new("Frame")
	Pages.Parent = Window
	Pages["BorderSizePixel"] = 0
	Pages["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	Pages["Size"] = UDim2.new(0, 584, 0, 454)
	Pages["Position"] = UDim2.new(0.21333, 0, 0.092, 0)
	Pages["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	Pages["Name"] = [[Pages]]
	Pages["BackgroundTransparency"] = 1

	local Header = Instance.new("TextLabel")
	Header.Parent = TopBar
	Header["TextWrapped"] = true
	Header["BorderSizePixel"] = 0
	Header["TextSize"] = 14
	Header["TextScaled"] = true
	Header["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	Header["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Header["TextColor3"] = Color3.fromRGB(255, 255, 255)
	Header["BackgroundTransparency"] = 1
	Header["AnchorPoint"] = Vector2.new(0.5, 0.5)
	Header["Size"] = UDim2.new(1, 0, 0, 20)
	Header["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	Header["Name"] = "Header"
	Header["Position"] = UDim2.new(0.5, 0, 0.5, 0)
	Header.Text = data and data.Name or "Script"

	local PageBarPadding = Instance.new("UIListLayout")
	PageBarPadding.Parent = PageBar
	PageBarPadding["HorizontalAlignment"] = Enum.HorizontalAlignment.Right
	PageBarPadding["Padding"] = UDim.new(0, 3)
	PageBarPadding["SortOrder"] = Enum.SortOrder.LayoutOrder

	self.Pages = {}
	self.PageBar = PageBar
	self.PageDisplays = Pages
	
	if not data or data and not data.RemoveBlur then
		local MTREL = "Glass"
		local root = Instance.new('Folder', CAMERA)
		local wedgeguid = HttpService:GenerateGUID(true)
		root.Name = HttpService:GenerateGUID(true)

		local DepthOfField

		for _,v in pairs(game:GetService("Lighting"):GetChildren()) do
			if not v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
				DepthOfField = Instance.new('DepthOfFieldEffect', game:GetService('Lighting'))
				DepthOfField.FarIntensity = 0
				DepthOfField.FocusDistance = 51.6
				DepthOfField.InFocusRadius = 50
				DepthOfField.NearIntensity = 1
				DepthOfField.Name = HttpService:GenerateGUID(true)
				DepthOfField:AddTag(".")
			elseif v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
				DepthOfField = v
			end
		end

		if not DepthOfField then
			DepthOfField = Instance.new('DepthOfFieldEffect', game:GetService('Lighting'))
			DepthOfField.FarIntensity = 0
			DepthOfField.FocusDistance = 51.6
			DepthOfField.InFocusRadius = 50
			DepthOfField.NearIntensity = 1
			DepthOfField.Name = HttpService:GenerateGUID(true)
			DepthOfField:AddTag(".")
		end

		local frame = Instance.new('Frame')
		frame.Parent = Window
		frame.Size = UDim2.new(0.97, 0, 0.97, 0)
		frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BackgroundTransparency = 1
		frame.Name = HttpService:GenerateGUID(true)

		do
			local function IsNotNaN(x)
				return x == x
			end
			local continue = IsNotNaN(CAMERA:ScreenPointToRay(0,0).Origin.x)
			while not continue do
				RunService.RenderStepped:wait()
				continue = IsNotNaN(CAMERA:ScreenPointToRay(0,0).Origin.x)
			end
		end

		local DrawQuint do
			local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
			local sz = 0.2

			function DrawTriangle(v1, v2, v3, p0, p1)
				local s1 = (v1 - v2).magnitude
				local s2 = (v2 - v3).magnitude
				local s3 = (v3 - v1).magnitude
				local smax = max(s1, s2, s3)
				local A, B, C
				if s1 == smax then
					A, B, C = v1, v2, v3
				elseif s2 == smax then
					A, B, C = v2, v3, v1
				elseif s3 == smax then
					A, B, C = v3, v1, v2
				end

				local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
				local perp = sqrt((C-A).magnitude^2 - para*para)
				local dif_para = (A - B).magnitude - para

				local st = CFrame.new(B, A)
				local za = CFrame.Angles(pi/2,0,0)

				local cf0 = st

				local Top_Look = (cf0 * za).lookVector
				local Mid_Point = A + CFrame.new(A, B).lookVector * para
				local Needed_Look = CFrame.new(Mid_Point, C).lookVector
				local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

				local ac = CFrame.Angles(0, 0, acos(dot))

				cf0 = cf0 * ac
				if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
					cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
				end
				cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

				local cf1 = st * ac * CFrame.Angles(0, pi, 0)
				if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
					cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
				end
				cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

				if not p0 then
					p0 = Instance.new('Part')
					p0.FormFactor = 'Custom'
					p0.TopSurface = 0
					p0.BottomSurface = 0
					p0.Anchored = true
					p0.CanCollide = false
					p0.CastShadow = false
					p0.Material = MTREL
					p0.Size = Vector3.new(sz, sz, sz)
					p0.Name = HttpService:GenerateGUID(true)
					local mesh = Instance.new('SpecialMesh', p0)
					mesh.MeshType = 2
					mesh.Name = wedgeguid
				end
				p0[wedgeguid].Scale = Vector3.new(0, perp/sz, para/sz)
				p0.CFrame = cf0

				if not p1 then
					p1 = p0:clone()
				end
				p1[wedgeguid].Scale = Vector3.new(0, perp/sz, dif_para/sz)
				p1.CFrame = cf1

				return p0, p1
			end

			function DrawQuint(v1, v2, v3, v4, parts)
				parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
				parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
			end
		end

		local parts = {}
		local f = Instance.new('Folder', root)
		f.Name = HttpService:GenerateGUID(true)

		local parents = {}
		do
			local function add(child)
				if child:IsA'GuiObject' then
					parents[#parents + 1] = child
					add(child.Parent)
				end
			end
			add(frame)
		end

		local function IsVisible(instance)
			while instance do
				if instance:IsA("GuiObject") then
					if not instance.Visible then
						return false
					end
				elseif instance:IsA("ScreenGui") then
					if not instance.Enabled then
						return false
					end
					break
				end
				instance = instance.Parent
			end
			return true
		end

		local function UpdateOrientation(fetchProps)
			if not IsVisible(frame) then
				for _, pt in pairs(parts) do
					pt.Parent = nil
				end
				return
			end

			local properties = {
				Transparency = 0.98,
				BrickColor = BrickColor.new('Institutional white')
			}
			local zIndex = 1 - 0.05*frame.ZIndex

			local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
			local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
			do
				local rot = 0
				for _, v in ipairs(parents) do
					rot = rot + v.Rotation
				end
				if rot ~= 0 and rot%180 ~= 0 then
					local mid = tl:lerp(br, 0.5)
					local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
					local vec = tl
					tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
					tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
					bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
					br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
				end
			end
			DrawQuint(
				CAMERA:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
				CAMERA:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
				CAMERA:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
				CAMERA:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
				parts
			)
			if fetchProps then
				for _, pt in pairs(parts) do
					pt.Parent = f
				end
				for propName, propValue in pairs(properties) do
					for _, pt in pairs(parts) do
						pt[propName] = propValue
					end
				end
			end
		end

		UpdateOrientation(true)
		RunService:BindToRenderStep(HttpService:GenerateGUID(true), 2000, UpdateOrientation)
	end
	
	local frame = Window

	local dragToggle = nil
	local dragSpeed = 0.1
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end

	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)

	return self
end

function library:CreatePage(data)
	if not self.PageBar or not self.PageDisplays or not self.Pages then
		error("Self is missing index(s)")
		return
	end

	data = data or {}

	local PageId = HttpService:GenerateGUID()
	local PageSelected 
	local down
	local entered

	local Page = Instance.new("CanvasGroup")
	Page.Size = UDim2.new(1,0,1,0)
	Page.AnchorPoint = Vector2.new(0.5,0.5)
	Page.Position = UDim2.new(0.5,0,0.6,0)
	Page.BackgroundTransparency = 1
	Page.GroupTransparency = 1 -- 0
	Page.Parent = self.PageDisplays
	Page.Name = PageId
	Page.Interactable = nil

	local PageSelector = Instance.new("TextButton")
	PageSelector.Parent = self.PageBar
	PageSelector["BorderSizePixel"] = 0
	PageSelector["TextSize"] = 14
	PageSelector["AutoButtonColor"] = false
	PageSelector["TextColor3"] = Color3.fromRGB(0, 0, 0)
	PageSelector["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	PageSelector["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	PageSelector["BackgroundTransparency"] = 1 -- 0.95
	PageSelector["Size"] = UDim2.new(0.97, 0, 0, 35)
	PageSelector["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	PageSelector["Text"] = ""
	PageSelector["Name"] = PageId

	local PageSelectorCorner = Instance.new("UICorner")
	PageSelectorCorner.Parent = PageSelector
	PageSelectorCorner["CornerRadius"] = UDim.new(0, 4)

	local PageSelectorName = Instance.new("TextLabel")
	PageSelectorName.Parent = PageSelector
	PageSelectorName["TextWrapped"] = true
	PageSelectorName["BorderSizePixel"] = 0
	PageSelectorName["TextSize"] = 14
	PageSelectorName["TextXAlignment"] = Enum.TextXAlignment.Left
	PageSelectorName["TextScaled"] = true
	PageSelectorName["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	PageSelectorName["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	PageSelectorName["TextColor3"] = Color3.fromRGB(255, 255, 255)
	PageSelectorName["BackgroundTransparency"] = 1
	PageSelectorName["AnchorPoint"] = Vector2.new(0.5, 0.5)
	PageSelectorName["Size"] = UDim2.new(0.9, 0, 0, 15)
	PageSelectorName["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	PageSelectorName["Name"] = [[Name]]
	PageSelectorName["Position"] = UDim2.new(0.5, 0, 0.5, 0)
	PageSelectorName.Text = data.Name or "Page"

	local PageSelectorIndicator = Instance.new("Frame")
	PageSelectorIndicator.Parent = PageSelector
	PageSelectorIndicator["BorderSizePixel"] = 0
	PageSelectorIndicator["BackgroundColor3"] = Color3.fromRGB(182, 129, 255)
	PageSelectorIndicator["AnchorPoint"] = Vector2.new(0.5, 0.5)
	PageSelectorIndicator["Size"] = UDim2.new(0, 2, 1, 0)
	PageSelectorIndicator["Position"] = UDim2.new(1, -1, 0.5, 0)
	PageSelectorIndicator["BorderColor3"] = Color3.fromRGB(0, 0, 0)
	PageSelectorIndicator["Name"] = [[Indicator]]
	PageSelectorIndicator["BackgroundTransparency"] = 1 -- 0.2
	
	local Left
	local Right
	local Main
	
	if data.Sectioned then
		Left = Instance.new("ScrollingFrame")
		Left.Size = UDim2.new(0.49,0,1,0)
		Left.BackgroundTransparency = 1
		Left.BorderSizePixel = 0
		Left.AnchorPoint = Vector2.new(0.5,0.5)
		Left.CanvasSize = UDim2.new(0,0,0,0)
		Left.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Left.ScrollBarThickness = 0
		Left.ClipsDescendants = nil
		
		local LeftPadding = Instance.new("UIListLayout")
		LeftPadding.HorizontalAlignment = Enum.HorizontalAlignment.Right
		LeftPadding.Padding = UDim.new(0, 3)
		LeftPadding.SortOrder = Enum.SortOrder.LayoutOrder
		
		Right = Left:Clone()
		local RightPadding = LeftPadding:Clone()
		
		Right.Parent = Page
		RightPadding.Parent = Right
		Left.Parent = Page
		LeftPadding.Parent = Left
		
		Left.Position = UDim2.new(0.25, 0, 0.5, 0)
		Right.Position = UDim2.new(0.75, 0, 0.5 ,0)
	else
		Main = Instance.new("ScrollingFrame")
		Main.Size = UDim2.new(0.99,0,1,0)
		Main.BackgroundTransparency = 1
		Main.BorderSizePixel = 0
		Main.Parent = Page
		Main.AnchorPoint = Vector2.new(0.5,0.5)
		Main.Position = UDim2.new(0.5,0,0.5,0)
		Main.CanvasSize = UDim2.new(0,0,0,0)
		Main.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Main.ScrollBarThickness = 0
		Main.ClipsDescendants = nil
		
		local Padding = Instance.new("UIListLayout")
		Padding.HorizontalAlignment = Enum.HorizontalAlignment.Right
		Padding.Padding = UDim.new(0, 3)
		Padding.SortOrder = Enum.SortOrder.LayoutOrder
		Padding.Parent = Main
	end

	for i, v in pairs(self.Pages) do
		if data.ActivePage then
			self.Pages[i] = false
			self.PageDisplays:FindFirstChild(i).GroupTransparency = 1
			self.PageDisplays:FindFirstChild(i).Position = UDim2.new(0.5, 0, 0.6, 0)
			self.PageDisplays:FindFirstChild(i).Interactable = nil
			self.PageBar:FindFirstChild(i).BackgroundTransparency = 1
			self.PageBar:FindFirstChild(i).Indicator.BackgroundTransparency = 1
		end

		if v then
			PageSelected = true
			break
		end
	end

	if not PageSelected then
		PageSelector.BackgroundTransparency = 0.95
		Page.GroupTransparency = 0
		Page.Position = UDim2.new(0.5,0,0.5,0)
		Page.Interactable = true
		PageSelectorIndicator.BackgroundTransparency = 0.2
	end

	self.Pages[PageId] = not PageSelected

	PageSelector.MouseEnter:Connect(function()
		entered = true
		if down then
			return
		end
		TweenService:Create(PageSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
	end)

	PageSelector.MouseLeave:Connect(function()
		entered = nil
		if not self.Pages[PageId] and not down then
			TweenService:Create(PageSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
		end
	end)
	
	PageSelector.MouseButton1Down:Connect(function()
		down = true
		TweenService:Create(PageSelector, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
	end)
	
	PageSelector.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not down then
				return
			end
			down = nil
			
			if entered then
				TweenService:Create(PageSelector, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			else
				TweenService:Create(PageSelector, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			end
			
			if self.Pages[PageId] then
				return
			end

			for i, v in pairs(self.Pages) do
				if v then
					self.Pages[i] = false
					TweenService:Create(self.PageBar:FindFirstChild(i), TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					TweenService:Create(self.PageBar:FindFirstChild(i).Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					TweenService:Create(self.PageDisplays:FindFirstChild(i), TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.6, 0)}):Play()
					TweenService:Create(self.PageDisplays:FindFirstChild(i), TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 1}):Play()
				end
				self.PageDisplays:FindFirstChild(i).Interactable = nil
			end

			Page.Interactable = true

			TweenService:Create(Page, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
			TweenService:Create(Page, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
			TweenService:Create(PageSelector, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			TweenService:Create(PageSelectorIndicator, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
			
			for i, v in ipairs(Page:GetChildren()) do
				for i, v in ipairs(v:GetChildren()) do
					if v:FindFirstChild("Bar") then
						v.Bar.Circle.Position = UDim2.new(0,0,0.5,0)
						v.Bar.Progress.Size = UDim2.new(0,0,1,0)
						
						TweenService:Create(v.Bar.Circle, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(v:GetAttribute("progress"), 0, 0.5, 0)}):Play()
						TweenService:Create(v.Bar.Progress, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(v:GetAttribute("progress"), 0, 1, 0)}):Play()
					elseif v:FindFirstChild("Toggle") then
						v.Toggle.Circle.Position = UDim2.new(0.09, 7,0.5, 0)
						v.Toggle.Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
						
						if v:GetAttribute("enabled") then
							TweenService:Create(v.Toggle.Circle, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(181, 128, 255), Position = UDim2.new(0.91, -7,0.5, 0)}):Play()
						end
					end
				end
			end

			self.Pages[PageId] = true
		end
	end)
	
	local Page = {}
	
	function Page:CreateLabel(labelData)
		labelData = labelData or {}
		
		local Label = Instance.new("TextLabel")
		Label.Parent = (data.Sectioned and string.find(labelData.Side and labelData.Side:lower() or "","right") and Right or Left) or Main
		Label["TextWrapped"] = true
		Label["BorderSizePixel"] = 0
		Label["TextSize"] = 14
		Label["TextXAlignment"] = Enum.TextXAlignment.Left
		Label["TextScaled"] = true
		Label["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Label["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Label["TextColor3"] = Color3.fromRGB(255, 255, 255)
		Label["BackgroundTransparency"] = 1
		Label["Size"] = UDim2.new(1, 0, 0, 15)
		Label["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Label["Name"] = [[Label]]
		Label.Text = labelData.Name or "Label"
	end
	
	function Page:CreateButton(buttonData)
		buttonData = buttonData or {}
		local entered
		local down
		
		local Button = Instance.new("TextButton")
		Button.Parent = (data.Sectioned and string.find(buttonData.Side and buttonData.Side:lower() or "","right") and Right or Left) or Main
		Button["BorderSizePixel"] = 0
		Button["TextSize"] = 14
		Button["AutoButtonColor"] = false
		Button["TextColor3"] = Color3.fromRGB(0, 0, 0)
		Button["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Button["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Button["BackgroundTransparency"] = 0.95
		Button["Size"] = UDim2.new(1,0,0,30)
		Button["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Button["Text"] = [[]]
		Button["Name"] = [[Button]]

		local Name = Instance.new("TextLabel")
		Name.Parent = Button
		Name["BorderSizePixel"] = 0
		Name["TextSize"] = 14
		Name["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Name["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		Name["TextColor3"] = Color3.fromRGB(255, 255, 255)
		Name["BackgroundTransparency"] = 1
		Name["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Name["Size"] = UDim2.new(1, 0, 0, 20)
		Name["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Name["Text"] = buttonData.Name or "Button"
		Name["Name"] = [[Name]]
		Name["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		Name.TextTransparency = 0.1

		local Corner = Instance.new("UICorner")
		Corner.Parent = Button
		Corner["CornerRadius"] = UDim.new(0, 4)
		
		Button.MouseEnter:Connect(function()
			entered = true
			if down then
				return
			end
			TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		end)
		
		Button.MouseLeave:Connect(function()
			entered = nil
			if down then
				return
			end
			TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.1}):Play()
		end)
		
		Button.MouseButton1Down:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.89}):Play()
			down = true
		end)
		
		Button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not down then
					return
				end
				down = nil

				if entered then
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
				else
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
				end

				if buttonData.Callback then
					buttonData.Callback()
				end
			end
		end)
	end
	
	function Page:CreateToggle(toggleData)
		toggleData = toggleData or {}
		local entered
		local enabled = toggleData.Enabled or false
		local down

		local Toggle = Instance.new("TextButton")
		Toggle.Parent = (data.Sectioned and string.find(toggleData.Side and toggleData.Side:lower() or "","right") and Right or Left) or Main
		Toggle["BorderSizePixel"] = 0
		Toggle["TextSize"] = 14
		Toggle["AutoButtonColor"] = false
		Toggle["TextColor3"] = Color3.fromRGB(0, 0, 0)
		Toggle["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Toggle["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Toggle["BackgroundTransparency"] = 0.95
		Toggle["Size"] = UDim2.new(1, 0, 0, 35)
		Toggle["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Toggle["Text"] = [[]]
		Toggle["Name"] = [[Toggle]]


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.Name
		local Name = Instance.new("TextLabel")
		Name.Parent = Toggle
		Name["BorderSizePixel"] = 0
		Name["TextSize"] = 14
		Name["TextXAlignment"] = Enum.TextXAlignment.Left
		Name["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Name["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Name["TextColor3"] = Color3.fromRGB(255, 255, 255)
		Name["BackgroundTransparency"] = 1
		Name["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Name["Size"] = UDim2.new(0.79522, 0, 0, 20)
		Name["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Name["Text"] = toggleData.Name or "Toggle"
		Name["Name"] = [[Name]]
		Name["Position"] = UDim2.new(0.42261, 0, 0.5, 0)
		Name.TextTransparency = 0.1


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.UICorner
		local Corner = Instance.new("UICorner")
		Corner.Parent = Toggle
		Corner["CornerRadius"] = UDim.new(0, 4)


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.Toggle
		local ToggleBg = Instance.new("Frame")
		ToggleBg.Parent = Toggle
		ToggleBg["BorderSizePixel"] = 0
		ToggleBg["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
		ToggleBg["AnchorPoint"] = Vector2.new(0.5, 0.5)
		ToggleBg["Size"] = UDim2.new(0, 40, 0, 20)
		ToggleBg["Position"] = UDim2.new(0.96, -20, 0.5, 0)
		ToggleBg["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		ToggleBg["Name"] = [[Toggle]]
		ToggleBg["BackgroundTransparency"] = 0.8


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.Toggle.UICorner
		local BgCorner = Instance.new("UICorner")
		BgCorner.Parent = ToggleBg
		BgCorner["CornerRadius"] = UDim.new(0, 9)


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.Toggle.UIStroke
		local Outline = Instance.new("UIStroke")
		Outline.Parent = ToggleBg
		Outline["Transparency"] = 0.95
		Outline["Thickness"] = 2
		Outline["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.Toggle.Circle
		local Circle = Instance.new("Frame")
		Circle.Parent = ToggleBg
		Circle["BorderSizePixel"] = 0
		Circle["BackgroundColor3"] = enabled and Color3.fromRGB(181, 128, 255) or Color3.fromRGB(255,255,255)
		Circle["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Circle["Size"] = UDim2.new(0, 14, 0, 14)
		Circle["Position"] = enabled and UDim2.new(0.91, -7,0.5, 0) or UDim2.new(0.09, 7,0.5, 0)
		Circle["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Circle["Name"] = [[Circle]]
		Circle["BackgroundTransparency"] = 0.2


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Toggle.Toggle.Circle.UICorner
		local CircleCorner = Instance.new("UICorner")
		CircleCorner.Parent = Circle
		CircleCorner["CornerRadius"] = UDim.new(0, 6)
		
		task.spawn(toggleData.Callback or function() end, enabled)
		Toggle:SetAttribute("enabled", enabled)
		
		Toggle.MouseEnter:Connect(function()
			entered = true
			if down then
				return
			end
			TweenService:Create(Toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			
		end)

		Toggle.MouseLeave:Connect(function()
			entered = nil
			if down then
				return
			end
			TweenService:Create(Toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.1}):Play()
		end)
		
		Toggle.MouseButton1Down:Connect(function()
			TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.89}):Play()
			down = true
		end)
		
		Toggle.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not down then
					return
				end
				down = nil

				if entered then
					TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
				else
					TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
				end

				enabled = not enabled
				Toggle:SetAttribute("enabled", enabled)

				TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = enabled and UDim2.new(0.91, -7,0.5, 0) or UDim2.new(0.09, 7,0.5, 0)}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = enabled and Color3.fromRGB(181, 128, 255) or Color3.fromRGB(255,255,255)}):Play()
				local tween = TweenService:Create(Circle, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0,13,0,13)})
				tween:Play()
				task.spawn(function()
					tween.Completed:Wait()
					TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0,14,0,14)}):Play()
				end)
				
				if toggleData.Callback then
					toggleData.Callback(enabled)
				end
			end
		end)
	end
	
	function Page:CreateSlider(sliderData)
		sliderData = sliderData or {}
		local Min = sliderData.MinNumber or 0
		local Max = sliderData.MaxNumber or 100
		local Increment = sliderData.Increment or 1
		local Default = math.clamp(sliderData.Default or Min, Min, Max)
		local dragging
		local entered
		local down
		local value = Default
		
		local Slider = Instance.new("TextButton")
		Slider.Parent = (data.Sectioned and string.find(sliderData.Side and sliderData.Side:lower() or "","right") and Right or Left) or Main
		Slider["BorderSizePixel"] = 0
		Slider["TextSize"] = 14
		Slider["AutoButtonColor"] = false
		Slider["TextColor3"] = Color3.fromRGB(0, 0, 0)
		Slider["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Slider["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Slider["BackgroundTransparency"] = 0.95
		Slider["Size"] = UDim2.new(1, 0, 0, 50)
		Slider["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Slider["Text"] = [[]]
		Slider["Name"] = "Slider"

		local Corner = Instance.new("UICorner")
		Corner.Parent = Slider
		Corner["CornerRadius"] = UDim.new(0, 4)

		local Bar = Instance.new("Frame")
		Bar.Parent = Slider
		Bar["BorderSizePixel"] = 0
		Bar["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
		Bar["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Bar["Size"] = UDim2.new(0.95, 0, 0, 10)
		Bar["Position"] = UDim2.new(0.5, 0, 1, -15)
		Bar["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Bar["Name"] = [[Bar]]
		Bar["BackgroundTransparency"] = 0.8

		local BarCorner = Instance.new("UICorner")
		BarCorner.Parent = Bar
		BarCorner["CornerRadius"] = UDim.new(0, 4)

		local BarIndicator = Instance.new("Frame")
		BarIndicator.Parent = Bar
		BarIndicator["ZIndex"] = 3
		BarIndicator["BorderSizePixel"] = 0
		BarIndicator["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		BarIndicator["AnchorPoint"] = Vector2.new(0.5, 0.5)
		BarIndicator["Size"] = UDim2.new(0, 12, 0, 12)
		BarIndicator["Position"] = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
		BarIndicator["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		BarIndicator["Name"] = [[Circle]]
		BarIndicator["BackgroundTransparency"] = 0.1

		local IndicatorCorner = Instance.new("UICorner")
		IndicatorCorner.Parent = BarIndicator
		IndicatorCorner["CornerRadius"] = UDim.new(0, 999)

		local IndicatorOutline = Instance.new("UIStroke")
		IndicatorOutline.Parent = BarIndicator
		IndicatorOutline["Transparency"] = 0.85
		IndicatorOutline["Thickness"] = 3.25
		IndicatorOutline["Color"] = Color3.fromRGB(255, 255, 255)
		IndicatorOutline["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border

		local BarOutline = Instance.new("UIStroke")
		BarOutline.Parent = Bar
		BarOutline["Transparency"] = 0.95
		BarOutline["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border

		local BarProgress = Instance.new("Frame", Bar)
		BarProgress["BorderSizePixel"] = 0
		BarProgress["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		BarProgress["AnchorPoint"] = Vector2.new(0, 0.5)
		BarProgress["Size"] = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
		BarProgress["Position"] = UDim2.new(0, 0, 0.5, 0)
		BarProgress["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		BarProgress["Name"] = [[Progress]]
		BarProgress["BackgroundTransparency"] = 0.2

		local ProgressCorner = Instance.new("UICorner")
		ProgressCorner.Parent = BarProgress
		ProgressCorner["CornerRadius"] = UDim.new(0, 4)

		local ProgressGradient = Instance.new("UIGradient")
		ProgressGradient.Parent = BarProgress
		ProgressGradient["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(139, 98, 195)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(182, 129, 255))}

		local Name = Instance.new("TextLabel")
		Name.Parent = Slider
		Name["BorderSizePixel"] = 0
		Name["TextSize"] = 14
		Name["TextXAlignment"] = Enum.TextXAlignment.Left
		Name["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Name["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Name["TextColor3"] = Color3.fromRGB(255, 255, 255)
		Name["BackgroundTransparency"] = 1
		Name["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Name["Size"] = UDim2.new(0.79522, 0, 0, 20)
		Name["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Name["Text"] = sliderData.Name or "Slider"
		Name["Name"] = [[Name]]
		Name["Position"] = UDim2.new(0.42261, 0, 0, 15)
		Name.TextTransparency = 0.1

		local ProgressLabel = Instance.new("TextLabel")
		ProgressLabel.Parent = Slider
		ProgressLabel["BorderSizePixel"] = 0
		ProgressLabel["TextSize"] = 14
		ProgressLabel["TextXAlignment"] = Enum.TextXAlignment.Right
		ProgressLabel["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		ProgressLabel["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		ProgressLabel["TextColor3"] = Color3.fromRGB(255, 255, 255)
		ProgressLabel["BackgroundTransparency"] = 1
		ProgressLabel["AnchorPoint"] = Vector2.new(0.5, 0.5)
		ProgressLabel["Size"] = UDim2.new(0.13228, 0, 0, 20)
		ProgressLabel["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		ProgressLabel["Text"] = Default..(sliderData.Prefix or "")
		ProgressLabel["Name"] = [[ProgressLabel]]
		ProgressLabel["Position"] = UDim2.new(0.909, 0, 0, 15)
		
		
		Slider:SetAttribute("progress", (Default - Min) / (Max - Min))
		
		task.spawn(sliderData.Callback or function() end, value)
		
		local function setFromX(x)
			local percent = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,0,1)

			local raw = Min + (Max - Min) * percent
			local step = 1 / Increment
			value = math.clamp(math.floor(raw * step + 0.5) / step, Min, Max)
			
			Slider:SetAttribute("progress", (value - Min) / (Max - Min))
			
			TweenService:Create(BarProgress, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)}):Play()
			TweenService:Create(BarIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new((value - Min) / (Max - Min), 0, 0.5, 0)}):Play()
			ProgressLabel.Text = value..(sliderData.Prefix or "")
		end
		
		Slider.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				setFromX(input.Position.X)
			end
		end)

		Slider.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = nil
				
				if not down then
					return
				end
				down = nil

				if entered then
					TweenService:Create(Slider, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
				else
					TweenService:Create(Slider, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
				end
				
				if sliderData.Callback then
					sliderData.Callback(value)
				end
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				setFromX(input.Position.X)
			end
		end)
		
		Slider.MouseEnter:Connect(function()
			entered = true
			if down then
				return
			end
			TweenService:Create(Slider, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		end)

		Slider.MouseLeave:Connect(function()
			entered = nil
			if down then
				return
			end
			TweenService:Create(Slider, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.1}):Play()
		end)

		Slider.MouseButton1Down:Connect(function()
			TweenService:Create(Slider, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.89}):Play()
			down = true
		end)
	end
	
	function Page:CreateTextbox(textboxData)
		textboxData = textboxData or {}
		
		local Textbox = Instance.new("TextButton")
		Textbox.Parent = (data.Sectioned and string.find(textboxData.Side and textboxData.Side:lower() or "","right") and Right or Left) or Main
		Textbox["BorderSizePixel"] = 0
		Textbox["TextSize"] = 14
		Textbox["AutoButtonColor"] = false
		Textbox["TextColor3"] = Color3.fromRGB(0, 0, 0)
		Textbox["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Textbox["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Textbox["BackgroundTransparency"] = 0.95
		Textbox["Size"] = UDim2.new(1, 0, 0, 40)
		Textbox["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Textbox["Text"] = [[]]
		Textbox["Name"] = [[Textbox]]


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Textbox.Name
		local Name = Instance.new("TextLabel")
		Name.Parent = Textbox
		Name["BorderSizePixel"] = 0
		Name["TextSize"] = 14
		Name["TextXAlignment"] = Enum.TextXAlignment.Left
		Name["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Name["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Name["TextColor3"] = Color3.fromRGB(255, 255, 255)
		Name["BackgroundTransparency"] = 1
		Name["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Name["Size"] = UDim2.new(0.66941, 0, 0, 20)
		Name["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Name["Text"] = textboxData.Name or "Textbox"
		Name["Name"] = [[Name]]
		Name["Position"] = UDim2.new(0.35971, 0, 0.5, 0)
		Name.TextTransparency = 0.1


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Textbox.UICorner
		local TextboxCorner = Instance.new("UICorner")
		TextboxCorner.Parent = Textbox
		TextboxCorner["CornerRadius"] = UDim.new(0, 4)


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Textbox.Input
		local InputBox = Instance.new("TextBox")
		InputBox.Parent = Textbox
		InputBox["CursorPosition"] = -1
		InputBox["Name"] = [[Input]]
		InputBox["PlaceholderColor3"] = Color3.fromRGB(201, 201, 201)
		InputBox["BorderSizePixel"] = 0
		InputBox["TextSize"] = 14
		InputBox["TextColor3"] = Color3.fromRGB(255, 255, 255)
		InputBox["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
		InputBox["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		InputBox["AnchorPoint"] = Vector2.new(1, 0.5)
		InputBox["PlaceholderText"] = textboxData.PlaceholderText or "Enter Text"
		InputBox["Position"] = UDim2.new(0.96, 0, 0.5, 0)
		InputBox["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		InputBox["Text"] = ""
		InputBox["BackgroundTransparency"] = 0.8
		InputBox.Size = UDim2.new(0, InputBox.TextBounds.X + 24, 0, 28)
		
		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Textbox.Input.UICorner
		local InputBoxCorner = Instance.new("UICorner")
		InputBoxCorner.Parent = InputBox
		InputBoxCorner["CornerRadius"] = UDim.new(0, 9)

		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Textbox.Input.UIStroke
		local InputBoxOutline = Instance.new("UIStroke")
		InputBoxOutline.Parent = InputBox
		InputBoxOutline["Transparency"] = 0.95
		InputBoxOutline["Thickness"] = 2
		InputBoxOutline["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
		
		if textboxData.Callback then
			task.spawn(textboxData.Callback, InputBox.Text)
		end
		
		InputBox:GetPropertyChangedSignal("Text"):Connect(function()
			InputBox.Text = InputBox.Text:gsub("[\n\r]+", " ")
			TweenService:Create(InputBox, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, InputBox.TextBounds.X + 24, 0, 28)}):Play()
		end)
		
		Textbox.MouseEnter:Connect(function()
			entered = true
			if down then
				return
			end
			TweenService:Create(Textbox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		end)

		Textbox.MouseLeave:Connect(function()
			entered = nil
			if down then
				return
			end
			TweenService:Create(Textbox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.1}):Play()
		end)

		Textbox.MouseButton1Down:Connect(function()
			TweenService:Create(Textbox, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.89}):Play()
			down = true
		end)
		
		Textbox.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not down then
					return
				end

				down = nil

				if entered then
					TweenService:Create(Textbox, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
				else
					TweenService:Create(Textbox, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
				end
				
				if textboxData.Callback then
					textboxData.Callback(InputBox.Text)
				end
			end
		end)
		
		task.delay(RESIZE_DELAY, function()
			TweenService:Create(InputBox, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, InputBox.TextBounds.X + 24, 0, 28)}):Play()
		end)
	end
	
	function Page:CreateKeybind(keybindData)
		keybindData = keybindData or {}
		local down
		local entered
		local activeKeybind
		local choosingKeybind
		local eligibleKeys = {}
		
		local Keybind = Instance.new("TextButton", (data.Sectioned and string.find(keybindData.Side and keybindData.Side:lower() or "","right") and Right or Left) or Main)
		Keybind["BorderSizePixel"] = 0
		Keybind["TextSize"] = 14
		Keybind["AutoButtonColor"] = false
		Keybind["TextColor3"] = Color3.fromRGB(0, 0, 0)
		Keybind["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Keybind["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Keybind["BackgroundTransparency"] = 0.95
		Keybind["Size"] = UDim2.new(1, 0, 0, 40)
		Keybind["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Keybind["Text"] = [[]]
		Keybind["Name"] = [[Keybind]]


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Keybind.Name
		local Name = Instance.new("TextLabel", Keybind)
		Name["BorderSizePixel"] = 0
		Name["TextSize"] = 14
		Name["TextXAlignment"] = Enum.TextXAlignment.Left
		Name["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Name["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Name["TextColor3"] = Color3.fromRGB(255,255,255)
		Name["BackgroundTransparency"] = 1
		Name["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Name["Size"] = UDim2.new(0.66941, 0, 0, 20)
		Name["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Name["Text"] = keybindData.Name or "Keybind"
		Name["Name"] = [[Name]]
		Name["Position"] = UDim2.new(0.35971, 0, 0.5, 0)
		Name.TextTransparency = 0.1


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Keybind.UICorner
		local KeybindCorner = Instance.new("UICorner", Keybind)
		KeybindCorner["CornerRadius"] = UDim.new(0, 4)


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Keybind.Bind
		local Bind = Instance.new("TextLabel", Keybind)
		Bind["Active"] = false
		Bind["BorderSizePixel"] = 0
		Bind["TextSize"] = 14
		Bind["TextColor3"] = Color3.fromRGB(201, 201, 201)
		Bind["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
		Bind["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		Bind["AnchorPoint"] = Vector2.new(1, 0.5)
		Bind["BackgroundTransparency"] = 0.8
		Bind["BorderColor3"] = Color3.fromRGB(0, 0, 0)
		Bind["Text"] = [[Keybind]]
		Bind["Name"] = [[Bind]]
		Bind["Position"] = UDim2.new(0.96, 0, 0.5, 0)
		Bind.Size = UDim2.new(0, Bind.TextBounds.X + 24, 0, 28)


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Keybind.Bind.UICorner
		local BindCorner = Instance.new("UICorner", Bind)
		BindCorner["CornerRadius"] = UDim.new(0, 9)


		-- StarterGui.ScreenGui.Window.Tabs.Tab.Frame.Keybind.Bind.UIStroke
		local BindOutline = Instance.new("UIStroke", Bind)
		BindOutline["Transparency"] = 0.95
		BindOutline["Thickness"] = 2
		BindOutline["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
		
		Bind:GetPropertyChangedSignal("Text"):Connect(function()
			if Bind.Text == "..." or Bind.Text == "Keybind" then
				TweenService:Create(Bind, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(201,201,201)}):Play()
			else
				TweenService:Create(Bind, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			end
			TweenService:Create(Bind, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, Bind.TextBounds.X + 24, 0, 28)}):Play()
		end)
		
		Keybind.MouseEnter:Connect(function()
			entered = true
			if down then
				return
			end
			TweenService:Create(Keybind, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		end)

		Keybind.MouseLeave:Connect(function()
			entered = nil
			if down then
				return
			end
			TweenService:Create(Keybind, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
			TweenService:Create(Name, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.1}):Play()
		end)

		Keybind.MouseButton1Down:Connect(function()
			TweenService:Create(Keybind, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.89}):Play()
			down = true
		end)

		Keybind.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not down then
					return
				end

				down = nil
				

				if entered then
					TweenService:Create(Keybind, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.92}):Play()
				else
					TweenService:Create(Keybind, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
				end
				
				if not choosingKeybind then
					choosingKeybind = true
					activeKeybind = nil
					Bind.Text = "..."
					task.wait()
					
					local inputBegan = UserInputService.InputBegan:Connect(function(input)
						if input.KeyCode == Enum.KeyCode.Unknown then
							return
						end
						table.insert(eligibleKeys, input.KeyCode)
					end)
					
					local inputEnded; inputEnded = UserInputService.InputEnded:Connect(function(input)
						if input.KeyCode == Enum.KeyCode.Unknown then
							Bind.Text = "Keybind"
							inputBegan:Disconnect()
							inputEnded:Disconnect()
							eligibleKeys = {}
						elseif table.find(eligibleKeys, input.KeyCode) then
							task.delay(0,function()
								activeKeybind = input.KeyCode
							end)
							Bind.Text = input.KeyCode.Name
							inputBegan:Disconnect()
							inputEnded:Disconnect()
							eligibleKeys = {}
						end
						choosingKeybind = nil
					end)
				end
			end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			if choosingKeybind or not activeKeybind then
				return
			end
			
			if input.KeyCode == activeKeybind and keybindData.Callback then
				keybindData.Callback()
			end
		end)
		
		task.delay(RESIZE_DELAY, function()
			TweenService:Create(Bind, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, Bind.TextBounds.X + 24, 0, 28)}):Play()
		end)
	end
	
	
	return Page
end

return library
