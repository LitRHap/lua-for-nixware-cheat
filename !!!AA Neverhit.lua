--Created by @zxsleebu
--Sleebu#0090
--Sleebu on YouGay (YouGame) — https://yougame.biz/members/317159/
--Sleebu on BrokenAss (BrokenCore) — https://brokencore.club/members/17432/
--Thanks fivenuss for free nixerhook sub <3

--some shit pasted from Antihit.lua

--Time spent: 11 hours

require("bit32")
local ffi = require("ffi")
local pitch = ui.add_slider_int("Pitch", "pitch", -90, 90, 90)
local yaw_offset1 = ui.add_slider_int("Yaw offset", "yaw_offset1", -180, 180, 0)
local yaw_offset2 = ui.add_slider_int("Inverted yaw offset", "yaw_offset2", -180, 180, 0)
local jitter_offset1 = ui.add_slider_int("Jitter offset", "jitter_offset1", 0, 50, 0)
local jitter_offset2 = ui.add_slider_int("Inverted jitter offset", "jitter_offset2", 0, 50, 0)
local desync1 = ui.add_slider_int("Desync delta", "desync1", 0, 58, 58)
local desync2 = ui.add_slider_int("Inverted desync delta", "desync2", 0, 58, 58)
local lby_delta = ui.add_slider_float("LBY delta", "lby_delta", 0, 180, 180)
local lby_update_period = ui.add_slider_float("LBY update time", "lby_update_period", 0.055, 0.5, 0.15)
local inverter_bind = ui.add_key_bind("Inverter", "invert_side", 0, 2)
local max_fakelag = ui.add_check_box("Maximize fakelag", "max_fakelag", false)
local jitter_desync = ui.add_multi_combo_box("Jitter desync conditions", "jitter_desync", { "Standing", "Walk", "Run", "Air", "Crouch" }, { false, false, false, false, false })
local yaw_jitter = ui.add_multi_combo_box("Yaw jitter conditions", "yaw_jitter", { "Standing", "Walk", "Run", "Air", "Crouch" }, { false, false, false, false, false })
--local no_micromoves = ui.add_check_box("Semi-LBY", "no_micromoves", false)
local left_manual = ui.add_key_bind("Manual left", "left_manual", 0, 1)
local right_manual = ui.add_key_bind("Manual right", "right_manual", 0, 1)
--local disable_manuals_if_unsafe = ui.add_check_box("Disable when unsafe", "disable_manuals_if_unsafe", true)

local m_vecVelocity = se.get_netvar("DT_BasePlayer", "m_vecVelocity[0]")
local netMoveType = se.get_netvar("DT_BaseEntity", "m_nRenderMode") + 1
local m_hActiveWeapon = se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon")
local m_fThrowTime = se.get_netvar("DT_BaseCSGrenade", "m_fThrowTime")
local m_flDuckAmount = se.get_netvar("DT_BasePlayer", "m_flDuckAmount")
local m_vecOrigin = se.get_netvar("DT_BaseEntity", "m_vecOrigin")
local m_hCarriedHostage = se.get_netvar("DT_CSPlayer", "m_hCarriedHostage")
local m_flFallVelocity = se.get_netvar("DT_BasePlayer", "m_flFallVelocity")

ffi.cdef[[
	struct WeaponInfo_t
	{
		char _0x0000[6];
		uint8_t classID;
		char _0x0007[13];
		__int32 max_clip;	
		char _0x0018[12];
		__int32 max_reserved_ammo;
		char _0x0028[96];
		char* hud_name;			
		char* weapon_name;		
		char _0x0090[60];
		__int32 type;			
	};
	struct Animstate_t
	{ 
		char pad[ 3 ];
		char m_bForceWeaponUpdate;
		char pad1[ 91 ];
		void* m_pBaseEntity;
		void* m_pActiveWeapon;
		void* m_pLastActiveWeapon;
		float m_flLastClientSideAnimationUpdateTime;
		int m_iLastClientSideAnimationUpdateFramecount;
		float m_flAnimUpdateDelta;
		float m_flEyeYaw;
		float m_flPitch;
		float m_flGoalFeetYaw;
	};
]]

local weapon_data_call = ffi.cast("int*(__thiscall*)(void*)", client.find_pattern("client.dll", "55 8B EC 81 EC ? ? ? ? 53 8B D9 56 57 8D 8B ? ? ? ? 85 C9 75 04"))

local function weapon_data(weapon)
	return ffi.cast("struct WeaponInfo_t*", weapon_data_call(ffi.cast("void*", weapon:get_address())))
end

local function get_animstate()
	local entity = entitylist.get_local_player()
	return ffi.cast("struct Animstate_t**", entity:get_address() + 0x9960)[0]
end

local function clamp_yaw(yaw)
	while yaw < -180.0 do yaw = yaw + 360.0 end
	while yaw > 180.0 do yaw = yaw - 360.0 end
	return yaw
end

local jitter_desync_inverted = false
local e_pressed = false
local jitter_side = 1
local freezetime = false
local manual_side = 0 -- 0 backwards, -1 left, 1 right
local lby_update_time = 0.0
local lby_force_choke = false

local function get_current_desync(mod_yaw)
	local animstate = get_animstate()
	return math.abs(mod_yaw - math.abs(clamp_yaw(engine.get_view_angles().yaw - animstate.m_flGoalFeetYaw))) -- CO3DAT3JIb JS REZOLVER
end

local function is_nade(lp)
	return weapon_data(entitylist.get_entity_from_handle(lp:get_prop_int(m_hActiveWeapon))).type == 0
end

local function is_throwing(lp)
	return entitylist.get_entity_from_handle(lp:get_prop_int(m_hActiveWeapon)):get_prop_float(m_fThrowTime) > 0.1
end

local function hasbit(x, p) return x % (p + p) >= p end

local function get_lby_breaker_time(fd)
	return fd and 0.4 or lby_update_period:get_value()
end

--0 for standing, 1 is walk, 2 is run, 3 air, 4 crouch
local function movement_type(lp, fd)
	local fv = lp:get_prop_float(m_flFallVelocity)
	if fv < -1 or fv > 1 then return 3 end
	if lp:get_prop_float(m_flDuckAmount) > 0.1 or fd then return 4 end
	if ui.get_key_bind("antihit_extra_slowwalk_bind"):is_active() then return 1 end
	if lp:get_prop_vector(m_vecVelocity):length() < 4 then return 0 end
	return 2
end

local function checks(cmd, lp)
	if freezetime then return true end
	local move_type = lp:get_prop_int(netMoveType)
	if move_type == 8 or move_type == 9 then return true end
	if is_nade(lp) and not is_throwing(lp) then return false end
	if is_nade(lp) and is_throwing(lp) then return true end
	if hasbit(cmd.buttons, bit32.lshift(1, 0)) then return true end
end

local function micro_move(cmd, lp)
	local move = 1.10
	if (lp:get_prop_float(m_flDuckAmount) > 0.1) then move = move * 3.0 end
	if cmd.command_number % 2 == 0 then move = -move end
	cmd.sidemove = cmd.sidemove + move
end

local function manual_aa()
	if client.is_key_clicked(left_manual:get_key()) then
		if manual_side == -1 then manual_side = 0 else manual_side = -1 end
	end
	if client.is_key_clicked(right_manual:get_key()) then
		if manual_side == 1 then manual_side = 0 else manual_side = 1 end
	end
end

local function break_lby(cmd, lby, lp, fd)
	if clientstate.get_choked_commands() >= 13 and fd then return 0 end
	if globalvars.get_current_time() >= lby_update_time then
		cmd.send_packet = false
		lby_force_choke = true
		lby_update_time = globalvars.get_current_time() + get_lby_breaker_time(fd)
        micro_move(cmd, lp)
        return lby
	end
	if lby_force_choke then
		lby_force_choke = false
		cmd.send_packet = false
	end
    return 0
end

local function main(cmd)
	local lp = entitylist.get_local_player()
	if not lp or not lp:is_alive() then return end
	if checks(cmd, lp) then return end
    cmd.viewangles.yaw = 180
	cmd.viewangles.pitch = 90
	local in_use = hasbit(cmd.buttons, bit32.lshift(1, 5))
	local is_standing = lp:get_prop_vector(m_vecVelocity):length() < 4

	--stop legit aa when planting, defusing and taking a hostage
	if in_use then
		local pos = lp:get_prop_vector(m_vecOrigin)
		local C4 = entitylist.get_entities_by_class("CPlantedC4")
		local hostages = entitylist.get_entities_by_class("CHostage")
		if  (#C4 ~= 0 and C4[1]:get_prop_vector(m_vecOrigin):dist_to(pos) <= 75) or 
			(weapon_data(entitylist.get_entity_from_handle(lp:get_prop_int(m_hActiveWeapon))).classID == 207)
		then return end
		if #hostages > 0 then
			for i = 1, #hostages do
				if hostages[i]:get_prop_vector(m_vecOrigin):dist_to(pos) <= 75 and lp:get_prop_int(m_hCarriedHostage) == -1 then return end
			end
		end
	end

	--turning off fake lag
    --doing this shit because cmd.send_packet doesn't work :c
	ui.get_check_box("antihit_fakelag_enable"):set_value(false)
    ui.get_check_box("antihit_antiaim_enable"):set_value(false)
	local fakelag_limit = ui.get_slider_int("antihit_fakelag_limit")
    local fakelag = fakelag_limit:get_value() or 1
	if fakelag == 0 then fakelag_limit:set_value(1) end
	if max_fakelag:get_value() then fakelag = 15 end
    local exploit_is_active = ui.get_key_bind("rage_active_exploit_bind"):is_active()
	local fakeduck_is_active = ui.get_key_bind("antihit_extra_fakeduck_bind"):is_active()
    if not fakeduck_is_active and not exploit_is_active then
        cmd.send_packet = (fakelag <= clientstate.get_choked_commands())
	elseif exploit_is_active and not fakeduck_is_active then cmd.send_packet = (cmd.command_number % 2 == 0) end

	--stop aa on "USE" for one tick to make picking up weapons easier
	local first_time_e_pressed = false
	if e_pressed then cmd.buttons = bit32.band(cmd.buttons, -33) end
	if e_pressed ~= in_use then first_time_e_pressed = true end
	e_pressed = in_use
	
	local inverter = inverter_bind:is_active()
	local viewangles = engine.get_view_angles()
	local yaw = viewangles.yaw - 180 + (inverter and yaw_offset2:get_value() or yaw_offset1:get_value())
	local movement = movement_type(lp, fakeduck_is_active)

	--jitter
	if yaw_jitter:get_value(movement) then
		yaw = yaw + (inverter and jitter_offset2:get_value() or jitter_offset1:get_value() * -1) * jitter_side
	end

	--jitter inverter
	if jitter_desync:get_value(movement) and not cmd.send_packet then 
		jitter_desync_inverted = not jitter_desync_inverted
		inverter = jitter_desync_inverted
	end

	--flips your yaw 180 degrees to look forward when you press E, and flip inverter to make your real appear at the same place
	if in_use then
		yaw = yaw + 180
		inverter = not inverter
	end

	--changing jitter side to make jitter... jitter!
    --btw there's 300iq move that syncs your jitter with desync jitter, so your aa will never be fucked up :D
	if not cmd.send_packet then
		if jitter_desync:get_value(movement) then jitter_side = (inverter and 1 or -1)
		else jitter_side = jitter_side * -1 end
	end

    --calculating delta
    local lby = lby_delta:get_value()
	local delta = (inverter and desync2:get_value() or desync1:get_value() * -1)
	if ((not is_standing and lby ~= 0) or lby == 0) and get_current_desync(viewangles.yaw - yaw) < math.abs(delta) then
		delta = (delta / math.abs(delta)) * 120
	end

    -- do LBY or micromove if LBY is off
    if is_standing then
        if lby ~= 0 then
            yaw = yaw + break_lby(cmd, lby, lp, fakeduck_is_active)
            delta = delta * 2
        else micro_move(cmd, lp) end
    end

	--animation desyncing process
	if not cmd.send_packet and not first_time_e_pressed then yaw = yaw - delta end

	--manual aa bind logic and manuals itself
	manual_aa()

	--i left it for another time xd

	--if disable_manuals_if_unsafe:get_value() then
	--	local pos = lp:get_player_hitbox_pos(0) --local's head position
	--	local players = entitylist.get_players(0)
	--	for i = 1, #players do
	--		local player = players[i]
	--		if not player:is_alive() or player:is_dormant() then goto skip end
	--		local attacker_pos = player:get_player_hitbox_pos(4) --we don't need big accuracy with positions to hit sideways head
	--		local trace = trace.line(0, 65536, pos, attacker_pos)
	--		print(tostring(trace.fraction .. " " .. trace.hitbox .. " " .. trace.hit_entity_index))
	--		::skip::
	--	end
	--end
	if not in_use then yaw = yaw + (90 * manual_side) end

	--send yaw and pitch to server
	cmd.viewangles.yaw = yaw
	cmd.viewangles.pitch = pitch:get_value()

	--sets our pitch to natural if pitch slider is on 0
	if in_use or pitch:get_value() == 0 then cmd.viewangles.pitch = viewangles.pitch end
end

client.register_callback("create_move", main)
client.register_callback("round_prestart", function()
    freezetime = true
    lby_update_time = get_lby_breaker_time(ui.get_key_bind("antihit_extra_fakeduck_bind"):is_active())
	manual_side = 0
end)
client.register_callback("round_freeze_end", function() freezetime = false end)