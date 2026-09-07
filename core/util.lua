-- ReloadUI shortcut
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = function()
    ReloadUI()
end

-- Open the vault
SLASH_VAULT_TOGGLE1 = "/gv"
SLASH_VAULT_TOGGLE2 = "/vault"

SlashCmdList["VAULT_TOGGLE"] = function()
    toggleVault()
end

function toggleVault()
    if not WeeklyRewardsFrame then
        C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
    end
    if WeeklyRewardsFrame:IsShown() then
        WeeklyRewardsFrame:Hide()
    else
        WeeklyRewardsFrame:Show()
    end
end

-- Hide screenshot text
ActionStatus:UnregisterEvent("SCREENSHOT_STARTED")
ActionStatus:UnregisterEvent("SCREENSHOT_SUCCEEDED")
ActionStatus:UnregisterEvent("SCREENSHOT_FAILED")

-- Hide micro menu popups
local function HideAlert(microButton)
    -- Only hide alerts for the PlayerSpellsMicroButton
    if microButton == PlayerSpellsMicroButton then
        MainMenuMicroButton_HideAlert(microButton)
    end
end

local function HidePulse(microButton)
    -- Only stop pulse for the PlayerSpellsMicroButton
    if microButton == PlayerSpellsMicroButton then
        MicroButtonPulseStop(microButton)
    end
end

-- Hook the alert and pulse functions securely to avoid taint
hooksecurefunc("MainMenuMicroButton_ShowAlert", HideAlert)
hooksecurefunc("MicroButtonPulse", HidePulse)

-- Hides TutorialPointerFrame
SetCVar("showTutorials", 0)