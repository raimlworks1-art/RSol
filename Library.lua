-- bery ai

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}
local Utility = {}

local Theme = {
	Background = Color3.fromRGB(18, 18, 22),
	Sidebar = Color3.fromRGB(25, 25, 30),
	Element = Color3.fromRGB(32, 32, 38),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(160, 160, 160),
	Accent = Color3.fromRGB(114, 137, 218),
	Outline = Color3.fromRGB(45, 45, 50)
}

function Utility:Create(instanceType, properties)
	local instance = Instance.new(instanceType)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	return instance
end

function Utility:Tween(instance, info, properties)
	local tween = TweenService:Create(instance, info, properties)
	tween:Play()
	return tween
end

function Utility:MakeDraggable(topbar, object)
	local dragging, dragInput, dragStart, startPos

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Utility:Tween(object, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
		end
	end)
end

function Library:Create(config)
	local Title = config.Title or "UI Library"
	local SubTitle = config.SubTitle or "Version 1.0"
	local UseLoader = config.Config and config.Config.Loader or false

	local ScreenGui = Utility:Create("ScreenGui", {
		Name = Title,
		Parent = (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})

	local MainFrame = Utility:Create("Frame", {
		Name = "MainFrame",
		Parent = ScreenGui,
		BackgroundColor3 = Theme.Background,
		Position = UDim2.new(0.5, -300, 0.5, -200),
		Size = UDim2.new(0, 600, 0, 400),
		ClipsDescendants = false 
	})

	Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainFrame})
	Utility:Create("UIStroke", {Parent = MainFrame, Color = Theme.Outline, Thickness = 1})

	local Sidebar = Utility:Create("Frame", {
		Parent = MainFrame,
		BackgroundColor3 = Theme.Sidebar,
		Size = UDim2.new(0, 160, 1, 0),
		ZIndex = 2
	})
	
	Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sidebar})
	
	local SidebarFix = Utility:Create("Frame", {
		Parent = Sidebar,
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -5, 0, 0),
		Size = UDim2.new(0, 5, 1, 0),
		ZIndex = 2
	})

	local TitleLabel = Utility:Create("TextLabel", {
		Parent = Sidebar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 15),
		Size = UDim2.new(1, -30, 0, 25),
		Font = Enum.Font.GothamBold,
		Text = Title,
		TextColor3 = Theme.Text,
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local SubTitleLabel = Utility:Create("TextLabel", {
		Parent = Sidebar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 40),
		Size = UDim2.new(1, -30, 0, 15),
		Font = Enum.Font.Gotham,
		Text = SubTitle,
		TextColor3 = Theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local TabContainer = Utility:Create("ScrollingFrame", {
		Parent = Sidebar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 70),
		Size = UDim2.new(1, 0, 1, -80),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ZIndex = 3
	})
	
	Utility:Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
	Utility:Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 5)})

	local TopBar = Utility:Create("Frame", {
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 160, 0, 0),
		Size = UDim2.new(1, -160, 0, 40)
	})

	Utility:MakeDraggable(TopBar, MainFrame)
	Utility:MakeDraggable(Sidebar, MainFrame)

	local CloseBtn = Utility:Create("TextButton", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -35, 0, 5),
		Size = UDim2.new(0, 30, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "X",
		TextColor3 = Theme.SubText,
		TextSize = 14
	})

	CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
	
	local ContentHolder = Utility:Create("Frame", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 175, 0, 20), 
    Size = UDim2.new(1, -190, 1, -35),   
    ClipsDescendants = true
})


	local Loader = {}
	local LoaderFrame
	local LoaderLeft
	local LoaderRight
	local LoaderText

	if UseLoader then
		LoaderFrame = Utility:Create("Frame", {
			Parent = MainFrame,
			BackgroundColor3 = Color3.new(0,0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 100,
			ClipsDescendants = true
		})
		
		Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = LoaderFrame})

		LoaderLeft = Utility:Create("Frame", {
			Parent = LoaderFrame,
			BackgroundColor3 = Theme.Background,
			BorderSizePixel = 0,
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			ZIndex = 101
		})
		
		

		LoaderRight = Utility:Create("Frame", {
			Parent = LoaderFrame,
			BackgroundColor3 = Theme.Background,
			BorderSizePixel = 0,
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			ZIndex = 101
		})

		LoaderText = Utility:Create("TextLabel", {
			Parent = LoaderFrame,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0.5, -10),
			Size = UDim2.new(1, 0, 0, 20),
			Font = Enum.Font.GothamBold,
			Text = "INITIALIZING",
			TextColor3 = Theme.Text,
			TextSize = 16,
			ZIndex = 103
		})
	end

	function Loader:Start()
		if not UseLoader then return end
		LoaderFrame.Visible = true
	end

	function Loader:SetText(text)
		if not UseLoader then return end
		Utility:Tween(LoaderText, TweenInfo.new(0.3), {TextTransparency = 1}).Completed:Wait()
		LoaderText.Text = text
		Utility:Tween(LoaderText, TweenInfo.new(0.3), {TextTransparency = 0})
	end

	function Loader:End()
		if not UseLoader then return end
		
		Utility:Tween(LoaderText, TweenInfo.new(0.3), {TextTransparency = 1})
		task.wait(0.4)
		
		Utility:Tween(LoaderLeft, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(-0.5, 0, 0, 0)})
		local OpenAnim = Utility:Tween(LoaderRight, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)})
		
		OpenAnim.Completed:Connect(function()
			LoaderFrame:Destroy()
		end)
	end
	
	local Window = {Loader = Loader, Tabs = {}, ActiveTab = nil}

	function Window:Tab(name, icon)
		local TabFunctions = {}
		
		local TabBtn = Utility:Create("TextButton", {
			Parent = TabContainer,
			BackgroundColor3 = Theme.Sidebar,
			Size = UDim2.new(1, -10, 0, 32),
			Font = Enum.Font.GothamMedium,
			Text = "      " .. name,
			TextColor3 = Theme.SubText,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false
		})
		
		Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})
		
		local TabIndicator = Utility:Create("Frame", {
			Parent = TabBtn,
			BackgroundColor3 = Theme.Accent,
			Position = UDim2.new(0, 0, 0.2, 0),
			Size = UDim2.new(0, 3, 0.6, 0),
			Transparency = 1
		})
		
		Utility:Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = TabIndicator})

		local TabPage = Utility:Create("ScrollingFrame", {
			Parent = ContentHolder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.Accent,
			CanvasSize = UDim2.new(0, 0, 0, 0)
		})
		
		Utility:Create("UIListLayout", {Parent = TabPage, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
		Utility:Create("UIPadding", {Parent = TabPage, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 5)})
		
		local function ActivateTab()
			if Window.ActiveTab == TabPage then return end
			
			for _, tab in pairs(Window.Tabs) do
				Utility:Tween(tab.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Sidebar, TextColor3 = Theme.SubText})
				Utility:Tween(tab.Indicator, TweenInfo.new(0.2), {Transparency = 1})
				tab.Page.Visible = false
			end
			
			Window.ActiveTab = TabPage
			TabPage.Visible = true
			TabPage.Position = UDim2.new(0, 0, 0, 15)
			TabPage.BackgroundTransparency = 1
			
			Utility:Tween(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.Text})
			Utility:Tween(TabIndicator, TweenInfo.new(0.3), {Transparency = 0})
			Utility:Tween(TabPage, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
		end
		
		TabBtn.MouseButton1Click:Connect(ActivateTab)
		
		table.insert(Window.Tabs, {Btn = TabBtn, Page = TabPage, Indicator = TabIndicator})
		
		if #Window.Tabs == 1 then ActivateTab() end
		
		TabPage.ChildAdded:Connect(function()
			local Layout = TabPage:FindFirstChildOfClass("UIListLayout")
			if Layout then
				TabPage.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
			end
		end)

		function TabFunctions:Section(text)
			local SectionFrame = Utility:Create("Frame", {
				Parent = TabPage,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 35)
			})
			
			Utility:Create("TextLabel", {
				Parent = SectionFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 2, 0, 10),
				Size = UDim2.new(1, 0, 0, 20),
				Font = Enum.Font.GothamBold,
				Text = text,
				TextColor3 = Theme.Accent,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			Utility:Create("Frame", {
				Parent = SectionFrame,
				BackgroundColor3 = Theme.Outline,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 1, -2),
				Size = UDim2.new(1, 0, 0, 1)
			})
		end

		function TabFunctions:Button(text, callback)
			callback = callback or function() end
			
			local Button = Utility:Create("TextButton", {
				Parent = TabPage,
				BackgroundColor3 = Theme.Element,
				Size = UDim2.new(1, 0, 0, 36),
				AutoButtonColor = false,
				Font = Enum.Font.Gotham,
				Text = "",
				TextColor3 = Theme.Text
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Button})
			Utility:Create("UIStroke", {Parent = Button, Color = Theme.Outline, Thickness = 1})
			
			Utility:Create("TextLabel", {
				Parent = Button,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -10, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Icon = Utility:Create("ImageLabel", {
				Parent = Button,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -30, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "rbxassetid://3926305904",
				ImageRectOffset = Vector2.new(84, 204),
				ImageRectSize = Vector2.new(36, 36),
				ImageColor3 = Theme.SubText
			})
			
			Button.MouseEnter:Connect(function()
				Utility:Tween(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)})
			end)
			
			Button.MouseLeave:Connect(function()
				Utility:Tween(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element})
			end)
			
			Button.MouseButton1Click:Connect(function()
				Utility:Tween(Icon, TweenInfo.new(0.1), {ImageColor3 = Theme.Accent})
				callback()
				task.wait(0.1)
				Utility:Tween(Icon, TweenInfo.new(0.3), {ImageColor3 = Theme.SubText})
			end)
		end

		function TabFunctions:Toggle(text, default, callback)
			default = default or false
			callback = callback or function() end
			local toggled = default
			
			local ToggleFrame = Utility:Create("TextButton", {
				Parent = TabPage,
				BackgroundColor3 = Theme.Element,
				Size = UDim2.new(1, 0, 0, 36),
				AutoButtonColor = false,
				Text = ""
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ToggleFrame})
			Utility:Create("UIStroke", {Parent = ToggleFrame, Color = Theme.Outline, Thickness = 1})
			
			Utility:Create("TextLabel", {
				Parent = ToggleFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -60, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local SwitchBg = Utility:Create("Frame", {
				Parent = ToggleFrame,
				BackgroundColor3 = toggled and Theme.Accent or Color3.fromRGB(50, 50, 55),
				Position = UDim2.new(1, -50, 0.5, -10),
				Size = UDim2.new(0, 40, 0, 20)
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchBg})
			
			local SwitchDot = Utility:Create("Frame", {
				Parent = SwitchBg,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				Size = UDim2.new(0, 16, 0, 16)
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchDot})
			
			ToggleFrame.MouseButton1Click:Connect(function()
				toggled = not toggled
				callback(toggled)
				
				if toggled then
					Utility:Tween(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent})
					Utility:Tween(SwitchDot, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0.5, -8)})
				else
					Utility:Tween(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)})
					Utility:Tween(SwitchDot, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, -8)})
				end
			end)
		end
		
		function TabFunctions:Input(text, placeholder, callback)
			callback = callback or function() end
			
			local InputFrame = Utility:Create("Frame", {
				Parent = TabPage,
				BackgroundColor3 = Theme.Element,
				Size = UDim2.new(1, 0, 0, 42)
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputFrame})
			Utility:Create("UIStroke", {Parent = InputFrame, Color = Theme.Outline, Thickness = 1})
			
			Utility:Create("TextLabel", {
				Parent = InputFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, 0, 0, 20),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Theme.SubText,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local TextBox = Utility:Create("TextBox", {
				Parent = InputFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 20),
				Size = UDim2.new(1, -20, 0, 20),
				Font = Enum.Font.GothamSemibold,
				Text = "",
				PlaceholderText = placeholder,
				PlaceholderColor3 = Color3.fromRGB(80, 80, 80),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false
			})
			
			TextBox.FocusLost:Connect(function(enter)
				if enter then callback(TextBox.Text) end
			end)
		end
		
		function TabFunctions:Slider(text, min, max, default, callback)
			local value = default or min
			callback = callback or function() end
			
			local SliderFrame = Utility:Create("Frame", {
				Parent = TabPage,
				BackgroundColor3 = Theme.Element,
				Size = UDim2.new(1, 0, 0, 50)
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SliderFrame})
			Utility:Create("UIStroke", {Parent = SliderFrame, Color = Theme.Outline, Thickness = 1})
			
			Utility:Create("TextLabel", {
				Parent = SliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 5),
				Size = UDim2.new(0, 100, 0, 20),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ValueLabel = Utility:Create("TextLabel", {
				Parent = SliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -60, 0, 5),
				Size = UDim2.new(0, 50, 0, 20),
				Font = Enum.Font.GothamBold,
				Text = tostring(value),
				TextColor3 = Theme.Accent,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right
			})
			
			local SlideBg = Utility:Create("Frame", {
				Parent = SliderFrame,
				BackgroundColor3 = Color3.fromRGB(50, 50, 55),
				Position = UDim2.new(0, 10, 0, 32),
				Size = UDim2.new(1, -20, 0, 4)
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SlideBg})
			
			local SlideFill = Utility:Create("Frame", {
				Parent = SlideBg,
				BackgroundColor3 = Theme.Accent,
				Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SlideFill})
			
			local Trigger = Utility:Create("TextButton", {
				Parent = SlideBg,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local dragging = false
			
			local function Update(input)
				local pos = math.clamp((input.Position.X - SlideBg.AbsolutePosition.X) / SlideBg.AbsoluteSize.X, 0, 1)
				local newValue = math.floor(((pos * (max - min)) + min) * 10) / 10
				
				Utility:Tween(SlideFill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)})
				ValueLabel.Text = tostring(newValue)
				callback(newValue)
			end
			
			Trigger.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					Update(input)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					Update(input)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
		end
		
		function TabFunctions:Dropdown(text, options, callback)
			callback = callback or function() end
			local selected = options[1] or "Select..."
			local expanded = false
			
			local DropdownFrame = Utility:Create("Frame", {
				Parent = TabPage,
				BackgroundColor3 = Theme.Element,
				Size = UDim2.new(1, 0, 0, 36),
				ClipsDescendants = true,
				ZIndex = 2
			})
			
			Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropdownFrame})
			Utility:Create("UIStroke", {Parent = DropdownFrame, Color = Theme.Outline, Thickness = 1})
			
			local DropBtn = Utility:Create("TextButton", {
				Parent = DropdownFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36),
				Text = "",
				ZIndex = 2
			})
			
			Utility:Create("TextLabel", {
				Parent = DropdownFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0.5, 0, 0, 36),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local SelLabel = Utility:Create("TextLabel", {
				Parent = DropdownFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, -30, 0, 36),
				Font = Enum.Font.GothamBold,
				Text = selected,
				TextColor3 = Theme.Accent,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right
			})
			
			local Chevron = Utility:Create("ImageLabel", {
				Parent = DropdownFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -25, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "rbxassetid://6031091004",
				ImageColor3 = Theme.SubText
			})
			
			local List = Utility:Create("ScrollingFrame", {
				Parent = DropdownFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 36),
				Size = UDim2.new(1, 0, 1, -36),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 2
			})
			
			local ListLayout = Utility:Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
			
			local function Refresh()
				for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
				
				for _, opt in ipairs(options) do
					local Item = Utility:Create("TextButton", {
						Parent = List,
						BackgroundColor3 = Color3.fromRGB(40, 40, 45),
						Size = UDim2.new(1, -10, 0, 25),
						Font = Enum.Font.Gotham,
						Text = opt,
						TextColor3 = Theme.SubText,
						TextSize = 12
					})
					
					Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Item})
					
					Item.MouseButton1Click:Connect(function()
						selected = opt
						SelLabel.Text = selected
						expanded = false
						Utility:Tween(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 36)})
						Utility:Tween(Chevron, TweenInfo.new(0.3), {Rotation = 0})
						callback(selected)
					end)
				end
				List.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
			end
			
			Refresh()
			
			DropBtn.MouseButton1Click:Connect(function()
				expanded = not expanded
				if expanded then
					local h = math.min(#options * 27 + 45, 150)
					Utility:Tween(DropdownFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, h)})
					Utility:Tween(Chevron, TweenInfo.new(0.3), {Rotation = 180})
				else
					Utility:Tween(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 36)})
					Utility:Tween(Chevron, TweenInfo.new(0.3), {Rotation = 0})
				end
			end)
		end
		
		return TabFunctions
	end
	
	return Window
end

return Library
