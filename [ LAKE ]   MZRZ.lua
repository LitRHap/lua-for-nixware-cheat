local function rmnan(x)
    return x ~= x and 0 or x;
end

local function round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5);
end

local function get_color(info)
    if (info.reason == "desync") then
        return color_t.new(255, 0, 0, 255);
    elseif (info.reason == "unknown") then
        return color_t.new(255, 191, 0, 255)
    elseif (info.reason == "spread") then
        return color_t.new(255, 89, 0, 255);
    elseif (info.reason == "death") then
        return color_t.new(9, 255, 0, 255);
    end

    return color_t.new(0, 140, 255, 255);
end

local server_hitgroups =
{
    [1] = "generic",
    [2] = "head",
    [3] = "chest",
    [4] = "Stomach",
    [5] = "left arm",
    [6] = "right arm",
    [7] = "left leg",
    [8] = "right leg",
    [9] = "Body"
};

local client_hitboxes =
{
    [0] = "head",
    [2] = "neck",
    [3] = "Stomach",
    [5] = "breast",
    [9] = "left leg",
    [10] = "right leg",
    [11] = "left foot",
    [12] = "right foot"
};

local this = ffi.cast("unsigned long**", client.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08") + 1)[0]
local find_hud_element = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", client.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))

local function get_vfunc(ptr, typedef, index) 
    return ffi.cast(typedef, ffi.cast("void***", ptr)[0][index])
end

local hud_chat = find_hud_element(this, "CHudChat")
local chat_print = get_vfunc(hud_chat, "void(__cdecl*)(int, int, int, const char*, ...)", 27)

local function print_chat(iplayerindex, ifilter, text)
    chat_print(hud_chat, iplayerindex, ifilter, text)
end

ffi.cdef[[
    struct c_color { unsigned char clr[4]; };
]]

Delcui_color = ui.get_color_edit('misc_ui_color')

Delcengine_cvar = ffi.cast("void***", se.create_interface("vstdlib.dll", "VEngineCvar007"))
Delcconsole_print = ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", Delcengine_cvar[0][25])

Delcconsole_color = ffi.new('struct c_color');
Delcconsole_color.clr[3] = 255;

Delcchat_colors = {
    spread = { 255, 255, 0 },
    desync = { 255, 0, 0 },
    unk = { 0, 255, 0 },
    occlusion = { 255, 165, 0 },
    death = { 0, 0, 0 },
}


function Delcprint_console(text, color)
    Delcdef_color = { 255, 255, 255 }

    Delcconsole_color.clr[0] = Delcdef_color.r
    Delcconsole_color.clr[1] = Delcdef_color.g
    Delcconsole_color.clr[2] = Delcdef_color.b
    Delcconsole_print(Delcengine_cvar, Delcconsole_color, '[30 awp hs] ')

    Delcconsole_color.clr[0] = color[1]
    Delcconsole_color.clr[1] = color[2]
    Delcconsole_color.clr[2] = color[3]
    Delcconsole_print(Delcengine_cvar, Delcconsole_color, tostring(text) .. '\n')
end

local hitlist_id = 0

local m_iHealth = se.get_netvar("DT_BasePlayer", "m_iHealth")

client.register_callback("shot_fired", function(shot)
    if (shot.manual) then
        return;
    end
    
    local r_hitbox = server_hitgroups[shot.server_hitgroup + 1];
    if (shot.result ~= "hit") then
        r_hitbox = client_hitboxes[shot.hitbox];
    end

    hitlist_id = hitlist_id + 1;
    local percent = "%"
    local info = 
    {
        id = hitlist_id,
        player = engine.get_player_info(shot.target:get_index()).name,
        damage = tostring(shot.server_damage) .. (shot.server_damage == shot.client_damage and "" or "(" .. tostring(shot.client_damage) .. ")"),
        hprem = tostring(shot.target:get_prop_int(m_iHealth)),
        hitbox = r_hitbox,
        backtrack = shot.backtrack > 0 and tostring(shot.backtrack) .. " tick" .. (shot.backtrack == 1 and "" or "s") or "0 ticks",
        hitchance = shot.hitchance,
        safepoint = shot.safe_point,
        reason = shot.result == "hit" and "-" or (shot.result == "unk" and "unknown" or shot.result)
    };
    
    if shot.result == "hit" then
        print_chat(0, 0, "\x01[\x0dBinGaanspeak in your ear\x01] \x01hit \x04" .. info.player .. "  \x01of \x04" .. info.hitbox .. " \x01\x01remainingHP \x02" .. info.hprem .. "     \x01hit rate: \x10" .. tostring(info.hitchance) .. " \x01   \x01Safe point: \x10" .. tostring(info.safepoint));
    elseif shot.result == "unk" or shot.result == "spread" or shot.result == "occlusion" or shot.result == "desync" or shot.result == "death" then
        if shot.result == "Parse" then
            shot.result = "?"
        end
        print_chat(0, 0, "\x01[\x0dBinGaanspeak in your ear\x01] " .. info.player .. "\x07's \x10" .. info.hitbox .. " \x07because \x10" .. info.reason .. " \x01| \x07try backtracking \x10".. info.backtrack .. " \x01| \x07target hit rate: \x10" .. tostring(info.hitchance) .. " \x01| \x07Safe point: \x10" .. tostring(info.safepoint));
    end  
end)