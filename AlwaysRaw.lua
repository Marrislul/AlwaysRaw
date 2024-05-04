-- Event handling frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")

-- Initialize global settings variable
_G.AlwaysRaw_Settings = _G.AlwaysRaw_Settings or { RawMouseEnabled = true, RawMouseAccelerationDisabled = true, PrintEnabled = true }

-- Function to update the checkboxes based on the loaded settings
local function updateCheckboxes()
    AlwaysRawRawMouseCheckBox:SetChecked(_G.AlwaysRaw_Settings.RawMouseEnabled)
    AlwaysRawMouseAccelerationCheckBox:SetChecked(_G.AlwaysRaw_Settings.RawMouseAccelerationDisabled)
    AlwaysRawPrintCheckBox:SetChecked(_G.AlwaysRaw_Settings.PrintEnabled)
end

-- Function to load and apply settings based on the current configuration
local function loadSettings()
    -- Apply the settings to CVars
    SetCVar("rawMouseEnable", _G.AlwaysRaw_Settings.RawMouseEnabled and 1 or 0)
    SetCVar("rawMouseAccelerationEnable", _G.AlwaysRaw_Settings.RawMouseAccelerationDisabled and 0 or 1)
    if _G.AlwaysRaw_Settings.PrintEnabled then
        print("AlwaysRaw: Settings applied.")
    end
end

-- Function to create the options panel
local function createOptionsPanel()
    local panel = CreateFrame("Frame", "AlwaysRawPanel")
    panel.name = "AlwaysRaw"
    InterfaceOptions_AddCategory(panel)

    -- Title for the options panel
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("AlwaysRaw Settings")

    local checkBoxPrint = CreateFrame("CheckButton", "AlwaysRawPrintCheckBox", panel, "UICheckButtonTemplate")
    checkBoxPrint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    checkBoxPrint:SetScript("OnClick", function(self)
        _G.AlwaysRaw_Settings.PrintEnabled = self:GetChecked()
        loadSettings()  -- Update settings immediately
    end)
    checkBoxPrint:SetChecked(_G.AlwaysRaw_Settings.PrintEnabled)
    checkBoxPrint.text = checkBoxPrint:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    checkBoxPrint.text:SetPoint("LEFT", checkBoxPrint, "RIGHT", 8, 0)
    checkBoxPrint.text:SetText("Enable Print Output")

    local checkBoxRawMouse = CreateFrame("CheckButton", "AlwaysRawRawMouseCheckBox", panel, "UICheckButtonTemplate")
    checkBoxRawMouse:SetPoint("TOPLEFT", checkBoxPrint, "BOTTOMLEFT", 0, -8)
    checkBoxRawMouse:SetScript("OnClick", function(self)
        _G.AlwaysRaw_Settings.RawMouseEnabled = self:GetChecked()
        loadSettings()  -- Update settings immediately
    end)
    checkBoxRawMouse:SetChecked(_G.AlwaysRaw_Settings.RawMouseEnabled)
    checkBoxRawMouse.text = checkBoxRawMouse:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    checkBoxRawMouse.text:SetPoint("LEFT", checkBoxRawMouse, "RIGHT", 8, 0)
    checkBoxRawMouse.text:SetText("Enable Raw Mouse Input")

    local checkBoxMouseAccel = CreateFrame("CheckButton", "AlwaysRawMouseAccelerationCheckBox", panel, "UICheckButtonTemplate")
    checkBoxMouseAccel:SetPoint("TOPLEFT", checkBoxRawMouse, "BOTTOMLEFT", 0, -8)
    checkBoxMouseAccel:SetScript("OnClick", function(self)
        _G.AlwaysRaw_Settings.RawMouseAccelerationDisabled = self:GetChecked()
        loadSettings()  -- Update settings immediately
    end)
    checkBoxMouseAccel:SetChecked(_G.AlwaysRaw_Settings.RawMouseAccelerationDisabled)
    checkBoxMouseAccel.text = checkBoxMouseAccel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    checkBoxMouseAccel.text:SetPoint("LEFT", checkBoxMouseAccel, "RIGHT", 8, 0)
    checkBoxMouseAccel.text:SetText("Disable Mouse Acceleration")
end

-- Create the options panel as soon as the addon is loaded
local optionsPanel = createOptionsPanel()

-- Event handling function
frame:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == "AlwaysRaw" then
        updateCheckboxes()  -- Update checkboxes after loading settings
    elseif event == "PLAYER_LOGIN" then
        updateCheckboxes()  -- Update checkboxes after loading settings
        loadSettings()  -- Load settings on login
    elseif event == "PLAYER_LOGOUT" then
        -- Settings are automatically saved by WoW
    end
end)