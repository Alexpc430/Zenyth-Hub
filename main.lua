-- // ZENYTH DEBUGGER HUB - VILLA DEV EDITION
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // 1. LIMPIEZA
if PlayerGui:FindFirstChild("ZenythHub") then 
    PlayerGui.ZenythHub:Destroy() 
end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZenythHub"
sg.ResetOnSpawn = false

-- // 2. INTERFAZ PRINCIPAL
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 320, 0, 250)
Main.Position = UDim2.new(0.5, -160, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(120, 90, 180)

-- Título Superior Izquierda
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zenyth V1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Contenedor de Toggles
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -30, 1, -160)
Container.Position = UDim2.new(0, 15, 0, 50)
Container.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- BOTÓN FLOTANTE (MINIMIZADO) - Logo Minimalista arriba a la izquierda
local MiniBtn = Instance.new("TextButton", sg)
MiniBtn.Size = UDim2.new(0, 40, 0, 40)
MiniBtn.Position = UDim2.new(0, 20, 0, 20)
MiniBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
MiniBtn.BackgroundTransparency = 0.15
MiniBtn.Text = "Z"
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
MiniBtn.TextSize = 18
MiniBtn.Visible = false
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)

local MiniStroke = Instance.new("UIStroke", MiniBtn)
MiniStroke.Thickness = 1.5
MiniStroke.Color = Color3.fromRGB(140, 100, 210)

-- // LÓGICA PARA MOVER LA INTERFAZ (DRAGGABLE)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- // 3. LÓGICA DE LOS SCRIPT
local AutoE = false
local Anclado = false

-- Fuerza nativa de anclaje (Evita caídas y muertes)
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        if Anclado then
            root.Anchored = true
        else
            if root.Anchored then root.Anchored = false end
        end
    end
end)

-- Ejecución Instantánea de ProximityPrompts (Incluso en movimiento)
local function interactuarInstantaneo(prompt)
    if fireproximityprompt then
        -- Usar la API del exploit para dispararlo directamente en este frame
        fireproximityprompt(prompt)
    else
        -- Fallback manual hiperrápido si el exploit restringe la función básica
        task.spawn(function()
            prompt:InputHoldBegin()
            RunService.RenderStepped:Wait()
            prompt:InputHoldEnd()
        end)
    end
end

-- Escaneo de alta velocidad por frame para capturar cosas en movimiento
RunService.RenderStepped:Connect(function()
    if AutoE and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Enabled then
                local success, objPos = pcall(function() return p.Parent:GetPivot().Position end)
                if success and objPos then
                    local distancia = (root.Position - objPos).Magnitude
                    -- Si estás a menos de 15 studs del objeto moviéndose, lo agarra en el acto
                    if distancia <= 15 then
                        interactuarInstantaneo(p)
                    end
                end
            end
        end
    end
end)

-- // 4. COMPONENTES DE LA INTERFAZ (TOGGLES)
local function createToggle(name, callback)
    local toggleState = false

    local BtnFrame = Instance.new("TextButton", Container)
    BtnFrame.Size = UDim2.new(1, 0, 0, 45)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
    BtnFrame.Text = ""
    BtnFrame.AutoButtonColor = false
    Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", BtnFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("Frame", BtnFrame)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -55, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Track)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    BtnFrame.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        local targetPos = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = toggleState and Color3.fromRGB(150, 100, 255) or Color3.fromRGB(30, 20, 45)
        
        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggleState)
    end)
end

createToggle("Auto Agarrar Objetos (E)", function(state)
    AutoE = state
end)

createToggle("Modo Anclaje Seguro", function(state)
    Anclado = state
end)

-- Botón Cerrar (X)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "×"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(200, 150, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.MouseButton1Click:Connect(function() 
    sg:Destroy() 
end)

-- Botón Minimizar (-)
local Minimize = Instance.new("TextButton", Main)
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -65, 0, 5)
Minimize.Text = "-"
Minimize.BackgroundTransparency = 1
Minimize.TextColor3 = Color3.fromRGB(200, 150, 255)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 22

-- Lógica de Minimizar / Maximizar Estable
Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniBtn.Visible = true
end)

MiniBtn.MouseButton1Click:Connect(function()
    MiniBtn.Visible = false
    Main.Visible = true
end)

-- // 5. ANIMACIÓN DE ENTRADA INICIAL
local OriginalPosition = Main.Position
Main.Position = UDim2.new(OriginalPosition.X.Scale, OriginalPosition.X.Offset, 0, -300)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = OriginalPosition}):Play()
