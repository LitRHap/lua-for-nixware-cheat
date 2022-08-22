menu.add_check_box("Enable Resolver")

local memory = {}
for i = 0,64 do
    memory[i] = {
        last_speed = 0,
        last_speed2 = 0,
        last_hit_yaw = 0,
        last_miss_yaw = 0,
        last_miss_yaw2 = 0,
        current_yaw = 30,
    }
end

function start_resolver()
    if menu.get_bool("Enable Resolver") == false then return end
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    for i = 0, globals.get_maxclients() do
        menu.set_bool("player_list.player_settings[" .. tostring(i) .. "].force_body_yaw", true)
        menu.set_int("player_list.player_settings[" .. tostring(i) .. "].body_yaw", math.random(-60, 60))
    end
end

client.add_callback("on_createmove", start_resolver)