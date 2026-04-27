-- Track when script starts (before Roblox loads)
local ROBLOX_LOAD_START_TIME = os.clock()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local logBuffer = {}
local maxBufferSize = 100
local flushInterval = 0.01

local oldPrint = print
local oldWarn = warn
local oldError = error

local function instantLog(message, logType)
    logType = logType or "INFO"

    if rconsoleprint then
        local timestamp = os.date("%H:%M:%S")
        local prefix = ""

        if logType == "WARN" then
            prefix = "⚠️ "
        elseif logType == "ERROR" then
            prefix = "❌ "
        else
            prefix = "✓ "
        end

        rconsoleprint(string.format("[%s] %s%s\n", timestamp, prefix, tostring(message)))
    end

    table.insert(logBuffer, {
        time = tick(),
        message = message,
        type = logType
    })

    if #logBuffer > maxBufferSize then
        table.remove(logBuffer, 1)
    end
end

print = function(...)
    local args = {...}
    local message = table.concat({...}, " ")
    oldPrint(...)
    instantLog(message, "INFO")
end

warn = function(...)
    local message = table.concat({...}, " ")
    oldWarn(...)
    instantLog(message, "WARN")
end

task.spawn(function()
    while task.wait(flushInterval) do
        if rconsoleclear and #logBuffer > 50 then
        end
    end
end)

local function optimizeLogs()
    if setfflag then
        pcall(function()
            setfflag("AbuseReportScreenshotPercentage", "0")
            setfflag("DFFlagDebugAnalytics", "false")
            setfflag("DFFlagDebugVisualizationsEnabled", "false")
            setfflag("FFlagDebugForceFutureIsBrightPhase2", "false")
            setfflag("FFlagDebugForceFutureIsBrightPhase3", "false")
            setfflag("DFFlagDebugEnableLogToCloudForAllPlayers", "false")
        end)
    end

    if rconsoleclear then
        rconsoleclear()
    end

    if rconsoleinfo then
        rconsoleinfo("⚡ VXIOLENCE INSTA - DARK RED EDITION")
        rconsoleinfo("✓ Console forwarding: INSTANT MODE")
    end

    if setconsoletitle then
        setconsoletitle("VXIOLENCE INSTA - INSTANT LOGS")
    end

    instantLog("Executor optimization complete", "INFO")
end

optimizeLogs()

local function optimizeNetwork()
    instantLog("Applying network optimizations...", "INFO")

    pcall(function()
        settings().Network.IncomingReplicationLag = 0
        settings().Network.PhysicsSend = 255
        settings().Network.DataSendRate = 255
        settings().Network.ExperimentalPhysicsEnabled = true
        settings().Network.PhysicsReceive = 255

        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(game:GetService("NetworkClient"), "OutgoingReplicationLag", 0)
            end)
        end

        if setfflag then
            pcall(function()
                setfflag("DFIntTaskSchedulerTargetFps", "9999")
                setfflag("DFIntTimestepArbiterThresholdCFLThou", "0")
            end)
        end
    end)

    pcall(function()
        settings().Physics.AllowSleep = true
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
        settings().Physics.ThrottleAdjustTime = 0
    end)

    instantLog("Network optimizations applied", "INFO")
end

optimizeNetwork()

local function optimizeRendering()
    instantLog("Applying rendering optimizations...", "INFO")

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EnableFRM = false
        settings().Rendering.EnableVRMode = false

        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
            end)
        end

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0

        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") 
                or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") 
                or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end

        if setfpscap then
            setfpscap(999)
            instantLog("FPS cap set to 999", "INFO")
        end
    end)

    instantLog("Rendering optimizations applied", "INFO")
end

optimizeRendering()

local function createCleanLoadingScreen()
    local playerGui = player:WaitForChild("PlayerGui")

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "VxiolenceInsta" or gui.Name == "VxiolenceNotif" then
            gui:Destroy()
        end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VxiolenceInsta"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.IgnoreGuiInset = true
    screenGui.Enabled = true
    screenGui.Parent = playerGui

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(10, 0, 0) -- Dark Red/Black Base
    overlay.BackgroundTransparency = 0
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)), -- Crimson
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 0, 0)), -- Darker
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 5, 5)) -- Deep Red
    }
    gradient.Rotation = 0
    gradient.Parent = overlay

    task.spawn(function()
        while overlay.Parent do
            for i = 0, 360, 2 do
                if not overlay.Parent then break end
                gradient.Rotation = i
                task.wait(0.08)
            end
        end
    end)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = screenGui

    -- Crimson Stars
    for i = 1, 150 do
        local star = Instance.new("Frame")
        local size = math.random(1, 5)
        star.Size = UDim2.new(0, size, 0, size)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)

        if math.random() > 0.7 then
            star.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Vivid Red
        else
            star.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Deep Crimson
        end

        star.BackgroundTransparency = math.random(20, 90) / 100
        star.BorderSizePixel = 0
        star.ZIndex = math.random(1, 3)
        star.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = star

        if size > 3 then
            local glow = Instance.new("UIStroke")
            glow.Color = star.BackgroundColor3
            glow.Thickness = 1
            glow.Transparency = 0.5
            glow.Parent = star
        end

        task.spawn(function()
            while container.Parent do
                local duration = math.random(5, 18) / 10
                TweenService:Create(star, 
                    TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {BackgroundTransparency = math.random(5, 95) / 100}
                ):Play()
                task.wait(duration)
            end
        end)
    end

    -- Blood Red Shooting Stars
    task.spawn(function()
        while container.Parent do
            task.wait(math.random(2, 6) / 10)
            local shootingStar = Instance.new("Frame")
            local length = math.random(40, 80)
            shootingStar.Size = UDim2.new(0, length, 0, 3)
            shootingStar.Position = UDim2.new(math.random(), -80, math.random(0, 50) / 100, 0)

            local colors = {
                Color3.fromRGB(255, 100, 100),
                Color3.fromRGB(180, 0, 0),
                Color3.fromRGB(255, 0, 0)
            }
            shootingStar.BackgroundColor3 = colors[math.random(1, #colors)]

            shootingStar.BorderSizePixel = 0
            shootingStar.Rotation = -25
            shootingStar.ZIndex = 5
            shootingStar.Parent = container

            local grad = Instance.new("UIGradient")
            grad.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.3, 0),
                NumberSequenceKeypoint.new(1, 1)
            }
            grad.Parent = shootingStar

            TweenService:Create(shootingStar,
                TweenInfo.new(0.7, Enum.EasingStyle.Linear),
                {Position = UDim2.new(shootingStar.Position.X.Scale + 0.5, 0, shootingStar.Position.Y.Scale + 0.4, 0)}
            ):Play()

            task.delay(0.7, function() shootingStar:Destroy() end)
        end
    end)

    -- Red Particles
    for i = 1, 25 do
        local particle = Instance.new("Frame")
        local size = math.random(8, 15)
        particle.Size = UDim2.new(0, size, 0, size)
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)

        local colors = {
            Color3.fromRGB(255, 50, 50),
            Color3.fromRGB(100, 0, 0),
            Color3.fromRGB(200, 0, 0)
        }
        particle.BackgroundColor3 = colors[math.random(1, #colors)]
        particle.BackgroundTransparency = 0.3
        particle.BorderSizePixel = 0
        particle.ZIndex = 2
        particle.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle

        local glow = Instance.new("UIStroke")
        glow.Color = particle.BackgroundColor3
        glow.Thickness = 4
        glow.Transparency = 0.4
        glow.Parent = particle

        local innerGlow = Instance.new("Frame")
        innerGlow.Size = UDim2.new(0.5, 0, 0.5, 0)
        innerGlow.Position = UDim2.new(0.25, 0, 0.25, 0)
        innerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        innerGlow.BackgroundTransparency = 0.3
        innerGlow.BorderSizePixel = 0
        innerGlow.Parent = particle

        local innerCorner = Instance.new("UICorner")
        innerCorner.CornerRadius = UDim.new(1, 0)
        innerCorner.Parent = innerGlow

        task.spawn(function()
            while container.Parent do
                local duration = math.random(30, 60) / 10
                TweenService:Create(particle,
                    TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(math.random(), 0, math.random(), 0)}
                ):Play()
                TweenService:Create(glow,
                    TweenInfo.new(duration / 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Transparency = math.random(20, 70) / 100, Thickness = math.random(3, 6)}
                ):Play()
                TweenService:Create(innerGlow,
                    TweenInfo.new(duration / 4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {BackgroundTransparency = math.random(20, 60) / 100}
                ):Play()
                task.wait(duration / 4)
            end
        end)
    end

    local elixirText = Instance.new("TextLabel")
    elixirText.Size = UDim2.new(0, 700, 0, 200)
    elixirText.Position = UDim2.new(0.5, -350, 0.5, -100)
    elixirText.BackgroundTransparency = 1
    elixirText.Text = "vxiolence"
    elixirText.Font = Enum.Font.GothamBlack
    elixirText.TextSize = 120
    elixirText.TextColor3 = Color3.fromRGB(255, 200, 200) -- Off-white red
    elixirText.TextStrokeTransparency = 0
    elixirText.TextStrokeColor3 = Color3.fromRGB(180, 0, 0) -- Dark Red Outline
    elixirText.TextTransparency = 1
    elixirText.ZIndex = 10
    elixirText.Parent = container

    local instaText = Instance.new("TextLabel")
    instaText.Size = UDim2.new(0, 700, 0, 80)
    instaText.Position = UDim2.new(0.5, -350, 0.5, 70)
    instaText.BackgroundTransparency = 1
    instaText.Text = "Insta"
    instaText.Font = Enum.Font.GothamBold
    instaText.TextSize = 56
    instaText.TextColor3 = Color3.fromRGB(255, 50, 50)
    instaText.TextStrokeTransparency = 0.5
    instaText.TextStrokeColor3 = Color3.fromRGB(150, 0, 0)
    instaText.TextTransparency = 1
    instaText.ZIndex = 10
    instaText.Parent = container

    local loadingBg = Instance.new("Frame")
    loadingBg.Size = UDim2.new(0, 400, 0, 8)
    loadingBg.Position = UDim2.new(0.5, -200, 0.65, 0)
    loadingBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    loadingBg.BackgroundTransparency = 0.95
    loadingBg.BorderSizePixel = 0
    loadingBg.ZIndex = 10
    loadingBg.Parent = container

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = loadingBg

    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.fromRGB(180, 0, 0)
    bgStroke.Thickness = 2
    bgStroke.Transparency = 0.7
    bgStroke.Parent = loadingBg

    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    loadingBar.BorderSizePixel = 0
    loadingBar.ZIndex = 11
    loadingBar.Parent = loadingBg

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = loadingBar

    local barGlow = Instance.new("UIStroke")
    barGlow.Color = Color3.fromRGB(255, 50, 50)
    barGlow.Thickness = 2
    barGlow.Transparency = 0.4
    barGlow.Parent = loadingBar

    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(0, 100, 0, 30)
    percentText.Position = UDim2.new(0.5, -50, 0.7, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.Font = Enum.Font.GothamBold
    percentText.TextSize = 16
    percentText.TextColor3 = Color3.fromRGB(255, 100, 100)
    percentText.TextStrokeTransparency = 0.6
    percentText.TextStrokeColor3 = Color3.fromRGB(100, 0, 0)
    percentText.TextTransparency = 1
    percentText.ZIndex = 10
    percentText.Parent = container

    task.spawn(function()
        while elixirText.Parent do
            TweenService:Create(elixirText, 
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {TextStrokeTransparency = 0.3}
            ):Play()
            task.wait(1.5)
            TweenService:Create(elixirText,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {TextStrokeTransparency = 0}
            ):Play()
            task.wait(1.5)
        end
    end)

    local isLoaded = false
    local currentProgress = 0

    local function closeLoadingScreen()
        if isLoaded then return end
        isLoaded = true

        local loadTime = os.clock() - ROBLOX_LOAD_START_TIME

        local notifGui = Instance.new("ScreenGui")
        notifGui.Name = "VxiolenceNotif"
        notifGui.ResetOnSpawn = false
        notifGui.DisplayOrder = 9999999
        notifGui.IgnoreGuiInset = true
        notifGui.Parent = playerGui

        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 400, 0, 30)
        notif.Position = UDim2.new(0.5, -200, 0, -50)
        notif.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.Text = string.format("vxiolence: roblox loaded in %.10f seconds", loadTime)
        notif.Font = Enum.Font.Code
        notif.TextSize = 14
        notif.TextColor3 = Color3.fromRGB(255, 0, 0) -- Alert Red
        notif.TextXAlignment = Enum.TextXAlignment.Left
        notif.ZIndex = 99999
        notif.Parent = notifGui

        print(string.format("vxiolence: roblox loaded in %.10f seconds", loadTime))

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.Parent = notif

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = notif

        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -200, 0, 10)}):Play()

        task.spawn(function()
            task.wait(4)
            TweenService:Create(notif, TweenInfo.new(0.8),
                {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.wait(0.8)
            notifGui:Destroy()
        end)

        percentText.Text = "100%"
        TweenService:Create(loadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 0, 1, 0)}):Play()

        task.wait(0.6)

        TweenService:Create(elixirText, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {TextTransparency = 1, Size = UDim2.new(0, 900, 0, 250)}):Play()

        TweenService:Create(instaText, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {TextTransparency = 1, Position = UDim2.new(0.5, -600, 0.5, 70)}):Play()

        TweenService:Create(loadingBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        TweenService:Create(loadingBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(barGlow, TweenInfo.new(0.5), {Transparency = 1}):Play()
        TweenService:Create(percentText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(overlay, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()

        task.wait(0.8)
        if container then container:Destroy() end
        if overlay then overlay:Destroy() end
    end

    local loadDetected = false

    task.spawn(function()
        pcall(function()
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 10)
            local hum = character:WaitForChild("Humanoid", 10)

            if hrp and hum and hrp:IsDescendantOf(workspace) then
                if not loadDetected then
                    loadDetected = true
                    closeLoadingScreen()
                end
            end
        end)
    end)

    task.spawn(function()
        pcall(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end

            if not loadDetected then
                loadDetected = true
                closeLoadingScreen()
            end
        end)
    end)

    task.spawn(function()
        pcall(function()
            repeat task.wait(0.08) until workspace:FindFirstChild(player.Name) or workspace.CurrentCamera

            if not loadDetected then
                loadDetected = true
                closeLoadingScreen()
            end
        end)
    end)

    task.spawn(function()
        pcall(function()
            repeat task.wait(0.08) until #playerGui:GetChildren() > 1

            if not loadDetected then
                loadDetected = true
                closeLoadingScreen()
            end
        end)
    end)

    task.spawn(function()
        task.wait(15)
        if not loadDetected then
            loadDetected = true
            closeLoadingScreen()
        end
    end)

    task.spawn(function()
        task.wait(0.2)

        elixirText.Size = UDim2.new(0, 900, 0, 250)
        elixirText.Position = UDim2.new(0.5, -450, 0.5, -125)
        TweenService:Create(elixirText, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {TextTransparency = 0, Size = UDim2.new(0, 700, 0, 200), Position = UDim2.new(0.5, -350, 0.5, -100)}):Play()

        task.wait(0.3)

        instaText.Position = UDim2.new(0.5, 50, 0.5, 70)
        TweenService:Create(instaText, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {TextTransparency = 0, Position = UDim2.new(0.5, -350, 0.5, 70)}):Play()

        task.wait(0.3)

        TweenService:Create(percentText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

        task.spawn(function()
            while not isLoaded and bgStroke.Parent do
                TweenService:Create(bgStroke, TweenInfo.new(0.3), {Transparency = 0.3, Thickness = 3}):Play()
                task.wait(0.3)
                if isLoaded then break end
                TweenService:Create(bgStroke, TweenInfo.new(0.3), {Transparency = 0.7, Thickness = 2}):Play()
                task.wait(0.3)
            end
        end)

        task.spawn(function()
            local startWait = os.clock()
            while not isLoaded and percentText.Parent do
                local elapsed = os.clock() - startWait
                local targetProgress = math.min((elapsed / 8) * 85, 85)

                if currentProgress < targetProgress then
                    currentProgress = math.min(currentProgress + 2, targetProgress)
                end

                percentText.Text = math.floor(currentProgress) .. "%"
                TweenService:Create(loadingBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear),
                    {Size = UDim2.new(currentProgress / 100, 0, 1, 0)}):Play()

                task.wait(0.2)
            end
        end)
    end)

    return screenGui
end

pcall(function()
    game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
end)

local playerGui = player:WaitForChild("PlayerGui")
for _, gui in pairs(playerGui:GetChildren()) do
    if gui.Name == "VxiolenceInsta" or gui.Name == "VxiolenceNotif" then
        pcall(function() gui:Destroy() end)
    end
end

instantLog("Starting VXIOLENCE INSTA initialization...", "INFO")

local screenGui = createCleanLoadingScreen()

if screenGui then
    screenGui.Enabled = true
end

task.spawn(function()
    while task.wait(0.05) do
        for _, gui in pairs(player.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "VxiolenceInsta" then
                local name = gui.Name:lower()
                if name:match("loading") or name:match("intro") or name:match("welcome") then
                    pcall(function() gui:Destroy() end)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.03) do
        for _, button in pairs(player.PlayerGui:GetDescendants()) do
            if (button:IsA("TextButton") or button:IsA("ImageButton")) and button.Visible then
                local text = button.Text:lower()
                if text:match("play") or text:match("continue") or text:match("start") or text:match("skip") then
                    pcall(function()
                        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        collectgarbage("collect")
    end
end)

task.spawn(function()
    task.wait(1)
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Sound") and not obj:IsDescendantOf(player.Character) then
                obj:Stop()
                obj.Volume = 0
            end
        end
    end)
end)

instantLog("Vxiolence INSTA fully loaded", "INFO")
