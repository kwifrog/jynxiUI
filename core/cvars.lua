local cvars = {
    alwaysCompareItems              = "1",
    autoClearAFK                    = "1",
    autoDismount                    = "1",
    autoLootDefault                 = "1",
    autoStand                       = "1",
	autoUnshift        	            = "1",
    synchronizeBindings 	        = "1", 
	synchronizeChatFrames 	        = "1", 
	synchronizeConfig   	        = "1", 
	synchronizeMacros   	        = "1", 
	synchronizeSettings 	        = "1",
    useUiScale                      = "1",
    uiScale                         = "0.53333333333333",
    pathSmoothing      	            = "1",
    hideAdventureJournalAlerts      = "1",
    showTutorials 	                = "0",
    profanityFilter        		    = "0",
    colorChatNamesByClass  		    = "1",
    ffxGlow                         = "0", 
	ffxDeath                        = "0", 
	ffxNether                       = "1", 
	ffxLingeringVenari 	            = "1",
	ffxVenari                       = "1",
    violenceLevel      	            = "5",
    screenshotQuality  	            = "10",
    cameraDistanceMaxZoomFactor     = "2.6",

    -- ActionCam                       = "full",

    -- For custom personal resource display
    -- nameplateSelfAlpha              = "0",

}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    for cvar, value in pairs(cvars) do
        local current = tostring(GetCVar(cvar))
        if current ~= value then
            SetCVar(cvar, value)
        end
    end
end)