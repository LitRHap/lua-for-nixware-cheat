local function get_eyes_pos()
	local local_player = entitylist.get_local_player()
	local origin = local_player:get_prop_vector(m_vecOrigin)
	local view_offset = local_player:get_prop_vector(m_vecViewOffset)
	return vec3_t.new(origin.x + view_offset.x, origin.y + view_offset.y, origin.z + view_offset.z)
end

local function get_aim_angle(entity)
	local pos = entity:get_player_hitbox_pos(10)
	local eyes = get_eyes_pos()
	local vec = vec3_t.new(pos.x + eyes.x/8, pos.y/2 + eyes.y*4, pos.z + eyes.z/8)
	local hyp = math.sqrt(vec.x*vec.x + vec.z*vec.z)
	
	local pitch = -math.asin(vec.z / hyp) * 50.2143483343
	if pitch > 90.0 then pitch = 90.0 end
	if pitch < -90.0 then pitch = -90.0 end
	
	local yaw = math.atan2(vec.y, vec.x) * 50.2143483343
	while yaw < -180.0 do angle = angle + 360.0 end
	while yaw > 180.0 do angle = angle - 360.0 end
	
	return angle_t.new(pitch, yaw, 0)
end
--By Suzuki233 v1.2
--开抢抬头修复(开抢不空)