-- // ZENYTH DEBUGGER HUB - VILLA DEV EDITION
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- // 1. LIMPIEZA Y PREPARACIÓN
if PlayerGui:FindFirstChild("ZenythHub") then 
    PlayerGui.ZenythHub:Destroy() 
end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZenythHub"
sg.ResetOnSpawn = false -- Evita que la UI desaparezca al morir

-- // 2. INTERFAZ (Estilo Toggle, Morado Transparente)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 320, 0, 250)
Main.Position = UDim2.new(0.5, -160, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(30, 20, 45) -- Morado muy oscuro/fondo
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(120, 90, 180) -- Borde morado contraste

-- Título
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zenyth V1 (Villa Dev)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Contenedor de Botones
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -30, 1, -50)
Container.Position = UDim2.new(0, 15, 0, 40)
Container.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- // 3. LÓGICA DE PODERES
local AutoE = false
local Anclado = false

-- Lógica de Anclaje Mejorada (Uso de propiedad nativa Anchored)
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        if Anclado then
            root.Anchored = true
        else
            -- Solo desancla si está anclado, para no interferir con otros scripts del juego
            if root.Anchored then
                root.Anchored = false
            end
        end
    end
end)

-- Lógica de Spam E Mejorada (Bypass de HoldDuration)
task.spawn(function()
    while task.wait(0.2) do -- Pequeño delay para no saturar el cliente
        if AutoE and Player.Character and Player.Character:FindFirstChild("PrimaryPart") then
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Enabled then
                    local charPos = Player.Character.PrimaryPart.Position
                    local promptPos = p.Parent:GetPivot().Position
                    local dist = (charPos - promptPos).Magnitude
                    
                    if dist < 12 then
                        -- Guardamos la duración original, la bajamos a 0, disparamos y restauramos
                        local originalHold = p.HoldDuration
                        p.HoldDuration = 0
                        fireproximityprompt(p)
                        p.HoldDuration = originalHold
                    end
                end
            end
        end
    end
end)

-- // 4. CREACIÓN DE BOTONES TIPO TOGGLE (Interruptor)
local function createToggle(name, callback)
    local toggleState = false

    local BtnFrame = Instance.new("TextButton", Container)
    BtnFrame.Size = UDim2.new(1, 0, 0, 45)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(50, 35, 75) -- Morado claro interior
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

    -- Pista del interruptor
    local Track = Instance.new("Frame", BtnFrame)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -55, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    -- Círculo del interruptor
    local Circle = Instance.new("Frame", Track)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    BtnFrame.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        
        -- Animación del interruptor
        local targetPos = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = toggleState and Color3.fromRGB(150, 100, 255) or Color3.fromRGB(30, 20, 45)
        
        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggleState)
    end)
end

-- Agregar los Toggles
createToggle("Spam E (Bypass)", function(state)
    AutoE = state
end)

createToggle("Anclar Personaje", function(state)
    Anclado = state
    if Anclado then warn("⚓ PERSONAJE ANCLADO") else warn("🔓 MOVIMIENTO LIBERADO") end
end)

-- Botón Cerrar
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(200, 150, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.MouseButton1Click:Connect(function() 
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    sg:Destroy() 
end)

-- // 5. ANIMACIÓN DE ENTRADA
Main.Visible = true
Main.Size = UDim2.new(0, 320, 0, 0)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 320, 0, 250)}):Play()
