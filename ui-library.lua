--print('PixelHub UI v1 - riprippixel#6969')

local library = {}

function library.new(theme)

	theme = theme and theme or {
		BackgroundColor = Color3.fromRGB(30, 30, 30),
		MainColor = Color3.fromRGB(66, 66, 66),
		AccentColor = Color3.fromRGB(255, 255, 255),
		TextColor = Color3.fromRGB(255,255,255),
		SelectedTextColor = Color3.fromRGB(0, 255, 0)
	}

	local ColorThemes = {
		BackgroundColor = {},
		MainColor = {},
		AccentColor = {},
		TextColor = {}
	}

	local TweenService = game:GetService('TweenService')
	local UserInputService = game:GetService('UserInputService')
	local player = game:GetService('Players').LocalPlayer
	local mouse = player:GetMouse()
	local Camera = game:GetService('Workspace').Camera

	local TextSize = 17

	local uuid = game:GetService('HttpService'):GenerateGUID()

	local HubName = tostring('PixelHub-'..uuid)

	local MouseScroll = {
		['Debounce'] = false,
		['WaitTime'] = 0.5,
		['InFrame'] = false
	}

	local function ResetZoom()
		player.CameraMinZoomDistance = game:GetService('StarterPlayer').CameraMinZoomDistance
		player.CameraMaxZoomDistance = game:GetService('StarterPlayer').CameraMaxZoomDistance
	end

    local function CurrentZoom()
        local camera = game.Workspace.CurrentCamera
        local character = player.Character or player.CharacterAdded:Wait()
        local head = character:WaitForChild("Head")
        return (head.CFrame.p - camera.CFrame.p).magnitude
    end

    local function LockZoom(min, max)
		local currentzoom = CurrentZoom()
        player.CameraMinZoomDistance = currentzoom
        player.CameraMaxZoomDistance = currentzoom
    end

	local function exists()
		if game:GetService('CoreGui'):FindFirstChild(HubName) then
			return true
		else
			return false
		end
	end

	for _,v in pairs(game:GetService('CoreGui'):GetChildren()) do
		if string.match(v.Name, 'PixelHub') then
            ResetZoom()
			v:Destroy()
		end
	end

	local PixelHub = Instance.new("ScreenGui")
	local UIFrame = Instance.new("Frame")
	PixelHub.Name = HubName
	PixelHub.Parent = game:WaitForChild('CoreGui')
	PixelHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	UIFrame.Name = "UIFrame"
	UIFrame.Parent = PixelHub
	UIFrame.Active = false
	UIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	UIFrame.BackgroundColor3 = Color3.fromRGB(182, 182, 182)
	UIFrame.BackgroundTransparency = 1.000
	UIFrame.BorderSizePixel = 0
	UIFrame.Position = UDim2.new(0, 110, 0.5, 0)
	UIFrame.Size = UDim2.new(0, 225, 1, 0)

	local toggling = false

	local pages = {}
	local pagenumber = 0

    function pages:Exists()
        return exists()
    end

    function pages:GetPages()
        return UIFrame:GetChildren()
    end
	
	function pages:ChangeTheme(NewTheme)
		for col,v in pairs(ColorThemes) do
			for i,o in pairs(v) do
				local NewColor = NewTheme[col]
				local object = o[1]
				local property = o[2]
				object[property] = NewColor
			end
		end
	end

	function pages:Toggle()
		if toggling then return end
		toggling = true
		local toggled = not UIFrame.Active
		local dir = toggled and -110 or 110
		local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local ToggleTween = TweenService:Create(UIFrame, tweeninfo, {Position=UDim2.new(0,dir,0.5,0)})
		ToggleTween:Play()
		UIFrame.Active = not UIFrame.Active
		wait(1)
		toggling = false
	end

	function pages:Delete()
		game:WaitForChild('CoreGui')[HubName]:Destroy()
	end

    function pages:DeletePage(page)
        page:Destroy()
    end

	function pages:AddPage(PageTitle)
        PageTitle = PageTitle or 'Page'
		local Page = Instance.new("Frame")
		local PageListLayout = Instance.new("UIListLayout")
		local Title = Instance.new("TextLabel")
		local TitleBar = Instance.new("ImageLabel")
		local FrameNumber = Instance.new("NumberValue")
		local ActiveFrame = Instance.new("BoolValue")
		local PagePadding = Instance.new("UIPadding")

		pagenumber = pagenumber + 1

		FrameNumber.Name = "FrameNumber"
		FrameNumber.Parent = Page
		ActiveFrame.Name = "ActiveFrame"
		ActiveFrame.Parent = Page
		FrameNumber.Value = pagenumber
		ActiveFrame.Value = pagenumber == 1 and true or false

		local newpagepos = ActiveFrame.Value and 0.5 or -0.5

		PagePadding.Name = "PagePadding"
		PagePadding.Parent = Page
		PagePadding.PaddingBottom = UDim.new(0, 10)
		PagePadding.PaddingLeft = UDim.new(0, 0)
		PagePadding.PaddingRight = UDim.new(0, 0)
		PagePadding.PaddingTop = UDim.new(0, 10)

		Page.Name = "Page"
		Page.Parent = UIFrame
		Page.AnchorPoint = Vector2.new(0.5, 0.5)
		Page.BackgroundColor3 = theme['BackgroundColor']
		table.insert(ColorThemes['BackgroundColor'], {Page, 'BackgroundColor3'})
		Page.BorderSizePixel = 0
		Page.Position = UDim2.new(0.5, 0, newpagepos, 0)
		Page.Size = UDim2.new(0, 200, 0, 500)

		PageListLayout.Name = "PageListLayout"
		PageListLayout.Parent = Page
		PageListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		PageListLayout.Padding = UDim.new(0, 10)

		Title.Name = "Title"
		Title.Parent = Page
		Title.AnchorPoint = Vector2.new(0.5, 0.5)
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0.045, 0, 0.112, 0)
		Title.Size = UDim2.new(1, 0, 0, 35)
		Title.Font = Enum.Font.ArialBold
		Title.Text = PageTitle
		Title.TextColor3 = theme['TextColor']
		table.insert(ColorThemes['TextColor'], {Title, 'TextColor3'})
		Title.TextSize = 25

		TitleBar.Name = "TitleBar"
		TitleBar.Parent = Title
		TitleBar.AnchorPoint = Vector2.new(0.5, 0.5)
		TitleBar.BackgroundColor3 = theme['AccentColor']
		table.insert(ColorThemes['AccentColor'], {TitleBar, 'BackgroundColor3'})
		TitleBar.BorderSizePixel = 0
		TitleBar.Position = UDim2.new(0.5, 0, 1, 0)
		TitleBar.Size = UDim2.new(1, 0, 0, 2)
		TitleBar.ImageTransparency = 1.000
		TitleBar.ScaleType = Enum.ScaleType.Fit

		local sections = {}

        function sections:DeletePage()
            Page:Destroy()
        end

		function sections:AddSection()
			local Section = Instance.new("Frame")
			local SectionList = Instance.new("UIListLayout")

			Section.Name = "Section"
			Section.Parent = Page
			Section.AnchorPoint = Vector2.new(0.5, 0.5)
			Section.BackgroundColor3 = theme['MainColor']
			table.insert(ColorThemes['MainColor'], {Section, 'BackgroundColor3'})
			Section.BorderColor3 = theme['AccentColor']
			table.insert(ColorThemes['AccentColor'], {Section, 'BorderColor3'})
			Section.BorderSizePixel = 1
			Section.Position = UDim2.new(0, 1, 0, 1)
			Section.Size = UDim2.new(0.95, 0, 0, 30)

			SectionList.Name = "SectionList"
			SectionList.Parent = Section
			SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SectionList.SortOrder = Enum.SortOrder.LayoutOrder
			SectionList.Padding = UDim.new(0, 5)

			SectionList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local NewSize = SectionList.AbsoluteContentSize
				local OldSize = Section.Size
				Section.Size = UDim2.new(OldSize.X.Scale,0,0,NewSize.Y)
			end)

			local elements = {}

			function elements:NewButton(ButtonTitle, callback)
				ButtonTitle = ButtonTitle or 'Button'
				callback = callback or function()end
				local ButtonFrame = Instance.new("Frame")
				local Button = Instance.new("TextButton")
				local ButtonPadding = Instance.new("UIPadding")

				ButtonFrame.Name = "ButtonFrame"
				ButtonFrame.Parent = Section
				ButtonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				ButtonFrame.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {ButtonFrame, 'BackgroundColor3'})
				ButtonFrame.BackgroundTransparency = 1.000
				ButtonFrame.BorderSizePixel = 0
				ButtonFrame.Position = UDim2.new(0.045, 0, 0.112, 0)
				ButtonFrame.Size = UDim2.new(1, 0, 0, 30)

				Button.Name = "Button"
				Button.Parent = ButtonFrame
				Button.AnchorPoint = Vector2.new(0.5, 0.5)
				Button.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {Button, 'BackgroundColor3'})
				Button.BackgroundTransparency = 1.000
				Button.BorderSizePixel = 0
				Button.Position = UDim2.new(0.5, 0, 0.5, 0)
				Button.Size = UDim2.new(1, 0, 0, 30)
				Button.AutoButtonColor = false
				Button.Font = Enum.Font.ArialBold
				Button.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {Button, 'TextColor3'})
				Button.Text = ButtonTitle
				Button.TextSize = TextSize
				Button.TextWrapped = true

				ButtonPadding.Name = "ButtonPadding"
				ButtonPadding.Parent = ButtonFrame
				ButtonPadding.PaddingBottom = UDim.new(0, 5)
				ButtonPadding.PaddingLeft = UDim.new(0, 5)
				ButtonPadding.PaddingRight = UDim.new(0, 5)
				ButtonPadding.PaddingTop = UDim.new(0, 5)

				Button.MouseButton1Click:Connect(function()
					if not exists() then return end
					callback()
				end)
			end

            function elements:NewLabel(LabelTitle)
                local update = {}

				LabelTitle = LabelTitle or 'Label'
				local LabelFrame = Instance.new("Frame")
				local Label = Instance.new("TextLabel")
				local LabelPadding = Instance.new("UIPadding")

				LabelFrame.Name = "LabelFrame"
				LabelFrame.Parent = Section
				LabelFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				LabelFrame.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {LabelFrame, 'BackgroundColor3'})
				LabelFrame.BackgroundTransparency = 1.000
				LabelFrame.BorderSizePixel = 0
				LabelFrame.Position = UDim2.new(0.045, 0, 0.112, 0)
				LabelFrame.Size = UDim2.new(1, 0, 0, 30)

				Label.Name = "Label"
				Label.Parent = LabelFrame
				Label.AnchorPoint = Vector2.new(0.5, 0.5)
				Label.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {Label, 'BackgroundColor3'})
				Label.BackgroundTransparency = 1.000
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0.5, 0, 0.5, 0)
				Label.Size = UDim2.new(1, 0, 0, 30)
				Label.Font = Enum.Font.ArialBold
				Label.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {Label, 'TextColor3'})
				Label.Text = LabelTitle
				Label.TextSize = TextSize
				Label.TextWrapped = true
				Label.TextScaled = true

				LabelPadding.Name = "LabelPadding"
				LabelPadding.Parent = Label
				LabelPadding.PaddingBottom = UDim.new(0, 5)
				LabelPadding.PaddingLeft = UDim.new(0, 5)
				LabelPadding.PaddingRight = UDim.new(0, 5)
				LabelPadding.PaddingTop = UDim.new(0, 5)

                function update:UpdateLabel(LabelTitle)
                    Label.Text = LabelTitle
                end
                return update
			end

			function elements:NewKeybind(KeybindTitle, callback, defaultkey)
				KeybindTitle = KeybindTitle or 'Keybind'
				callback = callback or function()end
				local keybinded = defaultkey and Enum.KeyCode[defaultkey] or false
				local defaulttext = defaultkey or 'Key'

				local KeybindFrame = Instance.new("Frame")
				local KeybindLabel = Instance.new("TextLabel")
				local KeybindBox = Instance.new("TextBox")
				local KeybindPadding = Instance.new("UIPadding")

				KeybindFrame.Name = "KeybindFrame"
				KeybindFrame.Parent = Section
				KeybindFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				KeybindFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
				KeybindFrame.BackgroundTransparency = 1.000
				KeybindFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
				KeybindFrame.BorderSizePixel = 0
				KeybindFrame.Position = UDim2.new(0.045, 0, 0.112, 0)
				KeybindFrame.Size = UDim2.new(1, 0, 0, 30)

				KeybindLabel.Name = "KeybindLabel"
				KeybindLabel.Parent = KeybindFrame
				KeybindLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindLabel.BackgroundTransparency = 1.000
				KeybindLabel.BorderSizePixel = 0
				KeybindLabel.Position = UDim2.new(0.35, 0, 0.5, 0)
				KeybindLabel.Size = UDim2.new(0.7, 0, 1, 0)
				KeybindLabel.Font = Enum.Font.ArialBold
				KeybindLabel.Text = KeybindTitle
				KeybindLabel.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {KeybindLabel, 'TextColor3'})
				KeybindLabel.TextSize = TextSize
				KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

				KeybindBox.Name = "KeybindBox"
				KeybindBox.Parent = KeybindFrame
				KeybindBox.AnchorPoint = Vector2.new(0.5, 0.5)
				KeybindBox.BackgroundColor3 = theme['BackgroundColor']
				table.insert(ColorThemes['BackgroundColor'], {KeybindBox, 'BackgroundColor3'})
				KeybindBox.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {KeybindBox, 'BorderColor3'})
				KeybindBox.Position = UDim2.new(0.825, 0, 0.5, 0)
				KeybindBox.Size = UDim2.new(0.35, 0, 1, 0)
				KeybindBox.Font = Enum.Font.ArialBold
				KeybindBox.PlaceholderText = defaulttext
				table.insert(ColorThemes['TextColor'], {KeybindBox, 'PlaceholderColor3'})
				KeybindBox.Text = ""
				KeybindBox.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {KeybindBox, 'TextColor3'})
				KeybindBox.TextScaled = true
				KeybindBox.TextSize = TextSize
				KeybindBox.TextWrapped = false

				KeybindPadding.Name = "KeybindPadding"
				KeybindPadding.Parent = KeybindFrame
				KeybindPadding.PaddingBottom = UDim.new(0, 5)
				KeybindPadding.PaddingLeft = UDim.new(0, 5)
				KeybindPadding.PaddingRight = UDim.new(0, 5)
				KeybindPadding.PaddingTop = UDim.new(0, 5)

				local Listening = false

				KeybindBox.Focused:Connect(function()
					Listening = true
				end)
				KeybindBox.FocusLost:Connect(function()
					Listening = false
					KeybindBox.Text = tostring(keybinded):split('.')[3]
					
				end)

				game:GetService('UserInputService').InputBegan:Connect(function(input)
					if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
						keybinded = input.KeyCode
						KeybindBox:ReleaseFocus()
						return
					end
					if input.KeyCode == keybinded then
						if not exists() then return end
						callback()
					end	
				end)

			end

			function elements:NewTextbox(TextboxTitle, callback, defaulttext)
				TextboxTitle = TextboxTitle or 'TextBox'
				callback = callback or function()end
				defaulttext = defaulttext or ''
				local TextBoxFrame = Instance.new("Frame")
				local TextLabel = Instance.new("TextLabel")
				local TextBox = Instance.new("TextBox")
				local TextBoxPadding = Instance.new("UIPadding")

				TextBoxFrame.Name = "TextBoxFrame"
				TextBoxFrame.Parent = Section
				TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBoxFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
				TextBoxFrame.BackgroundTransparency = 1.000
				TextBoxFrame.BorderSizePixel = 0
				TextBoxFrame.Position = UDim2.new(0.045, 0, 0.112, 0)
				TextBoxFrame.Size = UDim2.new(1, 0, 0, 30)

				TextLabel.Parent = TextBoxFrame
				TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.25, 0, 0.5, 0)
				TextLabel.Size = UDim2.new(0.5, 0, 1, 0)
				TextLabel.Font = Enum.Font.ArialBold
				TextLabel.Text = TextboxTitle
				TextLabel.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {TextLabel, 'TextColor3'})
				TextLabel.TextSize = TextSize
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				TextBox.Parent = TextBoxFrame
				TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox.BackgroundColor3 = theme['BackgroundColor']
				table.insert(ColorThemes['BackgroundColor'], {TextLabel, 'BackgroundColor3'})
				TextBox.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {TextBox, 'BorderColor3'})
				TextBox.Position = UDim2.new(0.775, 0, 0.5, 0)
				TextBox.Size = UDim2.new(0.45, 0, 1, 0)
				TextBox.Font = Enum.Font.ArialBold
				TextBox.PlaceholderText = defaulttext
				table.insert(ColorThemes['TextColor'], {TextBox, 'PlaceholderColor3'})
				TextBox.Text = ""
				TextBox.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {TextBox, 'TextColor3'})
				TextBox.TextScaled = true
				TextBox.TextSize = TextSize
				TextBox.TextWrapped = true

				TextBoxPadding.Name = "TextBoxPadding"
				TextBoxPadding.Parent = TextBoxFrame
				TextBoxPadding.PaddingBottom = UDim.new(0, 5)
				TextBoxPadding.PaddingLeft = UDim.new(0, 5)
				TextBoxPadding.PaddingRight = UDim.new(0, 5)
				TextBoxPadding.PaddingTop = UDim.new(0, 5)

				TextBox.FocusLost:Connect(function()
					local txt = TextBox.Text
					if txt == '' then return end
					if not exists() then return end
					callback(txt)
				end)
			end

			function elements:NewToggle(ToggleTitle, callback, defaulttog)
				defaulttog = defaulttog or false
				local update = {}
				local ToggleFrame = Instance.new("Frame")
				local ToggleLabel = Instance.new("TextLabel")
				local TogglePadding = Instance.new("UIPadding")
				local ToggleButton = Instance.new("ImageButton")
				local ToggleOnImg = Instance.new("ImageLabel")
				local ToggleOnImgAspect = Instance.new("UIAspectRatioConstraint")
				local ToggleOffImg = Instance.new("ImageLabel")
				local ToggleOffImgAspect = Instance.new("UIAspectRatioConstraint")
				local ToggleSwitch = Instance.new("ImageLabel")
				local ToggleSwitchAspect = Instance.new("UIAspectRatioConstraint")

				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Parent = Section
				ToggleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
				ToggleFrame.BackgroundTransparency = 1.000
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.Position = UDim2.new(0, 1, 0, 1)
				ToggleFrame.Size = UDim2.new(1, 0, 0, 30)

				ToggleLabel.Name = "ToggleLabel"
				ToggleLabel.Parent = ToggleFrame
				ToggleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleLabel.BackgroundTransparency = 1.000
				ToggleLabel.BorderSizePixel = 0
				ToggleLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
				ToggleLabel.Size = UDim2.new(1, 0, 0, 30)
				ToggleLabel.Font = Enum.Font.ArialBold
				ToggleLabel.Text = ToggleTitle
				ToggleLabel.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {ToggleLabel, 'TextColor3'})
				ToggleLabel.TextSize = TextSize
				ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

				TogglePadding.Name = "TogglePadding"
				TogglePadding.Parent = ToggleFrame
				TogglePadding.PaddingBottom = UDim.new(0, 5)
				TogglePadding.PaddingLeft = UDim.new(0, 5)
				TogglePadding.PaddingRight = UDim.new(0, 5)
				TogglePadding.PaddingTop = UDim.new(0, 5)

				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = ToggleFrame
				ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleButton.BackgroundColor3 = theme['BackgroundColor']
				table.insert(ColorThemes['BackgroundColor'], {ToggleButton, 'BackgroundColor3'})
				ToggleButton.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {ToggleButton, 'BorderColor3'})
				ToggleButton.Position = UDim2.new(0.875, 0, 0.5, 0)
				ToggleButton.Size = UDim2.new(0.25, 0, 0, 20)
				ToggleButton.AutoButtonColor = false
				ToggleButton.ScaleType = Enum.ScaleType.Fit

				ToggleOnImg.Name = "ToggleOnImg"
				ToggleOnImg.Parent = ToggleButton
				ToggleOnImg.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleOnImg.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {ToggleOnImg, 'BackgroundColor3'})
				ToggleOnImg.BackgroundTransparency = 1.000
				ToggleOnImg.BorderSizePixel = 0
				ToggleOnImg.Position = UDim2.new(0.25, 0, 0.5, 0)
				ToggleOnImg.Size = UDim2.new(0.75, 0, 0.75, 0)
				ToggleOnImg.Image = "rbxassetid://7072719338"
				ToggleOnImg.ScaleType = Enum.ScaleType.Fit

				ToggleOnImgAspect.Name = "ToggleOnImgAspect"
				ToggleOnImgAspect.Parent = ToggleOnImg

				ToggleOffImg.Name = "ToggleOffImg"
				ToggleOffImg.Parent = ToggleButton
				ToggleOffImg.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleOffImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleOffImg.BackgroundTransparency = 1.000
				ToggleOffImg.BorderSizePixel = 0
				ToggleOffImg.Position = UDim2.new(0.75, 0, 0.5, 0)
				ToggleOffImg.Size = UDim2.new(0.6, 0, 0.6, 0)
				ToggleOffImg.Image = "rbxassetid://7072707153"
				ToggleOffImg.ScaleType = Enum.ScaleType.Fit

				ToggleOffImgAspect.Name = "ToggleOffImgAspect"
				ToggleOffImgAspect.Parent = ToggleOffImg

				ToggleSwitch.Name = "ToggleSwitch"
				ToggleSwitch.Parent = ToggleButton
				ToggleSwitch.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleSwitch.BackgroundColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {ToggleSwitch, 'BackgroundColor3'})
				ToggleSwitch.BorderSizePixel = 0
				ToggleSwitch.Position = UDim2.new(0.225, 0, 0.5, 0)
				ToggleSwitch.Size = UDim2.new(0.75, 0, 0.75, 0)
				ToggleSwitch.ScaleType = Enum.ScaleType.Fit

				ToggleSwitchAspect.Name = "ToggleSwitchAspect"
				ToggleSwitchAspect.Parent = ToggleSwitch


				local toggled = false
				local debounce = false

				local function SwitchToggle()
					if debounce then return end
					toggled = not toggled
					debounce = true
					local pos = toggled and 0.775 or 0.225
					local tweeninfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local SwitchTween = TweenService:Create(ToggleSwitch, tweeninfo, {Position=UDim2.new(pos,0,0.5,0)})
					SwitchTween:Play()
					if not exists() then return end
					callback(toggled)
					wait(0.25)
					debounce = false
				end

				ToggleButton.MouseButton1Click:Connect(SwitchToggle)

				if defaulttog then SwitchToggle() end

				function update:UpdateToggle(tog)
					toggled = not tog
					SwitchToggle()
				end

				return update

			end

			function elements:NewSlider(SliderTitle, callback, MinNum, MaxNum, DefNum)
                local update = {}
				local latestnum = 0
				SliderTitle = SliderTitle or 'Slider'
				callback = callback or function()end
				MinNum = MinNum or 0
				MaxNum = MaxNum or 10
				DefNum = DefNum or MinNum
				local SliderFrame = Instance.new("Frame")
				local SliderPadding = Instance.new("UIPadding")
				local SliderLabel = Instance.new("TextLabel")
				local SliderNumber = Instance.new("TextBox")
				local SliderLine = Instance.new("ImageButton")
				local SliderButton = Instance.new("ImageButton")
				local SliderButtonAspect = Instance.new("UIAspectRatioConstraint")
				local SliderFill = Instance.new("ImageLabel")

				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Section
				SliderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
				SliderFrame.BackgroundTransparency = 1.000
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(0.45, 0, 0.112, 0)
				SliderFrame.Size = UDim2.new(1, 0, 0, 60)

				SliderPadding.Name = "SliderPadding"
				SliderPadding.Parent = SliderFrame
				SliderPadding.PaddingBottom = UDim.new(0, 5)
				SliderPadding.PaddingLeft = UDim.new(0, 5)
				SliderPadding.PaddingRight = UDim.new(0, 5)
				SliderPadding.PaddingTop = UDim.new(0, 5)

				SliderLabel.Name = "SliderLabel"
				SliderLabel.Parent = SliderFrame
				SliderLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderLabel.BackgroundTransparency = 1.000
				SliderLabel.Position = UDim2.new(0.5, 0, 0.2, 0)
				SliderLabel.Size = UDim2.new(1, 0, 0, 30)
				SliderLabel.Font = Enum.Font.ArialBold
				SliderLabel.Text = SliderTitle
				SliderLabel.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {SliderLabel, 'TextColor3'})
				SliderLabel.TextSize = TextSize
				SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

				SliderNumber.Name = "SliderNumber"
				SliderNumber.Parent = SliderFrame
				SliderNumber.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderNumber.BackgroundColor3 = theme['BackgroundColor']
				table.insert(ColorThemes['BackgroundColor'], {SliderNumber, 'BackgroundColor3'})
				SliderNumber.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {SliderNumber, 'BorderColor3'})
				SliderNumber.Position = UDim2.new(0.9, 0, 0.75, 0)
				SliderNumber.Size = UDim2.new(0, 25, 0, 20)
				SliderNumber.Font = Enum.Font.ArialBold
				SliderNumber.PlaceholderText = DefNum
				table.insert(ColorThemes['TextColor'], {SliderNumber, 'PlaceholderColor3'})
				SliderNumber.Text = DefNum
				SliderNumber.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {SliderNumber, 'TextColor3'})
				SliderNumber.TextScaled = true
				SliderNumber.TextSize = TextSize
				SliderNumber.TextWrapped = true

				SliderLine.Name = "SliderLine"
				SliderLine.Parent = SliderFrame
				SliderLine.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderLine.BackgroundColor3 = theme['BackgroundColor']
				table.insert(ColorThemes['BackgroundColor'], {SliderLine, 'BackgroundColor3'})
				SliderLine.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {SliderLine, 'BorderColor3'})
				SliderLine.Position = UDim2.new(0.4, 0, 0.75, 0)
				SliderLine.Size = UDim2.new(0.75, 0, 0, 5)
				SliderLine.AutoButtonColor = false

				SliderButton.Name = "SliderButton"
				SliderButton.Parent = SliderLine
				SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderButton.BackgroundTransparency = 1.000
				SliderButton.Position = UDim2.new(0, 0, 0.5, 0)
				SliderButton.Rotation = 90.000
				SliderButton.Size = UDim2.new(5, 0, 5, 0)
				SliderButton.AutoButtonColor = false
				SliderButton.Image = "rbxassetid://7072719338"
				SliderButton.ImageColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {SliderButton, 'ImageColor3'})
				SliderButtonAspect.Name = "SliderButtonAspect"
				SliderButtonAspect.Parent = SliderButton

				SliderFill.Name = "SliderFill"
				SliderFill.Parent = SliderLine
				SliderFill.AnchorPoint = Vector2.new(0, 0.5)
				SliderFill.Position = UDim2.new(0,0,0.5,0)
				SliderFill.Size = UDim2.new(0,0,1,0)
				SliderFill.BackgroundColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {SliderFill, 'BackgroundColor3'})
				SliderFill.ImageTransparency = 1
				SliderFill.BorderSizePixel = 0

				local drag = false

				local function TweenSize(Per)
					local tweeninfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
					local NewSize = TweenService:Create(SliderButton, tweeninfo, {Position=UDim2.new(Per, 0, 0.5, 0)})
					local NewFillSize = TweenService:Create(SliderFill, tweeninfo, {Size=UDim2.new(Per, 0, 1, 0)})
					NewSize:Play()
					NewFillSize:Play()
				end

				local function Resize(Number)
					local Percent = math.clamp(Number/MaxNum, 0, 1)
					TweenSize(Percent)
				end

				local function Drag()
					if not drag then return end
					local MousePos = UserInputService:GetMouseLocation() + Vector2.new(0, 36)
					local RelPos = MousePos - SliderLine.AbsolutePosition
					local Percent = math.clamp(RelPos.X/SliderLine.AbsoluteSize.X, 0, 1)
					TweenSize(Percent)
					local Amount = math.round(math.floor((MinNum + (MaxNum - MinNum) * Percent) * MaxNum) / MaxNum)
					SliderNumber.Text = Amount
				end

				SliderButton.MouseButton1Down:Connect(function()
					drag = true
				end)
				SliderLine.MouseButton1Down:Connect(function()
					drag = true
				end)
				SliderLine.MouseButton1Click:Connect(function()
					drag = true
					Drag()
				end)

				UserInputService.InputChanged:Connect(Drag)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						drag = false
					end
				end)

				local function UpdateText()
					local input = SliderNumber.Text
					if input == '' then return end
					local num = tonumber(input)
					if not num then SliderNumber.Text = 0 return end
					if num > MaxNum then
						num = MaxNum
						SliderNumber.Text = MaxNum
						Resize(MaxNum)
					elseif num < MinNum then
						num = MinNum
						SliderNumber.Text = MinNum
						Resize(MinNum)
					else
						Resize(num)
					end
					if not exists() then return end
					latestnum = num
					callback(num)
				end


				SliderNumber:GetPropertyChangedSignal("Text"):Connect(function()
					UpdateText()
				end)
				Resize(DefNum)

                function update:UpdateSlider(SliderValue)
					SliderNumber.Text = tostring(SliderValue)
                    UpdateText()
                end
				function update:UpdateMaxSlider(SliderValue)
					MaxNum = SliderValue
					SliderNumber.Text = tostring(latestnum)
					UpdateText()
				end
                return update
			end

			function elements:NewDropdown(DropdownTitle, callback, Options, ResetText)
				local DropdownSize = 4
				ResetText = ResetText or false
				DropdownTitle = DropdownTitle or 'Dropdown'
				callback = callback or function()end
				Options = Options or {}
				local DropdownFrame = Instance.new("Frame")
				local DropdownBox = Instance.new("TextBox")
				local DropdownButton = Instance.new("ImageButton")
				local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
				local DropdownContainer = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = Section
				DropdownFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownFrame.BackgroundTransparency = 1.000
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.Position = UDim2.new(0.045, 0, 0.112, 0)
				DropdownFrame.Size = UDim2.new(1, 0, 0, 30)

				DropdownBox.Name = "DropdownBox"
				DropdownBox.Parent = DropdownFrame
				DropdownBox.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownBox.BackgroundTransparency = 1.000
				DropdownBox.BorderSizePixel = 0
				DropdownBox.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownBox.Size = UDim2.new(1, 0, 0, 30)
				DropdownBox.Font = Enum.Font.ArialBold
				DropdownBox.PlaceholderText = DropdownTitle
				DropdownBox.PlaceholderColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {DropdownBox, 'PlaceholderColor3'})
				DropdownBox.Text = ""
				DropdownBox.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {DropdownBox, 'TextColor3'})
				DropdownBox.TextSize = TextSize
				DropdownBox.TextXAlignment = Enum.TextXAlignment.Center

				DropdownButton.Name = "DropdownButton"
				DropdownButton.Parent = DropdownFrame
				DropdownButton.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownButton.BackgroundTransparency = 1.000
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Position = UDim2.new(0.95, 0, 0.5, 0)
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Image = "rbxassetid://7072706703"
				DropdownButton.ScaleType = Enum.ScaleType.Fit
				DropdownButton.ImageColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {DropdownButton, 'ImageColor3'})

				UIAspectRatioConstraint.Parent = DropdownButton

				DropdownContainer.Name = "DropdownContainer"
				DropdownContainer.Parent = Section
				DropdownContainer.Active = true
				DropdownContainer.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownContainer.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {DropdownContainer, 'BackgroundColor3'})
				DropdownContainer.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {DropdownContainer, 'BorderColor3'})
				DropdownContainer.Position = UDim2.new(0.045, 0, 0.112, 0)
				DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
				DropdownContainer.Visible = false
				DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropdownContainer.ScrollBarThickness = 3
				DropdownContainer.ScrollingDirection = Enum.ScrollingDirection.Y
				DropdownContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

				UIListLayout.Parent = DropdownContainer
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				
				DropdownContainer.MouseEnter:Connect(function()
					MouseScroll['InFrame'] = false
				end)

				DropdownContainer.MouseLeave:Connect(function()
					MouseScroll['InFrame'] = true
				end)

				local function ResizeCanvas()
					local NewCanvasSize = UIListLayout.AbsoluteContentSize
					DropdownContainer.CanvasSize = UDim2.new(0,NewCanvasSize.X,0,NewCanvasSize.Y)
				end

				local CurrentOption = false

				local function DropTween(boo)
					ResizeCanvas()
					local NewCanvasSize = UIListLayout.AbsoluteContentSize
					local dropsize = NewCanvasSize.Y >= DropdownSize * 30 and DropdownSize * 30 or NewCanvasSize.Y
					local arrowshow = boo and -90 or 0
					local dropshowval = boo and dropsize or 0
					local tweeninfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local ArrowShow = TweenService:Create(DropdownButton, tweeninfo, {Rotation=arrowshow})
					local DropShow = TweenService:Create(DropdownContainer, tweeninfo, {Visible=boo,Size=UDim2.new(1,0,0,dropshowval)})
					ArrowShow:Play()
					DropShow:Play()
					wait(0.25)
				end

				local function UpdateOptions(options)
					DropdownBox.Text = ""
					DropTween(false)
					DropdownBox.PlaceholderText = DropdownTitle
					for _,v in pairs(DropdownContainer:GetChildren()) do
						if v:IsA('TextButton') then
							v:Destroy()
						end
					end
					for _,option in pairs(options) do
						local Option = Instance.new("TextButton")
						Option.Name = option
						Option.Parent = DropdownContainer
						Option.AnchorPoint = Vector2.new(0.5, 0.5)
						Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Option.BackgroundTransparency = 1.000
						Option.BorderSizePixel = 0
						Option.Position = UDim2.new(0.5, 0, 0.5, 0)
						Option.Size = UDim2.new(1, 0, 0, 30)
						Option.Font = Enum.Font.ArialBold
						Option.Text = option
						Option.TextColor3 = theme['TextColor']
						table.insert(ColorThemes['TextColor'], {Option, 'TextColor3'})
						Option.TextSize = TextSize

						Option.MouseButton1Click:Connect(function()
							CurrentOption = Option.Text
							if ResetText then
								DropdownBox.Text = ""
								DropdownBox.PlaceholderText = DropdownTitle
								for _,b in pairs(DropdownContainer:GetChildren()) do
									if b:IsA('TextButton') then
										b.TextColor3 = theme['TextColor']
									end
								end
								Option.TextColor3 = theme['SelectedTextColor']
							else
								DropdownBox.Text = Option.Text
							end
							if not exists() or not Option then return end
							callback(CurrentOption)
							DropTween(false)
						end)
					end
				end

				UpdateOptions(Options)

				DropdownBox.Focused:Connect(function()
					DropTween(true)
				end)

				DropdownBox.FocusLost:Connect(function()
					wait(0.1)
					if CurrentOption then
						DropdownBox.Text = CurrentOption
					else
						DropdownBox.PlaceholderText = DropdownTitle
					end
					DropTween(false)
				end)

				DropdownButton.MouseButton1Click:Connect(function()
					local boo = DropdownButton.Rotation == 0 and true or false
					DropTween(boo)
				end)

				DropdownBox:GetPropertyChangedSignal('Text'):Connect(function()
					local txt = DropdownBox.Text
					for _,v in pairs(DropdownContainer:GetChildren()) do
						if v:IsA('TextButton') then
							if not string.match(string.lower(v.Text), string.lower(txt)) then
								v.Visible = false
							else
								v.Visible = true
							end
						end
					end
					DropTween(true)
					ResizeCanvas()
				end)

				DropdownContainer:GetPropertyChangedSignal('AbsoluteCanvasSize'):Connect(ResizeCanvas)

				local update = {}

				function update:UpdateOptions(NewOptions)
                    UpdateOptions(NewOptions)
                end
                return update

			end

			function elements:NewDropdownToggle(DropdownTitle, callback, Options)
				local DropdownSize = 4
				local update = {}
				local ChosenOptions = {}
				DropdownTitle = DropdownTitle or 'Dropdown'
				callback = callback or function()end
				Options = Options or {}
				local DropdownFrame = Instance.new("Frame")
				local DropdownBox = Instance.new("TextBox")
				local DropdownButton = Instance.new("ImageButton")
				local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
				local DropdownContainer = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = Section
				DropdownFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownFrame.BackgroundTransparency = 1.000
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.Position = UDim2.new(0.045, 0, 0.112, 0)
				DropdownFrame.Size = UDim2.new(1, 0, 0, 30)

				DropdownBox.Name = "DropdownBox"
				DropdownBox.Parent = DropdownFrame
				DropdownBox.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownBox.BackgroundTransparency = 1.000
				DropdownBox.BorderSizePixel = 0
				DropdownBox.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownBox.Size = UDim2.new(1, 0, 0, 30)
				DropdownBox.Font = Enum.Font.ArialBold
				DropdownBox.PlaceholderText = DropdownTitle
				DropdownBox.PlaceholderColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {DropdownBox, 'PlaceholderColor3'})
				DropdownBox.Text = ""
				DropdownBox.TextColor3 = theme['TextColor']
				table.insert(ColorThemes['TextColor'], {DropdownBox, 'TextColor3'})
				DropdownBox.TextSize = TextSize
				DropdownBox.TextXAlignment = Enum.TextXAlignment.Center

				DropdownButton.Name = "DropdownButton"
				DropdownButton.Parent = DropdownFrame
				DropdownButton.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownButton.BackgroundTransparency = 1.000
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Position = UDim2.new(0.95, 0, 0.5, 0)
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Image = "rbxassetid://7072706703"
				DropdownButton.ScaleType = Enum.ScaleType.Fit
				DropdownButton.ImageColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {DropdownButton, 'ImageColor3'})

				UIAspectRatioConstraint.Parent = DropdownButton

				DropdownContainer.Name = "DropdownContainer"
				DropdownContainer.Parent = Section
				DropdownContainer.Active = true
				DropdownContainer.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownContainer.BackgroundColor3 = theme['MainColor']
				table.insert(ColorThemes['MainColor'], {DropdownContainer, 'BackgroundColor3'})
				DropdownContainer.BorderColor3 = theme['AccentColor']
				table.insert(ColorThemes['AccentColor'], {DropdownContainer, 'BorderColor3'})
				DropdownContainer.Position = UDim2.new(0.045, 0, 0.112, 0)
				DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
				DropdownContainer.Visible = false
				DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropdownContainer.ScrollBarThickness = 3
				DropdownContainer.ScrollingDirection = Enum.ScrollingDirection.Y
				DropdownContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

				UIListLayout.Parent = DropdownContainer
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				local function ResizeCanvas()
					local NewCanvasSize = UIListLayout.AbsoluteContentSize
					DropdownContainer.CanvasSize = UDim2.new(0,NewCanvasSize.X,0,NewCanvasSize.Y)
				end

				local function DropTween(boo)
					ResizeCanvas()
					local NewCanvasSize = UIListLayout.AbsoluteContentSize
					local dropsize = NewCanvasSize.Y >= DropdownSize * 30 and DropdownSize * 30 or NewCanvasSize.Y
					local arrowshow = boo and -90 or 0
					local dropshowval = boo and dropsize or 0
					local tweeninfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local ArrowShow = TweenService:Create(DropdownButton, tweeninfo, {Rotation=arrowshow})
					local DropShow = TweenService:Create(DropdownContainer, tweeninfo, {Visible=boo,Size=UDim2.new(1,0,0,dropshowval)})
					ArrowShow:Play()
					DropShow:Play()
					wait(0.25)
				end

				local function UpdateOptions(options)
					ChosenOptions = {}
					DropdownBox.Text = ""
					DropTween(false)
					DropdownBox.PlaceholderText = DropdownTitle
					for _,v in pairs(DropdownContainer:GetChildren()) do
						if v:IsA('TextButton') then
							v:Destroy()
						end
					end
					for _,option in pairs(options) do
						local Option = Instance.new("TextButton")
						Option.Name = option
						Option.Parent = DropdownContainer
						Option.AnchorPoint = Vector2.new(0.5, 0.5)
						Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Option.BackgroundTransparency = 1.000
						Option.BorderSizePixel = 0
						Option.Position = UDim2.new(0.5, 0, 0.5, 0)
						Option.Size = UDim2.new(1, 0, 0, 30)
						Option.Font = Enum.Font.ArialBold
						Option.Text = option
						Option.TextColor3 = theme['TextColor']
						table.insert(ColorThemes['TextColor'], {Option, 'TextColor3'})
						Option.TextSize = TextSize

						Option.MouseButton1Click:Connect(function()
							local CurrentOption = Option.Text
							DropdownBox.Text = ""
							DropdownBox.PlaceholderText = DropdownTitle
							if not exists() then return end
							local opt = table.find(ChosenOptions, CurrentOption)
							if opt then
								Option.TextColor3 = theme['TextColor']
								table.remove(ChosenOptions, opt)
							else
								Option.TextColor3 = theme['SelectedTextColor']
								table.insert(ChosenOptions, CurrentOption)
							end
							callback(ChosenOptions)
							--DropTween(false)
						end)

					end
				end

				UpdateOptions(Options)

				DropdownContainer.MouseEnter:Connect(function()
					MouseScroll['InFrame'] = false
				end)

				DropdownContainer.MouseLeave:Connect(function()
					MouseScroll['InFrame'] = true
				end)

				DropdownBox.Focused:Connect(function()
					DropTween(true)
				end)

				DropdownBox.FocusLost:Connect(function()
					wait(0.1)
					DropdownBox.PlaceholderText = DropdownTitle
					DropTween(false)
				end)

				DropdownButton.MouseButton1Click:Connect(function()
					local boo = DropdownButton.Rotation == 0 and true or false
					DropTween(boo)
				end)

				DropdownBox:GetPropertyChangedSignal('Text'):Connect(function()
					local txt = DropdownBox.Text
					for _,v in pairs(DropdownContainer:GetChildren()) do
						if v:IsA('TextButton') then
							if not string.match(string.lower(v.Text), string.lower(txt)) then
								v.Visible = false
							else
								v.Visible = true
							end
						end
					end
					DropTween(true)
					ResizeCanvas()
				end)

				DropdownContainer:GetPropertyChangedSignal('AbsoluteCanvasSize'):Connect(ResizeCanvas)

				function update:UpdateOptions(NewOptions)
                    UpdateOptions(NewOptions)
                end
				return update

			end

			return elements

		end

		local Frames = UIFrame:GetChildren()

		for _,page in pairs(Frames) do
			page.PageListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local ActivePage = page.ActiveFrame.Value
				local Tweeninfo = TweenInfo.new(0.01, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				local PageSize = page.PageListLayout.AbsoluteContentSize
				local NewPageSize = UDim2.new(0,200,0,PageSize.Y+10)
				local pagepos = ActivePage and 0.5 or -0.5
				local NewPagePos = UDim2.new(0.5, 0, pagepos, 0)
				local SizeTween = TweenService:Create(page, Tweeninfo, {Size=NewPageSize})
				local PosTween = TweenService:Create(page, Tweeninfo, {Position=NewPagePos})
				SizeTween:Play()
				PosTween:Play()
			end)
		end

		UserInputService.InputChanged:connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseWheel and MouseScroll['InFrame'] then
				local TextBoxFocused = UserInputService:GetFocusedTextBox()
				if TextBoxFocused then return end
				local direction = input.Position.Z > 0 and "up" or "down"
				if not MouseScroll['Debounce'] then
					if #Frames == 1 then return end
					MouseScroll['Debounce'] = true
					local dir = direction == "down" and 1 or -1
					local CurrentFrame = function()for _,v in pairs(Frames) do if v.ActiveFrame.Value then return v end end end
					local NewFrame = function()
						local NewFrameReturn = false
						for _,v in pairs(Frames) do
							if v.FrameNumber.Value == CurrentFrame().FrameNumber.Value + dir then
								NewFrameReturn = v
								break
							end
						end
						if direction == "down" and not NewFrameReturn then
							NewFrameReturn = Frames[1]
						elseif direction == "up" and not NewFrameReturn then
							NewFrameReturn = Frames[#Frames]
						end
						CurrentFrame().ActiveFrame.Value = false
						NewFrameReturn.ActiveFrame.Value = true
						return NewFrameReturn
					end
					local CurrentFrameVar = CurrentFrame()
					local NewFrameVar = NewFrame()
					local SendCurrent
					if direction == "down" then
						NewFrameVar.Position = UDim2.new(0.5, 0, 1.5, 0)
						SendCurrent = UDim2.new(0.5, 0, -0.5, 0)
					elseif direction == "up" then
						NewFrameVar.Position = UDim2.new(0.5, 0, -0.5, 0)
						SendCurrent = UDim2.new(0.5, 0, 1.5, 0)
					end

					local Tweeninfo = TweenInfo.new(MouseScroll['WaitTime'], Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local CurrentTween = TweenService:Create(CurrentFrameVar, Tweeninfo, {Position=SendCurrent})
					local NewTween = TweenService:Create(NewFrameVar, Tweeninfo, {Position=UDim2.new(0.5,0,0.5,0)})
					CurrentTween:Play()
					NewTween:Play()
					wait(MouseScroll['WaitTime'])
					MouseScroll['Debounce'] = false
				end
			end
		end)

		UIFrame.MouseEnter:Connect(function()
			LockZoom()
			MouseScroll['InFrame'] = true
		end)

		UIFrame.MouseLeave:Connect(function()
			ResetZoom()
			MouseScroll['InFrame'] = false
		end)

		return sections

	end

	return pages

end

return library
