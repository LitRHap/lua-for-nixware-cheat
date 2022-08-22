local old_counter = 20
local counter = 20

local thidperson_bind = ui.add_key_bind("Thirdperson bind", "thirdperson_bind", 0, 2)

ui.get_key_bind("visuals_other_thirdperson_bind"):set_key(0x00)
ui.get_key_bind("visuals_other_thirdperson_bind"):set_type(0)
ui.get_check_box("visuals_other_thirdperson"):set_value(false)
ui.get_check_box("visuals_other_force_thirdperson"):set_value(false)

client.register_callback("frame_stage_notify", function(stage) 
	if thidperson_bind:is_active() then

		if counter ~= 150 then
		 	counter = counter + 2
		end

	else

		if counter ~= 20 then
			counter = counter - 2
	   end

	end
	
	if old_counter ~= counter then
		engine.execute_client_cmd("cam_idealdist " .. counter .. "")
		old_counter = counter
	end

	if counter >= 40 then
		ui.get_check_box("visuals_other_thirdperson"):set_value(true)
		ui.get_check_box("visuals_other_force_thirdperson"):set_value(true)
	else
		ui.get_check_box("visuals_other_thirdperson"):set_value(false)
		ui.get_check_box("visuals_other_force_thirdperson"):set_value(false)
	end
end)

local function on_unload()
	engine.execute_client_cmd("cam_idealdist 150")
end

local legbreaker = ui.add_check_box("Leg Breaker", "legbreaker", false)

local ffi = require 'ffi'

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
]]

local ENTITY_LIST_POINTER = ffi.cast("void***", se.create_interface("client.dll", "VClientEntityList003")) or error("Failed to find VClientEntityList003!")
local GET_CLIENT_ENTITY_FN = ffi.cast("GetClientEntity_4242425_t", ENTITY_LIST_POINTER[0][3])

local ffi_helper = {
    get_animstate_offset = function()
        return 14612
    end,

    get_entity_address = function(entity_index)
        local addr = GET_CLIENT_ENTITY_FN(ENTITY_LIST_POINTER, entity_index)
        return addr
    end
}

local function on_create_move(cmd) 
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    ffi.cast("float*", ffi_helper.get_entity_address(localplayer:get_index()) + 10100)[0] = 0
end

local function leg_breaker(cmd)  
    if switch then
        switch = false
    else
         switch = true
    end

    if switch then
        local antiaim_active_movement_type = ui.get_combo_box("antihit_extra_leg_movement"):set_value(1)
    else
        local antiaim_active_movement_type = ui.get_combo_box("antihit_extra_leg_movement"):set_value(2)
    end
end




client.register_callback("fire_game_event", function(event)

	if event:get_name() == "round_start" then
    	is_round_started = true
    end

    if event:get_name() == "round_prestart" then
		is_round_started = true
	end

	if event:get_name() == "round_freeze_end" then
        is_round_started = false
    end

end)

client.register_callback("create_move", function(cmd)
	
	if is_round_started then
		buy_bot( )
		is_round_started = false
	end

end)

is_round_started = false

pistols_list = {
	["0"] = "",
	["1"] = "buy glock; buy hkp2000; buy usp_silencer;",
	["2"] = "buy elite;",
	["3"] = "buy p250;",
	["4"] = "buy tec9; buy fiveseven;",
	["5"] = "buy deagle; buy revolver;",
}

pistols_name_list = {

	"None",
	"Glock-18/HKP2000/USP-S",
	"Dual Berretas",
	"P250",
	"Tec-9/Five7",
	"Deagle/Revolver"

}

weapons_list = {
	["0"] = "",
	["1"] = "buy ssg08;",
	["2"] = "buy awp;",
	["3"] = "buy scar20; buy g3sg1;",
	["4"] = "buy galilar; buy famas;",
	["5"] = "buy ak47; buy m4a1; buy m4a1_silencer;",
	["6"] = "buy sg556; buy aug;",
	["7"] = "buy nova;",
	["8"] = "buy xm1014;",
	["9"] = "buy mag7;",
	["10"] = "buy m249;",
	["11"] = "buy negev;",
	["12"] = "buy mac10; buy mp9;",
	["13"] = "buy mp7;",
	["14"] = "buy ump45;",
	["15"] = "buy p90;",
	["16"] = "buy bizon;"
}

weapons_name_list = {

	"None",
	"SSG08",
	"AWP",
	"Scar20/G3SG1",
	"GalilAR/Famas",
	"AK-47/M4A1",
	"AUG/SG556",
	"Nova",
	"XM1014",
	"Mag-7",
	"M249",
	"Negev",
	"Mac-10/MP9",
	"MP7",
	"UMP-45",
	"P90",
	"Bizon"

}

other_list = {
	["0"] = "buy vesthelm;",
	["1"] = "buy hegrenade;",
	["2"] = "buy molotov; buy incgrenade;",
	["3"] = "buy smokegrenade;",
	["4"] = "buy taser;",
	["5"] = "buy defuser;"
}

other_name_list = {

	"Armor",
	"HE",
	"Molotov/Incgrenade",
	"Smoke",
	"Taser",
	"Defuser"

}

function buy_bot( )

	local pistol = pistols_list[tostring(buy_pistol:get_value(""))]
	local weapon = weapons_list[tostring(buy_weapon:get_value(""))]
	local other  = ""

	for i = 0, 5 do
		other = other..(buy_other:get_value(i) and other_list[tostring(i)] or "")
	end

	engine.execute_client_cmd(pistol)
	engine.execute_client_cmd(weapon)
	engine.execute_client_cmd(other)

end

buy_pistol = ui.add_combo_box("Pistol", "_pistols", pistols_name_list, 0)
buy_weapon = ui.add_combo_box("Weapon", "_weapons", weapons_name_list, 0)
buy_other = ui.add_multi_combo_box("Other", "_other", other_name_list, { false, false, false, false, false, false })


local ffi = require 'ffi'

local matrix_color = ui.add_color_edit('color', 'vis_matrixonshot_color', true, color_t.new(255, 255, 255, 130))
local duration = ui.add_slider_float('duration', 'vis_matrixonshot_duration', 0.1, 10.0, 2)

ffi.cdef[[
    typedef unsigned char byte;

    typedef struct
    {
        float x,y,z;
    } Vector;

    typedef struct
    {
        void*   fnHandle;               //0x0000
        char    szName[260];            //0x0004
        int nLoadFlags;             //0x0108
        int nServerCount;           //0x010C
        int type;                   //0x0110
        int flags;                  //0x0114
        Vector  vecMins;                //0x0118
        Vector  vecMaxs;                //0x0124
        float   radius;                 //0x0130
        char    pad[28];              //0x0134
    } model_t;
    
    typedef struct
    {
        int     m_bone;                 // 0x0000
        int     m_group;                // 0x0004
        Vector  m_mins;                 // 0x0008
        Vector  m_maxs;                 // 0x0014
        int     m_name_id;                // 0x0020
        Vector  m_angle;                // 0x0024
        float   m_radius;               // 0x0030
        int        pad2[4];
    } mstudiobbox_t;
    
    typedef struct
    {
        int sznameindex;
    
        int numhitboxes;
        int hitboxindex;
    } mstudiohitboxset_t;
    
    typedef struct
    {
        int id;                     //0x0000
        int version;                //0x0004
        long    checksum;               //0x0008
        char    szName[64];             //0x000C
        int length;                 //0x004C
        Vector  vecEyePos;              //0x0050
        Vector  vecIllumPos;            //0x005C
        Vector  vecHullMin;             //0x0068
        Vector  vecHullMax;             //0x0074
        Vector  vecBBMin;               //0x0080
        Vector  vecBBMax;               //0x008C
        int pad[5];
        int numhitboxsets;          //0x00AC
        int hitboxsetindex;         //0x00B0
    } studiohdr_t;
    
    typedef struct
    {
        float m_flMatVal[3][4];
    } matrix3x4_t;
    
    typedef struct
    {
        matrix3x4_t test[128];
    } matrix3x4_t2;
    
    typedef struct
    {
        unsigned memory;
        char pad[8];
        unsigned int count;
        unsigned pelements;
    } CUtlVectorSimple;
]]

local pHitboxSet = function(i, stdmdl)
    if i < 0 or i > stdmdl.numhitboxsets then return nil end
    return ffi.cast("mstudiohitboxset_t*", ffi.cast("byte*", stdmdl) + stdmdl.hitboxsetindex) + i
end

local pHitbox = function(i, stdmdl)
    if i > stdmdl.numhitboxes then return nil end
    return ffi.cast("mstudiobbox_t*", ffi.cast("byte*", stdmdl) + stdmdl.hitboxindex) + i
end

local DotProduct = function(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z
end

local VectorTransform = function(in1, in2)
    return ffi.new("Vector", {
        DotProduct(in1, vec3_t.new(in2[0][0], in2[0][1], in2[0][2])) + in2[0][3],
        DotProduct(in1, vec3_t.new(in2[1][0], in2[1][1], in2[1][2])) + in2[1][3],
        DotProduct(in1, vec3_t.new(in2[2][0], in2[2][1], in2[2][2])) + in2[2][3]
    })
end

local DEG2RAD = function(x)
    return x * (math.pi / 180)
end

local RAD2DEG = function(x)
    return x * (180 / math.pi)
end

local AngleMatrix = function(angles)
    local sr, sp, sy, cr, cp, cy
    
    sy = math.sin(DEG2RAD(angles.y))
    cy = math.cos(DEG2RAD(angles.y))
    
    sp = math.sin(DEG2RAD(angles.x))
    cp = math.cos(DEG2RAD(angles.x))
    
    sr = math.sin(DEG2RAD(angles.z))
    cr = math.sin(DEG2RAD(angles.z))
    
    local matrix = ffi.new("matrix3x4_t").m_flMatVal
    
    matrix[0][0] = cp * cy
    matrix[1][0] = cp * sy
    matrix[2][0] = -sp
    
    local crcy = cr * cy;
    local crsy = cr * sy;
    local srcy = sr * cy;
    local srsy = sr * sy;
    
    matrix[0][1] = sp * srcy - crsy;
    matrix[1][1] = sp * srsy + crcy;
    matrix[2][1] = sr * cp;
 
    matrix[0][2] = sp * crcy + srsy;
    matrix[1][2] = sp * crsy - srcy;
    matrix[2][2] = cr * cp;
 
    matrix[0][3] = 0.0
    matrix[1][3] = 0.0
    matrix[2][3] = 0.0
    
    return matrix
end

local ConcatTransforms = function(in1, in2)
    local out = ffi.new("matrix3x4_t").m_flMatVal
    
    out[ 0 ][ 0 ] = in1[ 0 ][ 0 ] * in2[ 0 ][ 0 ] + in1[ 0 ][ 1 ] * in2[ 1 ][ 0 ] + in1[ 0 ][ 2 ] * in2[ 2 ][ 0 ];
    out[ 0 ][ 1 ] = in1[ 0 ][ 0 ] * in2[ 0 ][ 1 ] + in1[ 0 ][ 1 ] * in2[ 1 ][ 1 ] + in1[ 0 ][ 2 ] * in2[ 2 ][ 1 ];
    out[ 0 ][ 2 ] = in1[ 0 ][ 0 ] * in2[ 0 ][ 2 ] + in1[ 0 ][ 1 ] * in2[ 1 ][ 2 ] + in1[ 0 ][ 2 ] * in2[ 2 ][ 2 ];
    out[ 0 ][ 3 ] = in1[ 0 ][ 0 ] * in2[ 0 ][ 3 ] + in1[ 0 ][ 1 ] * in2[ 1 ][ 3 ] + in1[ 0 ][ 2 ] * in2[ 2 ][ 3 ] + in1[ 0 ][ 3 ];

    out[ 1 ][ 0 ] = in1[ 1 ][ 0 ] * in2[ 0 ][ 0 ] + in1[ 1 ][ 1 ] * in2[ 1 ][ 0 ] + in1[ 1 ][ 2 ] * in2[ 2 ][ 0 ];
    out[ 1 ][ 1 ] = in1[ 1 ][ 0 ] * in2[ 0 ][ 1 ] + in1[ 1 ][ 1 ] * in2[ 1 ][ 1 ] + in1[ 1 ][ 2 ] * in2[ 2 ][ 1 ];
    out[ 1 ][ 2 ] = in1[ 1 ][ 0 ] * in2[ 0 ][ 2 ] + in1[ 1 ][ 1 ] * in2[ 1 ][ 2 ] + in1[ 1 ][ 2 ] * in2[ 2 ][ 2 ];
    out[ 1 ][ 3 ] = in1[ 1 ][ 0 ] * in2[ 0 ][ 3 ] + in1[ 1 ][ 1 ] * in2[ 1 ][ 3 ] + in1[ 1 ][ 2 ] * in2[ 2 ][ 3 ] + in1[ 1 ][ 3 ];

    out[ 2 ][ 0 ] = in1[ 2 ][ 0 ] * in2[ 0 ][ 0 ] + in1[ 2 ][ 1 ] * in2[ 1 ][ 0 ] + in1[ 2 ][ 2 ] * in2[ 2 ][ 0 ];
    out[ 2 ][ 1 ] = in1[ 2 ][ 0 ] * in2[ 0 ][ 1 ] + in1[ 2 ][ 1 ] * in2[ 1 ][ 1 ] + in1[ 2 ][ 2 ] * in2[ 2 ][ 1 ];
    out[ 2 ][ 2 ] = in1[ 2 ][ 0 ] * in2[ 0 ][ 2 ] + in1[ 2 ][ 1 ] * in2[ 1 ][ 2 ] + in1[ 2 ][ 2 ] * in2[ 2 ][ 2 ];
    out[ 2 ][ 3 ] = in1[ 2 ][ 0 ] * in2[ 0 ][ 3 ] + in1[ 2 ][ 1 ] * in2[ 1 ][ 3 ] + in1[ 2 ][ 2 ] * in2[ 2 ][ 3 ] + in1[ 2 ][ 3 ];
    
    return out
end

local MatrixAngles = function(matrix)
    local forward, left, up
    
    local angles = ffi.new("Vector")
    
    forward = vec3_t.new( matrix[ 0 ][ 0 ], matrix[ 1 ][ 0 ], matrix[ 2 ][ 0 ] )
    left = vec3_t.new( matrix[ 0 ][ 1 ], matrix[ 1 ][ 1 ], matrix[ 2 ][ 1 ] )
    up = vec3_t.new( 0, 0, 0 )
    
    local len = math.sqrt(forward.x^2+forward.y^2)
    
    if len > 0.001 then
        angles.x = RAD2DEG( math.atan2( -forward.z, len ) )
        angles.y = RAD2DEG( math.atan2( forward.y, forward.x ) )
        angles.z = RAD2DEG( math.atan2( left.z, up.z ) )
    else
        angles.x = RAD2DEG( math.atan2( -forward.z, len ) )
        angles.y = RAD2DEG( math.atan2( -left.x, left.y ) )
        angles.z = 0
    end
    
    return angles
end

local MatrixOrigin = function(matrix)
    return ffi.new("Vector", {
        matrix[0][3],
        matrix[1][3],
        matrix[2][3]
    })
end

local DebugOverlay = ffi.cast(ffi.typeof("void***"), se.create_interface("engine.dll", "VDebugOverlay004"))
local AddBoxOverlay = ffi.cast("void(__thiscall*)(void*, Vector&, Vector&, Vector&, Vector&, int, int, int, int, float)", DebugOverlay[0][1])
local AddCapsuleOverlay = ffi.cast(ffi.typeof("void(__thiscall*)(void*, Vector&, Vector&, float&, int, int, int, int, float, int, int)"), DebugOverlay[0][23])

local ModelInfo = ffi.cast(ffi.typeof("void***"), se.create_interface("engine.dll", "VModelInfoClient004"))
local GetStudioModel = ffi.cast(ffi.typeof("studiohdr_t*(__thiscall*)(void*, model_t*)"), ModelInfo[0][32])

local ClientEntityList = ffi.cast(ffi.typeof("void***"), se.create_interface("client.dll", "VClientEntityList003"))
local GetClientEntity = ffi.cast(ffi.typeof("unsigned long(__thiscall*)(void*, int)"), ClientEntityList[0][3])

local matrix_data = { }

local AddMatrix = function(index, r, g, b, a, duration, hitgroup)
    if index == engine.get_local_player() then return end
    
    local ClientRenderable = ffi.cast(ffi.typeof("void***"), GetClientEntity(ClientEntityList, index) + 0x4)
    local GetModel = ffi.cast(ffi.typeof("model_t*(__thiscall*)(void*)"), ClientRenderable[0][8])

    local matrix = ffi.cast("matrix3x4_t2*", ffi.cast("CUtlVectorSimple*", ffi.cast("unsigned long", GetClientEntity(ClientEntityList, index)) + 0x2910).memory)

    if not matrix then return end

    local model = GetModel(ClientRenderable)

    if not model then return end

    local hdr = GetStudioModel(ModelInfo, model)

    if not hdr then return end
            
    local set = pHitboxSet(entitylist.get_entity_by_index(index):get_prop_int(se.get_netvar("CBasePlayer", "m_nHitboxSet")), hdr)

    if not set then return end

    for i=0, set.numhitboxes - 1 do
        local bbox = pHitbox(i, set)
        
        if not bbox then goto continue end
        
        if bbox.m_radius == -1 then
            local rot_matrix = AngleMatrix(bbox.m_angle)
                    
            local matrix_out = ConcatTransforms(matrix[0].test[bbox.m_bone].m_flMatVal, rot_matrix)
                    
            local bbox_angles = MatrixAngles(matrix_out)
                    
            local origin = MatrixOrigin(matrix_out)
            
            AddBoxOverlay(DebugOverlay, origin, bbox.m_mins, bbox.m_maxs, bbox_angles, r, g, b, 0, duration)
        else
            local mins = VectorTransform(bbox.m_mins, matrix[0].test[bbox.m_bone].m_flMatVal)
            local maxs = VectorTransform(bbox.m_maxs, matrix[0].test[bbox.m_bone].m_flMatVal)
            
            AddCapsuleOverlay(DebugOverlay, mins, maxs, ffi.new("float[1]", bbox.m_radius), hitgroup == bbox.m_group and 255 or r, hitgroup == bbox.m_group and 0 or g, hitgroup == bbox.m_group and 0 or b, a, duration, 0, 1)
        end
            
        ::continue::
    end
end

local function to_rgba(color)
    return color.r, color.g, color.b, color.a
end

local staticleg = ui.add_check_box("Static leg in air", "staticleg", false)

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;

    typedef struct
    {
        char        pad0[0x60]; // 0x00
        void*       pEntity; // 0x60
        void*       pActiveWeapon; // 0x64
        void*       pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char        pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        Vector_t    vecOrigin; // 0xB0
        Vector_t    vecLastOrigin;// 0xBC
        Vector_t    vecVelocity; // 0xC8
        Vector_t    vecVelocityNormalized; // 0xD4
        Vector_t    vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char        pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char        pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char        pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;
]]

local entity_list_ptr = ffi.cast("void***", se.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntity_4242425_t", entity_list_ptr[0][3])

local ffi_helpers = {
    get_entity_address = function(ent_index)
        local addr = get_client_entity_fn(entity_list_ptr, ent_index)
        return addr
    end
}

local shared_onground




client.register_callback("paint", function()
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    local m_fFlags = se.get_netvar("DT_BasePlayer", "m_fFlags")

    local bOnGround = bit.band(localplayer:get_prop_float(m_fFlags), bit.lshift(1,0)) ~= 0
    if not bOnGround then
        ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi_helpers.get_entity_address(localplayer:get_index()) + 14612)[0].flDurationInAir = 99
        ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi_helpers.get_entity_address(localplayer:get_index()) + 14612)[0].flHitGroundCycle = 0
        ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi_helpers.get_entity_address(localplayer:get_index()) + 14612)[0].bHitGroundAnimation = false
    end

    shared_onground = bOnGround
end)
client.register_callback("paint", function()
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end

    local m_fFlags = se.get_netvar("DT_BasePlayer", "m_fFlags")

    local bOnGround = bit.band(localplayer:get_prop_float(m_fFlags), bit.lshift(1,0)) ~= 0
    if bOnGround and not shared_onground then 
        ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi_helpers.get_entity_address(localplayer:get_index()) + 14612)[0].flDurationInAir = 0.5 
    end -- ACT_CSGO_LAND_LIGHT
end)
client.register_callback('fire_game_event', function (e)
    if e:get_name() == 'player_hurt' then
        local attacker_idx = engine.get_player_for_user_id(e:get_int("attacker", 0))
        local victim_idx = engine.get_player_for_user_id(e:get_int("userid", 0))

        local r, g, b, a = to_rgba(matrix_color:get_value())

        if attacker_idx == engine.get_local_player() then
            AddMatrix(victim_idx, r, g, b, a, duration:get_value(), e:get_int("hitgroup", 0))
        end
    end
end)
client.register_callback("create_move", on_create_move)
client.register_callback("create_move", leg_breaker)
client.register_callback("unload", on_unload)