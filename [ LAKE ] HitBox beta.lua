local hitbox = ui.add_key_bind('HitBox', 'hitbox_key', 0, 1)
local hitbox_type = ui.add_combo_box("HitBox Type", "hitbox_type", { "head", "chest", "pelvis", "stomach", "legs", "foot" }, 0)

local function on_create_move()	
    local override = {
        HitBox = { hitbox:is_active(), hitbox_type:get_value() },
    }

    local entities = entitylist.get_players(0)

    for i = 1, #entities do
        local index = entities[i]:get_index()

        if override.HitBox[1] then
            for i = 0, 5 do
                ragebot.override_hitscan(index, i, override.HitBox[2] == i)
            end
        end
    end
end

client.register_callback('create_move', on_create_move)