local lua_re_bt = ui.add_slider_float("backtrack", "lua_re_bt", 0, 0.2, 0.2)
local lua_re_bt_onxploit = ui.add_slider_float("backtrack on exploit", "lua_re_bt_onxploit", 0, 0.2, 0.2)

local function backtracking()
	if ui.get_combo_box("rage_active_exploit"):get_value() ~= 0 and ui.get_key_bind("rage_active_exploit_bind"):is_active() then 
		sv_maxunlag:set_float(lua_re_bt_onxploit:get_value())
	else
		sv_maxunlag:set_float(lua_re_bt:get_value())
	end
end
local function on_create_move(cmd)
	backtracking()
	end	
client.register_callback("create_move", on_create_move)

