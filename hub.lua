--============================================================
--  APEX UI  •  Modern Roblox UI Library
--  Single-file, dependency-free, animated
--============================================================

local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")

local LP = Players.LocalPlayer

--============================================================
-- UTILITIES
--============================================================
local function new(class, props)
    local ok, inst = pcall(Instance.new, class)
    if not ok or not inst then return nil end
    if props then
        for k, v in pairs(props) do pcall(function() inst[k] = v end) end
    end
    return inst
end
local function corner(p, r) if p then return new("UICorner", { CornerRadius = UDim.new(0, r or 10), Parent = p }) end end
local function stroke(p, c, t, tr)
    if not p then return nil end
    return new("UIStroke", { Color = c, Thickness = t or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p })
end
local function padding(p, t, b, l, r)
    if not p then return nil end
    t = t or 0; b = b or t; l = l or t; r = r or r or l
    return new("UIPadding", { PaddingTop = UDim.new(0,t), PaddingBottom = UDim.new(0,b), PaddingLeft = UDim.new(0,l), PaddingRight = UDim.new(0,r), Parent = p })
end
local function gradient(p, c1, c2, rot)
    return new("UIGradient", { Color = ColorSequence.new(c1, c2), Rotation = rot or 90, Parent = p })
end
local function tween(obj, info, goal)
    if obj then TweenService:Create(obj, info, goal):Play() end
end

--============================================================
-- THEMES
--============================================================
local Themes = {
    Blood = {
        windowBg   = Color3.fromRGB(9, 9, 12),
        surface    = Color3.fromRGB(14, 14, 18),
        surfaceHi  = Color3.fromRGB(19, 19, 25),
        card       = Color3.fromRGB(20, 20, 26),
        cardHi     = Color3.fromRGB(26, 26, 34),
        cardHeader = Color3.fromRGB(24, 24, 31),
        row        = Color3.fromRGB(22, 22, 28),
        rowHover   = Color3.fromRGB(32, 32, 42),
        accent     = Color3.fromRGB(235, 45, 60),
        accentHi   = Color3.fromRGB(255, 80, 95),
        accentLo   = Color3.fromRGB(160, 25, 35),
        accentSoft = Color3.fromRGB(200, 40, 55),
        accentGlow = Color3.fromRGB(255, 70, 85),
        accentDim  = Color3.fromRGB(70, 15, 22),
        success    = Color3.fromRGB(70, 200, 120),
        warning    = Color3.fromRGB(230, 180, 40),
        text       = Color3.fromRGB(248, 248, 252),
        textSoft   = Color3.fromRGB(178, 178, 192),
        textDim    = Color3.fromRGB(122, 122, 138),
        textFaint  = Color3.fromRGB(62, 62, 76),
        border     = Color3.fromRGB(28, 28, 36),
        borderHi   = Color3.fromRGB(44, 44, 58),
        track      = Color3.fromRGB(40, 40, 52),
    },
    Midnight = {
        windowBg   = Color3.fromRGB(8, 10, 16),
        surface    = Color3.fromRGB(12, 15, 22),
        surfaceHi  = Color3.fromRGB(17, 20, 30),
        card       = Color3.fromRGB(18, 21, 32),
        cardHi     = Color3.fromRGB(24, 28, 42),
        cardHeader = Color3.fromRGB(22, 25, 38),
        row        = Color3.fromRGB(20, 24, 36),
        rowHover   = Color3.fromRGB(30, 36, 52),
        accent     = Color3.fromRGB(90, 130, 255),
        accentHi   = Color3.fromRGB(130, 170, 255),
        accentLo   = Color3.fromRGB(50, 80, 200),
        accentSoft = Color3.fromRGB(70, 100, 220),
        accentGlow = Color3.fromRGB(120, 160, 255),
        accentDim  = Color3.fromRGB(20, 35, 90),
        success    = Color3.fromRGB(70, 200, 120),
        warning    = Color3.fromRGB(230, 180, 40),
        text       = Color3.fromRGB(240, 244, 255),
        textSoft   = Color3.fromRGB(170, 180, 200),
        textDim    = Color3.fromRGB(115, 125, 145),
        textFaint  = Color3.fromRGB(60, 68, 85),
        border     = Color3.fromRGB(26, 32, 48),
        borderHi   = Color3.fromRGB(42, 50, 72),
        track      = Color3.fromRGB(38, 46, 65),
    },
    Ghost = {
        windowBg   = Color3.fromRGB(245, 245, 250),
        surface    = Color3.fromRGB(235, 235, 242),
        surfaceHi  = Color3.fromRGB(228, 228, 236),
        card       = Color3.fromRGB(255, 255, 255),
        cardHi     = Color3.fromRGB(248, 248, 252),
        cardHeader = Color3.fromRGB(242, 242, 248),
        row        = Color3.fromRGB(248, 248, 252),
        rowHover   = Color3.fromRGB(240, 240, 248),
        accent     = Color3.fromRGB(120, 90, 255),
        accentHi   = Color3.fromRGB(160, 130, 255),
        accentLo   = Color3.fromRGB(80, 55, 200),
        accentSoft = Color3.fromRGB(100, 70, 230),
        accentGlow = Color3.fromRGB(150, 120, 255),
        accentDim  = Color3.fromRGB(220, 210, 255),
        success    = Color3.fromRGB(60, 180, 100),
        warning    = Color3.fromRGB(210, 160, 30),
        text       = Color3.fromRGB(30, 30, 45),
        textSoft   = Color3.fromRGB(70, 70, 90),
        textDim    = Color3.fromRGB(120, 120, 140),
        textFaint  = Color3.fromRGB(180, 180, 195),
        border     = Color3.fromRGB(220, 220, 230),
        borderHi   = Color3.fromRGB(200, 200, 215),
        track      = Color3.fromRGB(220, 220, 230),
    },
}

local Lib = {}
Lib.__index = Lib
Lib.Themes = Themes

--============================================================
-- ROOT CONTAINER
--============================================================
local function createRoot(name)
    local existing = CoreGui:FindFirstChild(name)
    if existing then existing:Destroy() end
    return new("ScreenGui", {
        Name = name,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
end

--============================================================
-- TOASTS
--============================================================
local function createToastSystem(root, theme)
    local container = new("Frame", {
        Size = UDim2.new(0, 280, 1, -100),
        Position = UDim2.new(1, -300, 0, 70),
        BackgroundTransparency = 1,
        ZIndex = 400,
        Parent = root,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = container,
    })

    local api = {}

    function api:Show(opts)
        opts = opts or {}
        local title = opts.Title or "Notice"
        local text = opts.Text or ""
        local color = opts.Color or theme.accent
        local duration = opts.Duration or 2.6

        local toast = new("Frame", {
            Size = UDim2.new(1, 0, 0, 56),
            Position = UDim2.new(1, 40, 0, 0),
            BackgroundColor3 = theme.cardHi,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 401,
            Parent = container,
        })
        corner(toast, 12)
        local st = stroke(toast, color, 1, 0.5)

        local accentBar = new("Frame", {
            Size = UDim2.new(0, 3, 1, -16),
            Position = UDim2.new(0, 0, 0, 8),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            ZIndex = 402,
            Parent = toast,
        })
        corner(accentBar, 2)

        new("TextLabel", { Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 16, 0, 8), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 402, Parent = toast })
        new("TextLabel", { Size = UDim2.new(1, -24, 0, 22), Position = UDim2.new(0, 16, 0, 26), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text, TextColor3 = theme.textSoft, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 402, Parent = toast })

        tween(toast, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) })
        task.wait(duration)
        tween(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 1, Position = UDim2.new(1, 40, 0, 0) })
        tween(st, TweenInfo.new(0.25), { Transparency = 1 })
        for _, c in ipairs(toast:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, TweenInfo.new(0.25), { TextTransparency = 1 })
            elseif c:IsA("Frame") then tween(c, TweenInfo.new(0.25), { BackgroundTransparency = 1 })
            end
        end
        task.wait(0.3)
        toast:Destroy()
    end

    return api
end

--============================================================
-- WINDOW
--============================================================
function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local themeName = cfg.Theme or "Blood"
    local theme = Themes[themeName] or Themes.Blood
    local title = cfg.Title or "APEX UI"
    local subtitle = cfg.Subtitle or ""
    local size = cfg.Size or UDim2.new(0, 840, 0, 560)
    local icon = cfg.Icon or "rbxassetid://6034684930"
    local showLoader = cfg.Loader ~= false
    local loaderText = cfg.LoaderText or "Preparing your interface..."

    local window = setmetatable({}, Lib)
    window.Theme = theme
    window.Tabs = {}
    window.CurrentTab = nil
    window._destroyed = false

    local root = createRoot("ApexUI_" .. tostring(math.random(1000, 9999)))
    window.Root = root

    -- MAIN WINDOW
    local main = new("Frame", {
        Name = "Main",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
        BackgroundColor3 = theme.windowBg,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        Parent = root,
    })
    corner(main, 18)
    local mainStroke = stroke(main, theme.borderHi, 1, 1)
    window.Main = main

    local outerGlow = new("Frame", { Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0, -15, 0, -15), BackgroundColor3 = theme.accentGlow, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = main.ZIndex - 2, Parent = main })
    corner(outerGlow, 26)
    local innerGlow = new("Frame", { Size = UDim2.new(1, 8, 1, 8), Position = UDim2.new(0, -4, 0, -4), BackgroundColor3 = theme.accentGlow, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = main.ZIndex - 1, Parent = main })
    corner(innerGlow, 20)

    -- TOP BAR
    local topBar = new("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = theme.windowBg, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main })
    corner(topBar, 18)
    window.TopBar = topBar

    local brand = new("Frame", { Size = UDim2.new(0, 240, 0, 34), Position = UDim2.new(0, 20, 0, 10), BackgroundTransparency = 1, Parent = topBar })
    local brandIconWrap = new("Frame", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 0, 0.5, -14), BackgroundColor3 = theme.accent, BorderSizePixel = 0, Parent = brand })
    corner(brandIconWrap, 9)
    gradient(brandIconWrap, theme.accentHi, theme.accentLo, 45)
    stroke(brandIconWrap, theme.accentGlow, 1, 0.6)
    new("ImageLabel", { Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0.5, -7.5, 0.5, -7.5), BackgroundTransparency = 1, Image = icon, ImageColor3 = Color3.fromRGB(255,255,255), Parent = brandIconWrap })

    new("TextLabel", { Size = UDim2.new(1, -36, 0, 16), Position = UDim2.new(0, 36, 0, 2), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = brand })
    if subtitle ~= "" then
        new("TextLabel", { Size = UDim2.new(1, -36, 0, 12), Position = UDim2.new(0, 36, 0, 18), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = subtitle, TextColor3 = theme.textFaint, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Parent = brand })
    end

    local rightControls = new("Frame", { Size = UDim2.new(0, 84, 0, 30), Position = UDim2.new(1, -96, 0, 12), BackgroundTransparency = 1, Parent = topBar })

    local closeBtn = new("ImageButton", { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 54, 0, 0), BackgroundColor3 = theme.card, BackgroundTransparency = 1, Image = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = rightControls })
    corner(closeBtn, 9)
    local closeSt = stroke(closeBtn, theme.border, 1, 1)
    local closeIcon = new("ImageLabel", { Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0.5, -6.5, 0.5, -6.5), BackgroundTransparency = 1, Image = "rbxassetid://6026568199", ImageColor3 = theme.textDim, Parent = closeBtn })

    local minimizeBtn = new("ImageButton", { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 18, 0, 0), BackgroundColor3 = theme.card, BackgroundTransparency = 1, Image = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = rightControls })
    corner(minimizeBtn, 9)
    local minSt = stroke(minimizeBtn, theme.border, 1, 1)
    local minIcon = new("ImageLabel", { Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6), BackgroundTransparency = 1, Image = "rbxassetid://6023426926", ImageColor3 = theme.textDim, Parent = minimizeBtn })

    local function wireTopBtn(btn, ic, st)
        btn.MouseEnter:Connect(function()
            tween(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0, BackgroundColor3 = theme.rowHover })
            tween(st, TweenInfo.new(0.18), { Transparency = 0 })
            tween(ic, TweenInfo.new(0.18), { ImageColor3 = theme.text })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, TweenInfo.new(0.18), { BackgroundTransparency = 1 })
            tween(st, TweenInfo.new(0.18), { Transparency = 1 })
            tween(ic, TweenInfo.new(0.18), { ImageColor3 = theme.textDim })
        end)
    end
    wireTopBtn(closeBtn, closeIcon, closeSt)
    wireTopBtn(minimizeBtn, minIcon, minSt)

    -- SIDEBAR
    local sidebar = new("Frame", { Name = "Sidebar", Size = UDim2.new(0, 210, 1, -70), Position = UDim2.new(0, 16, 0, 62), BackgroundColor3 = theme.surface, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main })
    corner(sidebar, 14)
    local sidebarStroke = stroke(sidebar, theme.border, 1, 1)
    window.Sidebar = sidebar

    local sidebarScroll = new("ScrollingFrame", { Size = UDim2.new(1, -18, 1, -20), Position = UDim2.new(0, 9, 0, 10), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = theme.accent, ScrollBarImageTransparency = 0.4, AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = sidebar })
    new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebarScroll })

    local content = new("Frame", { Name = "Content", Size = UDim2.new(1, -252, 1, -76), Position = UDim2.new(0, 236, 0, 62), BackgroundTransparency = 1, Parent = main })
    window.Content = content

    -- TOASTS
    local toastApi = createToastSystem(root, theme)
    window.Toasts = toastApi

    function window:Toast(opts)
        task.spawn(function() toastApi:Show(opts) end)
    end

    -- TAB MANAGEMENT
    local navFrames = {}

    function window:ShowTab(name)
        for n, tab in pairs(self.Tabs) do
            if tab.Page and tab.Page.Parent then
                tab.Page.Visible = (n == name)
            end
        end
        for n, b in pairs(navFrames) do
            if b and b.frame and b.frame.Parent then
                local active = (n == name)
                tween(b.frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad), { BackgroundColor3 = active and theme.card or theme.surface })
                tween(b.icon, TweenInfo.new(0.22), { ImageColor3 = active and theme.accent or theme.textFaint })
                tween(b.label, TweenInfo.new(0.22), { TextColor3 = active and theme.text or theme.textDim })
                tween(b.bar, TweenInfo.new(0.22, Enum.EasingStyle.Quad), { Size = active and UDim2.new(0, 3, 0.5, 0) or UDim2.new(0, 0, 0.5, 0), BackgroundTransparency = active and 0 or 1 })
            end
        end
        local target = self.Tabs[name]
        if target and target.Page then
            for _, child in ipairs(target.Page:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChildOfClass("UIListLayout") then
                    local final = child.Position
                    child.Position = UDim2.new(final.X.Scale, final.X.Offset + 20, final.Y.Scale, final.Y.Offset)
                    child.BackgroundTransparency = 1
                    task.spawn(function()
                        tween(child, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = final, BackgroundTransparency = 0 })
                    end)
                end
            end
        end
        self.CurrentTab = name
    end

    function window:CreateTab(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Tab"
        local iconId = cfg.Icon or "rbxassetid://6022668086"
        local section = cfg.Section

        if section then
            local found = nil
            for _, child in ipairs(sidebarScroll:GetChildren()) do
                if child:IsA("TextLabel") and child.Text == section:upper() then found = child break end
            end
            if not found then
                local lbl = new("TextLabel", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = section:upper(), TextColor3 = theme.textFaint, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, Parent = sidebarScroll })
                padding(lbl, 0, 2, 10, 0)
            end
        end

        local frame = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = theme.surface, BorderSizePixel = 0, Parent = sidebarScroll })
        corner(frame, 8)

        local bar = new("Frame", { Size = UDim2.new(0, 0, 0.5, 0), Position = UDim2.new(0, 0, 0.25, 0), BackgroundColor3 = theme.accent, BorderSizePixel = 0, BackgroundTransparency = 1, Parent = frame })
        corner(bar, 2)

        local iconImg = new("ImageLabel", { Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0, 14, 0.5, -7.5), BackgroundTransparency = 1, Image = iconId, ImageColor3 = theme.textFaint, Parent = frame })
        local label = new("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 38, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = name, TextColor3 = theme.textDim, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })

        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = frame })
        hit.MouseButton1Click:Connect(function() self:ShowTab(name) end)
        hit.MouseEnter:Connect(function()
            if self.CurrentTab == name then return end
            tween(frame, TweenInfo.new(0.15), { BackgroundColor3 = theme.card })
            tween(iconImg, TweenInfo.new(0.15), { ImageColor3 = theme.textSoft, Size = UDim2.new(0, 17, 0, 17), Position = UDim2.new(0, 13, 0.5, -8.5) })
        end)
        hit.MouseLeave:Connect(function()
            if self.CurrentTab == name then return end
            tween(frame, TweenInfo.new(0.15), { BackgroundColor3 = theme.surface })
            tween(iconImg, TweenInfo.new(0.15), { ImageColor3 = theme.textFaint, Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0, 14, 0.5, -7.5) })
        end)

        navFrames[name] = { frame = frame, icon = iconImg, label = label, bar = bar }

        local page = new("Frame", { Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = content })

        local scroll = new("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3, ScrollBarImageColor3 = theme.accent, ScrollBarImageTransparency = 0.4, AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = page })
        new("UIListLayout", { Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll })

        local tab = setmetatable({
            Name = name,
            Page = page,
            Scroll = scroll,
            Window = self,
            Theme = theme,
        }, Lib)

        self.Tabs[name] = tab

        -- SEARCH BAR (optional)
        if cfg.Search then
            self:_CreateSearchBar(scroll, cfg.Search)
        end

        return tab
    end

    function window:_CreateSearchBar(parent, cfg)
        cfg = cfg or {}
        local bar = new("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = theme.card, BackgroundTransparency = 0, BorderSizePixel = 0, Parent = parent })
        corner(bar, 12)
        stroke(bar, theme.border, 1)

        new("ImageLabel", { Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0, 16, 0.5, -7.5), BackgroundTransparency = 1, Image = "rbxassetid://6031094667", ImageColor3 = theme.textDim, Parent = bar })

        local box = new("TextBox", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 44, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "", PlaceholderText = cfg.Placeholder or "Search...", PlaceholderColor3 = theme.textFaint, TextColor3 = theme.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = bar })
        if cfg.Callback then
            box:GetPropertyChangedSignal("Text"):Connect(function()
                pcall(cfg.Callback, box.Text)
            end)
        end
        return box
    end

    -- PUBLIC BUTTONS
    function window:Minimize()
        local minimized = not self._minimized
        self._minimized = minimized
        local fs = size
        local ms = UDim2.new(0, size.X.Offset, 0, 54)
        tween(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Size = minimized and ms or fs })
        if minimized then
            tween(sidebar, TweenInfo.new(0.18), { BackgroundTransparency = 1 })
            tween(content, TweenInfo.new(0.18), { BackgroundTransparency = 1 })
            tween(sidebarStroke, TweenInfo.new(0.18), { Transparency = 1 })
            task.wait(0.18)
            sidebar.Visible = false
            content.Visible = false
        else
            sidebar.Visible = true
            content.Visible = true
            tween(sidebar, TweenInfo.new(0.22), { BackgroundTransparency = 0 })
            tween(content, TweenInfo.new(0.22), { BackgroundTransparency = 0 })
            tween(sidebarStroke, TweenInfo.new(0.22), { Transparency = 0 })
        end
    end

    function window:Destroy()
        self._destroyed = true
        tween(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 })
        task.wait(0.24)
        root:Destroy()
    end

    minimizeBtn.MouseButton1Click:Connect(function() self:Minimize() end)
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    -- DRAG
    do
        local dragging, dragStart, startPos = false, nil, nil
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging or not startPos or not dragStart then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                startPos = nil
                dragStart = nil
            end
        end)
    end

    -- LOADER
    if showLoader then
        local loaderGui = new("Frame", { Name = "Loader", Size = UDim2.new(0, 340, 0, 180), Position = UDim2.new(0.5, -170, 0.5, -90), BackgroundColor3 = theme.surfaceHi, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 500, Parent = root })
        corner(loaderGui, 18)
        local loaderStroke = stroke(loaderGui, theme.borderHi, 1)
        gradient(loaderGui, theme.cardHi, theme.card, 90)

        local loaderGlow = new("Frame", { Size = UDim2.new(0, 360, 0, 200), Position = UDim2.new(0.5, -180, 0.5, -100), BackgroundColor3 = theme.accentGlow, BackgroundTransparency = 0.93, BorderSizePixel = 0, ZIndex = 499, Parent = root })
        corner(loaderGlow, 24)

        local iconWrap = new("Frame", { Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.5, -30, 0, 22), BackgroundColor3 = theme.accent, BorderSizePixel = 0, ZIndex = 502, Parent = loaderGui })
        corner(iconWrap, 20)
        gradient(iconWrap, theme.accentHi, theme.accentLo, 45)
        stroke(iconWrap, theme.accentGlow, 1, 0.4)

        local li = new("ImageLabel", { Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0.5, -16, 0.5, -16), BackgroundTransparency = 1, Image = icon, ImageColor3 = Color3.fromRGB(255,255,255), ZIndex = 503, Parent = iconWrap })
        local lt = new("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 96), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = cfg.LoaderTitle or "LOADING", TextColor3 = theme.text, TextSize = 13, ZIndex = 502, Parent = loaderGui })
        local ls = new("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 116), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = loaderText, TextColor3 = theme.textDim, TextSize = 10, ZIndex = 502, Parent = loaderGui })

        local barBg = new("Frame", { Size = UDim2.new(1, -80, 0, 5), Position = UDim2.new(0, 40, 0, 148), BackgroundColor3 = theme.track, BorderSizePixel = 0, ZIndex = 502, Parent = loaderGui })
        corner(barBg, 3)
        local barFill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.accent, BorderSizePixel = 0, ZIndex = 503, Parent = barBg })
        corner(barFill, 3)
        gradient(barFill, theme.accentHi, theme.accentLo, 0)
        local lp = new("TextLabel", { Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 0, 158), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "0%", TextColor3 = theme.textFaint, TextSize = 9, ZIndex = 502, Parent = loaderGui })

        local running = true
        task.spawn(function()
            local rot = 0
            local sh = 0
            while running and root.Parent do
                rot = (rot + 4) % 360
                if li then pcall(function() li.Rotation = rot end) end
                sh = (sh + 0.03) % 2
                if iconWrap then pcall(function() iconWrap.BackgroundTransparency = math.abs(math.sin(sh * math.pi)) * 0.08 end) end
                RunService.RenderStepped:Wait()
            end
        end)
        task.spawn(function()
            while running and root.Parent do
                tween(loaderGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.88 })
                task.wait(1)
                tween(loaderGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.95 })
                task.wait(1)
            end
        end)

        window._loaderParts = { gui = loaderGui, glow = loaderGlow, fill = barFill, pct = lp, sub = ls, stroke = loaderStroke, running = function() return running end, stop = function() running = false end }
    end

    -- REVEAL
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundTransparency = 1
    sidebar.BackgroundTransparency = 1
    content.BackgroundTransparency = 1

    function window:_Reveal()
        if self._loaderParts then
            local P = self._loaderParts
            local stages = {
                { pct = 25, label = "Loading modules...", wait = 0.4 },
                { pct = 50, label = "Building interface...", wait = 0.4 },
                { pct = 75, label = "Animating...", wait = 0.4 },
                { pct = 100, label = "Ready.", wait = 0.3 },
            }
            for _, s in ipairs(stages) do
                task.wait(s.wait)
                if not P.running() then break end
                tween(P.fill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { Size = UDim2.new(s.pct / 100, 0, 1, 0) })
                pcall(function()
                    P.pct.Text = s.pct .. "%"
                    P.sub.Text = s.label
                end)
            end
            task.wait(0.35)
            P.stop()
            tween(P.gui, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 260, 0, 140), Position = UDim2.new(0.5, -130, 0.5, -70), BackgroundTransparency = 1 })
            tween(P.glow, TweenInfo.new(0.32), { BackgroundTransparency = 1 })
            tween(P.stroke, TweenInfo.new(0.32), { Transparency = 1 })
            for _, d in ipairs(P.gui:GetDescendants()) do
                pcall(function()
                    if d:IsA("TextLabel") then tween(d, TweenInfo.new(0.28), { TextTransparency = 1, BackgroundTransparency = 1 })
                    elseif d:IsA("ImageLabel") then tween(d, TweenInfo.new(0.28), { ImageTransparency = 1, BackgroundTransparency = 1 })
                    elseif d:IsA("Frame") then tween(d, TweenInfo.new(0.28), { BackgroundTransparency = 1 })
                    elseif d:IsA("UIStroke") then tween(d, TweenInfo.new(0.28), { Transparency = 1 })
                    elseif d:IsA("UIGradient") then tween(d, TweenInfo.new(0.28), { Transparency = NumberSequence.new(1) })
                    end
                end)
            end
            task.wait(0.35)
            pcall(function() P.gui:Destroy() end)
            pcall(function() P.glow:Destroy() end)
        end

        tween(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = size, Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2), BackgroundTransparency = 0 })
        tween(outerGlow, TweenInfo.new(0.65), { BackgroundTransparency = 0.95 })
        tween(innerGlow, TweenInfo.new(0.65), { BackgroundTransparency = 0.94 })
        tween(mainStroke, TweenInfo.new(0.65), { Transparency = 0 })

        task.wait(0.28)
        tween(sidebar, TweenInfo.new(0.35), { BackgroundTransparency = 0 })
        tween(sidebarStroke, TweenInfo.new(0.35), { Transparency = 0 })
        task.wait(0.1)
        tween(content, TweenInfo.new(0.35), { BackgroundTransparency = 0 })

        for _, child in ipairs(sidebarScroll:GetChildren()) do
            if child:IsA("Frame") then
                local final = child.Position
                child.Position = UDim2.new(final.X.Scale, final.X.Offset - 28, final.Y.Scale, final.Y.Offset)
                child.BackgroundTransparency = 1
                task.spawn(function()
                    tween(child, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = final, BackgroundTransparency = 0 })
                end)
                task.wait(0.05)
            end
        end

        task.wait(0.15)
        if self.CurrentTab then
            self:ShowTab(self.CurrentTab)
        elseif next(self.Tabs) then
            local first = next(self.Tabs)
            self:ShowTab(first)
        end
    end

    task.spawn(function() window:_Reveal() end)

    return window
end

--============================================================
-- CARD
--============================================================
function Lib:CreateCard(cfg)
    cfg = cfg or {}
    local title = cfg.Title or ""
    local icon = cfg.Icon or "rbxassetid://6022668086"
    local initialOn = cfg.Toggle
    local onToggle = cfg.Callback
    local theme = self.Theme or Themes.Blood
    local parent = cfg.Parent or self.Scroll

    if not parent then return end

    local card = new("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = theme.card, BackgroundTransparency = 0, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
    corner(card, 14)
    stroke(card, theme.border, 1)

    local header = new("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = theme.cardHeader, BackgroundTransparency = 0, BorderSizePixel = 0, Parent = card })
    corner(header, 14)
    new("Frame", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = theme.cardHeader, BorderSizePixel = 0, Parent = header })

    local iconWrap = new("Frame", { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 16, 0.5, -15), BackgroundColor3 = theme.accentDim, BorderSizePixel = 0, Parent = header })
    corner(iconWrap, 9)
    gradient(iconWrap, theme.accentDim, theme.cardHeader, 45)
    stroke(iconWrap, theme.border, 1)
    new("ImageLabel", { Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0.5, -7.5, 0.5, -7.5), BackgroundTransparency = 1, Image = icon, ImageColor3 = theme.accent, Parent = iconWrap })

    if title ~= "" then
        new("TextLabel", { Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 58, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    end

    if initialOn ~= nil then
        local switch = new("Frame", { Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -60, 0.5, -12), BackgroundColor3 = initialOn and theme.accent or theme.track, BorderSizePixel = 0, Parent = header })
        corner(switch, 12)
        if initialOn then gradient(switch, theme.accentHi, theme.accentLo, 0) end
        local knob = new("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = initialOn and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = switch })
        corner(knob, 9)
        local on = initialOn
        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = header })
        hit.MouseButton1Click:Connect(function()
            on = not on
            tween(switch, TweenInfo.new(0.28, Enum.EasingStyle.Back), { BackgroundColor3 = on and theme.accent or theme.track })
            tween(knob, TweenInfo.new(0.28, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) })
            if on and not switch:FindFirstChildOfClass("UIGradient") then
                gradient(switch, theme.accentHi, theme.accentLo, 0)
            elseif not on then
                local g = switch:FindFirstChildOfClass("UIGradient")
                if g then g:Destroy() end
            end
            if onToggle then pcall(onToggle, on) end
        end)
    end

    local body = new("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 52), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
    padding(body, 6, 12, 0, 0)
    new("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body })

    local cardObj = setmetatable({
        Frame = card,
        Body = body,
        Theme = theme,
    }, Lib)

    return cardObj
end

--============================================================
-- ROW BUILDER
--============================================================
local function makeRow(parent, theme, label, controlBuilder)
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme.card, BackgroundTransparency = 0, BorderSizePixel = 0, Parent = parent })
    padding(row, 6, 6, 20, 20)
    new("TextLabel", { Size = UDim2.new(0.55, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = label, TextColor3 = theme.textSoft, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })

    if controlBuilder then
        local ctrl = new("Frame", { Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1, Parent = row })
        controlBuilder(ctrl)
    end
    return row
end

--============================================================
-- COMPONENTS
--============================================================

-- CHECKBOX
function Lib:CreateCheckbox(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local initial = cfg.Default or false
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Checkbox", function(c)
        local box = new("Frame", { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -22, 0.5, -11), BackgroundColor3 = initial and theme.accent or theme.track, BorderSizePixel = 0, Parent = c })
        corner(box, 7)
        if initial then gradient(box, theme.accentHi, theme.accentLo, 45) end
        local mark = new("ImageLabel", { Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6), BackgroundTransparency = 1, Image = "rbxassetid://6022668086", ImageColor3 = Color3.fromRGB(255,255,255), Visible = initial, Parent = box })
        local on = initial
        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = c })
        hit.MouseButton1Click:Connect(function()
            on = not on
            tween(box, TweenInfo.new(0.22, Enum.EasingStyle.Back), { Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -26, 0.5, -13), BackgroundColor3 = on and theme.accent or theme.track })
            task.wait(0.1)
            tween(box, TweenInfo.new(0.14, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -22, 0.5, -11) })
            mark.Visible = on
            if on then
                if not box:FindFirstChildOfClass("UIGradient") then gradient(box, theme.accentHi, theme.accentLo, 45) end
            else
                local g = box:FindFirstChildOfClass("UIGradient")
                if g then g:Destroy() end
            end
            if callback then pcall(callback, on) end
        end)
        if cfg.OnCreate then pcall(cfg.OnCreate, box) end
    end)
end

-- TOGGLE (small standalone row)
function Lib:CreateToggle(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local initial = cfg.Default or false
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Toggle", function(c)
        local switch = new("Frame", { Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -44, 0.5, -12), BackgroundColor3 = initial and theme.accent or theme.track, BorderSizePixel = 0, Parent = c })
        corner(switch, 12)
        if initial then gradient(switch, theme.accentHi, theme.accentLo, 0) end
        local knob = new("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = initial and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = switch })
        corner(knob, 9)
        local on = initial
        local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = c })
        hit.MouseButton1Click:Connect(function()
            on = not on
            tween(switch, TweenInfo.new(0.28, Enum.EasingStyle.Back), { BackgroundColor3 = on and theme.accent or theme.track })
            tween(knob, TweenInfo.new(0.28, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) })
            if on and not switch:FindFirstChildOfClass("UIGradient") then
                gradient(switch, theme.accentHi, theme.accentLo, 0)
            elseif not on then
                local g = switch:FindFirstChildOfClass("UIGradient")
                if g then g:Destroy() end
            end
            if callback then pcall(callback, on) end
        end)
    end)
end

-- BUTTON
function Lib:CreateButton(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local callback = cfg.Callback
    local style = cfg.Style or "Primary" -- "Primary", "Secondary", "Danger"

    local bg = theme.accent
    if style == "Secondary" then bg = theme.row
    elseif style == "Danger" then bg = theme.row
    end

    makeRow(parent, theme, cfg.Name or "Button", function(c)
        local btn = new("TextButton", { Size = UDim2.new(0, 110, 0, 30), Position = UDim2.new(1, -110, 0.5, -15), BackgroundColor3 = bg, Text = cfg.Text or "RUN", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = (style == "Danger" and theme.accent) or Color3.fromRGB(255,255,255), BorderSizePixel = 0, AutoButtonColor = false, Parent = c })
        corner(btn, 8)
        if style == "Primary" then
            gradient(btn, theme.accentHi, theme.accentLo, 0)
            stroke(btn, theme.accentGlow, 1, 0.5)
        elseif style == "Danger" then
            stroke(btn, theme.accentDim, 1)
        else
            stroke(btn, theme.borderHi, 1)
        end

        btn.MouseEnter:Connect(function()
            tween(btn, TweenInfo.new(0.22, Enum.EasingStyle.Back), { Size = UDim2.new(0, 116, 0, 32), Position = UDim2.new(1, -116, 0.5, -16) })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 110, 0, 30), Position = UDim2.new(1, -110, 0.5, -15) })
        end)
        btn.MouseButton1Down:Connect(function()
            tween(btn, TweenInfo.new(0.08), { Size = UDim2.new(0, 106, 0, 27), Position = UDim2.new(1, -106, 0.5, -13.5) })
        end)
        btn.MouseButton1Up:Connect(function()
            tween(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.new(0, 116, 0, 32), Position = UDim2.new(1, -116, 0.5, -16) })
        end)
        btn.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
        if cfg.OnCreate then pcall(cfg.OnCreate, btn) end
    end)
end

-- DROPDOWN
function Lib:CreateDropdown(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local options = cfg.Options or {}
    local default = cfg.Default or (options[1] or "—")
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Dropdown", function(c)
        local btn = new("TextButton", { Size = UDim2.new(0, 130, 0, 30), Position = UDim2.new(1, -130, 0.5, -15), BackgroundColor3 = theme.cardHi, Text = "   " .. default, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = theme.text, BorderSizePixel = 0, AutoButtonColor = false, Parent = c })
        corner(btn, 8)
        stroke(btn, theme.borderHi, 1)
        btn.TextXAlignment = Enum.TextXAlignment.Left

        new("TextLabel", { Size = UDim2.new(0, 12, 1, 0), Position = UDim2.new(1, -18, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "⌄", TextColor3 = theme.textDim, TextSize = 12, Parent = btn })

        local menu = new("Frame", { Size = UDim2.new(0, 170, 0, #options * 26 + 10), Position = UDim2.new(1, -170, 1, 6), BackgroundColor3 = theme.cardHi, BorderSizePixel = 0, Visible = false, ZIndex = 100, Parent = btn })
        corner(menu, 10)
        stroke(menu, theme.borderHi, 1)
        padding(menu, 5)
        new("UIListLayout", { Padding = UDim.new(0, 2), Parent = menu })

        for _, opt in ipairs(options) do
            local o = new("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = theme.row, Text = tostring(opt), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = theme.textSoft, BorderSizePixel = 0, AutoButtonColor = false, Parent = menu })
            corner(o, 6)
            o.MouseEnter:Connect(function()
                tween(o, TweenInfo.new(0.14), { BackgroundColor3 = theme.rowHover, TextColor3 = theme.text })
            end)
            o.MouseLeave:Connect(function()
                tween(o, TweenInfo.new(0.14), { BackgroundColor3 = theme.row, TextColor3 = theme.textSoft })
            end)
            o.MouseButton1Click:Connect(function()
                btn.Text = "   " .. tostring(opt)
                menu.Visible = false
                if callback then pcall(callback, opt) end
            end)
        end

        btn.MouseButton1Click:Connect(function()
            menu.Visible = not menu.Visible
        end)
        if cfg.OnCreate then pcall(cfg.OnCreate, btn) end
    end)
end

-- SLIDER
function Lib:CreateSlider(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local default = cfg.Default or min
    local callback = cfg.Callback
    local decimals = cfg.Decimals or 0

    local valueLabel

    makeRow(parent, theme, cfg.Name or "Slider", function(c)
        valueLabel = new("TextLabel", { Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(1, -110, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = tostring(default), TextColor3 = theme.text, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = c })

        local track = new("Frame", { Size = UDim2.new(0, 90, 0, 4), Position = UDim2.new(1, -90, 0.5, -2), BackgroundColor3 = theme.track, BorderSizePixel = 0, Parent = c })
        corner(track, 2)
        local pct = math.clamp((default - min) / (max - min), 0, 1)
        local fill = new("Frame", { Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = theme.accent, BorderSizePixel = 0, Parent = track })
        corner(fill, 2)
        gradient(fill, theme.accentHi, theme.accentLo, 0)
        local knob = new("Frame", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(pct, -5, 0.5, -5), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = track })
        corner(knob, 5)

        local dragging = false
        local hit = new("TextButton", { Size = UDim2.new(0, 90, 0, 20), Position = UDim2.new(1, -90, 0.5, -10), BackgroundTransparency = 1, Text = "", Parent = c })
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local val = min + (max - min) * rel
                if decimals == 0 then val = math.floor(val + 0.5) end
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -5, 0.5, -5)
                valueLabel.Text = tostring(val)
                if callback then pcall(callback, val) end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end)
end

-- KEYBIND
function Lib:CreateKeybind(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local default = cfg.Default or "F"
    local callback = cfg.Callback
    local listening = false
    local currentKey = default

    makeRow(parent, theme, cfg.Name or "Keybind", function(c)
        local btn = new("TextButton", { Size = UDim2.new(0, 90, 0, 30), Position = UDim2.new(1, -90, 0.5, -15), BackgroundColor3 = theme.cardHi, Text = default, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = theme.text, BorderSizePixel = 0, AutoButtonColor = false, Parent = c })
        corner(btn, 8)
        stroke(btn, theme.borderHi, 1)

        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "Press..."
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if not listening then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode.Name
                btn.Text = currentKey
                listening = false
                if callback then pcall(callback, currentKey) end
            end
        end)
    end)
end

-- TEXTBOX
function Lib:CreateTextbox(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local callback = cfg.Callback

    makeRow(parent, theme, cfg.Name or "Textbox", function(c)
        local box = new("TextBox", { Size = UDim2.new(0, 150, 0, 30), Position = UDim2.new(1, -150, 0.5, -15), BackgroundColor3 = theme.cardHi, Text = cfg.Default or "", PlaceholderText = cfg.Placeholder or "", PlaceholderColor3 = theme.textFaint, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = theme.text, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = c })
        corner(box, 8)
        stroke(box, theme.borderHi, 1)
        padding(box, 0, 0, 10, 10)
        if callback then
            box.FocusLost:Connect(function() pcall(callback, box.Text) end)
        end
    end)
end

-- LABEL
function Lib:CreateLabel(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    makeRow(parent, theme, cfg.Name or "", function(c)
        new("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = cfg.Text or "", TextColor3 = cfg.Color or theme.textDim, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, TextWrapped = true, Parent = c })
    end)
end

-- DIVIDER
function Lib:CreateDivider(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Body
    local d = new("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = theme.border, BackgroundTransparency = 0.4, BorderSizePixel = 0, Parent = parent })
end

-- SECTION (visual heading inside a page, before a card)
function Lib:CreateSection(cfg)
    cfg = cfg or {}
    local theme = self.Theme
    local parent = cfg.Parent or self.Scroll
    local lbl = new("TextLabel", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = string.upper(cfg.Name or "Section"), TextColor3 = theme.textFaint, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, Parent = parent })
    padding(lbl, 0, 2, 4, 0)
    return lbl
end

--============================================================
-- RETURN LIBRARY
--============================================================
return Lib
