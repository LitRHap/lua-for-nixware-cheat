local screensize = engine.get_screen_size()
local world_to_screen = se.world_to_screen
local render_line = renderer.line
local render_filled_polygon = renderer.filled_polygon
local vec3_t_new = vec3_t.new
local cos = math.cos
local sin = math.sin

-- ui
local primary_color = ui.add_color_edit('primary color', 'ch_primcolor', true, color_t.new(255, 255, 255, 120))
local border_color = ui.add_color_edit('border color', 'ch_bordcolor', true, color_t.new(255, 255, 255, 255))

-- nix ui
local thirdperson = ui.get_check_box('visuals_other_thirdperson')
local thirdperson_bind = ui.get_key_bind('visuals_other_thirdperson_bind')

-- a lot of hacks here
local function draw_hat(from, pos, radius, segments, color)
    local points = {from}
    local last_point = nil

    local step = 6.2831853071795862 / segments
    for a = 0, 6.2831853071795862, step do
        local start = world_to_screen(vec3_t_new(radius * cos(a) + pos.x, radius * sin(a) + pos.y, pos.z))
        local endp = world_to_screen(vec3_t_new(radius * cos(a + step) + pos.x, radius * sin(a + step) + pos.y, pos.z))

        if start and endp then
            render_line(start, endp, color)      
            points[#points+1] = start  
            last_point = endp
        end
    end

    if last_point then
        points[#points+1] = last_point
        render_filled_polygon(points, primary_color:get_value())
    end
end


local function on_paint()
    local lp = entitylist.get_local_player()
    if not lp or not lp:is_alive() then
        return
    end

    if not thirdperson:get_value() or not thirdperson_bind:is_active() then
        return
    end

    local head_pos = lp:get_player_hitbox_pos(0)

    local high_pos = vec3_t_new(head_pos.x, head_pos.y, head_pos.z+8)
    local low_pos = vec3_t_new(head_pos.x, head_pos.y, head_pos.z)

    local w2s = world_to_screen(high_pos)
    if w2s then
        draw_hat(w2s, low_pos, 10, 75, border_color:get_value())
    end
end


client.register_callback('paint', on_paint)