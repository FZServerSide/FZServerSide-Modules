local Config = {
    Name = "FZ ServerSide",
    Version = "v0.0.1",
    WhitelistURL = "https://raw.githubusercontent.com/FZServerSide/Modules/refs/heads/Modules/Whitelist.json",
    DiscordLink = "https://discord.gg/yourserverhere",
    WhitelistEnabled = true
}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Username = Player.Name

local Authorized = false

local function httpGet(url)
    if syn and syn.request then return syn.request({Url = url, Method = "GET"}).Body
    elseif http_request then return http_request({Url = url, Method = "GET"}).Body
    elseif request then return request({Url = url, Method = "GET"}).Body
    else return HttpService:GetAsync(url) end
end

-- Whitelist check
local CorrectKey = ""
local AllowedUsers = {}
local IsWhitelisted = false

if Config.WhitelistEnabled then
    local success, json = pcall(httpGet, Config.WhitelistURL)
    if success and json then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
        if ok and type(data) == "table" then
            CorrectKey = data["whitelist key"] or ""
            local i = 1
            while data["username" .. i] do
                table.insert(AllowedUsers, data["username" .. i])
                i = i + 1
            end
        end
    end
    IsWhitelisted = table.find(AllowedUsers, Username)
end

local GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
GUI.IgnoreGuiInset = true
GUI.ResetOnSpawn = false

local Menu = Instance.new("Frame", GUI)
Menu.AnchorPoint = Vector2.new(0.5, 0.5)
Menu.Position = UDim2.new(0.5, 0, 0.5, 0)
Menu.Size = UDim2.new(0, 571, 0, 290)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 12)

local Header = Instance.new("Frame", Menu)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Position = UDim2.new(0, 12, 0, 4)
TitleLabel.Size = UDim2.new(0, 400, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = Config.Name
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 19
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local VersionLabel = Instance.new("TextLabel", Header)
VersionLabel.Position = UDim2.new(0, 12, 0, 24)
VersionLabel.Size = UDim2.new(0, 400, 0, 14)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = Config.Version
VersionLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 12
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left

local Tabs = Instance.new("Frame", Menu)
Tabs.Position = UDim2.new(0, 0, 0, 35)
Tabs.Size = UDim2.new(1, 0, 1, -35)
Tabs.BackgroundTransparency = 1
Tabs.ClipsDescendants = true

local LoginTab = Instance.new("Frame", Tabs)
LoginTab.Size = UDim2.new(1, 0, 1, 0)
LoginTab.BackgroundTransparency = 1
LoginTab.Visible = true

local LoaderTab = Instance.new("Frame", Tabs)
LoaderTab.Size = UDim2.new(1, 0, 1, 0)
LoaderTab.BackgroundTransparency = 1
LoaderTab.Visible = false

-- Login UI
local InfoTitle = Instance.new("TextLabel", LoginTab)
InfoTitle.Position = UDim2.new(0, 20, 0, 10)
InfoTitle.Size = UDim2.new(0, 260, 0, 30)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "How to get whitelisted"
InfoTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 18
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

local InfoText = Instance.new("TextLabel", LoginTab)
InfoText.Position = UDim2.new(0, 20, 0, 50)
InfoText.Size = UDim2.new(0, 260, 0, 140)
InfoText.BackgroundTransparency = 1
InfoText.Text = [[To use FZ ServerSide, you need a whitelist key.

Steps:
1. Join our Discord server
2. Go to the #shop channel
3. Purchase a key or follow the instructions]]
InfoText.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 15
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.TextWrapped = true

local DiscordBtn = Instance.new("TextButton", LoginTab)
DiscordBtn.Position = UDim2.new(0, 20, 1, -50)
DiscordBtn.Size = UDim2.new(0, 260, 0, 36)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Text = "Copy Discord Invite"
DiscordBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 16
DiscordBtn.TextXAlignment = Enum.TextXAlignment.Left

local discordScale = Instance.new("UIScale", DiscordBtn)
discordScale.Scale = 1
DiscordBtn.MouseButton1Down:Connect(function() TweenService:Create(discordScale, TweenInfo.new(0.1), {Scale = 1.08}):Play() end)
DiscordBtn.MouseButton1Up:Connect(function() TweenService:Create(discordScale, TweenInfo.new(0.1), {Scale = 1}):Play() end)
DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard(Config.DiscordLink)
    DiscordBtn.Text = "Copied!"
    task.wait(1.5)
    DiscordBtn.Text = "Copy Discord Invite"
end)

local RightPanel = Instance.new("Frame", LoginTab)
RightPanel.Size = UDim2.new(0, 280, 0, 200)
RightPanel.Position = UDim2.new(1, -300, 0.5, -100)
RightPanel.BackgroundTransparency = 1

local LoginTitle = Instance.new("TextLabel", RightPanel)
LoginTitle.Size = UDim2.new(1, 0, 0, 40)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "Enter Whitelist Key"
LoginTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.TextSize = 20
LoginTitle.TextXAlignment = Enum.TextXAlignment.Center

local KeyBox = Instance.new("TextBox", RightPanel)
KeyBox.Position = UDim2.new(0, 10, 0, 50)
KeyBox.Size = UDim2.new(1, -20, 0, 40)
KeyBox.BackgroundTransparency = 1
KeyBox.PlaceholderText = "Enter key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
KeyBox.TextColor3 = Color3.fromRGB(230, 230, 230)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.ClearTextOnFocus = false

local Underline = Instance.new("Frame", KeyBox)
Underline.Size = UDim2.new(1, 0, 0, 2)
Underline.Position = UDim2.new(0, 0, 1, 0)
Underline.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

local VerifyBtn = Instance.new("TextButton", RightPanel)
VerifyBtn.Position = UDim2.new(0, 10, 0, 100)
VerifyBtn.Size = UDim2.new(1, -20, 0, 40)
VerifyBtn.BackgroundTransparency = 1
VerifyBtn.Text = "Verify"
VerifyBtn.TextColor3 = Color3.fromRGB(120, 220, 160)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 20

local verifyScale = Instance.new("UIScale", VerifyBtn)
verifyScale.Scale = 1
VerifyBtn.MouseButton1Down:Connect(function() TweenService:Create(verifyScale, TweenInfo.new(0.1), {Scale = 1.1}):Play() end)
VerifyBtn.MouseButton1Up:Connect(function() TweenService:Create(verifyScale, TweenInfo.new(0.1), {Scale = 1}):Play() end)

local StatusLabel = Instance.new("TextLabel", RightPanel)
StatusLabel.Position = UDim2.new(0, 10, 0, 150)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Loader Tab (simple loading screen after login)
local LoaderLabel = Instance.new("TextLabel", LoaderTab)
LoaderLabel.Position = UDim2.new(0.5, 0, 0.5, -30)
LoaderLabel.AnchorPoint = Vector2.new(0.5, 0.5)
LoaderLabel.Size = UDim2.new(0, 400, 0, 50)
LoaderLabel.BackgroundTransparency = 1
LoaderLabel.Text = "Loading your script..."
LoaderLabel.TextColor3 = Color3.fromRGB(120, 220, 160)
LoaderLabel.Font = Enum.Font.GothamBold
LoaderLabel.TextSize = 28

local Dots = "..."
task.spawn(function()
    while LoaderTab.Visible do
        LoaderLabel.Text = "Loading your script" .. Dots
        Dots = Dots .. "."
        if #Dots > 3 then Dots = "" end
        task.wait(0.5)
    end
end)

-- Verify → switch to loader screen
VerifyBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text or ""
    if enteredKey == CorrectKey and IsWhitelisted then
        Authorized = true
        StatusLabel.Text = "Verified!"
        StatusLabel.TextColor3 = Color3.fromRGB(120, 220, 160)
        task.wait(0.8)
        LoginTab.Visible = false
        LoaderTab.Visible = true
        -- Here you can add your actual main script load if you want
        -- For now it's just a loader screen
    else
        StatusLabel.Text = "Invalid key or username"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        KeyBox.Text = ""
    end
end)

KeyBox.FocusLost:Connect(function(enter)
    if enter then VerifyBtn.MouseButton1Click:Fire() end
end)

-- Dragging
do
    local dragging = false
    local dragStart = nil
    local startPos = nil

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Menu.Position
        end
    end)

    Header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
