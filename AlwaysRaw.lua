local AlwaysRaw = LibStub("AceAddon-3.0"):NewAddon("AlwaysRaw", "AceConsole-3.0", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")

-- Default settings
local defaults = {
    profile = {
        RawMouseEnabled = true,
        RawMouseAccelerationDisabled = true,
        PrintEnabled = true,
    },
}

-- Options table for AceConfig
local options = {
    name = "AlwaysRaw",
    handler = AlwaysRaw,
    type = "group",
    args = {
        RawMouseEnabled = {
            type = "toggle",
            name = "Enable Raw Mouse Input",
            desc = "Enable or disable raw mouse input.",
            get = function(info) return AlwaysRaw.db.profile.RawMouseEnabled end,
            set = function(info, value) 
                AlwaysRaw.db.profile.RawMouseEnabled = value 
                AlwaysRaw:ApplySettings()
            end,
            order = 1,  -- Ensure this is the lowest number to appear first
        },
        RawMouseAccelerationDisabled = {
            type = "toggle",
            name = "Disable Mouse Acceleration",
            desc = "Enable or disable mouse acceleration.",
            get = function(info) return AlwaysRaw.db.profile.RawMouseAccelerationDisabled end,
            set = function(info, value) 
                AlwaysRaw.db.profile.RawMouseAccelerationDisabled = value 
                AlwaysRaw:ApplySettings()
            end,
            order = 2,
        },
        PrintEnabled = {
            type = "toggle",
            name = "Enable Print Output",
            desc = "Enable or disable print output.",
            get = function(info) return AlwaysRaw.db.profile.PrintEnabled end,
            set = function(info, value) 
                AlwaysRaw.db.profile.PrintEnabled = value 
                AlwaysRaw:ApplySettings()
            end,
            order = 3,
        },
    },
}

function AlwaysRaw:OnInitialize()
    self.db = AceDB:New("AlwaysRaw_Settings", defaults, true)
    AceConfig:RegisterOptionsTable("AlwaysRaw", options)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("AlwaysRaw", "AlwaysRaw")
end

function AlwaysRaw:OnEnable()
    self:RegisterEvent("PLAYER_LOGIN", "ApplySettings")
end

function AlwaysRaw:ApplySettings()
    local settings = self.db.profile
    
    -- Apply the settings to CVars
    SetCVar("rawMouseEnable", settings.RawMouseEnabled and 1 or 0)
    SetCVar("rawMouseAccelerationEnable", settings.RawMouseAccelerationDisabled and 0 or 1)
    
    -- Print confirmation if enabled
    if settings.PrintEnabled then
        self:Print("Settings applied.")
    end
end