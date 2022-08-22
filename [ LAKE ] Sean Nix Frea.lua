-- updater: StalkeRR
-- modified by Fla1337
local text = "抱歉，你被BinGaan Nix GK击杀，加群免费摸参975979625，BinGaan nix拥有Sean.lua umpire lua双授权，助你在官匹大杀四方，暴打无脑摇头小朋友"

function Killsay(event)
    local attacker_index = engine.get_player_for_user_id(event:get_int("attacker",0))
    local died_index = engine.get_player_for_user_id(event:get_int("userid",1))
    local me = engine.get_local_player()   
    local died_info = engine.get_player_info(died_index)
    local died_name = died_info.name

    if attacker_index == me and died_index ~= me then
        engine.execute_client_cmd("say " .. text)
    end
end

client.register_callback("player_death",Killsay)