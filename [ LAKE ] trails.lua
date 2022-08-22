local ffi = require 'ffi'
local bit = require 'bit'

local sprites = {
    "sprites/purplelaser1.vmt",
    "sprites/physbeam.vmt",
    "sprites/blueglow1.vmt",
    "sprites/bubble.vmt",
    "sprites/glow01.vmt",
    "sprites/purpleglow1.vmt",
    "sprites/radio.vmt",
    "sprites/white.vmt"
}

local enable = ui.add_check_box('enable trails beam', 'trails_beam_state', false)
local color = ui.add_color_edit('trails beam color', 'trails_beam_color', false, color_t.new(255, 255, 255, 255))
local is_rgb = ui.add_check_box('rgb mode', 'trails_beam_rgb', false)
local beam_type = ui.add_combo_box('beams type', 'trails_beam_type', {"default", "old school", "blueglow1", "bubble", "glow01", "purpleglow1", "radio", "white"}, 0)

local width = ui.add_slider_int('trails width', 'trails_beam_width', 1, 20, 10)
local duration = ui.add_slider_int('trails duration', 'trails_beam_duration', 1, 5, 2)
local speed = ui.add_slider_int('trails speed', 'trails_beam_speed', 1, 20, 2)
local amplitude = ui.add_slider_float('trails amplitude', 'trails_beam_amplitude', 2.0, 20.0, 2.3)
local segments = ui.add_slider_int('trails segments', 'trails_beam_segments', 2, 100, 2)

ffi.cdef[[
    typedef struct 
    {
		float x;
		float y;
		float z;	
    } vec3_t;

    typedef struct
    {
        int				m_nType;
        void*           m_pStartEnt;
        int				m_nStartAttachment;
        void*           m_pEndEnt;
        int				m_nEndAttachment;
        float           m_flStartX;
        float           m_flStartY;
        float           m_flStartZ;
        float           m_flEndX;
        float           m_flEndY;
        float           m_flEndZ;
        int				m_nModelIndex;
        const char*     m_pszModelName;
        int				m_nHaloIndex;
        const char*     m_pszHaloName;
        float			m_flHaloScale;
        float			m_flLife;
        float			m_flWidth;
        float			m_flEndWidth;
        float			m_flFadeLength;
        float			m_flAmplitude;
        float			m_flBrightness;
        float			m_flSpeed;
        int				m_nStartFrame;
        float			m_flFrameRate;
        float			m_flRed;
        float			m_flGreen;
        float			m_flBlue;
        bool			m_bRenderable;
        int				m_nSegments;
        int				m_nFlags;
        vec3_t			m_vecCenter;
        float			m_flStartRadius;
        float			m_flEndRadius;
    } b_info_t;

    typedef void (__thiscall* draw_beams_t)(void*, void*);
    typedef void*(__thiscall* create_beam_points_t)(void*, b_info_t&);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void*(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
]]

local render_beams = ffi.cast("void**", ffi.cast("char*", client.find_pattern("client.dll", "B9 ? ? ? ? A1 ? ? ? ? FF 10 A1 ? ? ? ? B9")) + 1)[0]
local render_beams_class = ffi.cast("void***", render_beams)
local draw_beams = ffi.cast("draw_beams_t", render_beams_class[0][6])
local create_beam_points = ffi.cast("create_beam_points_t", render_beams_class[0][12])

local function create_beams(startpos, endpos, red, green, blue, alpha)
    local beam_info = ffi.new("b_info_t")
    beam_info.m_nType = 0
    beam_info.m_nModelIndex = -1
    beam_info.m_flHaloScale = 0

    beam_info.m_flLife = duration:get_value()
    beam_info.m_flFadeLength = 1

    beam_info.m_flWidth = width:get_value() * 0.1
    beam_info.m_flEndWidth = width:get_value() * 0.1

    beam_info.m_pszModelName = sprites[beam_type:get_value() + 1]

    beam_info.m_flAmplitude = amplitude:get_value()
    beam_info.m_flSpeed = speed:get_value() * 0.1

    beam_info.m_nStartFrame = 0
    beam_info.m_flFrameRate = 0

    beam_info.m_flRed = red
    beam_info.m_flGreen = green
    beam_info.m_flBlue = blue
    beam_info.m_flBrightness = alpha

    beam_info.m_nSegments = segments:get_value()
    beam_info.m_bRenderable = true

    beam_info.m_nFlags = bit.bor(0x100 + 0x200 + 0x8000)

    beam_info.m_flStartX = startpos.x
    beam_info.m_flStartY = startpos.y
    beam_info.m_flStartZ = startpos.z

    beam_info.m_flEndX = endpos.x
    beam_info.m_flEndY = endpos.y
    beam_info.m_flEndZ = endpos.z

    local beam = create_beam_points(render_beams_class, beam_info)

    if beam ~= nil then
        draw_beams(render_beams, beam)
    end
end

local m_vecVelocity = {
    [0] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[0]"),
    [1] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[1]"),
}
local m_vecOrigin = se.get_netvar("DT_BaseEntity", "m_vecOrigin")

local prev_origin = nil

client.register_callback('paint', function ()
    if not enable:get_value() then return end

    local me = entitylist.get_local_player()

    if not me or not me:is_alive() then return end

    local velocity = math.sqrt(me:get_prop_float(m_vecVelocity[0]) ^ 2 + me:get_prop_float(m_vecVelocity[1]) ^ 2)

    if velocity > 255 then
        velocity = 255
    end

    if velocity == 0 then return end

    local render_origin = me:get_prop_vector(m_vecOrigin)

    if not prev_origin then
        prev_origin = render_origin
    end

    local clr = color:get_value()

    if is_rgb:get_value() then
        local rt = globalvars.get_real_time()

        local r, g, b = 
            (math.sin(rt * 3) * 0.5 + 0.5) * 255,
            (math.sin(rt * 3 + 2) * 0.5 + 0.5) * 255,
            (math.sin(rt * 3 + 4) * 0.5 + 0.5) * 255

        create_beams(prev_origin, render_origin, r, g, b, velocity)
    else
        create_beams(prev_origin, render_origin, clr.r, clr.g, clr.b, velocity)
    end

    prev_origin = render_origin
end)
