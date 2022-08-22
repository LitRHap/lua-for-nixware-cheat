local js = require('panorama')

local spam_invite 		= ui.add_check_box('Mass Invite', 'spam_invite', false)
local refresh			= ui.add_check_box('Refresh Players', 'refresh', false)
local stop_game 		= ui.add_check_box('Stop searching game', 'stop_game', false)
local spam_window 		= ui.add_check_box('Spam windows', 'spam_window', false)
local close_window 		= ui.add_check_box('Close all windows', 'close_window', false)
local spam_message 		= ui.add_check_box('Spam empty message', 'spam_message', false)
local kol_window		= ui.add_slider_int('Amount message&windows', "kol_window", 1, 250, 1)
local int_target		= ui.add_slider_int('Target (Host To Last Place)', 'int_target', 0, 4, 0)
local int_rank			= ui.add_slider_int('Rank', 'int_rank', 0, 18, 0)
local int_level			= ui.add_slider_int('Level', 'int_level', 0, 40, 0)
local int_prime			= ui.add_slider_int('Fake Prime', 'int_prime', 0, 1, 0)
local fake_profile 		= ui.add_check_box('Change Profile', 'fake_profile', false)
local rem_profile 		= ui.add_check_box('Remove Changes Profile', 'rem_profile', false)

js.eval([[
    var collectedSteamIDS = []
]])

js.eval([[
	var OnyxWaitPUpdate = null;
	function OnyxStop() {
        if (OnyxWaitPUpdate != null) {
            $.UnregisterForUnhandledEvent( 'PanoramaComponent_Lobby_PlayerUpdated', OnyxWaitPUpdate);
            OnyxWaitPUpdate = null;
        }
    }
]])

js.eval([[
	OnyxStop();
	var playerData = {
		update: {
			members: {
			}
		}
    }
    var updateMessage = "";
]])

local function refresh_nearbies()
	js.eval([[
        PartyBrowserAPI.Refresh();
        var lobbies = PartyBrowserAPI.GetResultsCount();
        for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
            var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
            var name = PartyListAPI.GetFriendName(xuid)
            if (!collectedSteamIDS.includes(xuid)) {
                collectedSteamIDS.push(xuid);
                $.Msg(`Adding ${name}(${xuid}) to the collection..`);
            }
        }
        $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);
    ]])
end

refresh_nearbies()

local function spam_windows()
	for i = 1, kol_window:get_value() do
		js.eval([[
			PartyListAPI.SessionCommand("Game::HostEndGamePlayAgain", `run all xuid ${MyPersonaAPI.GetXuid()}`); 
		]])
	end
end

local function spam_messages()
	for i = 1, kol_window:get_value() do
		js.eval([[
			PartyListAPI.SessionCommand("Game::Chat", `run all xuid ${MyPersonaAPI.GetXuid()} name ${MyPersonaAPI.GetName()} chat `); 
		]])
	end
end

local function close_windows()
	js.eval([[
		UiToolkitAPI.CloseAllVisiblePopups();
	]])
end

local function stop_games()
	js.eval([[
		LobbyAPI.StopMatchmaking();
	]])
end

local function fake_rankings()
	js.eval([[
	OnyxStop();
	var playerData = {
		update: {
			members: {
			}
		}
    }
	]])
	js.eval([[
		var machineName = "machine]].. int_target:get_value() ..[["
		if (]]..int_rank:get_value()..[[ != 0){
			updateMessage += "Update/Members/" + machineName + "/player0/game/ranking " + ]] .. int_rank:get_value() .. [[ + " ";
		}
		if (]]..int_level:get_value()..[[ != 0){
			updateMessage += "Update/Members/" + machineName + "/player0/game/level " + ]] .. int_level:get_value() .. [[ + " ";
		}
		if (]]..int_prime:get_value()..[[ != 0){
            updateMessage += "Update/Members/" + machineName + "/player0/game/prime " + ]] .. int_prime:get_value() .. [[ + " ";
        }
		PartyListAPI.UpdateSessionSettings(updateMessage);
	]])
	js.eval([[
		OnyxWaitPUpdate = $.RegisterForUnhandledEvent( "PanoramaComponent_Lobby_PlayerUpdated", function(xuid) {
               PartyListAPI.UpdateSessionSettings(updateMessage);
        });
		PartyListAPI.UpdateSessionSettings(updateMessage);
	]])
end

local function rem_profiles()
	js.eval([[
		var updateMessage = "";
		PartyListAPI.UpdateSessionSettings(updateMessage);
	]])
end

client.register_callback('paint', function ()
	if spam_invite:get_value() then
        spam_invite:set_value(false)

        js.eval([[
            collectedSteamIDS.forEach(xuid => {
                FriendsListAPI.ActionInviteFriend(xuid, "");
            });
        ]])
    end
	
	if refresh:get_value() then
        refresh:set_value(false)
        refresh_nearbies()
    end

	if spam_window:get_value() then
        spam_window:set_value(false)
        spam_windows()
    end
	
	if close_window:get_value() then
        close_window:set_value(false)
        close_windows()
    end
	
	if spam_message:get_value() then
        spam_message:set_value(false)
        spam_messages()
    end
	
	if stop_game:get_value() then
        stop_game:set_value(false)
        stop_games()
    end
	
	if fake_profile:get_value() then
		fake_profile:set_value(false)
		fake_rankings()
	end
	
	if rem_profile:get_value() then
		rem_profile:set_value(false)
		rem_profiles()
	end
end)