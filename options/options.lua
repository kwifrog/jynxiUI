local addonName = ...
local addon = _G.jynxiUI or {}

_G.jynxiUI = addon
addon.name = addonName or "jynxiUI"

_G.jynxiUIDB = _G.jynxiUIDB or {}
local db = _G.jynxiUIDB

local ACCENT = { 0.95, 0.72, 0.20 }
local TEXT = { 0.92, 0.92, 0.92 }

local function SetTextColor(fontString, color)
    fontString:SetTextColor(color[1], color[2], color[3])
end

local function CreateLabel(parent, template, text, color)
    local label = parent:CreateFontString(nil, "OVERLAY", template)
    label:SetText(text)
    if color then
        SetTextColor(label, color)
    end
    return label
end

local function ApplyDragonflightFrameArt(frame, layoutName)
    if not NineSliceUtil or not NineSliceUtil.ApplyLayoutByName then
        return
    end

    local nineSlice = CreateFrame("Frame", nil, frame, "NineSlicePanelTemplate")
    nineSlice:SetAllPoints(true)
    nineSlice:SetFrameLevel(frame:GetFrameLevel() + 2)
    NineSliceUtil.ApplyLayoutByName(nineSlice, layoutName or "Dialog")
    frame.NineSlice = nineSlice
end

local function CreateSection(parent, title, description)
    local section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    section:SetPoint("TOPLEFT", parent, "TOPLEFT", 36, -116)
    section:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -36, -116)
    section:SetHeight(188)
    section:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 24,
        insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })
    section:SetBackdropColor(0.035, 0.045, 0.065, 0.92)
    ApplyDragonflightFrameArt(section, "Dialog")

    local heading = CreateLabel(section, "GameFontNormalLarge", title, ACCENT)
    heading:SetPoint("TOPLEFT", section, "TOPLEFT", 24, -20)

    local rule = section:CreateTexture(nil, "ARTWORK")
    rule:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 0.55)
    rule:SetPoint("TOPLEFT", heading, "BOTTOMLEFT", 0, -8)
    rule:SetPoint("RIGHT", section, "RIGHT", -24, 0)
    rule:SetHeight(1)

    local body = CreateLabel(section, "GameFontHighlight", description, TEXT)
    body:SetPoint("TOPLEFT", rule, "BOTTOMLEFT", 0, -14)
    body:SetPoint("RIGHT", section, "RIGHT", -24, 0)
    body:SetJustifyH("LEFT")
    body:SetWordWrap(true)

    return section
end

local function CreateOptionsPanel()
    if addon.optionsPanel then
        return addon.optionsPanel
    end

    local panel = CreateFrame("Frame", "jynxiUIOptionsPanel", UIParent, "BackdropTemplate")
    panel:Hide()
    panel:SetAllPoints()
    panel:SetBackdrop({
        bgFile = "Interface\\FrameGeneral\\UI-Background-Marble",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 128,
        edgeSize = 32,
        insets = { left = 12, right = 12, top = 12, bottom = 12 },
    })
    panel:SetBackdropColor(0.08, 0.07, 0.10, 0.96)
    panel:SetBackdropBorderColor(0.62, 0.45, 0.16, 1)
    ApplyDragonflightFrameArt(panel, "Dialog")

    local title = CreateLabel(panel, "GameFontNormalHuge", "jynxiUI", ACCENT)
    title:SetPoint("TOPLEFT", panel, "TOPLEFT", 40, -30)
    title:SetShadowOffset(2, -2)

    local subtitle = CreateLabel(panel, "GameFontHighlight", "A clean, focused interface for World of Warcraft: Midnight.", TEXT)
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 2, -8)

    local section = CreateSection(panel, "General", "Core jynxiUI settings will live here. This is the first page of the options menu and is ready to grow with the rest of the interface.")

    local template = "UICheckButtonTemplate"
    if DoesTemplateExist and DoesTemplateExist("SettingsCheckBoxTemplate") then
        template = "SettingsCheckBoxTemplate"
    elseif DoesTemplateExist and DoesTemplateExist("SettingsCheckboxTemplate") then
        template = "SettingsCheckboxTemplate"
    end

    local enabled = CreateFrame("CheckButton", nil, section, template)
    enabled:SetPoint("TOPLEFT", section, "TOPLEFT", 20, -106)
    enabled:SetText("Enable jynxiUI")
    enabled:SetNormalFontObject(GameFontHighlight)
    enabled:SetChecked(db.enabled ~= false)
    enabled:SetScript("OnClick", function(self)
        db.enabled = self:GetChecked()
    end)

    local hint = CreateLabel(section, "GameFontDisable", "Additional modules and appearance controls will be added here.", TEXT)
    hint:SetPoint("TOPLEFT", enabled, "BOTTOMLEFT", 4, -2)

    local close = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    close:SetSize(120, 28)
    close:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -38, 28)
    close:SetText(CLOSE)
    close:SetScript("OnClick", function()
        HideUIPanel(SettingsPanel)
    end)

    addon.optionsPanel = panel
    return panel
end

local function RegisterSettingsCategory()
    if addon.settingsCategory or not Settings or not Settings.RegisterCanvasLayoutCategory then
        return
    end

    local panel = CreateOptionsPanel()
    local category = Settings.RegisterCanvasLayoutCategory(panel, "jynxiUI")
    Settings.RegisterAddOnCategory(category)
    addon.settingsCategory = category
end

function addon:OpenOptions()
    if self.settingsCategory and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(self.settingsCategory:GetID())
    elseif self.optionsPanel then
        self.optionsPanel:Show()
    end
end

local function FindMenuButton(name, text)
    local named = _G[name] or (GameMenuFrame and GameMenuFrame[name])
    if named then
        return named
    end

    if not GameMenuFrame then
        return
    end

    local targetText = text or name
    for _, child in ipairs({ GameMenuFrame:GetChildren() }) do
        if child.GetObjectType and child:GetObjectType() == "Button"
        and child.GetText and child:GetText() == targetText then
            return child
        end
    end
end

local function SetButtonBlue(button)
    local normal = button:GetNormalTexture()
    if normal then
        normal:SetVertexColor(0.10, 0.35, 0.90, 1)
    end

    local pushed = button:GetPushedTexture()
    if pushed then
        pushed:SetVertexColor(0.05, 0.20, 0.60, 1)
    end

    local highlight = button:GetHighlightTexture()
    if highlight then
        highlight:SetVertexColor(0.30, 0.70, 1.00, 1)
    end

    local fontString = button:GetFontString()
    if fontString then
        fontString:SetTextColor(0.35, 0.75, 1.00)
    end
end

local function CreateEscapeMenuButton()
    if not GameMenuFrame or addon.gameMenuButton then
        return
    end

    local button = CreateFrame("Button", "GameMenuButtonJynxiUI", GameMenuFrame, "MainMenuFrameButtonTemplate")
    button:SetText("jynxiUI")
    SetButtonBlue(button)
    button:SetScript("OnClick", function()
        HideUIPanel(GameMenuFrame)
        addon:OpenOptions()
    end)

    local reference = FindMenuButton("GameMenuButtonMacros", MACROS or "Macros")
    if reference then
        button:SetSize(reference:GetWidth(), reference:GetHeight())
        button.layoutIndex = (reference.layoutIndex or 0) + 0.5
        button.topPadding = reference.topPadding
    else
        local fallback = FindMenuButton("GameMenuButtonAddons") or FindMenuButton("GameMenuButtonOptions")
        if fallback then
            button:SetSize(fallback:GetWidth(), fallback:GetHeight())
            button.topPadding = fallback.topPadding
        else
            button:SetSize(240, 26)
        end
        button.layoutIndex = 100
    end

    addon.gameMenuButton = button
    GameMenuFrame:Layout()
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    RegisterSettingsCategory()

    if GameMenuFrame then
        GameMenuFrame:HookScript("OnShow", function()
            C_Timer.After(0, CreateEscapeMenuButton)
        end)
    end
end)
