-- DarkScript Player Stats Viewer (Stats + Rebirth)
-- Lista vertical de jugadores con GUI movible, minimizable y cerrable
-- Adaptado para celular

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Función para abreviar números
local function abbreviateNumber(num)
local abbrevs = {"", "k", "m", "b", "t", "qd"}
local index = 1
while num >= 1000 and index < #abbrevs do
num = num / 1000
index = index + 1
end
return string.format("%.2f%s", num, abbrevs[index])
end

-- Crear GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 220)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Título arcoíris
local Title = Instance.new("TextLabel")
Title.Text = "DarkScript"
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Efecto rainbow
task.spawn(function()
local hue = 0
while Title.Parent do
hue = (hue + 0.01) % 1
Title.TextColor3 = Color3.fromHSV(hue, 1, 1)
task.wait(0.05)
end
end)

-- Botones minimizar y cerrar
local MinButton = Instance.new("TextButton")
MinButton.Text = "-"
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -65, 0, 0)
MinButton.TextScaled = true
MinButton.Font = Enum.Font.GothamBold
MinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Parent = MainFrame

-- ScrollingFrame para lista de jugadores
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 1, -40)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundTransparency = 1
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.ScrollBarThickness = 6
PlayerList.Parent = MainFrame

-- Layout vertical con padding
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = PlayerList

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 4)
UIPadding.PaddingBottom = UDim.new(0, 4)
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 4)
UIPadding.Parent = PlayerList

-- Función para obtener Rebirth
local function getRebirth(plr)
if plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Rebirth") then
return plr.leaderstats.Rebirth.Value
elseif ReplicatedStorage:FindFirstChild("Datas") and ReplicatedStorage.Datas:FindFirstChild(tostring(plr.UserId)) then
local data = ReplicatedStorage.Datas[tostring(plr.UserId)]
if data:FindFirstChild("Rebirth") then
return data.Rebirth.Value
end
elseif plr:FindFirstChild("Rebirth") then
return plr.Rebirth.Value
end
return 0
end

-- Actualizar lista de jugadores
local function updatePlayers()
for _,child in pairs(PlayerList:GetChildren()) do
if child:IsA("TextLabel") then child:Destroy() end
end

for _,plr in ipairs(Players:GetPlayers()) do
local statsValue = 0
if plr.Character and plr.Character:FindFirstChild("Stats") and plr.Character.Stats:FindFirstChild("Energy") then
statsValue = plr.Character.Stats.Energy.Value
end
local reb = getRebirth(plr)

local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Text = plr.Name.." | Stats: "..abbreviateNumber(statsValue).." | Rebs: "..abbreviateNumber(reb)
PlayerLabel.Size = UDim2.new(1, -5, 0, 28)
PlayerLabel.BackgroundTransparency = 0.2
PlayerLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerLabel.TextScaled = true
PlayerLabel.Font = Enum.Font.Gotham
PlayerLabel.Parent = PlayerList
end
end

RunService.Heartbeat:Connect(updatePlayers)

-- Minimizar
local minimized = false
MinButton.MouseButton1Click:Connect(function()
minimized = not minimized
PlayerList.Visible = not minimized
MainFrame.Size = minimized and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 220)
end)

-- Cerrar
CloseButton.MouseButton1Click:Connect(function()
ScreenGui:Destroy()
end)