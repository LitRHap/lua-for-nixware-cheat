ffi.cdef [[ struct c_color { unsigned char clr[4]; }; ]]
console_color = ffi.new("struct c_color")
console_color.clr[3] = 255
updated = false
messages = {}
messages.text = ""
messages.bg_position = 0
messages.once = true

client.register_callback(
    "shot_fired",
    function(info)
        local shot_result, shot_target, target_hitbox, shot_damage =
            info.result,
            info.target,
            info.hitbox + 1,
            info.server_damage

        if shot_result == "spread" then
            local nixware = string.format("[尼克斯软件] ")
            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 43
            console_color.clr[1] = 93
            console_color.clr[2] = 255
            console_print(engine_cvar, console_color, nixware)

            local temp_name = engine.get_player_info(shot_target:get_index()).name
            local target_name =
                string.len(temp_name) > 40 and string.lower(string.sub(temp_name, 0, 40)) .. "..." or
                string.lower(temp_name)

            local message_text = string.format("空枪了 原因:扩散 " .. " 空枪位置: " .. get_hitbox(target_hitbox))
            local nixware = string.format("[nixware.cc] ")

            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 200
            console_color.clr[1] = 0
            console_color.clr[2] = 0
            console_print(engine_cvar, console_color, message_text .. "\n")
            local A = "say " .."[尼克斯软件]" .. message_text
            engine.execute_client_cmd(A) 
        end

        if shot_result == "desync" then
            local nixware = string.format("[尼克斯软件] ")
            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 43
            console_color.clr[1] = 93
            console_color.clr[2] = 255
            console_print(engine_cvar, console_color, nixware)

            local temp_name = engine.get_player_info(shot_target:get_index()).name
            local target_name =
                string.len(temp_name) > 40 and string.lower(string.sub(temp_name, 0, 40)) .. "..." or
                string.lower(temp_name)

            local message_text = string.format("空枪了 原因:解析器 ".. " 空枪位置: " .. get_hitbox(target_hitbox))

            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 200
            console_color.clr[1] = 0
            console_color.clr[2] = 0
            console_print(engine_cvar, console_color, message_text .. "\n")
            local A = "say " .."[尼克斯软件]" ..message_text
            engine.execute_client_cmd(A)
        end

        if shot_result == "unk" then
            local nixware = string.format("[尼克斯软件] ")
            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 43
            console_color.clr[1] = 93
            console_color.clr[2] = 255
            console_print(engine_cvar, console_color, nixware)

            local temp_name = engine.get_player_info(shot_target:get_index()).name
            local target_name =
                string.len(temp_name) > 40 and string.lower(string.sub(temp_name, 0, 40)) .. "..." or
                string.lower(temp_name)

            local message_text = string.format("空枪了 原因:未知 " .. " 空枪位置: " .. get_hitbox(target_hitbox))

            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 200
            console_color.clr[1] = 0
            console_color.clr[2] = 0
            console_print(engine_cvar, console_color, message_text .. "\n")
            local A = "say " .."[尼克斯软件]" ..message_text
            engine.execute_client_cmd(A)
        end

        if shot_result == "hit" then
            local nixware = string.format("[尼克斯软件] ")
            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

            console_color.clr[0] = 43
            console_color.clr[1] = 93
            console_color.clr[2] = 255
            console_print(engine_cvar, console_color, nixware)

            message_text = string.format("打中了! %d in %s", shot_damage, get_hitbox(target_hitbox))
            console_color = ffi.new("struct c_color")
            console_color.clr[3] = 255
            engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
            console_print =
                ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])
            console_color.clr[0] = 0
            console_color.clr[1] = 200
            console_color.clr[2] = 0
            console_print(engine_cvar, console_color, message_text .. "\n")
        end
    end
)

client.register_callback(
    "fire_game_event",
    function(event)
        if event:get_name() == "player_hurt" then
            local event_player = engine.get_player_for_user_id(event:get_int("userid", -1))
            local event_attacker = engine.get_player_for_user_id(event:get_int("attacker", -1))
            local local_player = engine.get_local_player()
            local event_damage = event:get_int("dmg_health", -1)
            local event_hitbox = event:get_int("hitgroup", -1)

            if event_player == local_player then
                local nixware = string.format("[nixware.cc] ")
                console_color = ffi.new("struct c_color")
                console_color.clr[3] = 255
                engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
                console_print =
                    ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

                console_color.clr[0] = 43
                console_color.clr[1] = 93
                console_color.clr[2] = 255
                console_print(engine_cvar, console_color, nixware)

                local temp_name = engine.get_player_info(event_attacker).name
                local event_name =
                    string.len(temp_name) > 40 and string.lower(string.sub(temp_name, 0, 40)) .. "..." or
                    string.lower(temp_name)

                local message_text =
                    (temp_name == "" and "world" or event_name) ..
                    " did " ..
                        tostring(event_damage) ..
                            (temp_name == "" and " to you" or " damage in your " .. get_hitbox(event_hitbox))

                console_color = ffi.new("struct c_color")
                console_color.clr[3] = 255
                engine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
                console_print =
                    ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

                console_color.clr[0] = 200
                console_color.clr[1] = 0
                console_color.clr[2] = 0

                console_print(engine_cvar, console_color, message_text .. "\n")
            end
        end
    end
)

hitboxes = {
    "head",
    "neck",
    "pelvis",
    "belly",
    "thorax",
    "lower chest",
    "upper chest",
    "right thigh",
    "left thigh",
    "right calf",
    "left calf",
    "right foot",
    "left foot",
    "right hand",
    "left hand",
    "right upper arm",
    "right forearm",
    "left upper arm",
    "left forearm",
    "hitbox max"
}

function get_hitbox(hitbox)
    return hitboxes[hitbox]
end
