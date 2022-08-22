local lua_antihit_enabled = ui.add_check_box("enable", "lua_antihit_enabled", false)
local lua_antihit_pitch = ui.add_combo_box("pitch", "lua_antihit_pitch", { "none", "down", "zero", "up" }, 0)
local lua_antihit_yaw = ui.add_slider_int("yaw", "lua_antihit_yaw", -180.0, 180.0, 0.0)

local lua_antihit_manual_left = ui.add_key_bind("manual left", "lua_antihit_manual_left", 0, 1)
local lua_antihit_manual_back = ui.add_key_bind("manual backward", "lua_antihit_manual_back", 0, 1)
local lua_antihit_manual_right = ui.add_key_bind("manual right", "lua_antihit_manual_right", 0, 1)

local lua_antihit_jitter_yaw = ui.add_slider_int("jitter", "lua_antihit_jitter_yaw", 0.0, 24.0, 0.0)
local lua_antihit_at_targets = ui.add_check_box("at targets", "lua_antihit_at_targets", false)

local lua_antihit_desync = ui.add_combo_box("desync", "lua_antihit_desync", { "none", "static", "lowdelta", "extended", "breaker", "custom" }, 0)

local lua_antihit_desync_custom_yaw = ui.add_slider_int("desync angle", "lua_antihit_desync_custom_yaw", 0.0, 120.0, 0.0)
local lua_antihit_desync_custom_yaw_inverted = ui.add_slider_int("inverted desync angle", "lua_antihit_desync_custom_yaw_inverted", 0.0, 120.0, 0.0)

local lua_antihit_flip_bind = ui.add_key_bind("switch desync side", "lua_antihit_flip_bind", 0, 2)
local lua_antihit_flip_antibrute = ui.add_check_box("anti bruteforce", "lua_antihit_flip_antibrute", false)
local lua_antihit_desync_jitter = ui.add_check_box("desync jitter", "lua_antihit_desync_jitter", false)
local lua_antihit_legiaa_bind = ui.add_key_bind("legit aa bind", "lua_antihit_legiaa_bind", 0, 1)

local lua_antihit_alternative_desync = ui.add_combo_box("alternative desync", "lua_antihit_alternative_desync", { "none", "anti bruteforce", "lowdelta" }, 0)
local lua_antihit_desync_alternative_desync_triggers = ui.add_multi_combo_box("alternative desync triggers", "lua_antihit_desync_alternative_desync_triggers", { "in move", "in slowwalk", "on exploit" }, { false, false ,false })

local lua_antihit_fakelags = ui.add_slider_int("fakelags", "lua_antihit_fakelags", 0, 12, 0)
local lua_antihit_fakelags_randomize = ui.add_slider_int("fakelags randomize", "lua_antihit_fakelags_randomize", 0, 12, 0)
local lua_antihit_fakelags_force = ui.add_key_bind("force fakelags", "lua_antihit_fakelags_force", 0, 1)
local lua_antihit_fakelags_adaptive = ui.add_check_box("adaptive fakelags", "lua_antihit_fakelags_adaptive", false)

local using_alternative_desync = false
local desync_flipped = false
local jitter_state = -1

local player_shots = {}
for i = 0, 64 do player_shots[i] = 0.0 end

local m_vecOrigin = se.get_netvar("DT_BaseEntity", "m_vecOrigin")
local m_flDuckSpeed = se.get_netvar("DT_BasePlayer", "m_flDuckSpeed");
local m_flDuckAmount = se.get_netvar("DT_BasePlayer", "m_flDuckAmount");
local m_vecVelocity = se.get_netvar("DT_BasePlayer", "m_vecVelocity[0]");
local m_bIsValveDS = se.get_netvar("DT_CSGameRulesProxy", "m_bIsValveDS")
local m_hActiveWeapon = se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon")
local m_iTeamNum = se.get_netvar("DT_BaseEntity", "m_iTeamNum")
local m_fFlags = se.get_netvar("DT_BasePlayer", "m_fFlags")
local m_flDuckAmount = se.get_netvar("DT_BasePlayer", "m_flDuckAmount")
local m_vecViewOffset = se.get_netvar("DT_BasePlayer", "m_vecViewOffset[0]")
local m_iTeamNum = se.get_netvar("DT_BaseEntity", "m_iTeamNum")
local m_iHealth = se.get_netvar("DT_BasePlayer", "m_iHealth")

local sv_maxspeed = se.get_convar("sv_maxspeed")

local antihit_extra_fakeduck_bind = ui.get_key_bind("antihit_extra_fakeduck_bind")

ffi.cdef[[
	struct WeaponInfo_t
	{
		char _0x0000[20];
		__int32 max_clip;	
		char _0x0018[12];
		__int32 max_reserved_ammo;
		char _0x0028[96];
		char* hud_name;			
		char* weapon_name;		
		char _0x0090[60];
		__int32 type;			
		__int32 price;			
		__int32 reward;			
		char _0x00D8[20];
		bool full_auto;		
		char _0x00ED[3];
		__int32 damage;			
		float armor_ratio;		 
		__int32 bullets;	
		float penetration;	
		char _0x0100[8];
		float range;			
		float range_modifier;	
		char _0x0110[16];
		bool silencer;			
		char _0x0121[15];
		float max_speed;		
		float max_speed_alt;
		char _0x0138[76];
		__int32 recoil_seed;
		char _0x0188[32];
	};
]]

local weapon_data_call = ffi.cast("int*(__thiscall*)(void*)", client.find_pattern("client.dll", "55 8B EC 81 EC 0C 01 ? ? 53 8B D9 56 57 8D 8B"));
local function weapon_data(weapon)
	return ffi.cast("struct WeaponInfo_t*", weapon_data_call(ffi.cast("void*", weapon:get_address())));
end

function hasbit(x, p) return x % (p + p) >= p end

local game_rules = ffi.cast("void***", client.find_pattern("client_panorama.dll", "8B 0D ?? ?? ?? ?? 85 C0 74 0A 8B 01 FF 50 78 83 C0 54") + 0x2)
local function is_valve_ds()
	return ffi.cast("bool*", ffi.cast("uintptr_t*", game_rules[0])[0] + m_bIsValveDS)[0]
end

function server_time()
	return (entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BasePlayer", "m_nTickBase")) * globalvars.get_interval_per_tick())
end

function can_shoot(weapon)
	return weapon:get_prop_float(se.get_netvar("DT_BaseCombatWeapon", "m_flNextPrimaryAttack")) <= server_time() and ((get_weapon_ammo( entitylist.get_local_player() ) > 0 and not get_weapon_recharge( )) or is_knife())
end

local function get_weapon_ammo(player)
	return entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon"))):get_prop_int(se.get_netvar("DT_BaseCombatWeapon", "m_iClip1"))
end
local function get_weapon_recharge()
	if not entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon"))) then
		return false
	end
	in_recharge = ffi.cast("uint32_t*", (client.find_pattern("client.dll", "C6 87 ? ? ? ? ? 8B 06 8B CE FF 90") + 2))
	is_recharging = ffi.cast("bool*", entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon"))):get_address() + in_recharge[0])
	return is_recharging[0]
end
local function is_nade()
    local weapon = entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon")))
	if weapon_data(weapon).type == 0 then
		return true
	end
	return false
end
local function is_knife()
	local weapon = entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon")))
	if weapon_data(weapon).type == 1 then
		return true
	end
	return false
end
function is_throwing()
    local active_weapon_throw_time = entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon"))):get_prop_float(se.get_netvar("DT_BaseCSGrenade", "m_fThrowTime"))
    if active_weapon_throw_time > 0.1 then 
        return true
    end
    return false
end

local function micro_move(cmd)
	local micro_move = 1.10
	
	if (entitylist.get_local_player():get_prop_float(m_flDuckAmount) > 0.1) then
	  micro_move = micro_move * 3.0
	end
	
	if cmd.command_number % 2 == 0 then
	  micro_move = -micro_move
	end
	
	cmd.sidemove = cmd.sidemove + micro_move
end

local lower_body_yaw_update_time = 0.0
local lower_body_yaw_force_choke = false
local function break_lby(cmd, desync)
	if entitylist.get_local_player():get_prop_vector(m_vecVelocity):length() > 4.0 then
		return
	end
	if globalvars.get_current_time() >= lower_body_yaw_update_time then
		cmd.send_packet = false
		if not desync_flipped then
			cmd.viewangles.yaw = cmd.viewangles.yaw + (107.0 + math.abs(desync))
		else
			cmd.viewangles.yaw = cmd.viewangles.yaw - (107.0 + math.abs(desync))
		end
		lower_body_yaw_force_choke = true
		lower_body_yaw_update_time = globalvars.get_current_time() + 0.22
		micro_move(cmd)
		return
	end
	
	if lower_body_yaw_force_choke then
		lower_body_yaw_force_choke = false
		cmd.send_packet = false
		return
	end
	
	if lower_body_yaw_force_choke then
		return
	end
end

local function dist_3d(a, b)
	return vec3_t.new(a.x - b.x, a.y - b.y, a.z - b.z):length()
end

local function angle_vectors(angles)
  local cp, sp = math.cos(angles.pitch * 0.017453292519), math.sin(angles.pitch * 0.017453292519)
  local cy, sy = math.cos(angles.yaw * 0.017453292519), math.sin(angles.yaw * 0.017453292519)
  local cr, sr = math.cos(angles.roll * 0.017453292519), math.sin(angles.roll * 0.017453292519)
  
  local forward = vec3_t.new(0, 0, 0)
  
  forward.x = cp * cy
  forward.y = cp * sy
  forward.z = -sp
  
  return forward
end

local function calc_angle(from, to)
	local vec = vec3_t.new(to.x - from.x, to.y - from.y, to.z - from.z)
	local hyp = math.sqrt(vec.x*vec.x+vec.y*vec.y)
	
	local pitch = -math.asin(vec.z / hyp) * 57.29578
	if pitch > 89.0 then pitch = 89.0 end
	if pitch < -89.0 then pitch = -89.0 end
	
	local yaw = math.atan2(vec.y, vec.x) * 57.29578
	while yaw < -180.0 do angle = angle + 360.0 end
	while yaw > 180.0 do angle = angle - 360.0 end
	
	return angle_t.new(pitch, yaw, 0)
end

local function get_projection(a, b, c)
	local length = dist_3d(b, c)
	local d = vec3_t.new(c.x - b.x, c.y - b.y, c.z - b.z)
	d = vec3_t.new(d.x / length, d.y / length, d.z / length)
	local v = vec3_t.new(a.x - b.x, a.y - b.y, a.z - b.z)
	local t = v.x * d.x + v.y * d.y + v.z * d.z
	local p = vec3_t.new(d.x * t, d.y * t, d.z * t)
	return vec3_t.new(b.x + p.x, b.y + p.y, b.z + p.z)
end

local function best_angle(cmd)
	local lowest_fov = 2147483647	
	local best_player = nil
	local local_player = entitylist.get_local_player()
	if not local_player then return -1 end
	for i = 0, 64 do
	local current_player = entitylist.get_entity_by_index(i)
		if current_player ~= nil and current_player ~= entitylist.get_local_player() and current_player:get_prop_int(m_iTeamNum) ~= local_player:get_prop_int(m_iTeamNum) and not current_player:is_dormant() then
			if not current_player or not current_player:is_alive() and not current_player:is_dormant() then
				at_targets = false
				goto continue
			end
			
			local current_angle = calc_angle(local_player:get_prop_vector(m_vecOrigin), current_player:get_prop_vector(m_vecOrigin))
			local current_fov = dist_3d(angle_vectors(current_angle), angle_vectors(engine.get_view_angles()))
			
			if current_fov < lowest_fov then
				lowest_fov = current_fov
				best_player = current_player
			end
			::continue::
		end
	end
	if best_player == nil then
		return engine.get_view_angles()
	end
	return calc_angle(local_player:get_prop_vector(m_vecOrigin), best_player:get_prop_vector(m_vecOrigin))
end

local manual_side = 0
local manual_hold = false

local function get_manual_side() -- drunk coding owns me and all
	if not manual_hold then
		if lua_antihit_manual_left:is_active() and manual_side ~= 1 then
			manual_hold = true
			manual_side = 1
		elseif lua_antihit_manual_back:is_active() and manual_side ~= 2 then
			manual_hold = true
			manual_side = 2
		elseif lua_antihit_manual_right:is_active() and manual_side ~= 3 then
			manual_hold = true
			manual_side = 3
		end
		if manual_hold then return manual_side end
		if lua_antihit_manual_left:is_active() and manual_side == 1 then
			manual_hold = true
			manual_side = 0
		elseif lua_antihit_manual_back:is_active() and manual_side == 2 then
			manual_hold = true
			manual_side = 0
		elseif lua_antihit_manual_right:is_active() and manual_side == 3 then
			manual_hold = true
			manual_side = 0
		end
	end
	if not lua_antihit_manual_left:is_active() and not lua_antihit_manual_back:is_active() and not lua_antihit_manual_right:is_active() then
		manual_hold = false
	end
	return manual_side
end

local player_vtable = ffi.cast("int*", client.find_pattern("client.dll", "55 8B EC 83 E4 F8 83 EC 18 56 57 8B F9 89 7C 24 0C") + 0x47)[0]
local get_abs_origin = ffi.cast("float*(__thiscall*)(int)", ffi.cast("int*", player_vtable + 0x28)[0])

function get_eyes_pos()
	local local_player = entitylist.get_local_player()
	if local_player == nil or not local_player:is_alive() then 
        return 0
    end
	local abs_origin = get_abs_origin(local_player:get_address())
	local view_offset = local_player:get_prop_vector(m_vecViewOffset)
	return vec3_t.new(abs_origin[0] + view_offset.x, abs_origin[1] + view_offset.y, abs_origin[2] + view_offset.z)
end

local function find_closest_point_at_angle(angle)
	local local_player = entitylist.get_local_player()
    if local_player == nil or not local_player:is_alive() then 
        return 
    end

    local trace_end = angle_vectors(angle)

    local abs_origin = get_abs_origin(local_player:get_address())	
    local view_offset = local_player:get_prop_vector(m_vecViewOffset)
    local trace_start = vec3_t.new(abs_origin[0] + view_offset.x, abs_origin[1] + view_offset.y, abs_origin[2] + view_offset.z)

    trace_end.x = trace_start.x + trace_end.x * 8192.0
    trace_end.y = trace_start.y + trace_end.y * 8192.0
    trace_end.z = trace_start.z + trace_end.z * 8192.0

    local trace_out = trace.line(engine.get_local_player(), 0x46004003, trace_start, trace_end)	
	return dist_from_camera(trace_out.endpos)
end

local desync_flipped_held = false

local function on_paint()
	manual_side = get_manual_side()
	if lua_antihit_desync:get_value() == 5 then
		lua_antihit_desync_custom_yaw:set_visible(true)
		lua_antihit_desync_custom_yaw_inverted:set_visible(true)
	else
		lua_antihit_desync_custom_yaw:set_visible(false)
		lua_antihit_desync_custom_yaw_inverted:set_visible(false)
	end
end

local freezetime = false

se.register_event("round_start")
se.register_event("round_prestart")
se.register_event("round_freeze_end")
se.register_event("bullet_impact")

function on_event(event)
	if event:get_name() == "round_prestart" then
		freezetime = true
	end
	if event:get_name() == "round_freeze_end" then
        freezetime = false
    end
    if event:get_name() == "round_start" then
    	lower_body_yaw_update_time = 0.22
    end
	if event:get_name() == "bullet_impact" then
		local entity_id = engine.get_player_for_user_id( event:get_int("userid", 0) )
		if entity_id == engine.get_local_player() then return end
		
		local entity = entitylist.get_entity_by_index(entity_id)
		
		local from = entity:get_player_hitbox_pos(0)
		local to = vec3_t.new(event:get_float("x", 0.0), event:get_float("y", 0.0), event:get_float("z", 0.0))
		
		local head = get_eyes_pos()
		local closest_point = get_projection(head, from, to)
		local dist = dist_3d(closest_point, head)
		if dist < 45 and player_shots[engine.get_player_for_user_id(event:get_int("userid", 0))] + 0.25 < globalvars.get_current_time() then
			if lua_antihit_flip_antibrute:get_value() or (lua_antihit_alternative_desync:get_value() == 1 and using_alternative_desync) then 
				desync_flipped = not desync_flipped
			end	
		end
		player_shots[engine.get_player_for_user_id(event:get_int("userid", 0))] = globalvars.get_current_time()
	end
end

ffi.cdef[[
	struct Animstate_t
	{ 
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334
    };
]]

local function get_animstate()
	local entity = entitylist.get_local_player()
    return ffi.cast("struct Animstate_t**", entity:get_address() + 0x3914)[0]
end

local function clamp_yaw(yaw)
	while yaw < -180.0 do yaw = yaw + 360.0 end
	while yaw > 180.0 do yaw = yaw - 360.0 end
	return yaw
end

local function get_current_desync(mod_yaw) --very hacky and shitty way to do it perhaps, idk, drunk coding owns
	local animstate = get_animstate()
	return math.abs(mod_yaw - math.abs(clamp_yaw(engine.get_view_angles().yaw - animstate.m_flGoalFeetYaw)))
end

local function on_create_move(cmd)
	if not lua_antihit_enabled:get_value() then return end
	if freezetime then return end
	local local_player = entitylist.get_local_player()
	if bit32.band(local_player:get_prop_int(m_fFlags), 64) ~= 0 then return end --if halftime or game ended
	local velocity = local_player:get_prop_vector(m_vecVelocity)

	local fakelags = lua_antihit_fakelags:get_value()
	if lua_antihit_fakelags_adaptive:get_value() then fakelags = lua_antihit_fakelags:get_value() * ( velocity:length() / sv_maxspeed:get_int() ) end
	fakelags = fakelags + math.random(lua_antihit_fakelags_randomize:get_value())
	if lua_antihit_fakelags_force:is_active() then fakelags = 12 end
	if fakelags > 12 then fakelags = 12 end
	if is_valve_ds() and fakelags > 6 then fakelags = 6 end
	if fakelags < 2 and lua_antihit_desync:get_value() ~= 0 then  --minimum required fake lags for desync to work
		fakelags = 2
	end
	if fakelags > 2 and ui.get_combo_box("rage_active_exploit"):get_value() ~= 0 and ui.get_key_bind("rage_active_exploit_bind"):is_active() then fakelags = 1 end
	
	local active_weapon_handle = local_player:get_prop_int(m_hActiveWeapon)
	local active_weapon = entitylist.get_entity_from_handle(active_weapon_handle)
	local move_type = local_player:get_prop_int(se.get_netvar("DT_BaseEntity", "m_nRenderMode") + 1) 
	if move_type == 0 or move_type == 8 or move_type == 9 then return end
	if is_nade() and is_throwing() and not is_knife() then return end
	if (hasbit(cmd.buttons, 1) or (hasbit(cmd.buttons, 2048) and is_knife())) and can_shoot(active_weapon) then return end
    if not lua_antihit_legiaa_bind:is_active() and hasbit(cmd.buttons, 32) then return end

	if not antihit_extra_fakeduck_bind:is_active() then -- disable fakelags when using fakeduck
		if fakelags <= clientstate.get_choked_commands() then
			cmd.send_packet = true
		else
			cmd.send_packet = false
		end
	end

	local pitch_type = lua_antihit_pitch:get_value()
	if pitch_type == 0 then
	elseif pitch_type == 1 then
		cmd.viewangles.pitch = 89.0
	elseif pitch_type == 2 then
		cmd.viewangles.pitch = 0.0
	elseif pitch_type == 3 then
		cmd.viewangles.pitch = -89.0
	end
	
	cmd.viewangles.yaw = engine.get_view_angles().yaw - lua_antihit_yaw:get_value()
	if lua_antihit_at_targets:get_value() then
		cmd.viewangles.yaw = best_angle(cmd).yaw - lua_antihit_yaw:get_value()
	end
	
	if manual_side == 1 then cmd.viewangles.yaw = engine.get_view_angles().yaw - 270.0 end
	if manual_side == 2 then cmd.viewangles.yaw = engine.get_view_angles().yaw - 180.0 end
	if manual_side == 3 then cmd.viewangles.yaw = engine.get_view_angles().yaw - 90.0 end
	
	cmd.viewangles.yaw = cmd.viewangles.yaw - lua_antihit_jitter_yaw:get_value() * jitter_state
	if cmd.send_packet then
		jitter_state = jitter_state * -1
		if lua_antihit_desync_jitter:get_value() then
			desync_flipped = not desync_flipped
		end
	end
	
	if lua_antihit_legiaa_bind:is_active() then cmd.viewangles = engine.get_view_angles() end
	
	local desync_type = lua_antihit_desync:get_value()
	
	using_alternative_desync = false
	if lua_antihit_desync_alternative_desync_triggers:get_value(0) and velocity:length() > 130 then 
		desync_type = lua_antihit_alternative_desync:get_value() 
		using_alternative_desync = true
	end
	if lua_antihit_desync_alternative_desync_triggers:get_value(1) and velocity:length() > 10 and velocity:length() <= 130 then 
		desync_type = lua_antihit_alternative_desync:get_value() 
		using_alternative_desync = true
	end
	if lua_antihit_desync_alternative_desync_triggers:get_value(2) and ui.get_combo_box("rage_active_exploit"):get_value() ~= 0 and ui.get_key_bind("rage_active_exploit_bind"):is_active() then 
		desync_type = lua_antihit_alternative_desync:get_value()
		using_alternative_desync = true
	end
	
	local mod_yaw = engine.get_view_angles().yaw - cmd.viewangles.yaw
	
	local desync_switched = desync_flipped
	if lua_antihit_flip_bind:is_active() then
		desync_switched = not desync_switched
	end
	
	if desync_type == 1 or desync_type == 2 then
		local desync_value = 58.0
		micro_move(cmd)
		if desync_switched then
			desync_value = -desync_value
		end
		if get_current_desync(mod_yaw) < math.abs(desync_value) then -- allow fast desync switch
			desync_value = (desync_value / math.abs(desync_value)) * 120 -- side * 120
		end
		if desync_type == 2 then desync_value = 22.0 end
		if not cmd.send_packet then
		  cmd.viewangles.yaw = cmd.viewangles.yaw - desync_value
		end
	elseif desync_type == 3 or desync_type == 4 then
		local desync_value = 120.0
		if desync_type == 4 then desync_value = 58.0 end
		break_lby(cmd, desync_value)
		if desync_switched then
			desync_value = -desync_value
		end
		if not cmd.send_packet then
		  cmd.viewangles.yaw = cmd.viewangles.yaw - desync_value
		end
	elseif desync_type == 0 then
		return
	else
		local desync_value = 0
		if not desync_switched then
			desync_value = lua_antihit_desync_custom_yaw:get_value()
		else
			desync_value = -lua_antihit_desync_custom_yaw_inverted:get_value()
		end
		if math.abs(desync_value) > 58.0 then
			break_lby(cmd, desync_value)
		elseif math.abs(desync_value) == 58.0 then
			if get_current_desync(mod_yaw) < math.abs(desync_value) then -- allow fast desync switch
				desync_value = (desync_value / math.abs(desync_value)) * 120 -- side * 120
			end
			micro_move(cmd)
		else
			micro_move(cmd)
		end
		if not cmd.send_packet then
			cmd.viewangles.yaw = cmd.viewangles.yaw - desync_value
		end
	end
end

client.register_callback("paint", on_paint)
client.register_callback("fire_game_event", on_event)
client.register_callback("create_move", on_create_move)