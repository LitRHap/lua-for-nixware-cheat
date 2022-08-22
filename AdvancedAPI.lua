-- Script version
ADVANCED_API_VERSION = 1.5;

-- Netvars
m_fFlags = se.get_netvar("DT_BasePlayer", "m_fFlags");
m_iHealth = se.get_netvar("DT_BasePlayer", "m_iHealth");
m_iTeamNum = se.get_netvar("DT_BaseEntity", "m_iTeamNum");
m_hActiveWeapon = se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon");
m_vecOrigin = se.get_netvar("DT_BaseEntity", "m_vecOrigin");
m_angEyeAngles = se.get_netvar("DT_CSPlayer", "m_angEyeAngles");
m_flSimulationTime = se.get_netvar("DT_BaseEntity", "m_flSimulationTime");
m_flOldSimulationTime = m_flSimulationTime + 0x4;
m_iAccount = se.get_netvar("DT_CSPlayer", "m_iAccount");
m_bBombTicking = se.get_netvar("DT_PlantedC4", "m_bBombTicking")
m_flC4Blow = se.get_netvar("DT_PlantedC4", "m_flC4Blow")
m_nBombSite = se.get_netvar("DT_PlantedC4", "m_nBombSite")
m_lifeState = se.get_netvar("DT_BasePlayer", "m_lifeState");
m_bPinPulled = se.get_netvar("DT_BaseCSGrenade", "m_bPinPulled");
m_fThrowTime = se.get_netvar("DT_BaseCSGrenade", "m_fThrowTime");
m_flLowerBodyYawTarget = se.get_netvar("DT_CSPlayer", "m_flLowerBodyYawTarget");
m_bGunGameImmunity = se.get_netvar("DT_CSPlayer", "m_bGunGameImmunity");
m_flFlashDuration = se.get_netvar("DT_CSPlayer", "m_flFlashDuration");
m_bIsScoped = se.get_netvar("DT_CSPlayer", "m_bIsScoped");
m_flNextAttack = se.get_netvar("DT_BaseCombatCharacter", "m_flNextAttack");
m_zoomLevel = se.get_netvar("DT_WeaponCSBaseGun", "m_zoomLevel");
m_Collision = se.get_netvar("DT_BaseEntity", "m_Collision");
m_flDuckSpeed = se.get_netvar("DT_BasePlayer", "m_flDuckSpeed");
m_flDuckAmount = se.get_netvar("DT_BasePlayer", "m_flDuckAmount");
m_iClip1 = se.get_netvar("DT_BaseCombatWeapon", "m_iClip1");
m_iClip2 = se.get_netvar("DT_BaseCombatWeapon", "m_iClip2");
m_fAccuracyPenalty = se.get_netvar("DT_WeaponCSBase", "m_fAccuracyPenalty");
m_flPostponeFireReadyTime = se.get_netvar("DT_WeaponCSBase", "m_flPostponeFireReadyTime");
m_flNextPrimaryAttack = 0x3238;  -- se.get_netvar("DT_BaseCombatWeapon", "LocalActiveWeaponData", "m_flNextPrimaryAttack");
m_iItemDefinitionIndex = 0x2FAA; -- se.get_netvar("DT_BaseAttributableItem", "m_AttributeManager", "m_Item", "m_iItemDefinitionIndex");
m_vecViewOffset = 0x108;
m_nTickBase = 0x3430; -- se.get_netvar("DT_BasePlayer", "localdata", "m_nTickBase");
m_MoveType = 0x25C;
m_aimPunchAngle = 0x302C;
m_flNextSecondaryAttack = 0x323C; -- se.get_netvar("DT_BaseCombatWeapon", "LocalActiveWeaponData", "m_flNextSecondaryAttack");
m_iShotsFired = 0xA390; -- se.get_netvar("DT_CSPlayer", "cslocaldata", "m_iShotsFired");
m_vecVelocity = {
    [0] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[0]"),
    [1] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[1]"),
	[2] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[2]")
};

-- C definitions
local C = ffi.C;
ffi.cdef[[
	typedef void* FARPROC;
	typedef void* HMODULE;
	typedef const char* LPCSTR;
	typedef wchar_t WCHAR;
	typedef const WCHAR* LPCWSTR;
	FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);
	HMODULE GetModuleHandleA(LPCSTR lpModuleName);

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

	typedef struct { 
		float x,y,z; 
	} vec3_t; 
	
	struct CBaseAnimState
	{
		void* pThis;
		char pad2[91];
		void* pBaseEntity; 
		void* pActiveWeapon; 
		void* pLastActiveWeapon; 
		float m_flLastClientSideAnimationUpdateTime; 
		int m_iLastClientSideAnimationUpdateFramecount; 
		float m_flEyePitch; 
		float m_flEyeYaw; 
		float m_flPitch; 
		float m_flGoalFeetYaw; 
		float m_flCurrentFeetYaw;
		float m_flCurrentTorsoYaw; 
		float m_flUnknownVelocityLean;
		float m_flLeanAmount; 
		char pad4[4];
		float m_flFeetCycle;
		float m_flFeetYawRate;
		float m_fUnknown2;
		float m_fDuckAmount; 
		float m_fLandingDuckAdditiveSomething; 
		float m_fUnknown3;
		vec3_t m_vOrigin;
		vec3_t m_vLastOrigin; 
		float m_vVelocityX; 
		float m_vVelocityY;
		char pad5[4];
		float m_flUnknownFloat1;
		char pad6[8];
		float m_flUnknownFloat2;
		float m_flUnknownFloat3; 
		float m_flUnknown; 
		float speed_2d; 
		float flUpVelocity; 
		float m_flSpeedNormalized; 
		float m_flFeetSpeedForwardsOrSideWays; 
		float m_flFeetSpeedUnknownForwardOrSideways;
		float m_flTimeSinceStartedMoving; 
		float m_flTimeSinceStoppedMoving;
		unsigned char m_bOnGround; 
		unsigned char m_bInHitGroundAnimation;
		char pad7[10];
		float m_flLastOriginZ; 
		float m_flHeadHeightOrOffsetFromHittingGroundAnimation; 
		float m_flStopToFullRunningFraction; 
		char pad8[4];
		float m_flUnknownFraction; 
		char pad9[4];
		float m_flUnknown3;
		char pad10[528];
	};
]]

-- Math variables
NULL = 0;
M_PI = 3.14159265358979323846;
M_PI_2 = 6.2831853071795862;
M_180_PI = 0.0174533;
M_PI_180 = 57.2958;
INT_MAX = 2147483647;
INFINITE = math.huge;

-- Math functions
function round(x)
  return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5);
end

function hasbit(x, p)
    return x % (p + p) >= p
end

function clamp(x, min, max)
	if (x < min) then
		x = min;
	end
	
	if (x > max) then
		x = max;
	end
	
	return x;
end

RandomFloat = ffi.cast("float(*)(float, float)", C.GetProcAddress(C.GetModuleHandleA("vstdlib.dll"), "RandomFloat"));

function IsInfinite(x)
  return x == INFINITE or x == -INFINITE;
end

function IsNaN(x)
  return x ~= x;
end

function NormalizePitch(pitch)
	if (pitch > 89) then
		return 89;
	elseif (pitch < -89) then
		return -89;
	end
	
	return pitch;
end

function NormalizeYaw(yaw)
	if (yaw > 180) then
		return yaw - (round(yaw / 360) * 360.0);
	elseif (yaw < -180) then
		return yaw + (round(yaw / 360) * -360.0);
	end
	
	return yaw;
end

function NormalizeRoll(roll)
	return 0;
end

function NormalizeAngle(vAngle)
	vAngle.pitch = NormalizePitch(vAngle.pitch);
	vAngle.yaw = NormalizeYaw(vAngle.yaw);
	vAngle.roll = NormalizeRoll(vAngle.roll);
	return vAngle;
end

function NormalizeVector(vAngle)
	vAngle.x = NormalizePitch(vAngle.x);
	vAngle.y = NormalizeYaw(vAngle.y);
	vAngle.z = NormalizeRoll(vAngle.z);
	return vAngle;
end

function VectorSubtraction(vFirst, vSecond)
	return vec3_t.new(vFirst.x - vSecond.x, vFirst.y - vSecond.y, vFirst.z - vSecond.z);
end

function VectorAddition(vFirst, vSecond)
	return vec3_t.new(vFirst.x + vSecond.x, vFirst.y + vSecond.y, vFirst.z + vSecond.z);
end

function VectorDivision(vFirst, vSecond)
	return vec3_t.new(vFirst.x / vSecond.x, vFirst.y / vSecond.y, vFirst.z / vSecond.z);
end

function VectorMultiplication(vFirst, vSecond)
	return vec3_t.new(vFirst.x * vSecond.x, vFirst.y * vSecond.y, vFirst.z * vSecond.z);
end

function VectorNumberSubtraction(Vector, Number)
	return vec3_t.new(Vector.x - Number, Vector.y - Number, Vector.z - Number);
end

function VectorNumberAddition(Vector, Number)
	return vec3_t.new(Vector.x + Number, Vector.y + Number, Vector.z + Number);
end

function VectorNumberDivision(Vector, Number)
	return vec3_t.new(Vector.x / Number, Vector.y / Number, Vector.z / Number);
end

function VectorNumberMultiplication(Vector, Number)
	return vec3_t.new(Vector.x * Number, Vector.y * Number, Vector.z * Number);
end

function GetMiddlePoint(vFirst, vSecond)
	return VectorAddition(VectorNumberDivision(VectorSubtraction(vSecond, vFirst), 2), vFirst);
end

function ExtendVector(Vector, Angle, Extension)
	local RadianAngle = Angle * M_180_PI;
	return vec3_t.new(Extension * math.cos(RadianAngle) + Vector.x, Extension * math.sin(RadianAngle) + Vector.y, Vector.z);
end

function CalcAngle(vecSource, vecDestination) 
	if (vecSource.x == nil or vecSource.y == nil or vecSource.z == nil) then
		vecSource = vec3_t.new(vecSource.pitch, vecSource.yaw, vecSource.roll);
	end
	
	if (vecDestination.x == nil or vecDestination.y == nil or vecDestination.z == nil) then
		vecDestination = vec3_t.new(vecDestination.pitch, vecDestination.yaw, vecDestination.roll);
	end

	local vAngle = vec3_t.new(0, 0, 0);	
	local vDelta = vec3_t.new(vecSource.x - vecDestination.x, vecSource.y - vecDestination.y, vecSource.z - vecDestination.z);	
	local hyp = math.sqrt(vDelta.x * vDelta.x + vDelta.y * vDelta.y);
	vAngle.x = math.atan(vDelta.z / hyp) * M_PI_180;
	vAngle.y = math.atan(vDelta.y / vDelta.x) * M_PI_180;
	vAngle.z = 0;
	
	if (vDelta.x >= 0) then
		vAngle.y = vAngle.y + 180;
	end
		
	vAngle = NormalizeVector(vAngle);
	
	return vAngle;
end

-- Converts a QAngle into either one or three normalised Vectors
function AngleVectors(vAngles)
	if (vAngles.x == nil or vAngles.y == nil or vAngles.z == nil) then
		vAngles = vec3_t.new(vAngles.pitch, vAngles.yaw, vAngles.roll);
	end

	local sy = math.sin(DEG2RAD(vAngles.y));
	local cy = math.cos(DEG2RAD(vAngles.y));
	
	local sp = math.sin(DEG2RAD(vAngles.x));
	local cp = math.cos(DEG2RAD(vAngles.x));
	
	return vec3_t.new(cp * cy, cp * sy, -sp);
end
	
-- Converts a single Vector into a QAngle.
function VectorAngles(vAngles)
	if (vAngles.x == nil or vAngles.y == nil or vAngles.z == nil) then
		vAngles = vec3_t.new(vAngles.pitch, vAngles.yaw, vAngles.roll);
	end
	
	local tmp, yaw, pitch;
	
	if (vAngles.y == 0 and vAngles.x == 0) then
		yaw = 0;
		if (vAngles.z > 0) then
			pitch = 270;
		else
			pitch = 90;
		end	
	else
		yaw = math.atan2(vAngles.y, vAngles.x) * 180.0 / M_PI;
		if (yaw < 0) then
			yaw = yaw + 360;
		end
		
		tmp = math.sqrt(vAngles.x * vAngles.x + vAngles.y * vAngles.y);
		pitch = math.atan2(-vAngles.z, tmp) * 180.0 / M_PI;
		if (pitch < 0) then
			pitch = pitch + 360;
		end
	end
	
	return vec3_t.new(pitch, yaw, 0);
end

function GetMaxDesyncDelta(Player)
	local Animstate = ffi.cast("struct CBaseAnimState*", ffi.cast("int*", Player:get_address() + 0x3914)[0]);

    if (not Animstate) then
		return 0;
	end
	
	local flRunningSpeed = math.max(0, math.min(Animstate.m_flFeetSpeedForwardsOrSideWays));
	local flYawModifier = (((Animstate.m_flStopToFullRunningFraction * -0.3) - 0.2) * flRunningSpeed) + 1.0;

	if (Animstate.m_fDuckAmount > 0) then
		local speedfactor = math.max( 0, math.min( 1, Animstate.m_flFeetSpeedUnknownForwardOrSideways ) ); 
		flYawModifier = flYawModifier + ( ( Animstate.m_fDuckAmount * speedfactor ) * ( 0.5 - flYawModifier ) )
	end

	return ffi.cast("float*", ffi.cast("int*", Player:get_address() + 0x3914)[0] + 0x334)[0] * flYawModifier;
end


function RAD2DEG(x)
	return (x * M_PI_180);
end

function DEG2RAD(x)  
	return (x * M_180_PI);
end

function VectorDot(vFirst, vSecond)
	return (vFirst.x * vSecond.x + vFirst.y * vSecond.y + vFirst.z * vSecond.z);
end
	
function VectorLengthSqr(Vector)
	return (Vector.x*Vector.x + Vector.y*Vector.y);
end
	
function GetFov(viewAngle, aimAngle)
	if (viewAngle.x == nil or viewAngle.y == nil or viewAngle.z == nil) then
		viewAngle = vec3_t.new(viewAngle.pitch, viewAngle.yaw, viewAngle.roll);
	end
	
	if (aimAngle.x == nil or aimAngle.y == nil or aimAngle.z == nil) then
		aimAngle = vec3_t.new(aimAngle.pitch, aimAngle.yaw, aimAngle.roll);
	end
	
	local Aim = AngleVectors(viewAngle);
	local Ang = AngleVectors(aimAngle);
	
	return RAD2DEG(math.acos(VectorDot(Aim, Ang) / VectorLengthSqr(Aim)));
end

function Distance3D(vFirst, vSecond)
	return (((vFirst.x - vSecond.x) ^ 2) + ((vFirst.y - vSecond.y) ^ 2) + ((vFirst.z - vSecond.z) ^ 2) * 0.5) / 300;
end

function Distance2D(vFirst, vSecond) 
	return ((vFirst.x - vSecond.x) ^ 2) + ((vFirst.y - vSecond.y) ^ 2);
end

function GetCurtime(Player)
	if (not Player or not Player:is_alive()) then
		return globalvars.get_current_time();
	end
	
	return Player:get_prop_int(m_nTickBase) * globalvars.get_interval_per_tick();
end

function GetTickrate()
	return (1.0 / globalvars.get_interval_per_tick());
end

function TIME_TO_TICKS(dt)		
	return (0.5 + dt / globalvars.get_interval_per_tick());
end

function TICKS_TO_TIME(t)
	return (globalvars.get_interval_per_tick() * t);
end

function GetLerpTime()
	local cl_updaterate = se.get_convar("cl_updaterate"):get_int();
	local sv_minupdaterate = se.get_convar("sv_minupdaterate");
	local sv_maxupdaterate se.get_convar("sv_maxupdaterate");
	
	if (sv_minupdaterate and sv_maxupdaterate) then
		cl_updaterate = sv_maxupdaterate:get_int();
	end	
	
	local cl_interp_ratio = se.get_convar("cl_interp_ratio"):get_float();
	
	if (cl_interp_ratio == 0) then
		cl_interp_ratio = 1;
	end
	
	local cl_interp = se.get_convar("cl_interp"):get_float();
	local sv_client_min_interp_ratio = se.get_convar("sv_client_min_interp_ratio");
	local sv_client_max_interp_ratio = se.get_convar("sv_client_max_interp_ratio");
	
	if (sv_client_min_interp_ratio and sv_client_max_interp_ratio and sv_client_min_interp_ratio:get_float() ~= 1) then
		cl_interp_ratio = clamp(cl_interp_ratio, sv_client_min_interp_ratio:get_float(), sv_client_max_interp_ratio:get_float());
	end
	
	return math.max(cl_interp, (cl_interp_ratio / cl_updaterate));
end

function RotateMovement(pCmd, vAngles)
	if (vAngles.x == nil or vAngles.y == nil or vAngles.z == nil) then
		vAngles = vec3_t.new(vAngles.pitch, vAngles.yaw, vAngles.roll);
	end
	
	local viewangles = engine.get_view_angles();
	local rotation = DEG2RAD(viewangles.yaw - vAngles.y);
	
	local cos_rot = math.cos(rotation);
	local sin_rot = math.sin(rotation);
	
	local new_forwardmove = (cos_rot * pCmd.forwardmove) - (sin_rot * pCmd.sidemove);
	local new_sidemove = (sin_rot *  pCmd.forwardmove) + (cos_rot * pCmd.sidemove);
	
	pCmd.forwardmove = new_forwardmove;
	pCmd.sidemove = new_sidemove;
end

-- From ValveSDK https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/public/mathlib/mathlib.h#L634
local function anglemod(x)
	x = (360.0 / 65536) * bit32.band(math.floor(x * (65536.0 / 360.0)));
	return x;
end

-- From ValveSDK https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/mathlib/mathlib_base.cpp#L3438
function ApproachAngle(target, value, speed)
	target = anglemod(target);
	value = anglemod(value);
	
	local delta = target - value;
	
	-- Speed is assumed to be positive
	speed = math.abs(speed);
	
	if (delta < -180) then
		delta = delta + 360;
	elseif (delta > 180) then
		delta = delta - 360;
	end
	
	if (delta > speed) then
		value = value + speed;
	elseif (delta < -speed) then
		value = value - speed;
	else
		value = target;
	end
	
	return value;
end

-- From ValveSDK https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/mathlib/mathlib_base.cpp#L3466
function AngleDifference(destAngle, srcAngle)
	local delta = math.fmod(destAngle - srcAngle, 360);
	if (destAngle > srcAngle) then
		if (delta >= 180) then
			delta = delta - 360;
		end
	else
		if (delta <= - 180) then
			delta = delta + 360;
		end
	end
	return delta;
end


-- Renderer helpers
local ScreenSize = engine.get_screen_size();
function IsOnScreen(Vector2D)
	if (Vector2D.x < 0 or Vector2D.y < 0) then
		return false;
	elseif (Vector2D.x > ScreenSize.x or Vector2D.y > ScreenSize.y) then
		return false;
	end

	return true;
end

function DrawOutlined3DCircle(vOrigin, Radius, Segments, Color)
	local Step = M_PI_2 / Segments;

	for a = 0, M_PI_2, Step do
		local vStart =  se.world_to_screen(vec3_t.new(Radius * math.cos(a) + vOrigin.x, Radius * math.sin(a) + vOrigin.y, vOrigin.z));
		local vEnd = se.world_to_screen(vec3_t.new(Radius * math.cos(a + Step) + vOrigin.x, Radius * math.sin(a + Step) + vOrigin.y, vOrigin.z));

		if (IsOnScreen(vStart) or IsOnScreen(vEnd)) then
			renderer.line(vStart, vEnd, Color);
		end
	end
end

-- Helper functions
local HasC4Func = ffi.cast("bool(__thiscall*)(void*)", client.find_pattern("client.dll", "56 8B F1 85 F6 74 31"));
function HasC4(Player)
	if (not HasC4Func) then
		client.notify("Invalid HasC4 signature!");
		return;
	end
	
	local cb = ffi.cast("void*", Player:get_address());
	return HasC4Func(cb);
end

local WeaponDataFunc = ffi.cast("int*(__thiscall*)(void*)", client.find_pattern("client.dll", "55 8B EC 81 EC ? ? ? ? 53 8B D9 56 57 8D 8B ? ? ? ? 85 C9 75 04"));
function GetWeaponData(Weapon)
	if (not WeaponDataFunc) then
		client.notify("Invalid GetWeaponData signature!");
		return;
	end

	local cb = ffi.cast("void*", Weapon:get_address());
	return ffi.cast("struct WeaponInfo_t*", WeaponDataFunc(cb));
end

local AnimstateOffset = 0x3914;
function GetAnimstate(Player)
	local PlayerAddress = Player:get_address();
	return ffi.cast("struct CBaseAnimState*", ffi.cast("int*", PlayerAddress + AnimstateOffset)[0]);
end

function IsKnife(Weapon)
	if (GetWeaponData(Weapon).type == 1) then -- NULL is knife
		return true;
	end
	
	return false;
end

function IsNade(Weapon)
	local Type = GetWeaponData(Weapon).type;
	if (Type == 0) then
		return true;
	end
	
	return false;
end

-- Exploits
function IsExploitRecharged(LocalPlayer, Weapon, Exploit)
	if (Exploit == 0 or IsKnife(Weapon) or IsNade(Weapon)) then
		return true;
	end
	
	local m_nShiftedTicks = 9;
	if (Exploit == 2) then
		m_nShiftedTicks = 12;
	end
	
	local m_Tickbase = LocalPlayer:get_prop_int(m_nTickBase);
	if (Exploit > 0) then
		m_Tickbase = LocalPlayer:get_prop_int(m_nTickBase) - m_nShiftedTicks + 1;
	end
		
	local m_flPlayerTime = m_Tickbase * globalvars.get_interval_per_tick();
	if (m_flPlayerTime < Weapon:get_prop_float(m_flNextPrimaryAttack)) then
		return false;
	end
	
	return true;
end

function GetExploitCharge(LocalPlayer, Weapon, Exploit)
	if (Exploit == 0 or IsKnife(Weapon) or IsNade(Weapon)) then
		return 0;
	end

	local m_nShiftedTicks = 9;
	if (Exploit == 2) then
		m_nShiftedTicks = 12;
	end
	
	local m_Tickbase = LocalPlayer:get_prop_int(m_nTickBase);
	if (Exploit > 0) then
		m_Tickbase = LocalPlayer:get_prop_int(m_nTickBase) - m_nShiftedTicks + 1;
	end

	local m_flPlayerTime = m_Tickbase * globalvars.get_interval_per_tick();
	local NextAttack = Weapon:get_prop_float(m_flNextPrimaryAttack);
	if (m_flPlayerTime < NextAttack) then
		return NextAttack - m_flPlayerTime;
	end
	
	return 0;
end

local FLT_EPSILON = 0x0.000002p0;

local function GetSmoothedVelocity(min_delta, a, b)
	local delta = VectorSubtraction(a, b);
	local delta_length = delta:length();

	if (delta_length <= min_delta) then
		if (-min_delta <= delta_length) then
			return a;
		else
			local iradius = 1 / (delta_length + FLT_EPSILON);
			return VectorNumberSubtraction(b, ((delta * iradius) * min_delta));
		end
	else
		local iradius = 1 / (delta_length + FLT_EPSILON);
		return VectorNumberSubtraction(b, ((delta * iradius) * min_delta));
	end
end

local function GetSafepoints(Player)
    local Animstate = GetAnimstate(Player);
    if (not Animstate) then
		return 0;
	end

	local vVelocity = vec3_t.new(Player:get_prop_float(m_vecVelocity[0]), Player:get_prop_float(m_vecVelocity[1]), Player:get_prop_float(m_vecVelocity[2]));
	local Spd = VectorLengthSqr(vVelocity);
	if (Spd > math.pow(1.2 * 260, 2)) then
		local vVelocityNormalize = NormalizeVector(vVelocity);
		vVelocity = VectorNumberMultiplication(vVelocityNormalize, (1.2 * 260));
	end

	local m_flChokedTime = Player:get_prop_float(m_flSimulationTime) - Player:get_prop_float(m_flOldSimulationTime);
	local v25 = clamp(Animstate.m_fDuckAmount + Animstate.m_fLandingDuckAdditiveSomething, 0, 1); -- 0xA4 -- m_flDuckAmount -- 0xA8 -- m_fLandingDuckAdditiveSomething
	local v26 = Animstate.m_fDuckAmount; -- 0xA4 -- m_flDuckAmount
	local v27 = m_flChokedTime * 6;
	local v28 = v25;

	-- clamp
	if ((v25 - v26) <= 27) then
		if (-v27 <= (v25 - v26)) then
			v28 = v25;
		else
			v25 = v26 - v27;
		end
	else
		v28 = v26 + v27;
	end

	local m_flDuckAmount = clamp(v28, 0, 1);

	local vAnimVelocity = GetSmoothedVelocity(m_flChokedTime * 2000, vVelocity, vec3_t.new(Animstate.m_vVelocityX, Animstate.m_vVelocityY, Animstate.flUpVelocity));
	local Speed = math.min(vAnimVelocity:length(), 260);

	local ActiveWeaponHandle = Player:get_prop_int(m_hActiveWeapon);
	local Weapon = entitylist.get_entity_from_handle(ActiveWeaponHandle);

	local flMaxMovementSpeed = 260;

	if (Weapon) then
		flMaxMovementSpeed = math.max(GetWeaponData(Weapon).max_speed_alt, 0.001);
	end

	local flRunningSpeed = Speed / (flMaxMovementSpeed * 0.520);
	local flDuckingSpeed = Speed / (flMaxMovementSpeed * 0.340);

	flRunningSpeed = clamp(flRunningSpeed, 0, 1);

	local flYawModifier = (((Animstate.m_flStopToFullRunningFraction * -0.3) - 0.2) * flRunningSpeed) + 1.0;

	if (m_flDuckAmount > 0) then
		local flDuckingSpeed = clamp(flDuckingSpeed, 0, 1);
		flYawModifier = flYawModifier + ((m_flDuckAmount * flDuckingSpeed) * (0.5 - flYawModifier));
	end

	-- lol, just rofl
	local m_flMinBodyYaw = ffi.cast("float*", ffi.cast("int*", Player:get_address() + AnimstateOffset)[0] + 0x330)[0];
	local m_flMaxBodyYaw = ffi.cast("float*", ffi.cast("int*", Player:get_address() + AnimstateOffset)[0] + 0x334)[0];

	local flMinBodyYaw = m_flMinBodyYaw * flYawModifier;
	local flMaxBodyYaw = m_flMaxBodyYaw * flYawModifier;

	local flEyeYaw = Animstate.m_flEyeYaw;
	local flEyeDiff = NormalizeYaw(flEyeYaw - Animstate.m_flGoalFeetYaw);

	local m_flFakeGoalFeetYaw = Animstate.m_flGoalFeetYaw;

	if (flEyeDiff <= flMaxBodyYaw) then
		if (flMinBodyYaw > flEyeDiff) then
			m_flFakeGoalFeetYaw = math.abs(flMinBodyYaw) + flEyeYaw;
		end
	else
		m_flFakeGoalFeetYaw = flEyeYaw - math.abs(flMaxBodyYaw);
	end

	m_flFakeGoalFeetYaw = NormalizeYaw(m_flFakeGoalFeetYaw);

	if (Speed > 0 or vVelocity.z > 100) then
		m_flFakeGoalFeetYaw = ApproachAngle(
			flEyeYaw, 
			m_flFakeGoalFeetYaw,
			((Animstate.m_flStopToFullRunningFraction * 20) + 30) * m_flChokedTime
		);
	else
		m_flFakeGoalFeetYaw = ApproachAngle(
			Player:get_prop_float(m_flLowerBodyYawTarget),
			m_flFakeGoalFeetYaw,
			m_flChokedTime * 100
		)
	end

--	client.notify(tostring(m_flFakeGoalFeetYaw + flMinBodyYaw) .. " " .. tostring(m_flFakeGoalFeetYaw + flMaxBodyYaw) .. " " .. tostring(m_flFakeGoalFeetYaw))
	local FinalPoints = 
	{
		flEyeYaw + flMinBodyYaw,
		flEyeYaw + flMaxBodyYaw,
		m_flFakeGoalFeetYaw,
		Player:get_prop_float(m_flLowerBodyYawTarget)
	};

	return FinalPoints;
end

-- Libraries
-- Timers lib https://nixware.cc/threads/7591/
local function get_time()
    return math.floor(globalvars.get_current_time() * 1000)
end

Timer = {}
Timer.timers = {}

local function add_timer(is_interval, callback, ms)
    table.insert(Timer.timers, {
        time = get_time() + ms,
        ms = ms,
        is_interval = is_interval,
        callback = callback
    })

    return #Timer.timers
end

Timer.new_timeout = function (callback, ms)
    local index = add_timer(false, callback, ms)

    return index
end

Timer.new_interval = function(callback, ms)
    local index = add_timer(true, callback, ms)

    return index
end

Timer.listener = function()
    for i = 1, #Timer.timers do
        local timer = Timer.timers[i]
        local current_time = get_time()

        if current_time >= timer.time then
            timer.callback()

            if timer.is_interval then
                timer.time = get_time() + timer.ms
            else
                table.remove(Timer.timers, i)
            end
        end
    end
end

Timer.remove = function(index)
    table.remove(Timer.timers, index)
end

-- MoveType_t
MOVETYPE_NONE = 0; -- Freezes the entity, outside sources can't move it. 
MOVETYPE_ISOMETRIC = 1; -- For players in TF2 commander view etc. Do not use this for normal players! 
MOVETYPE_WALK = 2; -- Default player (client) move type. 
MOVETYPE_STEP = 3; -- NPC movement 
MOVETYPE_FLY = 4; -- Fly with no gravity. 
MOVETYPE_FLYGRAVITY = 5; -- Fly with gravity. 
MOVETYPE_VPHYSICS = 6; -- Physics movetype (prop models etc.) 
MOVETYPE_PUSH = 7; -- No clip to world, but pushes and crushes things.
MOVETYPE_NOCLIP = 8; -- Noclip, behaves exactly the same as console command.
MOVETYPE_LADDER = 9; -- For players, when moving on a ladder. 
MOVETYPE_OBSERVER = 10; -- Spectator movetype. DO NOT use this to make player spectate. 
MOVETYPE_CUSTOM = 11; -- Custom movetype, can be applied to the player to prevent the default movement code from running, while still calling the related hooks
MOVETYPE_LAST = MOVETYPE_CUSTOM;
MOVETYPE_MAX_BITS = 4;

-- Buttons
IN_ATTACK   = 1;       --  (1 << 0)  -- Fire weapon
IN_JUMP 	= 2;       --  (1 << 1)  -- Jump
IN_DUCK     = 4;       --  (1 << 2)  -- Crouch
IN_FORWARD  = 8;       --  (1 << 3)  -- Walk forward
IN_BACK     = 16;      --  (1 << 4)  -- Walk backwards
IN_USE      = 32;      --  (1 << 5)  -- Use (Defuse bomb, etc...)
IN_CANCEL   = 64;      --  (1 << 6)
IN_LEFT     = 128;     --  (1 << 7)  -- Walk left
IN_RIGHT    = 256;     --  (1 << 8)  -- Walk right
IN_MOVELEFT = 512;     --  (1 << 9)
IN_MOVERIGHT= 1024;    --  (1 << 10)
IN_ATTACK2  = 2048;    --  (1 << 11) -- Secondary fire (Revolver, Glock change fire mode, Famas change fire mode), zoom
IN_RUN      = 4096;    --  (1 << 12)
IN_RELOAD   = 8192;    --  (1 << 13) -- Reload weapon
IN_ALT1     = 16384;   --  (1 << 14)
IN_ALT2     = 32768;   --  (1 << 15)
IN_SCORE    = 65536;   --  (1 << 16) -- Used by client.dll for when scoreboard is held down
IN_SPEED    = 131072;  --  (1 << 17) -- Player is holding the speed key
IN_WALK     = 262144;  --  (1 << 18) -- Player holding walk key
IN_ZOOM     = 524288;  --  (1 << 19) -- Zoom key for HUD zoom
IN_WEAPON1  = 1048576; --  (1 << 20) -- weapon defines these bits
IN_WEAPON2  = 2097152; --  (1 << 21) -- weapon defines these bits
IN_BULLRUSH = 4194304; --  (1 << 22)
IN_GRENADE1 = 8388608; --  (1 << 23) -- grenade 1
IN_GRENADE2 = 16777216;--  (1 << 24) -- grenade 2
IN_ATTACK3  = 33554432;--  (1 << 25)

-- EntityFlags
FL_ONGROUND  = 1;  -- (1 << 0), At rest / on the ground
FL_DUCKING   = 2;  -- (1 << 1), Player flag -- Player is fully crouched
FL_ANIMDUCKING=4;  -- (1 << 2), Player flag -- Player is in the process of crouching or uncrouching but could be in transition
--		                                       Fully ducked:  FL_DUCKING &  FL_ANIMDUCKING
--           Previously fully ducked, unducking in progress:  FL_DUCKING & !FL_ANIMDUCKING
--                                           Fully unducked: !FL_DUCKING & !FL_ANIMDUCKING
--           Previously fully unducked, ducking in progress: !FL_DUCKING &  FL_ANIMDUCKING
FL_WATERJUMP = 8;  -- (1 << 3), Player jumping out of water
FL_ONTRAIN   = 16; -- (1 << 4), Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
FL_INRAIN	   = 32; -- (1 << 5), Indicates the entity is standing in rain
FL_FROZEN    = 64; -- (1 << 6), Player is frozen for 3rd person camera
FL_ATCONTROLS= 128;-- (1 << 7), Player can't move, but keeps key inputs for controlling another entity
FL_CLIENT	   = 256;-- (1 << 8), Is a player
FL_FAKECLIENT= 512;-- (1 << 9), Fake client, simulated server side; don't send network messages to them
-- NON-PLAYER SPECIFIC (i.e., not used by GameMovement or the client .dll ) -- Can still be applied to players, though
FL_INWATER = 1024; -- (1 << 10), // In water

-- ClientFrameStage_t
FRAME_UNDEFINED = -1;						-- Haven't run any frames yet
FRAME_START = 0;
FRAME_NET_UPDATE_START = 1;					-- A network packet is being recieved
FRAME_NET_UPDATE_POSTDATAUPDATE_START = 2;  -- Data has been received and we're going to start calling PostDataUpdate
FRAME_NET_UPDATE_POSTDATAUPDATE_END = 3;	-- Data has been received and we've called PostDataUpdate on all data recipients
FRAME_NET_UPDATE_END = 4;					-- We've received all packets, we can now do interpolation, prediction, etc..
FRAME_RENDER_START = 5;						-- We're about to start rendering the scene
FRAME_RENDER_END = 6;						-- We've finished rendering the scene.
	
-- ItemDefinitionIndex
WEAPON_NONE = 0;
WEAPON_DEAGLE = 1;
WEAPON_ELITE = 2;
WEAPON_FIVESEVEN = 3;
WEAPON_GLOCK = 4;
WEAPON_AK47 = 7;
WEAPON_AUG = 8;
WEAPON_AWP = 9;
WEAPON_FAMAS = 10;
WEAPON_G3SG1 = 11;
WEAPON_GALILAR = 13;
WEAPON_M249 = 14;
WEAPON_M4A1 = 16;
WEAPON_MAC10 = 17;
WEAPON_P90 = 19;
WEAPON_MP5SD = 23;
WEAPON_UMP45 = 24;
WEAPON_XM1014 = 25;
WEAPON_BIZON = 26;
WEAPON_MAG7 = 27;
WEAPON_NEGEV = 28;
WEAPON_SAWEDOFF = 29;
WEAPON_TEC9 = 30;
WEAPON_TASER = 31;
WEAPON_HKP2000 = 32;
WEAPON_MP7 = 33;
WEAPON_MP9 = 34;
WEAPON_NOVA = 35;
WEAPON_P250 = 36;
WEAPON_SHIELD = 37;
WEAPON_SCAR20 = 38;
WEAPON_SG556 = 39;
WEAPON_SSG08 = 40;
WEAPON_KNIFEGG = 41;
WEAPON_KNIFE = 42;
WEAPON_FLASHBANG = 43;
WEAPON_HEGRENADE = 44;
WEAPON_SMOKEGRENADE = 45;
WEAPON_MOLOTOV = 46;
WEAPON_DECOY = 47;
WEAPON_INCGRENADE = 48;
WEAPON_C4 = 49;
WEAPON_HEALTHSHOT = 57;
WEAPON_KNIFE_T = 59;
WEAPON_M4A1_SILENCER = 60;
WEAPON_USP_SILENCER = 61;
WEAPON_CZ75A = 63;
WEAPON_REVOLVER = 262208; -- 64
WEAPON_TAGRENADE = 68;
WEAPON_FISTS = 69;
WEAPON_BREACHCHARGE = 70;
WEAPON_TABLET = 72;
WEAPON_MELEE = 74;
WEAPON_AXE = 75;
WEAPON_HAMMER = 76;
WEAPON_SPANNER = 78;
WEAPON_KNIFE_GHOST = 80;
WEAPON_FIREBOMB = 81;
WEAPON_DIVERSION = 82;
WEAPON_FRAG_GRENADE = 83;
WEAPON_SNOWBALL = 84;
WEAPON_BUMPMINE = 85;
WEAPON_BAYONET = 500;
WEAPON_KNIFE_TACTICAL = 509;
WEAPON_KNIFE_SURVIVAL_BOWIE = 514;
WEAPON_KNIFE_PUSH = 516;
WEAPON_KNIFE_GYPSY_JACKKNIFE = 520;
WEAPON_KNIFE_WIDOWMAKER = 523;
WEAPON_KNIFE_BAYONET = 590324;
WEAPON_KNIFE_FLIP = 590329;
WEAPON_KNIFE_GUT = 590330;
WEAPON_KNIFE_KARAMBIT = 590331;
WEAPON_KNIFE_M9_BAYONET = 590332;
WEAPON_KNIFE_HUNTSMAN = 590333;
WEAPON_KNIFE_FALCHION = 590336;
WEAPON_KNIFE_BOWIE = 590338;
WEAPON_KNIFE_BUTTERFLY = 590339;
WEAPON_KNIFE_SHADOW_DAGGERS = 590340;
WEAPON_KNIFE_URSUS = 590343;
WEAPON_KNIFE_NAVAJA = 590344;
WEAPON_KNIFE_STILETTO = 590346;
WEAPON_KNIFE_TALON = 590347;
WEAPON_KNIFE_CSS = 590327;
WEAPON_KNIFE_CORD = 590341;
WEAPON_KNIFE_CANIS = 590342;
WEAPON_KNIFE_OUTDOOR = 590345;
WEAPON_KNIFE_SKELETON = 590349;

-- Hitboxes
HITBOX_HEAD = 0;
HITBOX_NECK = 1;
HITBOX_PELVIS = 2;
HITBOX_STOMACH = 3;
HITBOX_THORAX = 4;
HITBOX_CHEST = 5;
HITBOX_UPPER_CHEST = 6;
HITBOX_RIGHT_THIGH = 7;
HITBOX_LEFT_THIGH = 8;
HITBOX_RIGHT_CALF = 9;
HITBOX_LEFT_CALF = 10;
HITBOX_RIGHT_FOOT = 11;
HITBOX_LEFT_FOOT = 12;
HITBOX_RIGHT_HAND = 13;
HITBOX_LEFT_HAND = 14;
HITBOX_RIGHT_UPPER_ARM = 15;
HITBOX_RIGHT_FOREARM = 16;
HITBOX_LEFT_UPPER_ARM = 17;
HITBOX_LEFT_FOREARM = 18;
HITBOX_MAX = 19;

-- Bspflags
CONTENTS_EMPTY = 0; -- No contents
CONTENTS_SOLID = 0x1; -- an eye is never valid in a solid
CONTENTS_WINDOW = 0x2; -- translucent, but not watery (glass)
CONTENTS_AUX = 0x4;
CONTENTS_GRATE = 0x8; -- alpha-tested "grate" textures.  Bullets/sight pass through, but solids
CONTENTS_SLIME = 0x10;
CONTENTS_WATER = 0x20;
CONTENTS_BLOCKLOS = 0x40; -- block AI line of sight
CONTENTS_OPAQUE = 0x80;
LAST_VISIBLE_CONTENTS = 0x80 -- things that cannot be seen through (may be non-solid though)

ALL_VISIBLE_CONTENTS = bit32.band(LAST_VISIBLE_CONTENTS, (LAST_VISIBLE_CONTENTS-1));
CONTENTS_TESTFOGVOLUME = 0x100;
CONTENTS_UNUSED = 0x200;

-- unused
-- NOTE: If it's visible, grab from the top + update LAST_VISIBLE_CONTENTS
-- if not visible, then grab from the bottom.
CONTENTS_UNUSED6 = 0x400;
CONTENTS_TEAM1 = 0x800;
CONTENTS_TEAM2 = 0x1000;

-- ignore CONTENTS_OPAQUE on surfaces that have SURF_NODRAW
CONTENTS_IGNORE_NODRAW_OPAQUE = 0x2000

-- hits entities which are MOVETYPE_PUSH (doors, plats, etc.)
CONTENTS_MOVEABLE = 0x4000;

-- remaining contents are non-visible, and don't eat brushes
CONTENTS_AREAPORTAL = 0x8000;

CONTENTS_PLAYERCLIP = 0x10000;
CONTENTS_MONSTERCLIP = 0x20000;

-- currents can be added to any other contents, and may be mixed
CONTENTS_CURRENT_0 = 0x40000;
CONTENTS_CURRENT_90 = 0x80000;
CONTENTS_CURRENT_180 = 0x100000;
CONTENTS_CURRENT_270 = 0x200000;
CONTENTS_CURRENT_UP = 0x400000;
CONTENTS_CURRENT_DOWN = 0x800000;

CONTENTS_ORIGIN = 0x1000000 -- removed before bsping an entity

CONTENTS_MONSTER = 0x2000000 -- should never be on a brush, only in game
CONTENTS_DEBRIS =  0x4000000;
CONTENTS_DETAIL = 0x8000000; -- brushes to be added after vis leafs
CONTENTS_TRANSLUCENT = 0x10000000; -- auto set if any surface has trans
CONTENTS_LADDER = 0x20000000;
CONTENTS_HITBOX = 0x40000000; -- use accurate hitboxes on trace


-- NOTE: These are stored in a short in the engine now.  Don't use more than 16 bits
SURF_LIGHT = 0x0001; -- value will hold the light strength
SURF_SKY2D = 0x0002; -- don't draw, indicates we should skylight + draw 2d sky but not draw the 3D skybox
SURF_SKY = 0x0004; -- don't draw, but add to skybox
SURF_WARP = 0x0008; -- turbulent water warp
SURF_TRANS = 0x0010;
SURF_NOPORTAL = 0x0020; -- the surface can not have a portal placed on it
SURF_TRIGGER = 0x0040; -- FIXME: This is an xbox hack to work around elimination of trigger surfaces, which breaks occluders
SURF_NODRAW = 0x0080; -- don't bother referencing the texture

SURF_HINT = 0x0100; -- make a primary bsp splitter

SURF_SKIP = 0x0200; -- completely ignore, allowing non-closed brushes
SURF_NOLIGHT = 0x0400; -- Don't calculate light
SURF_BUMPLIGHT = 0x0800; -- calculate three lightmaps for the surface for bumpmapping
SURF_NOSHADOWS = 0x1000; -- Don't receive shadows
SURF_NODECALS = 0x2000; -- Don't receive decals
SURF_NOCHOP = 0x4000; -- Don't subdivide patches on this surface 
SURF_HITBOX = 0x8000; -- surface is part of a hitbox

-------------------------------------------------------
-- spatial content masks - used for spatial queries (traceline,etc.)
-------------------------------------------------------
MASK_ALL = (0xFFFFFFFF);
-- everything that is normally solid
MASK_SOLID = bit32.bor(CONTENTS_SOLID,  bit32.bor(CONTENTS_MOVEABLE,  bit32.bor(CONTENTS_WINDOW,  bit32.bor(CONTENTS_MONSTER, CONTENTS_GRATE))));
-- everything that blocks player movement
MASK_PLAYERSOLID = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_PLAYERCLIP, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_MONSTER,CONTENTS_GRATE)))));
-- blocks npc movement
MASK_NPCSOLID = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_MONSTERCLIP, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_MONSTER, CONTENTS_GRATE)))));
-- water physics in these contents
MASK_WATER = bit32.bor(CONTENTS_WATER, bit32.bor(CONTENTS_MOVEABLE, CONTENTS_SLIME));
-- everything that blocks lighting
MASK_OPAQUE = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, CONTENTS_OPAQUE));
-- everything that blocks lighting, but with monsters added.
MASK_OPAQUE_AND_NPCS = bit32.bor(MASK_OPAQUE, CONTENTS_MONSTER);
-- everything that blocks line of sight for AI
MASK_BLOCKLOS = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, CONTENTS_BLOCKLOS));
-- everything that blocks line of sight for AI plus NPCs
MASK_BLOCKLOS_AND_NPCS = bit32.bor(MASK_BLOCKLOS, CONTENTS_MONSTER);
-- everything that blocks line of sight for players
MASK_VISIBLE = bit32.bor(MASK_OPAQUE, CONTENTS_IGNORE_NODRAW_OPAQUE);
-- everything that blocks line of sight for players, but with monsters added.
MASK_VISIBLE_AND_NPCS = bit32.bor(MASK_OPAQUE_AND_NPCS, CONTENTS_IGNORE_NODRAW_OPAQUE);
-- bullets see these as solid
MASK_SHOT = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_MONSTER, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_DEBRIS, CONTENTS_HITBOX)))));
-- non-raycasted weapons see this as solid (includes grates)
MASK_SHOT_HULL = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_MONSTER, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_DEBRIS, CONTENTS_GRATE)))));
-- hits solids (not grates) and passes through everything else
MASK_SHOT_PORTAL = bit32.bor(CONTENTS_SOLID,  bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_WINDOW,CONTENTS_MONSTER)));
-- everything normally solid, except monsters (world+brush only)
MASK_SOLID_BRUSHONLY = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_WINDOW, CONTENTS_GRATE)));
-- everything normally solid for player movement, except monsters (world+brush only)
MASK_PLAYERSOLID_BRUSHONLY = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_PLAYERCLIP, CONTENTS_GRATE))));
-- everything normally solid for npc movement, except monsters (world+brush only)
MASK_NPCSOLID_BRUSHONLY = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_MOVEABLE, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_MONSTERCLIP, CONTENTS_GRATE))));
-- just the world, used for route rebuilding
MASK_NPCWORLDSTATIC = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_WINDOW, bit32.bor(CONTENTS_MONSTERCLIP, CONTENTS_GRATE)));
-- These are things that can split areaportals
MASK_SPLITAREAPORTAL = bit32.bor(CONTENTS_WATER, CONTENTS_SLIME);

-- UNDONE: This is untested, any moving water
MASK_CURRENT = bit32.bor(CONTENTS_CURRENT_0, bit32.bor(CONTENTS_CURRENT_90, bit32.bor(CONTENTS_CURRENT_180, bit32.bor(CONTENTS_CURRENT_270, bit32.bor(CONTENTS_CURRENT_UP, CONTENTS_CURRENT_DOWN)))));

-- everything that blocks corpse movement
-- UNDONE: Not used yet / may be deleted
MASK_DEADSOLID = bit32.bor(CONTENTS_SOLID, bit32.bor(CONTENTS_PLAYERCLIP, bit32.bor(CONTENTS_WINDOW, CONTENTS_GRATE)));