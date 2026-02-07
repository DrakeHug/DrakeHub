
local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

--========================
-- 
--========================
local function getHRP()
    local char = plr.Character or plr.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

--========================
-- SAFE TELEPORT
--========================
local function safeTP(part)
    if not (part and part:IsA("BasePart")) then return end

    local hrp = getHRP()
    local target = part.Position + Vector3.new(0,3,0)

    local dist = (hrp.Position - target).Magnitude
    local steps = math.ceil(dist / 40) -- nhảy 40 studs/lần

    for i = 1, steps do
        hrp.CFrame = CFrame.new(
            hrp.Position:Lerp(target, i/steps)
        )
        task.wait(0.05)
    end
end

--========================
-- 
--========================
local function press(obj)
    if not obj then return end
    local p = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if p then
        fireproximityprompt(p)
    end
end

--========================
-- BASE 
--========================
local function getBase()
    return workspace.Bases:GetChildren()[4]
end

--========================
-- SLOT1
--========================
local function getSlot1()
    local base = getBase()

    for _,v in pairs(base:GetDescendants()) do
        if string.find(string.lower(v.Name),"slot") then
            return v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart",true) or v
        end
    end
end

--========================
-- COLLECT
--========================
local function getCollect()
    local base = getBase()

    for _,v in pairs(base:GetDescendants()) do
        if string.find(string.lower(v.Name),"collect") then
            return v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart",true) or v
        end
    end
end

--========================
-- ATM
--========================
local function getATM()
    for _,v in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(v.Name),"atm") then
            return v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart",true) or v
        end
    end
end

--========================
-- DIVINE
--========================
local function findDivine()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(string.lower(v.Name),"divine") then
            return v:FindFirstChildWhichIsA("BasePart",true)
        end
    end
end

--========================
-- 
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "DrakeHub"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,150)
frame.Position = UDim2.fromScale(.5,.5)
frame.AnchorPoint = Vector2.new(.5,.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,18)

-- 
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Drake Hug"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.TextScaled = true

-- 
local function makeBtn(txt,y)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(.9,0,0,45)
    b.Position = UDim2.new(.05,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = txt.." : OFF"
    Instance.new("UICorner",b)

    local state=false

    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = txt.." : "..(state and "ON" or "OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(50,50,50)
    end)

    return function() return state end
end

local farmOn = makeBtn("Auto Divine",40)
local atmOn  = makeBtn("Auto ATM",95)

--========================
--========================
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--H
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.H then
        frame.Visible = not frame.Visible
    end
end)

--========================
task.spawn(function()
    while true do
        task.wait(.3)

        if atmOn() then
            local slot = getSlot1()
            local atm = getATM()

            if slot and atm then
                safeTP(slot); task.wait(.5); press(slot)
                safeTP(atm);  task.wait(.5); press(atm)
                task.wait(30)
            end
        end

        if farmOn() then
            local t = findDivine()
            if t then
                safeTP(t); task.wait(.4); press(t)
            else
                local c = getCollect()
                if c then safeTP(c) end
            end
        end
    end
end)
