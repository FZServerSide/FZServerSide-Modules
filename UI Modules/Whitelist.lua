local Config={Name="FZ ServerSide",Version="v0.0.1",WhitelistURL="https://raw.githubusercontent.com/FZServerSide/Modules/refs/heads/Modules/Whitelist.json",DiscordLink="https://discord.gg/yourserverhere",WhitelistEnabled=true,LoadURL="LOADING_STRING_URL"}
local TweenService=game.TweenService
local UIS=game.UserInputService
local HttpService=game.HttpService
local Player=game.Players.LocalPlayer
local Username=Player.Name
local Authorized=false
local Verifying=false

local function httpGet(url)
    if syn and syn.request then return syn.request({Url=url,Method="GET"}).Body
    elseif http_request then return http_request({Url=url,Method="GET"}).Body
    elseif request then return request({Url=url,Method="GET"}).Body
    else return HttpService:GetAsync(url) end
end

local CorrectKey=""
local AllowedUsers={}
local IsWhitelisted=false
if Config.WhitelistEnabled then
    local ok,json=pcall(httpGet,Config.WhitelistURL)
    if ok and json then
        local decodeOk,data=pcall(HttpService.JSONDecode,HttpService,json)
        if decodeOk and type(data)=="table" then
            CorrectKey=tostring(data["whitelist key"] or "")
            local i=1
            while data["username"..i] do
                table.insert(AllowedUsers,tostring(data["username"..i]))
                i=i+1
            end
        end
    end
    IsWhitelisted=table.find(AllowedUsers,Username)~=nil
end

local GUI=Instance.new("ScreenGui",game.CoreGui)
GUI.IgnoreGuiInset=true
GUI.ResetOnSpawn=false

local Menu=Instance.new("Frame",GUI)
Menu.AnchorPoint=Vector2.new(0.5,0.5)
Menu.Position=UDim2.new(0.5,0,0.5,0)
Menu.Size=UDim2.new(0,571,0,290)
Menu.BackgroundColor3=Color3.fromRGB(15,15,15)
Instance.new("UICorner",Menu).CornerRadius=UDim.new(0,12)

local Header=Instance.new("Frame",Menu)
Header.Size=UDim2.new(1,0,0,35)
Header.BackgroundColor3=Color3.fromRGB(10,10,10)
Instance.new("UICorner",Header).CornerRadius=UDim.new(0,12)

local TitleLabel=Instance.new("TextLabel",Header)
TitleLabel.Position=UDim2.new(0,12,0,4)
TitleLabel.Size=UDim2.new(0,400,0,20)
TitleLabel.BackgroundTransparency=1
TitleLabel.Text=Config.Name
TitleLabel.TextColor3=Color3.fromRGB(230,230,230)
TitleLabel.Font=Enum.Font.GothamBold
TitleLabel.TextSize=19
TitleLabel.TextXAlignment=Enum.TextXAlignment.Left

local VersionLabel=Instance.new("TextLabel",Header)
VersionLabel.Position=UDim2.new(0,12,0,24)
VersionLabel.Size=UDim2.new(0,400,0,14)
VersionLabel.BackgroundTransparency=1
VersionLabel.Text=Config.Version
VersionLabel.TextColor3=Color3.fromRGB(160,160,160)
VersionLabel.Font=Enum.Font.Gotham
VersionLabel.TextSize=12
VersionLabel.TextXAlignment=Enum.TextXAlignment.Left

local CloseBtn=Instance.new("TextButton",Header)
CloseBtn.Position=UDim2.new(1,-30,0,5)
CloseBtn.Size=UDim2.new(0,25,0,25)
CloseBtn.BackgroundTransparency=1
CloseBtn.Text="X"
CloseBtn.TextColor3=Color3.fromRGB(200,200,200)
CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.TextSize=18
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3=Color3.fromRGB(255,100,100) end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3=Color3.fromRGB(200,200,200) end)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Menu,TweenInfo.new(0.3),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
    task.wait(0.3)
    GUI:Destroy()
end)

local Tabs=Instance.new("Frame",Menu)
Tabs.Position=UDim2.new(0,0,0,35)
Tabs.Size=UDim2.new(1,0,1,-35)
Tabs.BackgroundTransparency=1
Tabs.ClipsDescendants=true

local LoginTab=Instance.new("Frame",Tabs)
LoginTab.Size=UDim2.new(1,0,1,0)
LoginTab.BackgroundTransparency=1
LoginTab.Visible=true

local InfoTitle=Instance.new("TextLabel",LoginTab)
InfoTitle.Position=UDim2.new(0,20,0,10)
InfoTitle.Size=UDim2.new(0,260,0,30)
InfoTitle.BackgroundTransparency=1
InfoTitle.Text="How to get whitelisted"
InfoTitle.TextColor3=Color3.fromRGB(230,230,230)
InfoTitle.Font=Enum.Font.GothamBold
InfoTitle.TextSize=18
InfoTitle.TextXAlignment=Enum.TextXAlignment.Left

local InfoText=Instance.new("TextLabel",LoginTab)
InfoText.Position=UDim2.new(0,20,0,50)
InfoText.Size=UDim2.new(0,260,0,140)
InfoText.BackgroundTransparency=1
InfoText.Text=[[To use FZ ServerSide, you need a whitelist key.

Steps:
1. Join our Discord server
2. Go to the #shop channel
3. Purchase a key or follow the instructions]]
InfoText.TextColor3=Color3.fromRGB(180,180,180)
InfoText.Font=Enum.Font.Gotham
InfoText.TextSize=15
InfoText.TextXAlignment=Enum.TextXAlignment.Left
InfoText.TextYAlignment=Enum.TextYAlignment.Top
InfoText.TextWrapped=true

local DiscordBtn=Instance.new("TextButton",LoginTab)
DiscordBtn.Position=UDim2.new(0,20,1,-50)
DiscordBtn.Size=UDim2.new(0,260,0,36)
DiscordBtn.BackgroundTransparency=1
DiscordBtn.Text="Copy Discord Invite"
DiscordBtn.TextColor3=Color3.fromRGB(88,101,242)
DiscordBtn.Font=Enum.Font.GothamBold
DiscordBtn.TextSize=16
DiscordBtn.TextXAlignment=Enum.TextXAlignment.Left
local discordScale=Instance.new("UIScale",DiscordBtn)
discordScale.Scale=1
DiscordBtn.MouseButton1Down:Connect(function() TweenService:Create(discordScale,TweenInfo.new(0.1),{Scale=1.08}):Play() end)
DiscordBtn.MouseButton1Up:Connect(function() TweenService:Create(discordScale,TweenInfo.new(0.1),{Scale=1}):Play() end)
DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(Config.DiscordLink) end
    DiscordBtn.Text="Copied"
    task.wait(1.5)
    DiscordBtn.Text="Copy Discord Invite"
end)

local RightPanel=Instance.new("Frame",LoginTab)
RightPanel.Size=UDim2.new(0,280,0,200)
RightPanel.Position=UDim2.new(1,-300,0.5,-100)
RightPanel.BackgroundTransparency=1

local LoginTitle=Instance.new("TextLabel",RightPanel)
LoginTitle.Size=UDim2.new(1,0,0,40)
LoginTitle.BackgroundTransparency=1
LoginTitle.Text="Enter Whitelist Key"
LoginTitle.TextColor3=Color3.fromRGB(230,230,230)
LoginTitle.Font=Enum.Font.GothamBold
LoginTitle.TextSize=20
LoginTitle.TextXAlignment=Enum.TextXAlignment.Center

local KeyBox=Instance.new("TextBox",RightPanel)
KeyBox.Position=UDim2.new(0,10,0,50)
KeyBox.Size=UDim2.new(1,-20,0,40)
KeyBox.BackgroundTransparency=1
KeyBox.PlaceholderText="Enter key..."
KeyBox.PlaceholderColor3=Color3.fromRGB(120,120,120)
KeyBox.TextColor3=Color3.fromRGB(230,230,230)
KeyBox.Font=Enum.Font.Gotham
KeyBox.TextSize=18
KeyBox.ClearTextOnFocus=false

local Underline=Instance.new("Frame",KeyBox)
Underline.Size=UDim2.new(1,0,0,2)
Underline.Position=UDim2.new(0,0,1,0)
Underline.BackgroundColor3=Color3.fromRGB(80,80,80)

local VerifyBtn=Instance.new("TextButton",RightPanel)
VerifyBtn.Position=UDim2.new(0,10,0,100)
VerifyBtn.Size=UDim2.new(1,-20,0,40)
VerifyBtn.BackgroundTransparency=1
VerifyBtn.Text="Verify"
VerifyBtn.TextColor3=Color3.fromRGB(120,220,160)
VerifyBtn.Font=Enum.Font.GothamBold
VerifyBtn.TextSize=20
local verifyScale=Instance.new("UIScale",VerifyBtn)
verifyScale.Scale=1
VerifyBtn.MouseButton1Down:Connect(function() TweenService:Create(verifyScale,TweenInfo.new(0.1),{Scale=1.1}):Play() end)
VerifyBtn.MouseButton1Up:Connect(function() TweenService:Create(verifyScale,TweenInfo.new(0.1),{Scale=1}):Play() end)

local StatusLabel=Instance.new("TextLabel",RightPanel)
StatusLabel.Position=UDim2.new(0,10,0,150)
StatusLabel.Size=UDim2.new(1,-20,0,20)
StatusLabel.BackgroundTransparency=1
StatusLabel.Text=""
StatusLabel.TextColor3=Color3.fromRGB(255,100,100)
StatusLabel.Font=Enum.Font.Gotham
StatusLabel.TextSize=14
StatusLabel.TextXAlignment=Enum.TextXAlignment.Center

local function fail(msg) StatusLabel.TextColor3=Color3.fromRGB(255,100,100) StatusLabel.Text=msg Verifying=false end
local function success(msg) StatusLabel.TextColor3=Color3.fromRGB(120,220,160) StatusLabel.Text=msg end

local function VerifyKey()
    if Verifying then return end
    Verifying=true
    local enteredKey=tostring(KeyBox.Text or ""):gsub("%s+","")
    if not Config.WhitelistEnabled or not IsWhitelisted then return fail("Not whitelisted") end
    if enteredKey=="" then return fail("Invalid key") end
    local ok,json=pcall(httpGet,Config.WhitelistURL)
    if not ok or not json then return fail("Verification failed") end
    local decodeOk,data=pcall(HttpService.JSONDecode,HttpService,json)
    if not decodeOk or type(data)~="table" then return fail("Verification failed") end
    local liveKey=tostring(data["whitelist key"] or "")
    if enteredKey~=liveKey then return fail("Invalid key") end
    Authorized=true
    success("Verified, loading UI...")
    local loadOk,result=pcall(httpGet,Config.LoadURL)
    if not loadOk or type(result)~="string" or #result<1 then return fail("Failed to load") end
    local fn=loadstring(result)
    if not fn then return fail("Failed to load") end
    fn()
    GUI:Destroy()
end

VerifyBtn.MouseButton1Click:Connect(VerifyKey)
KeyBox.FocusLost:Connect(function(e) if e then VerifyKey() end end)

local dragging=false
local dragStart
local startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true dragStart=i.Position startPos=Menu.Position
    end
end)
Header.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local delta=i.Position-dragStart
        Menu.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
