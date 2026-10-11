--[[
    ╔═══════════════════════════════════════════════╗
    ║  NEBULA UI LIBRARY  v1.0.0                    ║
    ║  Modern, animated Roblox UI library for Luau  ║
    ╚═══════════════════════════════════════════════╝

    Features
      • Animated loading screen (spinner, progress, status text, player welcome)
      • Key system (local key list or custom validator, saved key, attempts, shake)
      • Player card (display name, @username, avatar headshot)
      • Themes (Midnight, Ocean, Rose, Emerald, Amber, Light) + live switching
      • Icon registry (glyphs OR rbxassetid numbers) + asset preloading
      • Elements: Section, Label, Paragraph, Button, Toggle, Slider, Input,
                  Dropdown (multi), Keybind, ColorPicker
      • Notifications (Info / Success / Warning / Error) with progress bars
      • Config saving/loading via Flags
      • Draggable, minimize, close, toggle key, mobile toggle button

    NOTE: Key checks that run on the client are NOT secure. Use a server-side
    validator (ks.Validate) if the key actually protects something.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Nebula = {
	Version = "1.0.0",
	Flags = {},
	Icons = {},
	Themes = {},
	_conns = {},
	_themed = {},
	_windows = {},
}

--==================================================================
-- THEMES
--==================================================================
Nebula.Themes = {
	Midnight = {
		Background = Color3.fromRGB(14, 14, 20), Surface = Color3.fromRGB(23, 23, 33),
		Elevated = Color3.fromRGB(33, 33, 47), Stroke = Color3.fromRGB(48, 48, 68),
		Text = Color3.fromRGB(240, 240, 250), SubText = Color3.fromRGB(150, 150, 175),
		Accent = Color3.fromRGB(124, 92, 255), Accent2 = Color3.fromRGB(82, 160, 255),
		Success = Color3.fromRGB(70, 210, 130), Warning = Color3.fromRGB(255, 190, 70),
		Error = Color3.fromRGB(255, 90, 100),
	},
	Ocean = {
		Background = Color3.fromRGB(10, 18, 28), Surface = Color3.fromRGB(16, 29, 44),
		Elevated = Color3.fromRGB(24, 43, 64), Stroke = Color3.fromRGB(38, 65, 94),
		Text = Color3.fromRGB(232, 245, 255), SubText = Color3.fromRGB(135, 165, 195),
		Accent = Color3.fromRGB(40, 190, 230), Accent2 = Color3.fromRGB(60, 120, 255),
		Success = Color3.fromRGB(70, 210, 150), Warning = Color3.fromRGB(255, 200, 80),
		Error = Color3.fromRGB(255, 100, 110),
	},
	Rose = {
		Background = Color3.fromRGB(22, 12, 18), Surface = Color3.fromRGB(34, 20, 28),
		Elevated = Color3.fromRGB(50, 29, 41), Stroke = Color3.fromRGB(78, 46, 64),
		Text = Color3.fromRGB(255, 240, 246), SubText = Color3.fromRGB(190, 150, 168),
		Accent = Color3.fromRGB(255, 80, 140), Accent2 = Color3.fromRGB(255, 130, 90),
		Success = Color3.fromRGB(90, 215, 140), Warning = Color3.fromRGB(255, 200, 80),
		Error = Color3.fromRGB(255, 80, 90),
	},
	Emerald = {
		Background = Color3.fromRGB(10, 20, 16), Surface = Color3.fromRGB(16, 33, 26),
		Elevated = Color3.fromRGB(24, 49, 39), Stroke = Color3.fromRGB(38, 76, 60),
		Text = Color3.fromRGB(235, 255, 245), SubText = Color3.fromRGB(135, 185, 160),
		Accent = Color3.fromRGB(50, 220, 130), Accent2 = Color3.fromRGB(40, 190, 200),
		Success = Color3.fromRGB(80, 230, 140), Warning = Color3.fromRGB(255, 200, 80),
		Error = Color3.fromRGB(255, 95, 105),
	},
	Amber = {
		Background = Color3.fromRGB(22, 16, 8), Surface = Color3.fromRGB(35, 26, 14),
		Elevated = Color3.fromRGB(52, 39, 21), Stroke = Color3.fromRGB(82, 62, 34),
		Text = Color3.fromRGB(255, 247, 232), SubText = Color3.fromRGB(190, 168, 135),
		Accent = Color3.fromRGB(255, 170, 40), Accent2 = Color3.fromRGB(255, 110, 60),
		Success = Color3.fromRGB(100, 215, 120), Warning = Color3.fromRGB(255, 210, 90),
		Error = Color3.fromRGB(255, 90, 90),
	},
	Light = {
		Background = Color3.fromRGB(244, 245, 250), Surface = Color3.fromRGB(255, 255, 255),
		Elevated = Color3.fromRGB(235, 237, 245), Stroke = Color3.fromRGB(214, 218, 232),
		Text = Color3.fromRGB(28, 30, 42), SubText = Color3.fromRGB(110, 115, 140),
		Accent = Color3.fromRGB(95, 85, 240), Accent2 = Color3.fromRGB(60, 150, 255),
		Success = Color3.fromRGB(40, 175, 100), Warning = Color3.fromRGB(230, 150, 20),
		Error = Color3.fromRGB(230, 60, 75),
	},
}
Nebula.Theme = Nebula.Themes.Midnight
Nebula.ThemeName = "Midnight"

--==================================================================
-- ICONS
-- Values can be a glyph string (rendered as text) or an asset id
-- (number or "rbxassetid://123"). Add your own with Nebula:RegisterIcon.
--==================================================================
Nebula.Icons = {
	home = "⌂", settings = "⚙", star = "★", info = "ℹ", check = "✔", close = "✖",
	warning = "⚠", user = "☻", key = "⚿", combat = "⚔", visual = "◉", misc = "☰",
	heart = "♥", bolt = "⚡", palette = "✦", lock = "◈", world = "◍", list = "≡",
}

function Nebula:RegisterIcon(name, value)
	self.Icons[name] = value
end

function Nebula:RegisterIcons(map)
	for k, v in pairs(map) do self.Icons[k] = v end
end

--==================================================================
-- HELPERS
--==================================================================
local function Connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(Nebula._conns, c)
	return c
end

local function Create(class, props, children)
	local inst = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else inst[k] = v end
	end
	for _, c in ipairs(children or {}) do c.Parent = inst end
	if parent then inst.Parent = parent end
	return inst
end

local function Tween(obj, t, props, style, dir)
	local tw = TweenService:Create(obj, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

-- Bind instance properties to theme keys (auto-updates on SetTheme)
local function Bind(inst, map)
	for prop, key in pairs(map) do
		inst[prop] = Nebula.Theme[key]
		table.insert(Nebula._themed, { inst, prop, key })
	end
	return inst
end

local function Corner(parent, r)
	return Create("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent })
end

local function Stroke(parent, key, thickness, transparency)
	local s = Create("UIStroke", { Thickness = thickness or 1, Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent })
	return Bind(s, { Color = key or "Stroke" })
end

local function Pad(parent, l, t, r, b)
	return Create("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or l or 0),
		PaddingRight = UDim.new(0, r or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0),
		Parent = parent,
	})
end

local function Label(parent, text, size, colorKey, font, props)
	local l = Create("TextLabel", {
		BackgroundTransparency = 1, Text = text or "", TextSize = size or 14,
		Font = font or Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = parent,
	})
	for k, v in pairs(props or {}) do l[k] = v end
	return Bind(l, { TextColor3 = colorKey or "Text" })
end

local function Accent(inst, prop)
	Bind(inst, { [prop or "BackgroundColor3"] = "Accent" })
end

local function AccentGradient(parent, rotation)
	local g = Create("UIGradient", { Rotation = rotation or 0, Parent = parent })
	local function upd() g.Color = ColorSequence.new(Nebula.Theme.Accent, Nebula.Theme.Accent2) end
	upd()
	table.insert(Nebula._themed, { g, "__accentgradient", upd })
	return g
end

local function SafeCall(fn, ...)
	if type(fn) ~= "function" then return end
	local ok, err = pcall(fn, ...)
	if not ok then warn("[Nebula] callback error: " .. tostring(err)) end
end

local function Icon(parent, icon, size, colorKey)
	if icon == nil then return nil end
	local v = Nebula.Icons[icon] or icon
	if type(v) == "number" then v = "rbxassetid://" .. v end
	if type(v) == "string" and (v:find("rbxassetid") or v:find("rbxasset://") or v:find("http")) then
		local img = Create("ImageLabel", { BackgroundTransparency = 1, Image = v, Size = UDim2.fromOffset(size, size), Parent = parent })
		return Bind(img, { ImageColor3 = colorKey or "Text" })
	end
	local t = Create("TextLabel", {
		BackgroundTransparency = 1, Text = tostring(v), TextSize = size, Font = Enum.Font.GothamBold,
		Size = UDim2.fromOffset(size + 4, size + 4), Parent = parent,
	})
	return Bind(t, { TextColor3 = colorKey or "Text" })
end

local function CanFile()
	return writefile ~= nil and readfile ~= nil and isfile ~= nil
end

local function ClickArea(parent)
	return Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), AutoButtonColor = false, ZIndex = 5, Parent = parent })
end

local function IsPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function IsMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

-- Drag inside an area; reports relative x,y in 0..1
local function AreaDrag(area, onMove)
	local dragging = false
	local function update(input)
		local p, s = area.AbsolutePosition, area.AbsoluteSize
		onMove(math.clamp((input.Position.X - p.X) / math.max(s.X, 1), 0, 1), math.clamp((input.Position.Y - p.Y) / math.max(s.Y, 1), 0, 1))
	end
	Connect(area.InputBegan, function(i) if IsPress(i) then dragging = true update(i) end end)
	Connect(UserInputService.InputChanged, function(i) if dragging and IsMove(i) then update(i) end end)
	Connect(UserInputService.InputEnded, function(i) if IsPress(i) then dragging = false end end)
end

--==================================================================
-- THEME SWITCHING
--==================================================================
function Nebula:SetTheme(name)
	local theme = self.Themes[name]
	if not theme then return warn("[Nebula] Unknown theme: " .. tostring(name)) end
	self.Theme, self.ThemeName = theme, name
	for i = #self._themed, 1, -1 do
		local e = self._themed[i]
		local inst, prop, key = e[1], e[2], e[3]
		if inst.Parent == nil and not inst:IsA("UIGradient") then
			table.remove(self._themed, i)
		elseif prop == "__accentgradient" then
			key()
		else
			Tween(inst, 0.35, { [prop] = theme[key] })
		end
	end
end

function Nebula:AddTheme(name, theme)
	local base = self.Themes.Midnight
	for k, v in pairs(base) do if theme[k] == nil then theme[k] = v end end
	self.Themes[name] = theme
end

--==================================================================
-- GUI ROOT
--==================================================================
local function NewGui(name)
	local gui = Create("ScreenGui", {
		Name = name, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true, DisplayOrder = 999,
	})
	local ok = pcall(function()
		if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end
	end)
	if not ok or not gui.Parent then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	return gui
end

--==================================================================
-- NOTIFICATIONS
--==================================================================
local NotifHolder
local function EnsureNotifHolder()
	if NotifHolder and NotifHolder.Parent then return NotifHolder end
	local gui = NewGui("NebulaNotifications")
	gui.DisplayOrder = 1001
	Nebula._notifGui = gui
	NotifHolder = Create("Frame", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, 310, 1, -32), BackgroundTransparency = 1, Parent = gui,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Parent = NotifHolder,
	})
	return NotifHolder
end

function Nebula:Notify(o)
	o = o or {}
	local holder = EnsureNotifHolder()
	local typ = o.Type or "Info"
	local colorKey = ({ Info = "Accent", Success = "Success", Warning = "Warning", Error = "Error" })[typ] or "Accent"
	local iconName = o.Icon or ({ Info = "info", Success = "check", Warning = "warning", Error = "close" })[typ]
	local duration = o.Duration or 4

	local wrap = Create("Frame", { Size = UDim2.new(1, 0, 0, 74), BackgroundTransparency = 1, Parent = holder })
	local card = Bind(Create("CanvasGroup", {
		Size = UDim2.fromScale(1, 1), Position = UDim2.new(1.2, 0, 0, 0), BorderSizePixel = 0, Parent = wrap,
	}), { BackgroundColor3 = "Surface" })
	Corner(card, 10)
	Stroke(card, "Stroke", 1)

	local badge = Bind(Create("Frame", { Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(12, 12), BackgroundTransparency = 0.8, BorderSizePixel = 0, Parent = card }), { BackgroundColor3 = colorKey })
	Corner(badge, 9)
	local ic = Icon(badge, iconName, 16, colorKey)
	if ic then ic.AnchorPoint = Vector2.new(0.5, 0.5) ic.Position = UDim2.fromScale(0.5, 0.5) end

	Label(card, o.Title or "Notification", 14, "Text", Enum.Font.GothamBold, { Position = UDim2.fromOffset(56, 10), Size = UDim2.new(1, -66, 0, 18) })
	Label(card, o.Content or "", 12, "SubText", Enum.Font.Gotham, {
		Position = UDim2.fromOffset(56, 29), Size = UDim2.new(1, -66, 0, 34), TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top, TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local bar = Bind(Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 3), BorderSizePixel = 0, Parent = card }), { BackgroundColor3 = colorKey })

	Tween(card, 0.5, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
	Tween(bar, duration, { Size = UDim2.new(0, 0, 0, 3) }, Enum.EasingStyle.Linear)

	local closed = false
	local function close()
		if closed then return end
		closed = true
		Tween(card, 0.35, { Position = UDim2.new(1.2, 0, 0, 0), GroupTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		task.wait(0.3)
		Tween(wrap, 0.25, { Size = UDim2.new(1, 0, 0, 0) })
		task.wait(0.28)
		wrap:Destroy()
	end
	local btn = ClickArea(card)
	btn.MouseButton1Click:Connect(function() task.spawn(close) end)
	task.delay(duration, function() task.spawn(close) end)
end

--==================================================================
-- LOADING SCREEN
--==================================================================
local function RunLoading(gui, s)
	local blur
	if s.Blur ~= false then
		pcall(function()
			blur = Instance.new("BlurEffect") blur.Size = 0 blur.Name = "NebulaBlur" blur.Parent = Lighting
			Tween(blur, 0.6, { Size = 18 })
		end)
	end

	local dim = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Parent = gui })
	Tween(dim, 0.5, { BackgroundTransparency = 0.45 })

	local card = Bind(Create("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(380, 250),
		BorderSizePixel = 0, GroupTransparency = 1, Parent = gui,
	}), { BackgroundColor3 = "Background" })
	Corner(card, 16) Stroke(card, "Stroke", 1)
	local scale = Create("UIScale", { Scale = 0.85, Parent = card })
	Tween(card, 0.5, { GroupTransparency = 0 })
	Tween(scale, 0.6, { Scale = 1 }, Enum.EasingStyle.Back)

	-- spinner ring
	local ring = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 26), Size = UDim2.fromOffset(60, 60), BackgroundTransparency = 1, Parent = card })
	Corner(ring, 30)
	local rs = Create("UIStroke", { Thickness = 4, Color = Color3.new(1, 1, 1), Parent = ring })
	local rg = Create("UIGradient", { Parent = rs })
	local function updRing()
		rg.Color = ColorSequence.new(Nebula.Theme.Accent, Nebula.Theme.Accent2)
		rg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.15), NumberSequenceKeypoint.new(0.62, 1), NumberSequenceKeypoint.new(1, 1) })
	end
	updRing()
	local spin = RunService.Heartbeat:Connect(function(dt) rg.Rotation = (rg.Rotation + dt * 300) % 360 end)
	local logo = Icon(ring, s.Icon or "bolt", 24, "Accent")
	if logo then logo.AnchorPoint = Vector2.new(0.5, 0.5) logo.Position = UDim2.fromScale(0.5, 0.5) end

	Label(card, s.LoadingTitle or s.Name or "Nebula", 20, "Text", Enum.Font.GothamBold, {
		Position = UDim2.fromOffset(0, 100), Size = UDim2.new(1, 0, 0, 24), TextXAlignment = Enum.TextXAlignment.Center,
	})
	Label(card, s.LoadingSubtitle or "Loading interface", 12, "SubText", Enum.Font.Gotham, {
		Position = UDim2.fromOffset(0, 124), Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Center,
	})

	local track = Bind(Create("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 160), Size = UDim2.new(1, -64, 0, 6), BorderSizePixel = 0, Parent = card }), { BackgroundColor3 = "Elevated" })
	Corner(track, 3)
	local fill = Create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = track })
	Corner(fill, 3) AccentGradient(fill)

	local status = Label(card, "Starting...", 12, "SubText", Enum.Font.Gotham, { Position = UDim2.fromOffset(32, 174), Size = UDim2.new(1, -64, 0, 16) })
	local pct = Label(card, "0%", 12, "Accent", Enum.Font.GothamBold, { Position = UDim2.fromOffset(32, 174), Size = UDim2.new(1, -64, 0, 16), TextXAlignment = Enum.TextXAlignment.Right })

	local display = LocalPlayer.DisplayName
	local who = Label(card, "", 12, "SubText", Enum.Font.GothamMedium, { Position = UDim2.fromOffset(0, 214), Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Center })

	local steps = s.LoadingSteps or {
		"Initializing core...", "Loading assets...", "Building interface...", "Applying theme: " .. Nebula.ThemeName .. "...", "Almost there...",
	}

	-- preload assets in background
	if s.Preload and #s.Preload > 0 then
		task.spawn(function()
			local list = {}
			for _, id in ipairs(s.Preload) do
				table.insert(list, type(id) == "number" and ("rbxassetid://" .. id) or id)
			end
			pcall(function() ContentProvider:PreloadAsync(list) end)
		end)
	end

	local total = s.LoadingTime or 3
	for i, text in ipairs(steps) do
		status.Text = text
		local target = i / #steps
		Tween(fill, total / #steps, { Size = UDim2.fromScale(target, 1) }, Enum.EasingStyle.Sine)
		local t0 = tick()
		local startV = (i - 1) / #steps
		while tick() - t0 < total / #steps do
			local a = math.clamp((tick() - t0) / (total / #steps), 0, 1)
			pct.Text = math.floor((startV + (target - startV) * a) * 100) .. "%"
			RunService.Heartbeat:Wait()
		end
	end
	pct.Text = "100%"
	status.Text = "Ready"
	who.Text = ("Welcome, %s  (@%s)"):format(display, LocalPlayer.Name)
	who.TextTransparency = 1
	Tween(who, 0.5, { TextTransparency = 0 })
	task.wait(0.8)

	Tween(card, 0.45, { GroupTransparency = 1 })
	Tween(scale, 0.45, { Scale = 1.08 })
	Tween(dim, 0.45, { BackgroundTransparency = 1 })
	if blur then Tween(blur, 0.45, { Size = 0 }) end
	task.wait(0.5)
	spin:Disconnect()
	card:Destroy() dim:Destroy()
	if blur then blur:Destroy() end
end

--==================================================================
-- KEY SYSTEM
--==================================================================
local function ValidateKey(ks, key)
	if key == nil or key == "" then return false end
	if type(ks.Validate) == "function" then
		local ok, res = pcall(ks.Validate, key)
		return ok and res == true
	end
	for _, k in ipairs(ks.Keys or {}) do
		if k == key then return true end
	end
	return false
end

local function RunKeySystem(gui, ks, windowName)
	local file = ks.FileName or "NebulaKey.txt"
	if ks.SaveKey ~= false and CanFile() then
		local ok, saved = pcall(function() if isfile(file) then return readfile(file) end end)
		if ok and saved and ValidateKey(ks, saved) then return true end
	end

	local card = Bind(Create("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(390, 290),
		BorderSizePixel = 0, GroupTransparency = 1, Parent = gui,
	}), { BackgroundColor3 = "Background" })
	Corner(card, 16) Stroke(card, "Stroke", 1)
	local scale = Create("UIScale", { Scale = 0.9, Parent = card })
	Tween(card, 0.5, { GroupTransparency = 0 })
	Tween(scale, 0.6, { Scale = 1 }, Enum.EasingStyle.Back)

	local badge = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 22), Size = UDim2.fromOffset(48, 48), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = card })
	Corner(badge, 14) AccentGradient(badge, 45)
	local ic = Icon(badge, ks.Icon or "key", 22, "Text")
	if ic then ic.TextColor3 = Color3.new(1, 1, 1) ic.AnchorPoint = Vector2.new(0.5, 0.5) ic.Position = UDim2.fromScale(0.5, 0.5) end

	Label(card, ks.Title or "Key Required", 19, "Text", Enum.Font.GothamBold, { Position = UDim2.fromOffset(0, 80), Size = UDim2.new(1, 0, 0, 24), TextXAlignment = Enum.TextXAlignment.Center })
	Label(card, ks.Subtitle or ("Enter your key to access " .. (windowName or "the hub")), 12, "SubText", Enum.Font.Gotham, {
		Position = UDim2.fromOffset(0, 104), Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Center,
	})

	local boxHolder = Bind(Create("Frame", { Position = UDim2.fromOffset(28, 138), Size = UDim2.new(1, -56, 0, 40), BorderSizePixel = 0, Parent = card }), { BackgroundColor3 = "Surface" })
	Corner(boxHolder, 9)
	local boxStroke = Stroke(boxHolder, "Stroke", 1)
	local box = Create("TextBox", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0), Position = UDim2.fromOffset(12, 0), Text = "",
		PlaceholderText = ks.Placeholder or "Paste your key here...", ClearTextOnFocus = false, TextSize = 14,
		Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = boxHolder,
	})
	Bind(box, { TextColor3 = "Text", PlaceholderColor3 = "SubText" })
	Connect(box.Focused, function() Tween(boxStroke, 0.2, { Color = Nebula.Theme.Accent }) end)
	Connect(box.FocusLost, function() Tween(boxStroke, 0.2, { Color = Nebula.Theme.Stroke }) end)

	local status = Label(card, ks.Note or "", 12, "SubText", Enum.Font.Gotham, { Position = UDim2.fromOffset(28, 184), Size = UDim2.new(1, -56, 0, 16), TextXAlignment = Enum.TextXAlignment.Center })

	local function makeBtn(text, x, w, primary)
		local b = Create("TextButton", {
			Position = UDim2.new(x, x == 0 and 28 or 0, 0, 212), Size = UDim2.new(w, w == 1 and -56 or -34, 0, 40),
			AutoButtonColor = false, Text = text, TextSize = 14, Font = Enum.Font.GothamBold, BorderSizePixel = 0,
			BackgroundColor3 = primary and Color3.new(1, 1, 1) or Nebula.Theme.Elevated, Parent = card,
		})
		Corner(b, 9)
		if primary then AccentGradient(b) b.TextColor3 = Color3.new(1, 1, 1)
		else Bind(b, { BackgroundColor3 = "Elevated", TextColor3 = "Text" }) end
		Connect(b.MouseEnter, function() Tween(b, 0.15, { Size = b.Size + UDim2.fromOffset(0, 2) }) end)
		Connect(b.MouseLeave, function() Tween(b, 0.15, { Size = UDim2.new(b.Size.X.Scale, b.Size.X.Offset, 0, 40) }) end)
		return b
	end
	local hasLink = ks.Link ~= nil
	local verify = makeBtn("Verify Key", hasLink and 0.5 or 0, hasLink and 0.5 or 1, true)
	if hasLink then
		verify.Position = UDim2.new(0.5, 6, 0, 212)
		verify.Size = UDim2.new(0.5, -34, 0, 40)
		local get = makeBtn("Get Key", 0, 0.5, false)
		get.Size = UDim2.new(0.5, -34, 0, 40)
		Connect(get.MouseButton1Click, function()
			if setclipboard then
				setclipboard(ks.Link)
				status.Text = "Link copied to clipboard!"
				Tween(status, 0.2, { TextColor3 = Nebula.Theme.Success })
			else
				status.Text = ks.Link
			end
		end)
	end

	local attempts = 0
	local maxAttempts = ks.MaxAttempts or 5
	local result -- nil = pending, true/false

	local function shake()
		local base = card.Position
		for _, dx in ipairs({ 10, -10, 7, -7, 3, 0 }) do
			Tween(card, 0.05, { Position = UDim2.new(base.X.Scale, dx, base.Y.Scale, base.Y.Offset) }, Enum.EasingStyle.Sine)
			task.wait(0.05)
		end
	end

	local busy = false
	local function submit()
		if busy then return end
		busy = true
		verify.Text = "Checking..."
		task.wait(0.35)
		if ValidateKey(ks, box.Text) then
			status.Text = "Access granted"
			Tween(status, 0.2, { TextColor3 = Nebula.Theme.Success })
			Tween(boxStroke, 0.2, { Color = Nebula.Theme.Success })
			verify.Text = "Success ✔"
			if ks.SaveKey ~= false and CanFile() then pcall(writefile, file, box.Text) end
			task.wait(0.6)
			result = true
		else
			attempts += 1
			status.Text = ("Invalid key  (%d/%d)"):format(attempts, maxAttempts)
			Tween(status, 0.2, { TextColor3 = Nebula.Theme.Error })
			Tween(boxStroke, 0.2, { Color = Nebula.Theme.Error })
			verify.Text = "Verify Key"
			shake()
			if attempts >= maxAttempts then
				task.wait(0.4)
				result = false
			end
		end
		busy = false
	end
	Connect(verify.MouseButton1Click, submit)
	Connect(box.FocusLost, function(enter) if enter then submit() end end)

	repeat task.wait() until result ~= nil

	Tween(card, 0.4, { GroupTransparency = 1 })
	Tween(scale, 0.4, { Scale = result and 1.08 or 0.9 })
	task.wait(0.42)
	card:Destroy()
	return result
end

--==================================================================
-- WINDOW
--==================================================================
function Nebula:CreateWindow(s)
	s = s or {}
	if s.Theme and self.Themes[s.Theme] then self.Theme, self.ThemeName = self.Themes[s.Theme], s.Theme end

	local gui = NewGui("Nebula_" .. HttpService:GenerateGUID(false):sub(1, 8))
	local Window = { Gui = gui, Tabs = {}, Visible = true, Minimized = false }
	table.insert(self._windows, Window)

	-- 1) loading screen
	if s.LoadingScreen ~= false then RunLoading(gui, s) end

	-- 2) key system
	if s.KeySystem and s.KeySystem.Enabled then
		local ok = RunKeySystem(gui, s.KeySystem, s.Name)
		if not ok then
			self:Notify({ Title = "Access denied", Content = "Key verification failed.", Type = "Error" })
			task.wait(0.2)
			gui:Destroy()
			return nil
		end
	end

	-- 3) main window
	local W, H, TOP, SIDE = s.Width or 620, s.Height or 410, 46, 176

	local main = Bind(Create("CanvasGroup", {
		Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(W, H), BorderSizePixel = 0, GroupTransparency = 1, Parent = gui,
	}), { BackgroundColor3 = "Background" })
	Corner(main, 14) Stroke(main, "Stroke", 1)
	local uiscale = Create("UIScale", { Scale = 0.9, Parent = main })
	Window.Main = main

	-- scale down on small screens
	local function fitScale()
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
		return math.min(1, (vp.X - 20) / W, (vp.Y - 20) / H)
	end
	local baseScale = fitScale()

	local function open()
		Window.Visible = true
		main.Visible = true
		Tween(main, 0.4, { GroupTransparency = 0 })
		Tween(uiscale, 0.5, { Scale = baseScale }, Enum.EasingStyle.Back)
	end
	local function hide()
		Window.Visible = false
		Tween(main, 0.25, { GroupTransparency = 1 })
		Tween(uiscale, 0.25, { Scale = 0.92 })
		task.delay(0.26, function() if not Window.Visible then main.Visible = false end end)
	end
	open()

	-- top bar
	local top = Bind(Create("Frame", { Size = UDim2.new(1, 0, 0, TOP), BorderSizePixel = 0, Parent = main }), { BackgroundColor3 = "Surface" })
	local topLine = Bind(Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Parent = top }), { BackgroundColor3 = "Stroke" })

	local logo = Create("Frame", { Position = UDim2.fromOffset(12, 9), Size = UDim2.fromOffset(28, 28), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = top })
	Corner(logo, 8) AccentGradient(logo, 45)
	local lic = Icon(logo, s.Icon or "bolt", 14, "Text")
	if lic then lic.TextColor3 = Color3.new(1, 1, 1) lic.AnchorPoint = Vector2.new(0.5, 0.5) lic.Position = UDim2.fromScale(0.5, 0.5) end

	Label(top, s.Name or "Nebula", 15, "Text", Enum.Font.GothamBold, { Position = UDim2.fromOffset(50, 7), Size = UDim2.new(1, -200, 0, 18) })
	Label(top, s.Subtitle or ("v" .. self.Version), 11, "SubText", Enum.Font.Gotham, { Position = UDim2.fromOffset(50, 24), Size = UDim2.new(1, -200, 0, 14) })

	local function topButton(glyph, xOff, hoverKey)
		local b = Create("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOff, 0.5, 0), Size = UDim2.fromOffset(28, 28),
			AutoButtonColor = false, Text = glyph, TextSize = 14, Font = Enum.Font.GothamBold, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = top,
		})
		Corner(b, 8)
		Bind(b, { TextColor3 = "SubText" })
		Connect(b.MouseEnter, function() Tween(b, 0.15, { BackgroundTransparency = 0.8, BackgroundColor3 = Nebula.Theme[hoverKey], TextColor3 = Nebula.Theme[hoverKey] }) end)
		Connect(b.MouseLeave, function() Tween(b, 0.15, { BackgroundTransparency = 1, TextColor3 = Nebula.Theme.SubText }) end)
		return b
	end
	local closeBtn = topButton("✖", -10, "Error")
	local minBtn = topButton("–", -42, "Warning")

	-- dragging
	do
		local dragging, dStart, sPos = false, nil, nil
		Connect(top.InputBegan, function(i)
			if IsPress(i) then dragging, dStart, sPos = true, i.Position, main.Position end
		end)
		Connect(UserInputService.InputChanged, function(i)
			if dragging and IsMove(i) then
				local d = i.Position - dStart
				Tween(main, 0.08, { Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) }, Enum.EasingStyle.Linear)
			end
		end)
		Connect(UserInputService.InputEnded, function(i) if IsPress(i) then dragging = false end end)
	end

	-- sidebar
	local side = Bind(Create("Frame", { Position = UDim2.fromOffset(0, TOP), Size = UDim2.new(0, SIDE, 1, -TOP), BorderSizePixel = 0, Parent = main }), { BackgroundColor3 = "Surface" })
	Bind(Create("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 1, 1, 0), BorderSizePixel = 0, Parent = side }), { BackgroundColor3 = "Stroke" })

	local tabList = Create("ScrollingFrame", {
		Position = UDim2.fromOffset(0, 8), Size = UDim2.new(1, 0, 1, -76), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = side,
	})
	Pad(tabList, 10, 0, 10, 0)
	Create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabList })

	-- player card
	local pcard = Bind(Create("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -10), Size = UDim2.new(1, -20, 0, 54), BorderSizePixel = 0, Parent = side }), { BackgroundColor3 = "Elevated" })
	Corner(pcard, 10)
	local avatar = Bind(Create("ImageLabel", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(38, 38), BorderSizePixel = 0, Parent = pcard }), { BackgroundColor3 = "Stroke" })
	Corner(avatar, 19)
	task.spawn(function()
		local ok, img = pcall(function()
			return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and img then avatar.Image = img end
	end)
	Label(pcard, LocalPlayer.DisplayName, 13, "Text", Enum.Font.GothamBold, { Position = UDim2.fromOffset(54, 9), Size = UDim2.new(1, -60, 0, 16) })
	Label(pcard, "@" .. LocalPlayer.Name, 11, "SubText", Enum.Font.Gotham, { Position = UDim2.fromOffset(54, 26), Size = UDim2.new(1, -60, 0, 14) })
	local dot = Bind(Create("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(0, 46, 0, 46), Size = UDim2.fromOffset(10, 10), BorderSizePixel = 0, Parent = pcard }), { BackgroundColor3 = "Success" })
	Corner(dot, 5) Stroke(dot, "Elevated", 2)

	-- content
	local content = Create("Frame", { Position = UDim2.fromOffset(SIDE, TOP), Size = UDim2.new(1, -SIDE, 1, -TOP), BackgroundTransparency = 1, ClipsDescendants = true, Parent = main })

	--------------------------------------------------------------
	-- window methods
	--------------------------------------------------------------
	function Window:Toggle()
		if self.Visible then hide() else open() end
	end
	function Window:SetVisible(v) if v ~= self.Visible then self:Toggle() end end
	function Window:SetTheme(name) Nebula:SetTheme(name) end
	function Window:Notify(o) Nebula:Notify(o) end
	function Window:Destroy()
		Tween(main, 0.3, { GroupTransparency = 1 })
		Tween(uiscale, 0.3, { Scale = 0.9 })
		task.wait(0.32)
		gui:Destroy()
		for _, c in ipairs(Nebula._conns) do pcall(function() c:Disconnect() end) end
		Nebula._conns = {}
	end

	Connect(closeBtn.MouseButton1Click, function() Window:Destroy() end)
	Connect(minBtn.MouseButton1Click, function()
		Window.Minimized = not Window.Minimized
		Tween(main, 0.4, { Size = Window.Minimized and UDim2.fromOffset(W, TOP) or UDim2.fromOffset(W, H) }, Enum.EasingStyle.Quint)
	end)

	local toggleKey = s.ToggleKey or Enum.KeyCode.RightShift
	Connect(UserInputService.InputBegan, function(i, gp)
		if not gp and i.KeyCode == toggleKey then Window:Toggle() end
	end)

	-- mobile toggle button
	if UserInputService.TouchEnabled and s.MobileButton ~= false then
		local mb = Create("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14), Size = UDim2.fromOffset(44, 44),
			Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = gui,
		})
		Corner(mb, 22) AccentGradient(mb, 45)
		local mi = Icon(mb, s.Icon or "bolt", 20, "Text")
		if mi then mi.TextColor3 = Color3.new(1, 1, 1) mi.AnchorPoint = Vector2.new(0.5, 0.5) mi.Position = UDim2.fromScale(0.5, 0.5) end
		Connect(mb.MouseButton1Click, function() Window:Toggle() end)
	end

	--------------------------------------------------------------
	-- TABS
	--------------------------------------------------------------
	local current

	local function selectTab(tab)
		if current == tab then return end
		if current then
			local c = current
			Tween(c.Indicator, 0.25, { Size = UDim2.fromOffset(3, 0) })
			Tween(c.Button, 0.25, { BackgroundTransparency = 1 })
			Tween(c.NameLabel, 0.25, { TextColor3 = Nebula.Theme.SubText })
			if c.IconObj then
				Tween(c.IconObj, 0.25, { [c.IconObj:IsA("ImageLabel") and "ImageColor3" or "TextColor3"] = Nebula.Theme.SubText })
			end
			c.Page.Visible = false
		end
		current = tab
		Tween(tab.Indicator, 0.35, { Size = UDim2.fromOffset(3, 18) }, Enum.EasingStyle.Back)
		Tween(tab.Button, 0.25, { BackgroundTransparency = 0.82 })
		Tween(tab.NameLabel, 0.25, { TextColor3 = Nebula.Theme.Text })
		if tab.IconObj then
			Tween(tab.IconObj, 0.25, { [tab.IconObj:IsA("ImageLabel") and "ImageColor3" or "TextColor3"] = Nebula.Theme.Accent })
		end
		tab.Page.Visible = true
		tab.Page.GroupTransparency = 1
		tab.Page.Position = UDim2.fromOffset(0, 16)
		Tween(tab.Page, 0.4, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) })
	end

	function Window:CreateTab(name, icon)
		local Tab = { Name = name }

		local btn = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 36), AutoButtonColor = false, Text = "", BackgroundTransparency = 1,
			BorderSizePixel = 0, LayoutOrder = #Window.Tabs, Parent = tabList,
		})
		Bind(btn, { BackgroundColor3 = "Accent" })
		Corner(btn, 8)
		local ind = Bind(Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 0), BorderSizePixel = 0, Parent = btn }), { BackgroundColor3 = "Accent" })
		Corner(ind, 2)
		local xOff = 12
		local iconObj
		if icon then
			iconObj = Icon(btn, icon, 16, "SubText")
			iconObj.AnchorPoint = Vector2.new(0, 0.5)
			iconObj.Position = UDim2.new(0, 12, 0.5, 0)
			xOff = 38
		end
		local nameLbl = Label(btn, name, 13, "SubText", Enum.Font.GothamMedium, { Position = UDim2.fromOffset(xOff, 0), Size = UDim2.new(1, -xOff - 6, 1, 0) })

		Connect(btn.MouseEnter, function() if current ~= Tab then Tween(btn, 0.2, { BackgroundTransparency = 0.92 }) end end)
		Connect(btn.MouseLeave, function() if current ~= Tab then Tween(btn, 0.2, { BackgroundTransparency = 1 }) end end)

		local page = Create("CanvasGroup", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = content })
		local scroll = Create("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
			AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y, Parent = page,
		})
		Bind(scroll, { ScrollBarImageColor3 = "Accent" })
		Pad(scroll, 14, 14, 14, 14)
		Create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll })

		Tab.Button, Tab.Indicator, Tab.NameLabel, Tab.IconObj, Tab.Page = btn, ind, nameLbl, iconObj, page
		table.insert(Window.Tabs, Tab)
		Connect(btn.MouseButton1Click, function() selectTab(Tab) end)
		if #Window.Tabs == 1 then selectTab(Tab) end

		--------------------------------------------------------
		-- element helpers
		--------------------------------------------------------
		local function NewElement(height)
			local f = Bind(Create("Frame", { Size = UDim2.new(1, 0, 0, height), ClipsDescendants = true, BorderSizePixel = 0, Parent = scroll }), { BackgroundColor3 = "Surface" })
			Corner(f, 9) Stroke(f, "Stroke", 1, 0.3)
			return f
		end

		local function Hover(f, area)
			Connect(area.MouseEnter, function() Tween(f, 0.2, { BackgroundColor3 = Nebula.Theme.Elevated }) end)
			Connect(area.MouseLeave, function() Tween(f, 0.2, { BackgroundColor3 = Nebula.Theme.Surface }) end)
		end

		local function Header(f, o, rightPad, headerH)
			local hasDesc = o.Description ~= nil
			Label(f, o.Name or "Element", 13, "Text", Enum.Font.GothamMedium, {
				Position = UDim2.fromOffset(14, hasDesc and 8 or 0),
				Size = hasDesc and UDim2.new(1, -rightPad, 0, 16) or UDim2.new(1, -rightPad, 0, headerH),
			})
			if hasDesc then
				Label(f, o.Description, 11, "SubText", Enum.Font.Gotham, { Position = UDim2.fromOffset(14, 26), Size = UDim2.new(1, -rightPad, 0, 14) })
			end
		end

		local function Register(o, obj)
			if o.Flag then Nebula.Flags[o.Flag] = obj end
			return obj
		end

		--------------------------------------------------------
		-- SECTION / LABEL / PARAGRAPH
		--------------------------------------------------------
		function Tab:CreateSection(text)
			local f = Create("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = scroll })
			local l = Label(f, string.upper(text or "Section"), 11, "Accent", Enum.Font.GothamBold, { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X })
			local line = Bind(Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(1, -70, 0, 1), BorderSizePixel = 0, Parent = f }), { BackgroundColor3 = "Stroke" })
			l:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				line.Size = UDim2.new(1, -(l.AbsoluteSize.X + 10), 0, 1)
			end)
			local S = {}
			function S:Set(t) l.Text = string.upper(t) end
			return S
		end

		function Tab:CreateLabel(text, iconName)
			local f = NewElement(34)
			local x = 14
			if iconName then
				local ic = Icon(f, iconName, 14, "Accent")
				ic.AnchorPoint = Vector2.new(0, 0.5) ic.Position = UDim2.new(0, 12, 0.5, 0) x = 34
			end
			local l = Label(f, text, 12, "SubText", Enum.Font.GothamMedium, { Position = UDim2.fromOffset(x, 0), Size = UDim2.new(1, -x - 8, 1, 0) })
			local L = {}
			function L:Set(t) l.Text = t end
			return L
		end

		function Tab:CreateParagraph(o)
			local f = NewElement(0)
			f.AutomaticSize = Enum.AutomaticSize.Y
			f.Size = UDim2.new(1, 0, 0, 0)
			Pad(f, 14, 10, 14, 10)
			Create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = f })
			local t = Label(f, o.Title or "Paragraph", 13, "Text", Enum.Font.GothamBold, { Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1 })
			local c = Label(f, o.Content or "", 12, "SubText", Enum.Font.Gotham, {
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2,
			})
			local P = {}
			function P:Set(o2) if o2.Title then t.Text = o2.Title end if o2.Content then c.Text = o2.Content end end
			return P
		end

		--------------------------------------------------------
		-- BUTTON
		--------------------------------------------------------
		function Tab:CreateButton(o)
			local h = o.Description and 54 or 42
			local f = NewElement(h)
			Header(f, o, 60, h)
			local arrow = Label(f, "›", 22, "Accent", Enum.Font.GothamBold, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, -1), Size = UDim2.fromOffset(20, 24), TextXAlignment = Enum.TextXAlignment.Center })
			local area = ClickArea(f)
			Hover(f, area)
			Connect(area.MouseButton1Click, function()
				local flash = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 4, Parent = f })
				Bind(flash, { BackgroundColor3 = "Accent" })
				Corner(flash, 9)
				Tween(flash, 0.5, { BackgroundTransparency = 1 })
				Tween(arrow, 0.12, { Position = UDim2.new(1, -8, 0.5, -1) })
				task.delay(0.12, function() Tween(arrow, 0.25, { Position = UDim2.new(1, -14, 0.5, -1) }, Enum.EasingStyle.Back) end)
				game:GetService("Debris"):AddItem(flash, 0.6)
				SafeCall(o.Callback)
			end)
			local B = {}
			function B:Fire() SafeCall(o.Callback) end
			return B
		end

		--------------------------------------------------------
		-- TOGGLE
		--------------------------------------------------------
		function Tab:CreateToggle(o)
			local h = o.Description and 54 or 42
			local f = NewElement(h)
			Header(f, o, 80, h)
			local sw = Bind(Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(40, 22), BorderSizePixel = 0, Parent = f }), { BackgroundColor3 = "Elevated" })
			Corner(sw, 11)
			local swStroke = Stroke(sw, "Stroke", 1)
			local knob = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = sw })
			Corner(knob, 8)
			local area = ClickArea(f)
			Hover(f, area)

			local T = { Value = o.CurrentValue == true }
			local function render(anim)
				local t = anim and 0.3 or 0
				Tween(sw, t, { BackgroundColor3 = T.Value and Nebula.Theme.Accent or Nebula.Theme.Elevated })
				Tween(swStroke, t, { Color = T.Value and Nebula.Theme.Accent or Nebula.Theme.Stroke })
				Tween(knob, t, { Position = T.Value and UDim2.new(0, 21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, Enum.EasingStyle.Back)
			end
			render(false)
			function T:Set(v, silent)
				T.Value = v == true
				render(true)
				if not silent then SafeCall(o.Callback, T.Value) end
			end
			function T:Get() return T.Value end
			Connect(area.MouseButton1Click, function() T:Set(not T.Value) end)
			if T.Value then SafeCall(o.Callback, true) end
			return Register(o, T)
		end

		--------------------------------------------------------
		-- SLIDER
		--------------------------------------------------------
		function Tab:CreateSlider(o)
			local f = NewElement(58)
			local range = o.Range or { 0, 100 }
			local inc = o.Increment or 1
			local suffix = o.Suffix or ""
			Label(f, o.Name or "Slider", 13, "Text", Enum.Font.GothamMedium, { Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -100, 0, 16) })
			local val = Label(f, "", 12, "Accent", Enum.Font.GothamBold, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 8), Size = UDim2.fromOffset(80, 16), TextXAlignment = Enum.TextXAlignment.Right })
			local track = Bind(Create("Frame", { Position = UDim2.new(0, 14, 0, 38), Size = UDim2.new(1, -28, 0, 8), BorderSizePixel = 0, Parent = f }), { BackgroundColor3 = "Elevated" })
			Corner(track, 4)
			local fill = Create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = track })
			Corner(fill, 4) AccentGradient(fill)
			local knob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 3, Parent = track })
			Corner(knob, 7) Stroke(knob, "Accent", 2)

			local S = { Value = o.CurrentValue or range[1] }
			local function snap(v)
				v = math.clamp(math.floor((v - range[1]) / inc + 0.5) * inc + range[1], range[1], range[2])
				return tonumber(string.format("%.6f", v))
			end
			local function render(anim)
				local a = (S.Value - range[1]) / math.max(range[2] - range[1], 1e-9)
				local t = anim and 0.12 or 0
				Tween(fill, t, { Size = UDim2.fromScale(a, 1) }, Enum.EasingStyle.Sine)
				Tween(knob, t, { Position = UDim2.fromScale(a, 0.5) }, Enum.EasingStyle.Sine)
				val.Text = tostring(S.Value) .. suffix
			end
			S.Value = snap(S.Value) render(false)
			function S:Set(v, silent)
				v = snap(v)
				if v == S.Value and not silent then return end
				S.Value = v render(true)
				if not silent then SafeCall(o.Callback, v) end
			end
			function S:Get() return S.Value end
			-- enlarged hit area (full row width, taller than the track)
			local hit = Create("Frame", { Position = UDim2.fromOffset(0, 28), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Parent = f })
			AreaDrag(hit, function(x) S:Set(range[1] + (range[2] - range[1]) * math.clamp((hit.AbsoluteSize.X > 0 and (x * hit.AbsoluteSize.X - 14) / track.AbsoluteSize.X or x), 0, 1)) end)
			if o.CurrentValue then SafeCall(o.Callback, S.Value) end
			return Register(o, S)
		end

		--------------------------------------------------------
		-- INPUT
		--------------------------------------------------------
		function Tab:CreateInput(o)
			local h = o.Description and 54 or 42
			local f = NewElement(h)
			Header(f, o, 190, h)
			local holder = Bind(Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(160, 28), BorderSizePixel = 0, Parent = f }), { BackgroundColor3 = "Elevated" })
			Corner(holder, 7)
			local st = Stroke(holder, "Stroke", 1)
			local box = Create("TextBox", {
				BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), Text = o.CurrentValue or "",
				PlaceholderText = o.PlaceholderText or "Type here...", ClearTextOnFocus = false, TextSize = 12, Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = holder,
			})
			Bind(box, { TextColor3 = "Text", PlaceholderColor3 = "SubText" })
			Connect(box.Focused, function() Tween(st, 0.2, { Color = Nebula.Theme.Accent }) end)
			local I = { Value = box.Text }
			Connect(box.FocusLost, function(enter)
				Tween(st, 0.2, { Color = Nebula.Theme.Stroke })
				if o.NumbersOnly and tonumber(box.Text) == nil then box.Text = I.Value return end
				I.Value = box.Text
				SafeCall(o.Callback, I.Value)
				if o.RemoveTextAfterFocusLost then box.Text = "" end
			end)
			function I:Set(v, silent) box.Text = tostring(v) I.Value = box.Text if not silent then SafeCall(o.Callback, I.Value) end end
			function I:Get() return I.Value end
			return Register(o, I)
		end

		--------------------------------------------------------
		-- DROPDOWN
		--------------------------------------------------------
		function Tab:CreateDropdown(o)
			local HEAD, ITEM = 42, 30
			local options = o.Options or {}
			local multi = o.MultipleOptions == true
			local f = NewElement(HEAD)
			Header(f, o, 170, HEAD)

			local current = Label(f, "", 12, "Accent", Enum.Font.GothamMedium, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -36, 0, 0), Size = UDim2.fromOffset(130, HEAD), TextXAlignment = Enum.TextXAlignment.Right })
			local chev = Label(f, "▾", 14, "SubText", Enum.Font.GothamBold, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.fromOffset(18, HEAD), TextXAlignment = Enum.TextXAlignment.Center })

			local head = Create("TextButton", { Size = UDim2.new(1, 0, 0, HEAD), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5, Parent = f })
			Hover(f, head)

			local list = Create("Frame", { Position = UDim2.fromOffset(0, HEAD), Size = UDim2.new(1, 0, 0, #options * ITEM + 8), BackgroundTransparency = 1, Parent = f })
			Pad(list, 8, 0, 8, 8)
			Create("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

			local D = { Value = o.CurrentOption or (multi and {} or nil), Open = false }
			if not multi and type(D.Value) == "table" then D.Value = D.Value[1] end
			if multi and type(D.Value) ~= "table" then D.Value = { D.Value } end

			local items = {}
			local function isSel(opt)
				if multi then return table.find(D.Value, opt) ~= nil end
				return D.Value == opt
			end
			local function refresh()
				for opt, it in pairs(items) do
					local sel = isSel(opt)
					Tween(it.bg, 0.2, { BackgroundTransparency = sel and 0.8 or 1 })
					Tween(it.lbl, 0.2, { TextColor3 = sel and Nebula.Theme.Accent or Nebula.Theme.Text })
					it.check.Visible = sel
				end
				if multi then
					current.Text = #D.Value == 0 and "None" or (#D.Value == 1 and tostring(D.Value[1]) or (#D.Value .. " selected"))
				else
					current.Text = D.Value and tostring(D.Value) or "None"
				end
			end
			for idx, opt in ipairs(options) do
				local b = Create("TextButton", { Size = UDim2.new(1, 0, 0, ITEM), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = idx, Parent = list })
				local bg = Bind(Create("Frame", { Size = UDim2.new(1, 0, 1, -2), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = b }), { BackgroundColor3 = "Accent" })
				Corner(bg, 6)
				local lbl = Label(b, tostring(opt), 12, "Text", Enum.Font.GothamMedium, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -36, 1, -2) })
				local check = Label(b, "✔", 12, "Accent", Enum.Font.GothamBold, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 0), Size = UDim2.fromOffset(16, ITEM - 2), TextXAlignment = Enum.TextXAlignment.Center, Visible = false })
				items[opt] = { bg = bg, lbl = lbl, check = check }
				Connect(b.MouseEnter, function() if not isSel(opt) then Tween(bg, 0.15, { BackgroundTransparency = 0.92 }) end end)
				Connect(b.MouseLeave, function() if not isSel(opt) then Tween(bg, 0.15, { BackgroundTransparency = 1 }) end end)
				Connect(b.MouseButton1Click, function()
					if multi then
						local i = table.find(D.Value, opt)
						if i then table.remove(D.Value, i) else table.insert(D.Value, opt) end
					else
						D.Value = opt
						D:Toggle(false)
					end
					refresh()
					SafeCall(o.Callback, D.Value)
				end)
			end
			refresh()

			function D:Toggle(state)
				if state == nil then state = not D.Open end
				D.Open = state
				Tween(f, 0.35, { Size = UDim2.new(1, 0, 0, state and (HEAD + #options * ITEM + 8) or HEAD) }, Enum.EasingStyle.Quint)
				Tween(chev, 0.3, { Rotation = state and 180 or 0 })
			end
			function D:Set(v, silent)
				D.Value = v
				if multi and type(v) ~= "table" then D.Value = { v } end
				refresh()
				if not silent then SafeCall(o.Callback, D.Value) end
			end
			function D:Get() return D.Value end
			Connect(head.MouseButton1Click, function() D:Toggle() end)
			return Register(o, D)
		end

		--------------------------------------------------------
		-- KEYBIND
		--------------------------------------------------------
		function Tab:CreateKeybind(o)
			local h = o.Description and 54 or 42
			local f = NewElement(h)
			Header(f, o, 110, h)
			local pill = Bind(Create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(78, 26),
				AutoButtonColor = false, TextSize = 12, Font = Enum.Font.GothamBold, BorderSizePixel = 0, Text = "", Parent = f,
			}), { BackgroundColor3 = "Elevated", TextColor3 = "Accent" })
			Corner(pill, 7) Stroke(pill, "Stroke", 1)
			local K = { Value = o.CurrentKeybind or "None", Listening = false }
			pill.Text = K.Value
			Hover(f, pill)

			Connect(pill.MouseButton1Click, function()
				K.Listening = true
				pill.Text = "..."
				Tween(pill, 0.2, { Size = UDim2.fromOffset(88, 26) })
			end)
			Connect(UserInputService.InputBegan, function(i, gp)
				if K.Listening then
					if i.UserInputType == Enum.UserInputType.Keyboard then
						K.Listening = false
						K.Value = i.KeyCode == Enum.KeyCode.Escape and "None" or i.KeyCode.Name
						pill.Text = K.Value
						Tween(pill, 0.2, { Size = UDim2.fromOffset(78, 26) })
						SafeCall(o.OnChanged, K.Value)
					end
				elseif not gp and i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode.Name == K.Value then
					SafeCall(o.Callback, K.Value)
				end
			end)
			function K:Set(v) K.Value = v pill.Text = v end
			function K:Get() return K.Value end
			return Register(o, K)
		end

		--------------------------------------------------------
		-- COLOR PICKER
		--------------------------------------------------------
		function Tab:CreateColorPicker(o)
			local HEAD, FULL = 42, 42 + 138
			local f = NewElement(HEAD)
			Header(f, o, 80, HEAD)
			local preview = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0, HEAD / 2), Size = UDim2.fromOffset(34, 20), BackgroundColor3 = o.Color or Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = f })
			Corner(preview, 6) Stroke(preview, "Stroke", 1)
			local head = Create("TextButton", { Size = UDim2.new(1, 0, 0, HEAD), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5, Parent = f })
			Hover(f, head)

			local h, sat, v = (o.Color or Color3.new(1, 1, 1)):ToHSV()

			local sv = Create("Frame", { Position = UDim2.fromOffset(14, HEAD + 4), Size = UDim2.new(1, -56, 0, 110), BackgroundColor3 = Color3.fromHSV(h, 1, 1), BorderSizePixel = 0, Parent = f })
			Corner(sv, 6)
			local white = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = sv })
			Corner(white, 6)
			Create("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
			local black = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv })
			Corner(black, 6)
			Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = black })
			local svKnob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, ZIndex = 4, Parent = sv })
			Corner(svKnob, 6)
			Create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Parent = svKnob })

			local hue = Create("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, HEAD + 4), Size = UDim2.fromOffset(18, 110), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = f })
			Corner(hue, 6)
			local kp = {}
			for i = 0, 6 do table.insert(kp, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 % 1 == 0 and (i == 6 and 0.9999 or 0) or i / 6, 1, 1))) end
			Create("UIGradient", { Rotation = 90, Color = ColorSequence.new(kp), Parent = hue })
			local hueKnob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 4, 0, 5), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = hue })
			Corner(hueKnob, 3) Create("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.5, Parent = hueKnob })

			local C = { Value = o.Color or Color3.new(1, 1, 1), Open = false }
			local function render()
				C.Value = Color3.fromHSV(h, sat, v)
				preview.BackgroundColor3 = C.Value
				sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				svKnob.Position = UDim2.fromScale(sat, 1 - v)
				hueKnob.Position = UDim2.fromScale(0.5, h)
			end
			render()
			AreaDrag(sv, function(x, y) sat, v = x, 1 - y render() SafeCall(o.Callback, C.Value) end)
			AreaDrag(hue, function(_, y) h = math.clamp(y, 0, 0.9999) render() SafeCall(o.Callback, C.Value) end)

			function C:Set(color, silent)
				h, sat, v = color:ToHSV() render()
				if not silent then SafeCall(o.Callback, C.Value) end
			end
			function C:Get() return C.Value end
			Connect(head.MouseButton1Click, function()
				C.Open = not C.Open
				Tween(f, 0.35, { Size = UDim2.new(1, 0, 0, C.Open and FULL or HEAD) })
			end)
			return Register(o, C)
		end

		return Tab
	end

	--------------------------------------------------------------
	-- CONFIG SAVE / LOAD
	--------------------------------------------------------------
	local cfg = s.ConfigurationSaving or {}
	local function cfgPath()
		return (cfg.FolderName or "Nebula") .. "/" .. (cfg.FileName or "config") .. ".json"
	end
	function Window:SaveConfiguration()
		if not CanFile() then return false end
		local data = {}
		for flag, obj in pairs(Nebula.Flags) do
			local v = obj.Value
			if typeof(v) == "Color3" then v = { __c3 = { v.R, v.G, v.B } } end
			data[flag] = v
		end
		pcall(function()
			if makefolder and isfolder and not isfolder(cfg.FolderName or "Nebula") then makefolder(cfg.FolderName or "Nebula") end
			writefile(cfgPath(), HttpService:JSONEncode(data))
		end)
		return true
	end
	function Window:LoadConfiguration()
		if not CanFile() then return false end
		local ok, raw = pcall(function() if isfile(cfgPath()) then return readfile(cfgPath()) end end)
		if not ok or not raw then return false end
		local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
		if not ok2 then return false end
		for flag, v in pairs(data) do
			local obj = Nebula.Flags[flag]
			if obj and obj.Set then
				if type(v) == "table" and v.__c3 then v = Color3.new(v.__c3[1], v.__c3[2], v.__c3[3]) end
				pcall(obj.Set, obj, v)
			end
		end
		return true
	end

	-- built-in settings helpers
	function Window:CreateSettingsTab()
		local tab = Window:CreateTab("Settings", "settings")
		tab:CreateSection("Appearance")
		local names = {}
		for n in pairs(Nebula.Themes) do table.insert(names, n) end
		table.sort(names)
		tab:CreateDropdown({ Name = "Theme", Description = "Switch the interface colors live", Options = names, CurrentOption = Nebula.ThemeName, Callback = function(v) Nebula:SetTheme(v) end })
		tab:CreateKeybind({ Name = "Toggle UI", CurrentKeybind = toggleKey.Name, OnChanged = function(k) pcall(function() toggleKey = Enum.KeyCode[k] end) end })
		tab:CreateSection("Configuration")
		tab:CreateButton({ Name = "Save configuration", Callback = function() Window:SaveConfiguration() Nebula:Notify({ Title = "Saved", Content = "Configuration saved.", Type = "Success" }) end })
		tab:CreateButton({ Name = "Load configuration", Callback = function()
			local ok = Window:LoadConfiguration()
			Nebula:Notify({ Title = ok and "Loaded" or "Nothing to load", Content = ok and "Configuration applied." or "No saved config found.", Type = ok and "Success" or "Warning" })
		end })
		tab:CreateSection("Interface")
		tab:CreateButton({ Name = "Destroy UI", Description = "Closes and removes the window", Callback = function() Window:Destroy() end })
		return tab
	end

	if cfg.Enabled and cfg.AutoLoad ~= false then
		task.delay(0.5, function() Window:LoadConfiguration() end)
	end

	task.delay(0.6, function()
		Nebula:Notify({ Title = "Welcome, " .. LocalPlayer.DisplayName, Content = "Press " .. toggleKey.Name .. " to show or hide the interface.", Type = "Info" })
	end)

	return Window
end

return Nebula
