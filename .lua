here-- LocalScript داخل StarterGui
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء الـ ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BlackLibraryGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- المكتبة
local Library = {}

-- إنشاء نافذة جديدة
function Library:CreateWindow(title, sizeX, sizeY)
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, sizeX or 500, 0, sizeY or 300)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(255,255,255)
    main.Parent = gui

    -- Dragging functionality
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, mousePos, framePos

    local function update(input)
        local delta = input.Position - mousePos
        main.Position = UDim2.new(0, framePos.X + delta.X, 0, framePos.Y + delta.Y)
    end

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- زر X للإخفاء/الإظهار
    local hideBtn = Instance.new("TextButton", main)
    hideBtn.Size = UDim2.new(0, 30, 0, 30)
    hideBtn.Position = UDim2.new(1, -35, 0, 5)
    hideBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    hideBtn.BorderColor3 = Color3.fromRGB(255,255,255)
    hideBtn.BorderSizePixel = 2
    hideBtn.Text = "X"
    hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 18

    hideBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    -- تبويبات على اليسار
    local tabs = Instance.new("ScrollingFrame", main)
    tabs.Size = UDim2.new(0, 150, 1, -10)
    tabs.Position = UDim2.new(0, 5, 0, 5)
    tabs.BackgroundColor3 = Color3.fromRGB(0,0,0)
    tabs.BorderColor3 = Color3.fromRGB(255,255,255)
    tabs.BorderSizePixel = 2
    tabs.CanvasSize = UDim2.new(0,0,0,0)
    tabs.ScrollBarThickness = 6

    local UIListLayout = Instance.new("UIListLayout", tabs)
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- محتوى يمين
    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, -165, 1, -10)
    content.Position = UDim2.new(0, 160, 0, 5)
    content.BackgroundColor3 = Color3.fromRGB(0,0,0)
    content.BorderColor3 = Color3.fromRGB(255,255,255)
    content.BorderSizePixel = 2
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.ScrollBarThickness = 6

    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0,10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- دوال لإضافة عناصر
    local WindowAPI = {}

    function WindowAPI:AddTab(name)
        local tabBtn = Instance.new("TextButton", tabs)
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Position = UDim2.new(0,5,0,0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        tabBtn.BorderColor3 = Color3.fromRGB(255,255,255)
        tabBtn.BorderSizePixel = 2
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 16

        tabs.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)

        return tabBtn
    end

    function WindowAPI:AddButton(text, callback)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btn.BorderColor3 = Color3.fromRGB(255,255,255)
        btn.BorderSizePixel = 2
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16

        btn.MouseButton1Click:Connect(callback)

        content.CanvasSize = UDim2.new(0,0,0,contentLayout.AbsoluteContentSize.Y)

        return btn
    end

    function WindowAPI:AddToggle(text, callback)
        local toggled = false
        local toggleBtn = Instance.new("TextButton", content)
        toggleBtn.Size = UDim2.new(1, -10, 0, 40)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        toggleBtn.BorderColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.BorderSizePixel = 2
        toggleBtn.Text = text..": OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.Font = Enum.Font.Gotham
        toggleBtn.TextSize = 16

        toggleBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggleBtn.Text = text..(toggled and ": ON" or ": OFF")
            if callback then callback(toggled) end
        end)

        content.CanvasSize = UDim2.new(0,0,0,contentLayout.AbsoluteContentSize.Y)

        return toggleBtn
    end

    return WindowAPI
end

return Library
