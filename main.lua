-- // ZENYTH DEBUGGER HUB - VILLA DEV EDITION
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- // 1. LIMPIEZA
if PlayerGui:FindFirstChild("ZenythHub") then PlayerGui.ZenythHub:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZenythHub"

-- // 2. INTERFAZ ESTILO image_1cab11.png
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0.5, -150, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(30, 110, 255)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 3
Stroke.Color = Color3.new(1, 1, 1)

-- // 3. LÓGICA DE PODERES
local AutoE = false
local Anclado = false
local PosicionAnclaje = nil

-- Lógica de Anclaje (Inamovible)
RunService.Heartbeat:Connect(function()
    if Anclado and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        -- Si es la primera vez que activamos, guardamos la posición
        if not PosicionAnclaje then PosicionAnclaje = root.CFrame end
        -- Forzamos al personaje a quedarse en ese punto exacto, ignorando físicas
        root.CFrame = PosicionAnclaje
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    else
        PosicionAnclaje = nil
    end
end)

-- Lógica de Spam E (Depurador por cercanía)
task.spawn(function()
    while task.wait(0.1) do
        if AutoE and Player.Character then
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Enabled then
                    local dist = (Player.Character.PrimaryPart.Position - p.Parent:GetPivot().Position).Magnitude
                    if dist < 12 then
                        fireproximityprompt(p) -- Spamea la E automáticamente
                    end
                end
            end
        end
    end
end)

-- // 4. BOTONES (ESTILO image_1cab11.png)
local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

-- Botón Auto-E
createButton("DEPURADOR (SPAM E)", UDim2.new(0.1, 0, 0.2, 0), function(btn)
    AutoE = not AutoE
    btn.BackgroundColor3 = AutoE and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(240, 240, 240)
end)

-- Botón Anclaje (Inamovible)
createButton("MODO ANCLAJE (ANCLAR)", UDim2.new(0.1, 0, 0.45, 0), function(btn)
    Anclado = not Anclado
    btn.BackgroundColor3 = Anclado and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(240, 240, 240)
    if Anclado then warn("⚓ PERSONAJE ANCLADO") else warn("🔓 MOVIMIENTO LIBERADO") end
end)

-- Botón Cerrar
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
Close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- // 5. ANIMACIÓN DE ENTRADA
Main.Visible = true
Main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 400)}):Play()
