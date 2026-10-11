--============================================================
--  APEX UI  •  v2 (Rayfield-inspired, clean, modern)
--  Single-file, dependency-free, animated
--============================================================

local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")

local LP = Players.LocalPlayer

--============================================================
-- HELPERS
--============================================================
local function new(class, props)
    local ok, inst = pcall(Instance.new, class)
    if not ok or not inst then return nil end
    if props then for k, v in pairs(props) do pcall(function() inst[k] = v end) end end
    return inst
end
local function corner(p, r) if p then return new("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p }) end end
local function stroke(p, c, t, tr)
    if not p then return nil end
    return new("UIStroke", { Color = c, Thickness = t or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p })
end
local function padding(p, t, b, l, r)
    if not p then return nil end
    t = t or 0; b = b or t; l = l or t; r = r or l
    return new("UIPadding", { PaddingTop = UDim.new(0,t), PaddingBottom = UDim.new(0,b), PaddingLeft = UDim.new(0,l), PaddingRight = UDim.new(0,r), Parent = p })
end
local function tween(obj, info, goal) if obj then TweenService:Create(obj, info, goal):Play() end end
local function quad(d) return TweenInfo.new(d or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) end
local function sine(d) return TweenInfo.new(d or 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) end

--============================================================
-- THEMES
--============================================================
local Themes = {
    Dark = {
        window      = Color3.fromRGB(11, 11, 14),
        sidebar     = Color3.fromRGB(9, 9, 11),
        content     = Color3.fromRGB(11, 11, 14),
        card        = Color3.fromRGB(18, 18, 22),
        cardHeader  = Color3.fromRGB(22, 22, 27),
        row         = Color3.fromRGB(18, 18, 22),
        rowHover    = Color3.fromRGB(25, 25, 31),
        rowActive   = Color3.fromRGB(28, 28, 35),
        accent      = Color3.fromRGB(160, 130, 255),
        accentHi    = Color3.fromRGB(185, 160, 255),
        accentLo    = Color3.fromRGB(120, 90, 220),
        accentDim   = Color3.fromRGB(45, 35, 80),
        text        = Color3.fromRGB(232, 232, 238),
        textSoft    = Color3.fromRGB(168, 168, 180),
        textDim     = Color3.fromRGB(118, 118, 130),
        textFaint   = Color3.fromRGB(72, 72, 82),
        border      = Color3.fromRGB(26, 26, 32),
        borderHi    = Color3.fromRGB(38, 38, 46),
        track       = Color3.fromRGB(38, 38, 46),
        shadow      = Color3.fromRGB(0, 0, 0),
        success     = Color3.fromRGB(95, 210, 135),
        warning     = Color3.fromRGB(240, 190, 70),
        error       = Color3.fromRGB(240, 85, 95),
    },
    Light = {
        window      = Color3.fromRGB(250, 250, 253),
        sidebar     = Color3.fromRGB(243, 243, 247),
        content     = Color3.fromRGB(250, 250, 253),
        card        = Color3.fromRGB(255, 255, 255),
        cardHeader  = Color3.fromRGB(248, 248, 252),
        row         = Color3.fromRGB(255, 255, 255),
        rowHover    = Color3.fromRGB(245, 245, 250),
        rowActive   = Color3.fromRGB(238, 238, 245),
        accent      = Color3.fromRGB(120, 90, 240),
        accentHi    = Color3.fromRGB(150, 120, 255),
        accentLo    = Color3.fromRGB(90, 65, 200),
        accentDim   = Color3.fromRGB(230, 222, 255),
        text        = Color3.fromRGB(24, 24, 32),
        textSoft    = Color3.fromRGB(80, 80, 95),
        textDim     = Color3.fromRGB(130, 130, 145),
        textFaint   = Color3.fromRGB(180, 180, 195),
        border      = Color3.fromRGB(228, 228, 236),
        borderHi    = Color3.fromRGB(210, 210, 220),
        track       = Color3.fromRGB(220, 220, 230),
        shadow      = Color3.fromRGB(0, 0, 0),
        success     = Color3.fromRGB(60, 170, 105),
        warning     = Color3.fromRGB(200, 150, 40),
        error       = Color3.fromRGB(220, 70, 80),
    },
    Ocean = {
        window      = Color3.fromRGB(8, 12, 18),
        sidebar     = Color3.fromRGB(6, 10, 15),
        content     = Color3.fromRGB(8, 12, 18),
        card        = Color3.fromRGB(14, 20, 28),
        cardHeader  = Color3.fromRGB(18, 25, 34),
        row         = Color3.fromRGB(14, 20, 28),
        rowHover    = Color3.fromRGB(20, 28, 38),
        rowActive   = Color3.fromRGB(24, 33, 45),
        accent      = Color3.fromRGB(80, 190, 240),
        accentHi    = Color3.fromRGB(120, 215, 255),
        accentLo    = Color3.fromRGB(50, 150, 200),
        accentDim   = Color3.fromRGB(20, 55, 80),
        text        = Color3.fromRGB(230, 240, 248),
        textSoft    = Color3.fromRGB(160, 178, 192),
        textDim     = Color3.fromRGB(110, 128, 145),
        textFaint   = Color3.fromRGB(65, 78, 92),
        border      = Color3.fromRGB(22, 32, 42),
        borderHi    = Color3.fromRGB(35, 48, 62),
        track       = Color3.fromRGB(35, 48, 62),
        shadow      = Color3.fromRGB(0, 0, 0),
        success     = Color3.fromRGB(95, 210, 135),
        warning     = Color3.fromRGB(240, 190, 70),
        error       = Color3.fromRGB(240, 85, 95),
    },
}

local Lib = {}
Lib.__index = Lib
Lib.Themes = Themes

--============================================================
-- NOTIFICATIONS
--============================================================
local function createNotifier(root, theme)
    local holder = new("Frame", {
        Size = UDim2.new(0, 300, 1, -80),
        Position = UDim2.new(1, -316, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = 900,
        Parent = root,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = holder,
    })

    local api = {}

    function api:Notify(opts)
        opts = opts or {}
        local title = opts.Title or "Notification"
        local text  = opts.Text or ""
        local color = opts.Color or theme.accent
        local dur   = opts.Duration or 3

        local n = new("Frame", {
            Size = UDim2.new(1, 0, 0, 52),
            Position = UDim2.new(1, 20, 0, 0),
            BackgroundColor3 = theme.card,
            BackgroundTransparency = 0.04,
            BorderSizePixel = 0,
            ZIndex = 901,
            Parent = holder,
        })
        corner(n, 8)
        local st = stroke(n, theme.borderHi, 1, 0.3)

        local bar = new("Frame", {
            Size = UDim2.new(0, 2, 1, -14),
            Position = UDim2.new(0, 0, 0, 7),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            ZIndex = 902,
            Parent = n,
        })
        corner(bar, 1)

        local titleL = new("TextLabel", {
            Size = UDim2.new(1, -26, 0, 16),
            Position = UDim2.new(0, 16, 0, 8),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = theme.text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 902,
            Parent = n,
        })
        local textL = new("TextLabel", {
            Size = UDim2.new(1, -26, 0, 22),
            Position = UDim2.new(0, 16, 0, 24),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = theme.textDim,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 902,
            Parent = n,
        })

        tween(n, quad(0.28), { Position = UDim2.new(0, 0, 0, 0) })
        task.delay(dur, function()
            tween(n, quad(0.22), { BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, 0) })
            tween(st, quad(0.22), { Transparency = 1 })
            tween(bar, quad(0.22), { BackgroundTransparency = 1 })
            tween(titleL, quad(0.22), { TextTransparency = 1 })
            tween(textL, quad(0.22), { TextTransparency = 1 })
            task.wait(0.25)
            pcall(function() n:Destroy() end)
        end)
    end

    return api
end

--============================================================
-- WINDOW
--============================================================
function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local theme = Themes[cfg.Theme or "Dark"] or Themes.Dark
    local title = cfg.Title or "APEX"
    local subtitle = cfg.Subtitle or ""
    local icon = cfg.Icon or "rbxassetid://6034684930"
    local size = cfg.Size or UDim2.new(0, 620, 0, 460)
    local showLoader = cfg.Loader ~= false

    local win = setmetatable({}, Lib)
    win.Theme = theme
    win.Tabs = {}
    win.CurrentTab = nil

    local root = new("ScreenGui", { Name = "ApexUI_" .. tostring(math.random(1000, 9999)), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui })
    win.Root = root

    -- shadow + window
    local shadow = new("Frame", {
        Size = UDim2.new(1, 24, 1, 24),
        Position = UDim2.new(0.5, -(size.X.Offset / 2) - 12, 0.5, -(size.Y.Offset / 2) - 12),
        BackgroundColor3 = theme.shadow,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = root,
    })
    corner(shadow, 22)

    local main = new("Frame", {
        Name = "Main",
        Size = size,
        Position = UDim2.new(0.5, -(size.X.Offset / 2), 0.5, -(size.Y.Offset / 2)),
        BackgroundColor3 = theme.window,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        Parent = root,
    })
    corner(main, 12)
    local mainStroke = stroke(main, theme.borderHi, 1, 1)
    win.Main = main

    -- top bar
    local topBar = new("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = theme.window, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main })
    corner(topBar, 12)
    win.TopBar = topBar

    -- brand
    local brandWrap = new("Frame", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 16, 0, 10), BackgroundColor3 = theme.accent, BorderSizePixel = 0, Parent = topBar })
    corner(brandWrap, 7)
    new("ImageLabel", { Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0.5, -6.5, 0.5, -6.5), BackgroundTransparency = 1, Image = icon, ImageColor3 = Color3.fromRGB(255,255,255), Parent = brandWrap })
    new("TextLabel", { Size = UDim2.new(0, 200, 0, 14), Position = UDim2.new(0, 48, 0, 8), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar })
    if subtitle ~= "" then
        new("TextLabel", { Size = UDim2.new(0, 200, 0, 10), Position = UDim2.new(0, 48, 0, 23), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = subtitle, TextColor3 = theme.textFaint, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar })
    end

    -- controls
    local closeBtn = new("ImageButton", { Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -36, 0, 9), BackgroundColor3 = theme.card, BackgroundTransparency = 1, Image = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = topBar })
    corner(closeBtn, 7)
    local closeSt = stroke(closeBtn, theme.border, 1, 1)
    local closeIcon = new("ImageLabel", { Size = UDim2.new(0, 11, 0, 11), Position = UDim2.new(0.5, -5.5, 0.5, -5.5), BackgroundTransparency = 1, Image = "rbxassetid://6026568199", ImageColor3 = theme.textDim, Parent = closeBtn })

    local minBtn = new("ImageButton", { Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -68, 0, 9), BackgroundColor3 = theme.card, BackgroundTransparency = 1, Image = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = topBar })
    corner(minBtn, 7)
    local minSt = stroke(minBtn, theme.border, 1, 1)
    local minIcon = new("ImageLabel", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0.5, -5, 0.5, -5), BackgroundTransparency = 1, Image = "rbxassetid://6023426926", ImageColor3 = theme.textDim, Parent = minBtn })

    local function hover(btn, ic, st)
        btn.MouseEnter:Connect(function()
            tween(btn, quad(0.15), { BackgroundTransparency = 0, BackgroundColor3 = theme.rowHover })
            tween(st, quad(0.15), { Transparency = 0 })
            tween(ic, quad(0.15), { ImageColor3 = theme.text })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, quad(0.15), { BackgroundTransparency = 1 })
            tween(st, quad(0.15), { Transparency = 1 })
            tween(ic, quad(0.15), { ImageColor3 = theme.textDim })
        end)
    end
    hover(closeBtn, closeIcon, closeSt)
    hover(minBtn, minIcon, minSt)

    -- sidebar
    local sidebar = new("Frame", { Size = UDim2.new(0, 168, 1, -58), Position = UDim2.new(0, 10, 0, 52), BackgroundColor3 = theme.sidebar, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main })
    corner(sidebar, 8)
    local sidebarSt = stroke(sidebar, theme.border, 1, 1)
    win.Sidebar = sidebar

    local sideScroll = new("ScrollingFrame", { Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = theme.accent, ScrollBarImageTransparency = 0.6, AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = sidebar })
    new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sideScroll })

    -- content
    local content = new("Frame", { Size = UDim2.new(1, -190, 1, -58), Position = UDim2.new(0, 180, 0, 52), BackgroundTransparency = 1, Parent = main })
    win.Content = content

    -- notifier
    win.Notifier = createNotifier(root, theme)
    function win:Notify(o) task.spawn(function() self.Notifier:Notify(o) end) end

    -- tabs
    local navFrames = {}

    function win:ShowTab(name)
        for n, tab in pairs(self.Tabs) do
            if tab.Page and tab.Page.Parent then tab.Page.Visible = (n == name) end
        end
        for n, b in pairs(navFrames) do
            if b and b.frame and b.frame.Parent then
                local active = (n == name)
                tween(b.frame, quad(0.16), { BackgroundColor3 = active and theme.rowActive or theme.sidebar })
                tween(b.bar, quad(0.16), { BackgroundTransparency = active and 0 or 1 })
                tween(b.icon, quad(0.16), { ImageColor3 = active and theme.accent or theme.textDim })
                tween(b.label, quad(0.16), { TextColor3 = active and theme.text or theme.textDim })
            end
        end
        local tgt = self.Tabs[name]
        if tgt and tgt.Page then
            for _, child in ipairs(tgt.Page:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChildOfClass("UIListLayout") then
                    local final = child.Position
                    child.Position = UDim2.new(final.X.Scale, final.X.Offset + 10, final.Y.Scale, final.Y.Offset)
                    child.BackgroundTransparency = 1
                    task.spawn(function()
                        tween(child, quad(0.28), { Position = final, BackgroundTransparency = 0 })
                    end)
                end
            end
        end
        self.CurrentTab = name
    end

    function win:CreateTab(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Tab"
        local iconId = cfg.Icon or "rbxassetid://6022668086"
        local section = cfg.Section

        if section then
            local exists = false
            for _, c in ipairs(sideScroll:GetChildren()) do
                if c:IsA("TextLabel") and c.Text == string.upper(section) then exists = true break end
            end
            if not exists then
                local lbl = new("TextLabel", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = string.upper(section), TextColor3 = theme.textFaint, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, Parent = sideScroll })
                padding(lbl, 0, 2, 10, 0)
            end
        end

        local frame = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = theme.sidebar, BorderSizePixel = 0, Parent = sideScroll })
        corner(frame, 6)

        local bar = new("Frame", { Size = UDim2.new(0, 2, 0.6, 0), Position = UDim2.new(0, 0, 0.2, 0), BackgroundColor3 = theme.accent, BorderSizePixel = 0, BackgroundTransparency = 1, Parent = frame })
        corner(bar, 1)

        local iconImg = new("ImageLabel", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 12, 0.5, -7), BackgroundTransparency = 1, Image = iconId, ImageColor3 = theme.textDim, Parent = frame })
        local lbl = new("TextLabel", { Size = UDim2.new(1, -36, 1, 0), Position = UDim2.new(0, 32, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = name, TextColor3 = theme.textDim, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })

        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = frame })
        hit.MouseButton1Click:Connect(function() self:ShowTab(name) end)
        hit.MouseEnter:Connect(function()
            if self.CurrentTab == name then return end
            tween(frame, quad(0.12), { BackgroundColor3 = theme.row })
            tween(iconImg, quad(0.12), { ImageColor3 = theme.textSoft })
            tween(lbl, quad(0.12), { TextColor3 = theme.textSoft })
        end)
        hit.MouseLeave:Connect(function()
            if self.CurrentTab == name then return end
            tween(frame, quad(0.12), { BackgroundColor3 = theme.sidebar })
            tween(iconImg, quad(0.12), { ImageColor3 = theme.textDim })
            tween(lbl, quad(0.12), { TextColor3 = theme.textDim })
        end)

        navFrames[name] = { frame = frame, icon = iconImg, label = lbl, bar = bar }

        local page = new("Frame", { Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = content })
        local scroll = new("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = theme.borderHi, AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = page })
        new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll })

        local tab = setmetatable({ Name = name, Page = page, Scroll = scroll, Window = self, Theme = theme }, Lib)
        self.Tabs[name] = tab
        return tab
    end

    -- minimize & close
    function win:Minimize()
        self._min = not self._min
        tween(main, quad(0.22), { Size = self._min and UDim2.new(0, size.X.Offset, 0, 44) or size })
        if self._min then
            tween(sidebar, quad(0.16), { BackgroundTransparency = 1 })
            tween(content, quad(0.16), { BackgroundTransparency = 1 })
            tween(sidebarSt, quad(0.16), { Transparency = 1 })
            task.wait(0.16)
            sidebar.Visible = false
            content.Visible = false
        else
            sidebar.Visible = true
            content.Visible = true
            tween(sidebar, quad(0.2), { BackgroundTransparency = 0 })
            tween(content, quad(0.2), { BackgroundTransparency = 0 })
            tween(sidebarSt, quad(0.2), { Transparency = 0 })
        end
    end

    function win:Destroy()
        tween(main, quad(0.2), { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
        tween(shadow, quad(0.2), { BackgroundTransparency = 1 })
        task.wait(0.22)
        root:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)
    minBtn.MouseButton1Click:Connect(function() self:Minimize() end)

    -- drag
    do
        local dragging, ds, sp = false, nil, nil
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; ds = input.Position; sp = main.Position end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging or not sp or not ds then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local d = input.Position - ds
                main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    -- loader + reveal
    do
        local lg = new("Frame", { Size = UDim2.new(0, 260, 0, 120), Position = UDim2.new(0.5, -130, 0.5, -60), BackgroundColor3 = theme.card, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 800, Parent = root })
        corner(lg, 12)
        local lSt = stroke(lg, theme.borderHi, 1)

        local spinner = new("Frame", { Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0.5, -16, 0, 20), BackgroundColor3 = theme.accent, BorderSizePixel = 0, ZIndex = 802, Parent = lg })
        corner(spinner, 10)
        new("ImageLabel", { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0.5, -8, 0.5, -8), BackgroundTransparency = 1, Image = icon, ImageColor3 = Color3.fromRGB(255,255,255), ZIndex = 803, Parent = spinner })

        new("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 62), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "Loading", TextColor3 = theme.text, TextSize = 12, ZIndex = 802, Parent = lg })

        local barBg = new("Frame", { Size = UDim2.new(1, -48, 0, 3), Position = UDim2.new(0, 24, 0, 92), BackgroundColor3 = theme.track, BorderSizePixel = 0, ZIndex = 802, Parent = lg })
        corner(barBg, 1)
        local barFill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.accent, BorderSizePixel = 0, ZIndex = 803, Parent = barBg })
        corner(barFill, 1)

        main.Size = UDim2.new(0, 0, 0, 0)
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        sidebar.Visible = false
        content.Visible = false

        task.spawn(function()
            task.wait(0.3)
            tween(barFill, quad(0.9), { Size = UDim2.new(1, 0, 1, 0) })
            task.wait(1.0)
            tween(lg, quad(0.25), { BackgroundTransparency = 1, Size = UDim2.new(0, 200, 0, 90), Position = UDim2.new(0.5, -100, 0.5, -45) })
            tween(lSt, quad(0.25), { Transparency = 1 })
            for _, d in ipairs(lg:GetDescendants()) do
                pcall(function()
                    if d:IsA("Frame") then tween(d, quad(0.22), { BackgroundTransparency = 1 })
                    elseif d:IsA("TextLabel") then tween(d, quad(0.22), { TextTransparency = 1 })
                    elseif d:IsA("ImageLabel") then tween(d, quad(0.22), { ImageTransparency = 1 })
                    elseif d:IsA("UIStroke") then tween(d, quad(0.22), { Transparency = 1 })
                    end
                end)
            end
            task.wait(0.28)
            pcall(function() lg:Destroy() end)

            tween(main, quad(0.35), { Size = size, Position = UDim2.new(0.5, -(size.X.Offset / 2), 0.5, -(size.Y.Offset / 2)), BackgroundTransparency = 0 })
            tween(mainStroke, quad(0.4), { Transparency = 0 })
            tween(shadow, quad(0.4), { BackgroundTransparency = 0.75 })

            task.wait(0.2)
            sidebar.Visible = true
            content.Visible = true
            tween(sidebar, quad(0.3), { BackgroundTransparency = 0 })
            tween(sidebarSt, quad(0.3), { Transparency = 0 })
            tween(content, quad(0.3), { BackgroundTransparency = 0 })

            for _, c in ipairs(sideScroll:GetChildren()) do
                if c:IsA("Frame") then
                    local final = c.Position
                    c.Position = UDim2.new(final.X.Scale, final.X.Offset - 14, final.Y.Scale, final.Y.Offset)
                    c.BackgroundTransparency = 1
                    task.spawn(function() tween(c, quad(0.3), { Position = final, BackgroundTransparency = 0 }) end)
                    task.wait(0.03)
                end
            end

            if self.CurrentTab then self:ShowTab(self.CurrentTab) end
        end)
    end

    return win
end

--============================================================
-- CARD
--============================================================
function Lib:CreateCard(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Scroll
    if not parent then return end

    local card = new("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = theme.card, BackgroundTransparency = 0, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
    corner(card, 8)
    stroke(card, theme.border, 1)

    local header = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme.cardHeader, BackgroundTransparency = 0, BorderSizePixel = 0, Parent = card })
    corner(header, 8)
    new("Frame", { Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = theme.cardHeader, BorderSizePixel = 0, Parent = header })

    if cfg.Icon then
        local iw = new("Frame", { Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 12, 0.5, -10), BackgroundColor3 = theme.accentDim, BorderSizePixel = 0, Parent = header })
        corner(iw, 6)
        new("ImageLabel", { Size = UDim2.new(0, 11, 0, 11), Position = UDim2.new(0.5, -5.5, 0.5, -5.5), BackgroundTransparency = 1, Image = cfg.Icon, ImageColor3 = theme.accent, Parent = iw })
    end

    if cfg.Title then
        new("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, cfg.Icon and 40 or 14, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = cfg.Title, TextColor3 = theme.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    end

    if cfg.Toggle ~= nil then
        local sw = new("Frame", { Size = UDim2.new(0, 32, 0, 18), Position = UDim2.new(1, -44, 0.5, -9), BackgroundColor3 = cfg.Toggle and theme.accent or theme.track, BorderSizePixel = 0, Parent = header })
        corner(sw, 9)
        local kn = new("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = cfg.Toggle and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = sw })
        corner(kn, 7)
        local on = cfg.Toggle
        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = header })
        hit.MouseButton1Click:Connect(function()
            on = not on
            tween(sw, quad(0.18), { BackgroundColor3 = on and theme.accent or theme.track })
            tween(kn, quad(0.18), { Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
            if cfg.Callback then pcall(cfg.Callback, on) end
        end)
    end

    local body = new("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
    padding(body, 4, 8, 0, 0)
    new("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body })

    return setmetatable({ Frame = card, Body = body, Theme = theme }, Lib)
end

--============================================================
-- ROW HELPER
--============================================================
local function makeRow(parent, theme, label, ctrlBuilder)
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = theme.card, BackgroundTransparency = 0, BorderSizePixel = 0, Parent = parent })
    padding(row, 4, 4, 14, 14)
    new("TextLabel", { Size = UDim2.new(0.55, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = label, TextColor3 = theme.textSoft, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
    local ctrl = new("Frame", { Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1, Parent = row })
    if ctrlBuilder then ctrlBuilder(ctrl) end
    return row
end

--============================================================
-- COMPONENTS
--============================================================

function Lib:CreateToggle(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local initial = cfg.Default or false
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Toggle", function(c)
        local sw = new("Frame", { Size = UDim2.new(0, 32, 0, 18), Position = UDim2.new(1, -32, 0.5, -9), BackgroundColor3 = initial and theme.accent or theme.track, BorderSizePixel = 0, Parent = c })
        corner(sw, 9)
        local kn = new("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = initial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = sw })
        corner(kn, 7)
        local on = initial
        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = c })
        hit.MouseButton1Click:Connect(function()
            on = not on
            tween(sw, quad(0.18), { BackgroundColor3 = on and theme.accent or theme.track })
            tween(kn, quad(0.18), { Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
            if callback then pcall(callback, on) end
        end)
    end)
end

function Lib:CreateCheckbox(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local initial = cfg.Default or false
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Checkbox", function(c)
        local box = new("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -18, 0.5, -9), BackgroundColor3 = initial and theme.accent or theme.track, BorderSizePixel = 0, Parent = c })
        corner(box, 5)
        local mk = new("ImageLabel", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0.5, -5, 0.5, -5), BackgroundTransparency = 1, Image = "rbxassetid://6022668086", ImageColor3 = Color3.fromRGB(255,255,255), Visible = initial, Parent = box })
        local on = initial
        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = c })
        hit.MouseButton1Click:Connect(function()
            on = not on
            tween(box, quad(0.15), { BackgroundColor3 = on and theme.accent or theme.track })
            mk.Visible = on
            if callback then pcall(callback, on) end
        end)
    end)
end

function Lib:CreateButton(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local callback = cfg.Callback
    local style = cfg.Style or "Primary"

    makeRow(parent, theme, cfg.Name or "Button", function(c)
        local bg = style == "Primary" and theme.accent or (style == "Danger" and theme.card or theme.card)
        local txtColor = style == "Primary" and Color3.fromRGB(255,255,255) or (style == "Danger" and theme.error or theme.text)
        local btn = new("TextButton", { Size = UDim2.new(0, 90, 0, 24), Position = UDim2.new(1, -90, 0.5, -12), BackgroundColor3 = bg, Text = cfg.Text or "Run", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = txtColor, BorderSizePixel = 0, AutoButtonColor = false, Parent = c })
        corner(btn, 6)
        stroke(btn, style == "Primary" and theme.accent or theme.borderHi, 1, style == "Primary" and 0.4 or 0)

        btn.MouseEnter:Connect(function()
            if style == "Primary" then tween(btn, quad(0.15), { BackgroundColor3 = theme.accentHi })
            else tween(btn, quad(0.15), { BackgroundColor3 = theme.rowHover }) end
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, quad(0.15), { BackgroundColor3 = bg })
        end)
        btn.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
    end)
end

function Lib:CreateDropdown(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local options = cfg.Options or {}
    local default = cfg.Default or (options[1] or "—")
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Dropdown", function(c)
        local btn = new("TextButton", { Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -120, 0.5, -12), BackgroundColor3 = theme.cardHeader, Text = default, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = theme.text, BorderSizePixel = 0, AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left, Parent = c })
        corner(btn, 6)
        stroke(btn, theme.borderHi, 1)
        padding(btn, 0, 0, 10, 10)

        new("TextLabel", { Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -14, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "⌄", TextColor3 = theme.textDim, TextSize = 11, Parent = btn })

        local menu = new("Frame", { Size = UDim2.new(0, 150, 0, #options * 22 + 8), Position = UDim2.new(1, -150, 1, 4), BackgroundColor3 = theme.cardHeader, BorderSizePixel = 0, Visible = false, ZIndex = 100, Parent = btn })
        corner(menu, 6)
        stroke(menu, theme.borderHi, 1)
        padding(menu, 4)
        new("UIListLayout", { Padding = UDim.new(0, 1), Parent = menu })

        for _, opt in ipairs(options) do
            local o = new("TextButton", { Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = theme.cardHeader, Text = tostring(opt), Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = theme.textSoft, BorderSizePixel = 0, AutoButtonColor = false, Parent = menu })
            corner(o, 4)
            o.MouseEnter:Connect(function() tween(o, quad(0.1), { BackgroundColor3 = theme.rowHover, TextColor3 = theme.text }) end)
            o.MouseLeave:Connect(function() tween(o, quad(0.1), { BackgroundColor3 = theme.cardHeader, TextColor3 = theme.textSoft }) end)
            o.MouseButton1Click:Connect(function()
                btn.Text = tostring(opt)
                menu.Visible = false
                if callback then pcall(callback, opt) end
            end)
        end

        btn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)
    end)
end

function Lib:CreateSlider(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local default = cfg.Default or min
    local callback = cfg.Callback
    local decimals = cfg.Decimals or 0

    makeRow(parent, theme, cfg.Name or "Slider", function(c)
        local valL = new("TextLabel", { Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = tostring(default), TextColor3 = theme.text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, Parent = c })

        local track = new("Frame", { Size = UDim2.new(0, 80, 0, 3), Position = UDim2.new(1, -130, 0.5, -1.5), BackgroundColor3 = theme.track, BorderSizePixel = 0, Parent = c })
        corner(track, 1)
        local pct = math.clamp((default - min) / (max - min), 0, 1)
        local fill = new("Frame", { Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = theme.accent, BorderSizePixel = 0, Parent = track })
        corner(fill, 1)
        local kn = new("Frame", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(pct, -5, 0.5, -5), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = track })
        corner(kn, 5)
        stroke(kn, theme.accent, 1, 0.3)

        local dragging = false
        local hit = new("TextButton", { Size = UDim2.new(0, 80, 0, 20), Position = UDim2.new(1, -130, 0.5, -10), BackgroundTransparency = 1, Text = "", Parent = c })
        hit.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local v = min + (max - min) * rel
                if decimals == 0 then v = math.floor(v + 0.5) end
                fill.Size = UDim2.new(rel, 0, 1, 0)
                kn.Position = UDim2.new(rel, -5, 0.5, -5)
                valL.Text = tostring(v)
                if callback then pcall(callback, v) end
            end
        end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    end)
end

function Lib:CreateKeybind(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local default = cfg.Default or "F"
    local callback = cfg.Callback
    local listening = false

    makeRow(parent, theme, cfg.Name or "Keybind", function(c)
        local btn = new("TextButton", { Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(1, -80, 0.5, -12), BackgroundColor3 = theme.cardHeader, Text = default, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = theme.text, BorderSizePixel = 0, AutoButtonColor = false, Parent = c })
        corner(btn, 6)
        stroke(btn, theme.borderHi, 1)

        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if gp or not listening then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                btn.Text = input.KeyCode.Name
                listening = false
                if callback then pcall(callback, input.KeyCode.Name) end
            end
        end)
    end)
end

function Lib:CreateTextbox(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Input", function(c)
        local box = new("TextBox", { Size = UDim2.new(0, 130, 0, 24), Position = UDim2.new(1, -130, 0.5, -12), BackgroundColor3 = theme.cardHeader, Text = cfg.Default or "", PlaceholderText = cfg.Placeholder or "", PlaceholderColor3 = theme.textFaint, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = theme.text, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = c })
        corner(box, 6)
        stroke(box, theme.borderHi, 1)
        padding(box, 0, 0, 10, 10)
        if callback then box.FocusLost:Connect(function() pcall(callback, box.Text) end) end
    end)
end

function Lib:CreateLabel(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    makeRow(parent, theme, cfg.Name or "", function(c)
        new("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = cfg.Text or "", TextColor3 = cfg.Color or theme.textDim, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextWrapped = true, Parent = c })
    end)
end

function Lib:CreateDivider(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    new("Frame", { Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 0), BackgroundColor3 = theme.border, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = parent })
end

function Lib:CreateSection(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Scroll
    local lbl = new("TextLabel", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = string.upper(cfg.Name or "Section"), TextColor3 = theme.textFaint, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, Parent = parent })
    padding(lbl, 0, 2, 6, 0)
    return lbl
end

return Lib
