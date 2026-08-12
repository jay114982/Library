local players = game:GetService("Players")
local tweenservice = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local runservice = game:GetService("RunService")
local coregui = game:GetService("CoreGui")

local viewport = workspace.CurrentCamera.ViewportSize
local tweeninfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local plrs = game:GetService("Players")
local mouse = plrs.LocalPlayer:GetMouse()

local Library = {}

function Library:validate(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function Library:tween(object, goal, callback)
	local tween = tweenservice:Create(object, tweeninfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function Library:Init(options)
	options = Library:validate({
		name = "🔧 Jay's Library V1",
		version = "1.0"
	}, options or {})

	local GUI = {
		CurrentTab = nil
	}

	GUI["1"] = Instance.new("ScreenGui", runservice:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coregui)
	GUI["1"].Name = "LibraryV1"
	GUI["1"].IgnoreGuiInset = true
	GUI["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	GUI["2"] = Instance.new("Frame", GUI["1"])
	GUI["2"].BorderSizePixel = 0
	GUI["2"].BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	GUI["2"].AnchorPoint = Vector2.new(0.5, 0.5)
	GUI["2"].Size = UDim2.new(0, 550, 0, 350)
	GUI["2"].Position = UDim2.new(0.5, 0, 0.5, 0)
	GUI["2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["2"].Name = "MainFrame"

	GUI["3"] = Instance.new("UICorner", GUI["2"])
	GUI["3"].CornerRadius = UDim.new(0, 12)

	GUI["4"] = Instance.new("Frame", GUI["2"])
	GUI["4"].ZIndex = 5
	GUI["4"].BorderSizePixel = 0
	GUI["4"].BackgroundColor3 = Color3.fromRGB(49, 49, 49)
	GUI["4"].Size = UDim2.new(1, 0, 0.004, 0)
	GUI["4"].Position = UDim2.new(0, 0, 0.12, 0)
	GUI["4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["4"].Name = "Divider"

	GUI["5"] = Instance.new("Frame", GUI["2"])
	GUI["5"].ZIndex = 5
	GUI["5"].BorderSizePixel = 0
	GUI["5"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	GUI["5"].Size = UDim2.new(1, 0, 0.12, 0)
	GUI["5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["5"].Name = "TopBar"

	GUI["6"] = Instance.new("UICorner", GUI["5"])
	GUI["6"].CornerRadius = UDim.new(0, 12)

	local TopBar = GUI["5"]
	local MainFrame = GUI["2"]
	local dragging = false
	local dragStart = nil
	local startPos = nil
	local dragInput = nil
	local dragTime = 0.06

	local function update(input)
		local delta = input.Position - dragStart
		local goal = {
			Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		}
		tweenservice:Create(
			MainFrame,
			TweenInfo.new(dragTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			goal
		):Play()
	end

	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			local connection
			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end)

	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	uis.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			update(input)
		end
	end)

	local minimize = false
	local destroy = false
	local destroydebounce = false

	GUI["7"] = Instance.new("Frame", GUI["5"])
	GUI["7"].ZIndex = 3
	GUI["7"].BorderSizePixel = 0
	GUI["7"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	GUI["7"].AnchorPoint = Vector2.new(0.5, 0)
	GUI["7"].Size = UDim2.new(0.93, 0, 1, 0)
	GUI["7"].Position = UDim2.new(0.5, 0, 0, 0)
	GUI["7"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["7"].Name = "Container"
	GUI["7"].BackgroundTransparency = 1

	GUI["8"] = Instance.new("ImageLabel", GUI["7"])
	GUI["8"].BorderSizePixel = 0
	GUI["8"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["8"].ImageTransparency = 0.5
	GUI["8"].AnchorPoint = Vector2.new(0, 0.5)
	GUI["8"].Image = "rbxassetid://89147088704149"
	GUI["8"].Size = UDim2.new(0, 12, 0, 12)
	GUI["8"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["8"].BackgroundTransparency = 1
	GUI["8"].Name = "Minimize"
	GUI["8"].Position = UDim2.new(0.923, 0, 0.5, 0)
	GUI["8"].Active = true

	local destroyimage = {
		image1 = "rbxassetid://89843746726080",
		image2 = "rbxassetid://89271200625771"
	}

	GUI["9"] = Instance.new("ImageLabel", GUI["7"])
	GUI["9"].BorderSizePixel = 0
	GUI["9"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["9"].ImageTransparency = 0.3
	GUI["9"].AnchorPoint = Vector2.new(0, 0.5)
	GUI["9"].Image = destroyimage.image1
	GUI["9"].Size = UDim2.new(0, 14, 0, 14)
	GUI["9"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["9"].BackgroundTransparency = 1
	GUI["9"].Name = "Destroy"
	GUI["9"].Position = UDim2.new(0.98, 0, 0.5, 0)
	GUI["9"].Active = true

	GUI["b"] = Instance.new("Frame", GUI["5"])
	GUI["b"].ZIndex = 3
	GUI["b"].BorderSizePixel = 0
	GUI["b"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	GUI["b"].AnchorPoint = Vector2.new(0.5, 0)
	GUI["b"].Size = UDim2.new(1, 0, 1, 0)
	GUI["b"].Position = UDim2.new(0.5, 0, 0, 0)
	GUI["b"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["b"].Name = "Title"
	GUI["b"].BackgroundTransparency = 1

	GUI["c"] = Instance.new("TextLabel", GUI["b"])
	GUI["c"].BorderSizePixel = 0
	GUI["c"].TextSize = 16
	GUI["c"].TextXAlignment = Enum.TextXAlignment.Left
	GUI["c"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["c"].FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	GUI["c"].TextColor3 = Color3.fromRGB(191, 191, 191)
	GUI["c"].BackgroundTransparency = 1
	GUI["c"].Size = UDim2.new(0, 0, 1, 0)
	GUI["c"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["c"].Text = options.name
	GUI["c"].AutomaticSize = Enum.AutomaticSize.X
	GUI["c"].Name = "Title"

	GUI["d"] = Instance.new("UIPadding", GUI["c"])
	GUI["d"].PaddingLeft = UDim.new(0, 12)

	GUI["e"] = Instance.new("TextLabel", GUI["b"])
	GUI["e"].BorderSizePixel = 0
	GUI["e"].TextSize = 16
	GUI["e"].TextXAlignment = Enum.TextXAlignment.Left
	GUI["e"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["e"].FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	GUI["e"].TextColor3 = Color3.fromRGB(127, 127, 127)
	GUI["e"].BackgroundTransparency = 1
	GUI["e"].Size = UDim2.new(0, 0, 1, 0)
	GUI["e"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["e"].Text = options.version
	GUI["e"].AutomaticSize = Enum.AutomaticSize.X
	GUI["e"].Name = "Version"

	GUI["f"] = Instance.new("UIPadding", GUI["e"])
	GUI["f"].PaddingLeft = UDim.new(0, 8)

	GUI["10"] = Instance.new("UIListLayout", GUI["b"])
	GUI["10"].SortOrder = Enum.SortOrder.LayoutOrder
	GUI["10"].FillDirection = Enum.FillDirection.Horizontal

	GUI["11"] = Instance.new("Frame", GUI["5"])
	GUI["11"].BorderSizePixel = 0
	GUI["11"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	GUI["11"].Size = UDim2.new(1, 0, 0.35, 0)
	GUI["11"].Position = UDim2.new(0, 0, 0.65, 0)
	GUI["11"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["11"].Name = "Hide"

	GUI["11"] = Instance.new("Frame", GUI["2"])
	GUI["11"].BorderSizePixel = 0
	GUI["11"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["11"].AnchorPoint = Vector2.new(0, 0.5)
	GUI["11"].Size = UDim2.new(1, 0, 0.88, 0)
	GUI["11"].Position = UDim2.new(0, 0, 0.56, 0)
	GUI["11"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["11"].Name = "MainContainer"
	GUI["11"].BackgroundTransparency = 1

	GUI["aa"] = Instance.new("Frame", GUI["11"])
	GUI["aa"].ZIndex = 0
	GUI["aa"].BorderSizePixel = 0
	GUI["aa"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	GUI["aa"].Size = UDim2.new(0, 20, 0, 20)
	GUI["aa"].Position = UDim2.new(0.963, 0, 0, 0)
	GUI["aa"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["aa"].Name = "Hide"

	GUI["ab"] = Instance.new("Frame", GUI["11"])
	GUI["ab"].ZIndex = 0
	GUI["ab"].BorderSizePixel = 0
	GUI["ab"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	GUI["ab"].Size = UDim2.new(0, 20, 1, 0)
	GUI["ab"].Position = UDim2.new(0.32, 0, 0, 0)
	GUI["ab"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["ab"].Name = "Hide"

	GUI["12"] = Instance.new("Frame", GUI["11"])
	GUI["12"].ZIndex = 5
	GUI["12"].BorderSizePixel = 0
	GUI["12"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["12"].Size = UDim2.new(0.32, 0, 1, 0)
	GUI["12"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["12"].Name = "TabsContainer"
	GUI["12"].BackgroundTransparency = 1

	GUI["13"] = Instance.new("Frame", GUI["12"])
	GUI["13"].BorderSizePixel = 0
	GUI["13"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["13"].AnchorPoint = Vector2.new(0.5, 0.5)
	GUI["13"].Size = UDim2.new(0.93, 0, 0.93, 0)
	GUI["13"].Position = UDim2.new(0.5, 0, 0.5, 0)
	GUI["13"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["13"].Name = "ButtonContainer"
	GUI["13"].BackgroundTransparency = 1

	GUI["14"] = Instance.new("UIListLayout", GUI["13"])
	GUI["14"].HorizontalAlignment = Enum.HorizontalAlignment.Center
	GUI["14"].Padding = UDim.new(0, 5)
	GUI["14"].SortOrder = Enum.SortOrder.LayoutOrder

	GUI["21"] = Instance.new("Frame", GUI["11"])
	GUI["21"].BorderSizePixel = 0
	GUI["21"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUI["21"].AnchorPoint = Vector2.new(0.5, 0.5)
	GUI["21"].Size = UDim2.new(0.68, 0, 1, 0)
	GUI["21"].Position = UDim2.new(1, 0, 1, 0)
	GUI["21"].BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUI["21"].Name = "RightContainer"
	GUI["21"].BackgroundTransparency = 1

	GUI["8"].InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not minimize then
				minimize = true
				GUI["11"].Visible = false
				GUI["2"].BackgroundTransparency = 1
			else
				minimize = false
				GUI["11"].Visible = true
				GUI["2"].BackgroundTransparency = 0
			end
		end
	end)

	GUI["9"].InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if destroydebounce then return end
		if not destroy then
			destroy = true
			GUI["9"].Image = destroyimage.image2
			task.delay(4, function()
				if destroy then
					destroy = false
					GUI["9"].Image = destroyimage.image1
				end
			end)
		else
			destroydebounce = true
			GUI["1"]:Destroy()
		end
	end)

	function GUI:CreateTab(options)
		options = Library:validate({
			name = "Tab",
			icon = "rbxassetid://119583025383040"
		}, options or {})

		local Tab = {
			Hover = false,
			Active = false
		}

		Tab["1b"] = Instance.new("CanvasGroup", GUI["13"])
		Tab["1b"].BorderSizePixel = 0
		Tab["1b"].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		Tab["1b"].Size = UDim2.new(0, 160, 0, 30)
		Tab["1b"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["1b"].Name = "TabButton"
		Tab["1b"].Active = true

		Tab["1c"] = Instance.new("TextLabel", Tab["1b"])
		Tab["1c"].BorderSizePixel = 0
		Tab["1c"].TextSize = 19
		Tab["1c"].BackgroundColor3 = Color3.fromRGB(67, 67, 67)
		Tab["1c"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Tab["1c"].TextColor3 = Color3.fromRGB(167, 167, 167)
		Tab["1c"].BackgroundTransparency = 1
		Tab["1c"].Size = UDim2.new(0, 160, 0, 30)
		Tab["1c"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["1c"].Text = options.name

		Tab["1d"] = Instance.new("UIStroke", Tab["1c"])
		Tab["1d"].Transparency = 0.2
		Tab["1d"].Color = Color3.fromRGB(40, 40, 40)

		Tab["1e"] = Instance.new("UICorner", Tab["1b"])
		Tab["1e"].CornerRadius = UDim.new(0, 20)

		Tab["1f"] = Instance.new("ImageLabel", Tab["1b"])
		Tab["1f"].BorderSizePixel = 0
		Tab["1f"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab["1f"].ImageTransparency = 0.2
		Tab["1f"].AnchorPoint = Vector2.new(0.5, 0.5)
		Tab["1f"].Image = options.icon
		Tab["1f"].Size = UDim2.new(0, 25, 0, 25)
		Tab["1f"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["1f"].BackgroundTransparency = 1
		Tab["1f"].Position = UDim2.new(0.15, 0, 0.5, 0)

		Tab["20"] = Instance.new("UIStroke", Tab["1b"])
		Tab["20"].Transparency = 0.2
		Tab["20"].Color = Color3.fromRGB(50, 50, 50)

		Tab["23a"] = Instance.new("ScrollingFrame", GUI["21"])
		Tab["23a"].Active = false
		Tab["23a"].BorderSizePixel = 0
		Tab["23a"].CanvasSize = UDim2.new(0, 0, 0, 0)
		Tab["23a"].CanvasPosition = Vector2.new(0, 22)
		Tab["23a"].Name = "Tab"
		Tab["23a"].ScrollBarImageTransparency = 1
		Tab["23a"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Tab["23a"].AnchorPoint = Vector2.new(0.5, 0.5)
		Tab["23a"].AutomaticCanvasSize = Enum.AutomaticSize.Y
		Tab["23a"].Size = UDim2.new(1, 0, 1, 0)
		Tab["23a"].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
		Tab["23a"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["23a"].ScrollBarThickness = 0
		Tab["23a"].Visible = false

		Tab["a7"] = Instance.new("UICorner", Tab["23a"])
		Tab["a7"].CornerRadius = UDim.new(0, 12)

		Tab["a8"] = Instance.new("Frame", Tab["23a"])
		Tab["a8"].ZIndex = 5
		Tab["a8"].BorderSizePixel = 0
		Tab["a8"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab["a8"].Size = UDim2.new(1, 0, 0, 35)
		Tab["a8"].Position = UDim2.new(0, 0, 0, 1)
		Tab["a8"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["a8"].Name = "Gradient"
		Tab["a8"].Visible = false

		Tab["a9"] = Instance.new("UIGradient", Tab["a8"])
		Tab["a9"].Rotation = 90
		Tab["a9"].Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0.000, 0.35),
			NumberSequenceKeypoint.new(0.349, 0.79375),
			NumberSequenceKeypoint.new(0.999, 1),
			NumberSequenceKeypoint.new(1.000, 0)
		}
		Tab["a9"].Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.000, Color3.fromRGB(39, 39, 39)),
			ColorSequenceKeypoint.new(1.000, Color3.fromRGB(48, 48, 48))
		}

		Tab["23b"] = Instance.new("Frame", Tab["23a"])
		Tab["23b"].ZIndex = 5
		Tab["23b"].BorderSizePixel = 0
		Tab["23b"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab["23b"].Size = UDim2.new(1, 0, 1, 0)
		Tab["23b"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["23b"].Name = "Content"
		Tab["23b"].BackgroundTransparency = 1

		Tab["24"] = Instance.new("UICorner", Tab["23b"])
		Tab["24"].CornerRadius = UDim.new(0, 12)

		Tab["25"] = Instance.new("UIListLayout", Tab["23b"])
		Tab["25"].Padding = UDim.new(0, 4)
		Tab["25"].SortOrder = Enum.SortOrder.LayoutOrder

		Tab["26"] = Instance.new("UIPadding", Tab["23b"])
		Tab["26"].PaddingTop = UDim.new(0, 25)
		Tab["26"].PaddingRight = UDim.new(0, 8)
		Tab["26"].PaddingLeft = UDim.new(0, 8)
		Tab["26"].PaddingBottom = UDim.new(0, 8)

		Tab["a3"] = Instance.new("Frame", Tab["23a"])
		Tab["a3"].BorderSizePixel = 0
		Tab["a3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab["a3"].Size = UDim2.new(1, 0, 0.08, 0)
		Tab["a3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["a3"].Name = "TabTitle"
		Tab["a3"].BackgroundTransparency = 1

		Tab["a4"] = Instance.new("TextLabel", Tab["a3"])
		Tab["a4"].BorderSizePixel = 0
		Tab["a4"].TextSize = 16
		Tab["a4"].TextYAlignment = Enum.TextYAlignment.Top
		Tab["a4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab["a4"].FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Tab["a4"].TextColor3 = Color3.fromRGB(173, 173, 173)
		Tab["a4"].BackgroundTransparency = 1
		Tab["a4"].Size = UDim2.new(1, 0, 1, 0)
		Tab["a4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab["a4"].Text = options.name

		Tab["a5"] = Instance.new("UISizeConstraint", Tab["a4"])
		Tab["a5"].MinSize = Vector2.new(374, 0)

		Tab["a6"] = Instance.new("UIPadding", Tab["a4"])
		Tab["a6"].PaddingTop = UDim.new(0, 5)
		Tab["a6"].PaddingRight = UDim.new(0, 5)
		Tab["a6"].PaddingLeft = UDim.new(0, 5)
		Tab["a6"].PaddingBottom = UDim.new(0, 5)

		local function ripple(obj, color)
			color = color or Color3.fromRGB(255, 255, 255)
			task.spawn(function()
				if not obj.ClipsDescendants then
					obj.ClipsDescendants = true
				end
				local Ripple = Instance.new("ImageLabel")
				Ripple.Name = "Ripple"
				Ripple.Parent = obj
				Ripple.BackgroundTransparency = 1
				Ripple.Image = "rbxassetid://117035752780422"
				Ripple.ImageColor3 = color
				Ripple.ImageTransparency = 0.6
				Ripple.ZIndex = 10
				Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
				Ripple.Size = UDim2.fromOffset(0, 0)
				local relX = (mouse.X - obj.AbsolutePosition.X) / obj.AbsoluteSize.X
				local relY = (mouse.Y - obj.AbsolutePosition.Y) / obj.AbsoluteSize.Y
				Ripple.Position = UDim2.new(relX, 0, relY, 0)
				local targetSize = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 1.5
				local tween = tweenservice:Create(Ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(targetSize, targetSize),
					ImageTransparency = 1
				})
				tween:Play()
				tween.Completed:Wait()
				Ripple:Destroy()
			end)
		end

		Tab["1b"].InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				ripple(Tab["1b"])
			end
		end)

		function Tab:Activate()
			if not Tab.Active then
				if GUI.CurrentTab ~= nil then
					GUI.CurrentTab:Deactivate()
				end
				Tab.Active = true
				GUI.CurrentTab = Tab
				Library:tween(Tab["1c"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
				Library:tween(Tab["1b"], {BackgroundColor3 = Color3.fromRGB(65, 65, 65)})
				Tab["23a"].Visible = true
			end
		end

		function Tab:Deactivate()
			if Tab.Active then
				Tab.Active = false
				Tab.Hover = false
				Library:tween(Tab["1c"], {TextColor3 = Color3.fromRGB(167, 167, 167)})
				Library:tween(Tab["1b"], {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
				Tab["23a"].Visible = false
			end
		end

		Tab["1b"].MouseEnter:Connect(function()
			Tab.Hover = true
			if not Tab.Active then
				Library:tween(Tab["1b"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
				Library:tween(Tab["1c"], {TextColor3 = Color3.fromRGB(230, 230, 230)})
			end
		end)

		Tab["1b"].MouseLeave:Connect(function()
			Tab.Hover = false
			if not Tab.Active then
				Library:tween(Tab["1c"], {TextColor3 = Color3.fromRGB(167, 167, 167)})
				Library:tween(Tab["1b"], {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
			end
		end)

		Tab["1b"].InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Tab.Hover then
					Tab:Activate()
				end
			end
		end)

		if GUI.CurrentTab == nil then
			Tab:Activate()
		end

		function Tab:CreateButton(options)
			options = Library:validate({
				name = "Button",
				icon = "rbxassetid://84775756796375",
				callback = function() end
			}, options or {})

			local Button = {
				Hover = false,
				MouseDown = false
			}

			Button["37"] = Instance.new("CanvasGroup", Tab["23b"])
			Button["37"].BorderSizePixel = 0
			Button["37"].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Button["37"].Size = UDim2.new(0, 358, 0, 33)
			Button["37"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button["37"].Active = true

			Button["38"] = Instance.new("UICorner", Button["37"])
			Button["38"].CornerRadius = UDim.new(0, 15)

			Button["39"] = Instance.new("UIPadding", Button["37"])
			Button["39"].PaddingRight = UDim.new(0, 10)
			Button["39"].PaddingLeft = UDim.new(0, 3)

			Button["3b"] = Instance.new("UIStroke", Button["37"])
			Button["3b"].Transparency = 0.2
			Button["3b"].Color = Color3.fromRGB(32, 32, 32)
			Button["3b"].BorderStrokePosition = Enum.BorderStrokePosition.Inner

			Button["3c"] = Instance.new("ImageLabel", Button["37"])
			Button["3c"].BorderSizePixel = 0
			Button["3c"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button["3c"].ImageTransparency = 0.2
			Button["3c"].AnchorPoint = Vector2.new(0.5, 0.5)
			Button["3c"].Image = options.icon
			Button["3c"].Size = UDim2.new(0, 20, 0, 20)
			Button["3c"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button["3c"].BackgroundTransparency = 1
			Button["3c"].Position = UDim2.new(0.965, 0, 0.5, 0)

			Button["3d"] = Instance.new("TextLabel", Button["37"])
			Button["3d"].BorderSizePixel = 0
			Button["3d"].TextSize = 19
			Button["3d"].TextXAlignment = Enum.TextXAlignment.Left
			Button["3d"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button["3d"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Button["3d"].TextColor3 = Color3.fromRGB(167, 167, 167)
			Button["3d"].BackgroundTransparency = 1
			Button["3d"].Size = UDim2.new(1, 0, 1, 0)
			Button["3d"].Position = UDim2.new(0, 0, 0.47, 0)
			Button["3d"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button["3d"].Text = options.name

			Button["3e"] = Instance.new("UIStroke", Button["3d"])
			Button["3e"].Transparency = 0.2
			Button["3e"].Color = Color3.fromRGB(32, 32, 32)

			Button["3f"] = Instance.new("UISizeConstraint", Button["3d"])
			Button["3f"].MaxSize = Vector2.new(374)

			Button["40"] = Instance.new("UIPadding", Button["3d"])
			Button["40"].PaddingRight = UDim.new(0, 10)
			Button["40"].PaddingLeft = UDim.new(0, 10)

			Button["41"] = Instance.new("UICorner", Button["3d"])
			Button["41"].CornerRadius = UDim.new(0, 25)

			Button["37"].MouseEnter:Connect(function()
				Button.Hover = true
				Library:tween(Button["37"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
				Library:tween(Button["3d"], {TextColor3 = Color3.fromRGB(230, 230, 230)})
			end)

			Button["37"].MouseLeave:Connect(function()
				Button.Hover = false
				if not Button.MouseDown then
					Library:tween(Button["37"], {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
					Library:tween(Button["3d"], {TextColor3 = Color3.fromRGB(167, 167, 167)})
				end
			end)

			uis.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Button.Hover then
					Button.MouseDown = true
					Library:tween(Button["37"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
					Library:tween(Button["3d"], {TextColor3 = Color3.fromRGB(230, 230, 230)})
				end
			end)

			uis.InputEnded:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Button.MouseDown = false
					if Button.Hover then
						Library:tween(Button["37"], {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
						Library:tween(Button["3d"], {TextColor3 = Color3.fromRGB(230, 230, 230)})
					else
						Library:tween(Button["37"], {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
						Library:tween(Button["3d"], {TextColor3 = Color3.fromRGB(167, 167, 167)})
						options.callback()
					end
				end
			end)

			local function ripple(obj, color)
				color = color or Color3.fromRGB(255, 255, 255)
				task.spawn(function()
					if not obj.ClipsDescendants then
						obj.ClipsDescendants = true
					end
					local Ripple = Instance.new("ImageLabel")
					Ripple.Name = "Ripple"
					Ripple.Parent = obj
					Ripple.BackgroundTransparency = 1
					Ripple.Image = "rbxassetid://117035752780422"
					Ripple.ImageColor3 = color
					Ripple.ImageTransparency = 0.6
					Ripple.ZIndex = 10
					Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
					Ripple.Size = UDim2.fromOffset(0, 0)
					local relX = (mouse.X - obj.AbsolutePosition.X) / obj.AbsoluteSize.X
					local relY = (mouse.Y - obj.AbsolutePosition.Y) / obj.AbsoluteSize.Y
					Ripple.Position = UDim2.new(relX, 0, relY, 0)
					local targetSize = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 1.5
					local tween = tweenservice:Create(Ripple, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.fromOffset(targetSize, targetSize),
						ImageTransparency = 1
					})
					tween:Play()
					tween.Completed:Wait()
					Ripple:Destroy()
				end)
			end

			Button["37"].InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					ripple(Button["37"])
				end
			end)

			return Button
		end

		function Tab:CreateInfo(options)
			options = Library:validate({
				name = "Info",
				icon = "rbxassetid://73905881318171",
				callback = function() end
			}, options or {})

			local Info = {}

			Info["30"] = Instance.new("Frame", Tab["23b"])
			Info["30"].BorderSizePixel = 0
			Info["30"].BackgroundColor3 = Color3.fromRGB(33, 42, 49)
			Info["30"].Size = UDim2.new(0, 358, 0, 33)
			Info["30"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Info["30"].Name = "Info"

			Info["31"] = Instance.new("UICorner", Info["30"])
			Info["31"].CornerRadius = UDim.new(0, 15)

			Info["32"] = Instance.new("UIPadding", Info["30"])
			Info["32"].PaddingRight = UDim.new(0, 10)
			Info["32"].PaddingLeft = UDim.new(0, 3)

			Info["34"] = Instance.new("UIStroke", Info["30"])
			Info["34"].Transparency = 0.2
			Info["34"].Color = Color3.fromRGB(32, 32, 32)
			Info["34"].BorderStrokePosition = Enum.BorderStrokePosition.Inner

			Info["37"] = Instance.new("ImageLabel", Info["30"])
			Info["37"].BorderSizePixel = 0
			Info["37"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Info["37"].ImageTransparency = 0.2
			Info["37"].AnchorPoint = Vector2.new(0.5, 0.5)
			Info["37"].Image = options.icon
			Info["37"].Size = UDim2.new(0, 20, 0, 20)
			Info["37"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Info["37"].BackgroundTransparency = 1
			Info["37"].Position = UDim2.new(0.965, 0, 0.5, 0)

			Info["35"] = Instance.new("TextLabel", Info["30"])
			Info["35"].BorderSizePixel = 0
			Info["35"].TextSize = 19
			Info["35"].TextXAlignment = Enum.TextXAlignment.Left
			Info["35"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Info["35"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Info["35"].TextColor3 = Color3.fromRGB(167, 167, 167)
			Info["35"].BackgroundTransparency = 1
			Info["35"].Size = UDim2.new(1, 0, 1, 0)
			Info["35"].Position = UDim2.new(0, 0, 0.47, 0)
			Info["35"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Info["35"].Text = options.name
			Info["35"].Name = "Label"

			Info["36"] = Instance.new("UIStroke", Info["35"])
			Info["36"].Transparency = 0.2
			Info["36"].Color = Color3.fromRGB(32, 32, 32)

			Info["33"] = Instance.new("UISizeConstraint", Info["35"])
			Info["33"].MaxSize = Vector2.new(374)

			Info["38"] = Instance.new("UIPadding", Info["35"])
			Info["38"].PaddingRight = UDim.new(0, 10)
			Info["38"].PaddingLeft = UDim.new(0, 10)

			Info["39"] = Instance.new("UICorner", Info["35"])
			Info["39"].CornerRadius = UDim.new(0, 25)

			return Info
		end

		function Tab:CreateLabel(options)
			options = Library:validate({
				name = "Label",
				icon = "rbxassetid://123872731106364",
				callback = function() end
			}, options or {})

			local Label = {}

			Label["30"] = Instance.new("Frame", Tab["23b"])
			Label["30"].BorderSizePixel = 0
			Label["30"].BackgroundColor3 = Color3.fromRGB(44, 44, 44)
			Label["30"].Size = UDim2.new(0, 358, 0, 33)
			Label["30"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label["30"].Name = "Label"

			Label["31"] = Instance.new("UICorner", Label["30"])
			Label["31"].CornerRadius = UDim.new(0, 15)

			Label["32"] = Instance.new("UIPadding", Label["30"])
			Label["32"].PaddingRight = UDim.new(0, 10)
			Label["32"].PaddingLeft = UDim.new(0, 3)

			Label["34"] = Instance.new("UIStroke", Label["30"])
			Label["34"].Transparency = 0.2
			Label["34"].Color = Color3.fromRGB(32, 32, 32)
			Label["34"].BorderStrokePosition = Enum.BorderStrokePosition.Inner

			Label["37"] = Instance.new("ImageLabel", Label["30"])
			Label["37"].BorderSizePixel = 0
			Label["37"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label["37"].ImageTransparency = 0.2
			Label["37"].AnchorPoint = Vector2.new(0.5, 0.5)
			Label["37"].Image = options.icon
			Label["37"].Size = UDim2.new(0, 20, 0, 20)
			Label["37"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label["37"].BackgroundTransparency = 1
			Label["37"].Position = UDim2.new(0.965, 0, 0.5, 0)

			Label["35"] = Instance.new("TextLabel", Label["30"])
			Label["35"].BorderSizePixel = 0
			Label["35"].TextSize = 19
			Label["35"].TextXAlignment = Enum.TextXAlignment.Left
			Label["35"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label["35"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Label["35"].TextColor3 = Color3.fromRGB(167, 167, 167)
			Label["35"].BackgroundTransparency = 1
			Label["35"].Size = UDim2.new(1, 0, 1, 0)
			Label["35"].Position = UDim2.new(0, 0, 0.47, 0)
			Label["35"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label["35"].Text = options.name
			Label["35"].Name = "Label"

			Label["36"] = Instance.new("UIStroke", Label["35"])
			Label["36"].Transparency = 0.2
			Label["36"].Color = Color3.fromRGB(32, 32, 32)

			Label["33"] = Instance.new("UISizeConstraint", Label["35"])
			Label["33"].MaxSize = Vector2.new(374)

			Label["38"] = Instance.new("UIPadding", Label["35"])
			Label["38"].PaddingRight = UDim.new(0, 10)
			Label["38"].PaddingLeft = UDim.new(0, 10)

			Label["39"] = Instance.new("UICorner", Label["35"])
			Label["39"].CornerRadius = UDim.new(0, 25)

			return Label
		end

		function Tab:CreateWarning(options)
			options = Library:validate({
				name = "Warning",
				icon = "rbxassetid://83927714299990",
				callback = function() end
			}, options or {})

			local Warning = {}

			Warning["9b"] = Instance.new("Frame", Tab["23b"])
			Warning["9b"].BorderSizePixel = 0
			Warning["9b"].BackgroundColor3 = Color3.fromRGB(33, 42, 49)
			Warning["9b"].Size = UDim2.new(0, 358, 0, 33)
			Warning["9b"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Warning["9b"].Name = "Warning"

			Warning["9c"] = Instance.new("UICorner", Warning["9b"])
			Warning["9c"].CornerRadius = UDim.new(0, 15)

			Warning["9d"] = Instance.new("UIPadding", Warning["9b"])
			Warning["9d"].PaddingRight = UDim.new(0, 10)
			Warning["9d"].PaddingLeft = UDim.new(0, 3)

			Warning["9f"] = Instance.new("UIStroke", Warning["9b"])
			Warning["9f"].Transparency = 0.2
			Warning["9f"].Color = Color3.fromRGB(32, 32, 32)
			Warning["9f"].BorderStrokePosition = Enum.BorderStrokePosition.Inner

			Warning["a2"] = Instance.new("ImageLabel", Warning["9b"])
			Warning["a2"].BorderSizePixel = 0
			Warning["a2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Warning["a2"].ImageTransparency = 0.2
			Warning["a2"].AnchorPoint = Vector2.new(0.5, 0.5)
			Warning["a2"].Image = options.icon
			Warning["a2"].Size = UDim2.new(0, 20, 0, 20)
			Warning["a2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Warning["a2"].BackgroundTransparency = 1
			Warning["a2"].Position = UDim2.new(0.965, 0, 0.5, 0)

			Warning["a0"] = Instance.new("TextLabel", Warning["9b"])
			Warning["a0"].BorderSizePixel = 0
			Warning["a0"].TextSize = 19
			Warning["a0"].TextXAlignment = Enum.TextXAlignment.Left
			Warning["a0"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Warning["a0"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Warning["a0"].TextColor3 = Color3.fromRGB(167, 167, 167)
			Warning["a0"].BackgroundTransparency = 1
			Warning["a0"].Size = UDim2.new(1, 0, 1, 0)
			Warning["a0"].Position = UDim2.new(0, 0, 0.47, 0)
			Warning["a0"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Warning["a0"].Text = options.name
			Warning["a0"].Name = "Label"

			Warning["a1"] = Instance.new("UIStroke", Warning["a0"])
			Warning["a1"].Transparency = 0.2
			Warning["a1"].Color = Color3.fromRGB(32, 32, 32)

			Warning["9e"] = Instance.new("UISizeConstraint", Warning["a0"])
			Warning["9e"].MaxSize = Vector2.new(374)

			Warning["a3"] = Instance.new("UIPadding", Warning["a0"])
			Warning["a3"].PaddingRight = UDim.new(0, 10)
			Warning["a3"].PaddingLeft = UDim.new(0, 10)

			Warning["a4"] = Instance.new("UICorner", Warning["a0"])
			Warning["a4"].CornerRadius = UDim.new(0, 25)

			return Warning
		end

		return Tab
	end

	return GUI
end

return Library
