local trail_history_size = 1000
local trail_history = { n = trail_history_size + 1 }
local trail_state = false

local m_vecViewOffset = se.get_netvar("DT_BasePlayer", "m_vecViewOffset[0]")

local player_vtable = ffi.cast("int*", client.find_pattern("client.dll", "55 8B EC 83 E4 F8 83 EC 18 56 57 8B F9 89 7C 24 0C") + 0x47)[0]
local get_abs_origin = ffi.cast("float*(__thiscall*)(int)", ffi.cast("int*", player_vtable + 0x28)[0])
local trail_color = ui.add_color_edit("Color Pick", "trail_color", false, color_t.new(255, 0, 0, 255))

local misc_trail_enabled = ui.add_check_box("enabled", "misc_trail_enabled", false)
local misc_trail_length = ui.add_slider_int("length", "misc_trail_length", 30, 1000, 100)

function draw_trails()
	if misc_trail_enabled:get_value() == false then return end

	local local_player = entitylist.get_local_player()

	if engine.is_in_game() == false or engine.is_connected() == false or local_player:is_alive() == false then
		trail_state = false
		return
	end
	
	local abs_origin = get_abs_origin(local_player:get_address())
	local view_offset = local_player:get_prop_vector(m_vecViewOffset)
	
	local trail_start = vec3_t.new(abs_origin[0] + view_offset.x, abs_origin[1] + view_offset.y, abs_origin[2] + view_offset.z - 25)
	trail_start = vec3_t.new(trail_start.x, trail_start.y, trail_start.z-40)
	
	if misc_trail_length:get_value() ~= trail_history_size then
		trail_history_size = misc_trail_length:get_value()
		trail_state = false
	end
	
	if trail_state == false then
		for i = 1, trail_history_size + 1, 1 do
			trail_history[i] = trail_start
		end
		trail_state = true
	end
	
	trail_history[trail_history_size + 1] = trail_start
	for i = 1, trail_history_size, 1 do
		trail_history[i] = trail_history[i + 1]
	end
	
	for i = 1, trail_history_size - 1, 1 do
		local trail_pos_s = se.world_to_screen(trail_history[i])
		local trail_pos_e = se.world_to_screen(trail_history[i + 1])
                local trail_color = trail_color:get_value()
		if trail_pos_s ~= nil and trail_pos_e ~= nil then
			renderer.line(trail_pos_s, trail_pos_e, trail_color)
		end
	end
end
client.register_callback("paint", draw_trails)