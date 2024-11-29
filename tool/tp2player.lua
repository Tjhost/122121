local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create GUI elements
local gui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleBar = Instance.new("TextLabel")
local dropDown = Instance.new("TextButton")
local playerList = Instance.new("ScrollingFrame")
local teleportButton = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")
local refreshButton = Instance.new("TextButton")

-- GUI properties
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "TeleportGui"

-- Function to adjust GUI size based on the number of players
local function adjustGuiSize()
    -- Keep the GUI compact by default
    mainFrame.Size = UDim2.new(0.3, 0, 0.25, 0)  -- Compact size
    playerList.Size = UDim2.new(0.8, 0, 0.25, 0)  -- Size of the player list
end

-- Main frame properties
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0.3, 0, 0.25, 0)  -- Initial compact size
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

-- Title bar properties (fixed height)
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0.2, 0)  -- Fixed height for title bar
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Text = "Player Teleport"
titleBar.TextScaled = true
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold

-- Dropdown button properties
dropDown.Parent = mainFrame
dropDown.Size = UDim2.new(0.8, 0, 0.15, 0)
dropDown.Position = UDim2.new(0.1, 0, 0.2, 0)  -- Positioned below the title bar
dropDown.Text = "Select a Player"
dropDown.TextScaled = true
dropDown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropDown.Font = Enum.Font.SourceSans

-- Player list for dropdown options with scroll support
playerList.Parent = mainFrame
playerList.Size = UDim2.new(0.8, 0, 0.25, 0)
playerList.Position = UDim2.new(0.1, 0, 0.35, 0)  -- Positioned below the dropdown
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 6
playerList.Visible = false

-- Teleport button properties
teleportButton.Parent = mainFrame
teleportButton.Position = UDim2.new(0.1, 0, 0.75, 0)
teleportButton.Size = UDim2.new(0.8, 0, 0.15, 0)
teleportButton.Text = "Teleport"
teleportButton.TextScaled = true
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
teleportButton.Font = Enum.Font.SourceSans

-- Refresh button properties
refreshButton.Parent = mainFrame
refreshButton.Position = UDim2.new(0.1, 0, 0.92, 0)
refreshButton.Size = UDim2.new(0.8, 0, 0.1, 0)
refreshButton.Text = "Refresh"
refreshButton.TextScaled = true
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
refreshButton.Font = Enum.Font.SourceSans

-- Close button properties
closeButton.Parent = titleBar
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.Font = Enum.Font.SourceSansBold

-- Draggable functionality for the main frame
local dragging, dragStart, startPos
local draggingEnabled = false

-- Enable dragging when hovering over the GUI
mainFrame.MouseEnter:Connect(function()
    draggingEnabled = true
end)

mainFrame.MouseLeave:Connect(function()
    draggingEnabled = false
end)

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingEnabled then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Populate dropdown with player names
local function populateDropdown()
    for _, child in pairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local listHeight = 0
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Parent = playerList
            playerButton.Size = UDim2.new(1, -10, 0, 30)
            playerButton.Position = UDim2.new(0, 5, 0, listHeight)
            playerButton.Text = targetPlayer.Name
            playerButton.TextScaled = true
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            playerButton.Font = Enum.Font.SourceSans
            playerButton.MouseButton1Click:Connect(function()
                dropDown.Text = targetPlayer.Name
                playerList.Visible = false
            end)
            listHeight = listHeight + 35
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
end

-- Toggle player list visibility
dropDown.MouseButton1Click:Connect(function()
    playerList.Visible = not playerList.Visible
    if playerList.Visible then
        -- Expand the GUI size when the dropdown is open
        mainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)  -- Increase the height for dropdown
    else
        -- Return to the compact size when the dropdown is closed
        mainFrame.Size = UDim2.new(0.3, 0, 0.25, 0)
    end
end)

-- Teleport functionality
teleportButton.MouseButton1Click:Connect(function()
    local targetPlayer = Players:FindFirstChild(dropDown.Text)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    else
        warn("Selected player not found or doesn't have a valid position.")
    end
end)

-- Refresh button functionality
refreshButton.MouseButton1Click:Connect(function()
    populateDropdown()
    adjustGuiSize()  -- Adjust the size of the GUI based on player count
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Keyboard listener for 'O' key to close the GUI
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.O then
        gui.Enabled = false
    end
end)

-- Initial population of the player list
populateDropdown()
