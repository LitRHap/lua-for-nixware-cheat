local default = ui.add_slider_int('Default deg', 'dd', 0, 60, ui.get_slider_int('antihit_antiaim_desync_length'):get_value())
local override = ui.add_slider_int('Override deg', 'overidedeg', 0, 30, 17)
local expldeg = ui.add_slider_int('Exploit deg', 'exd', 28, 60, 60)
local overkey = ui.add_key_bind('Override key', 'keyover', 0, 1)

client.register_callback("create_move", function()

    if overkey:is_active() and ui.get_key_bind('rage_active_exploit_bind'):is_active() then
        ui.get_slider_int('antihit_antiaim_desync_length'):set_value(override:get_value() + 29)
    elseif overkey:is_active() and not ui.get_key_bind('rage_active_exploit_bind'):is_active() then
        ui.get_slider_int('antihit_antiaim_desync_length'):set_value(override:get_value())
    elseif not overkey:is_active() and ui.get_key_bind('rage_active_exploit_bind'):is_active() then
        ui.get_slider_int('antihit_antiaim_desync_length'):set_value(expldeg:get_value())
    elseif not overkey:is_active() and not ui.get_key_bind('rage_active_exploit_bind'):is_active() then
        ui.get_slider_int('antihit_antiaim_desync_length'):set_value(default:get_value())
    end
end)

local leftbind = ui.add_key_bind('Left manual', 'lm', 0, 1)
local rightbind = ui.add_key_bind('Right manual', 'rm', 0, 1)
local attargkey = ui.add_key_bind('At-targets key', 'atk', 0, 2)
local side = 0

client.register_callback('create_move', function()

    left_x = leftbind:get_key()
    right_x = rightbind:get_key()

    if side == 2 and client.is_key_clicked(left_x) then
        ui.get_combo_box('antihit_antiaim_yaw'):set_value(1)
        side = 0
    end

    if side == 3 and client.is_key_clicked(right_x) then
        ui.get_combo_box('antihit_antiaim_yaw'):set_value(1)
        side = 0
    end

    if client.is_key_clicked(left_x) then
        ui.get_combo_box('antihit_antiaim_yaw'):set_value(2)
        side = 2
    end

    if client.is_key_clicked(right_x) then
        ui.get_combo_box('antihit_antiaim_yaw'):set_value(3)
        side = 3
    end

    if attargkey:is_active() then
        ui.get_check_box('antihit_antiaim_at_targets'):set_value(false)
    else
        ui.get_check_box('antihit_antiaim_at_targets'):set_value(true)
    end
end)