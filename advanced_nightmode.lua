local lua_brightness = ui.add_slider_float("brightness", "lua_brightness", 0.01, 1.0, 1.0)
local lua_modelambient = ui.add_slider_float("model ambient", "lua_modelambient", 0.0, 10.0, 0.0)
local lua_bloomscale = ui.add_slider_float("bloom scale", "lua_bloomscale", 0.0, 10.0, 1)

local lua_fog_enable = ui.add_check_box("enable fog", "lua_fog_enable", false)
local lua_fog_start = ui.add_slider_float("fog start", "lua_fog_start", 0, 2500.00, 0)
local lua_fog_end = ui.add_slider_float("fog end", "lua_fog_end", 0, 2500.00, 2500.00)
local lua_fog_color = ui.add_color_edit("fog color", "lua_fog_color", false, color_t.new(255, 255, 255, 255))

local r_model_ambient_min = se.get_convar("r_modelAmbientMin")
local mat_force_tonemap_scale = se.get_convar("mat_force_tonemap_scale")

local m_custom_bloom_scale = se.get_netvar("DT_EnvTonemapController", "m_flCustomBloomScale")
local m_fog_enable = se.get_netvar("DT_FogController", "m_fog.enable")
local m_fog_blend = se.get_netvar("DT_FogController", "m_fog.blend")
local m_fog_start = se.get_netvar("DT_FogController", "m_fog.start")
local m_fog_end = se.get_netvar("DT_FogController", "m_fog.end")
local m_fog_maxdensity = se.get_netvar("DT_FogController", "m_fog.maxdensity")
local m_fog_colorPrimary = se.get_netvar("DT_FogController", "m_fog.colorPrimary")
local m_fog_colorSecondary = se.get_netvar("DT_FogController", "m_fog.colorSecondary")

local visuals_other_removals = ui.get_multi_combo_box("visuals_other_removals")

local originals = { r_model_ambient_min:get_float(), mat_force_tonemap_scale:get_float(), visuals_other_removals:get_value(5)  }

-- https://gist.github.com/marceloCodget/3862929
local function rgb_to_hex(rgb)
    local hexadecimal = '0x'

    for key, value in pairs(rgb) do
        local hex = ''

        while(value > 0)do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex           
        end

        if(string.len(hex) == 0)then
            hex = '00'

        elseif(string.len(hex) == 1)then
            hex = '0' .. hex
        end

        hexadecimal = hexadecimal .. hex
    end

    return hexadecimal
end

client.register_callback("frame_stage_notify", function(stage)
    if stage == 5 then
        
        -- CEnvTonemapController
        local entities = entitylist.get_entities_by_class_id(69)

        local brightness = lua_brightness:get_value()
        local ambient = lua_modelambient:get_value()
        local bloom = lua_bloomscale:get_value()

        r_model_ambient_min:set_float(ambient)
        mat_force_tonemap_scale:set_float(brightness)

        for i = 1, #entities do   
            entities[i]:set_prop_float(m_custom_bloom_scale, bloom)
        end

        -- CFogController
        entities = entitylist.get_entities_by_class_id(78)
    
        local lua_fog_color = lua_fog_color:get_value()
        local color = tonumber( rgb_to_hex( { lua_fog_color.b, lua_fog_color.g, lua_fog_color.r } ) )
    
        for i = 1, #entities do
            local entity = entities[i]
    
            entity:set_prop_bool(m_fog_enable, lua_fog_enable:get_value())
            entity:set_prop_bool(m_fog_blend, lua_fog_enable:get_value())

            entity:set_prop_float(m_fog_start, lua_fog_start:get_value())
            entity:set_prop_float(m_fog_end, lua_fog_end:get_value())
            entity:set_prop_float(m_fog_maxdensity, 1.0)
    
            entity:set_prop_int(m_fog_colorPrimary, color)
            entity:set_prop_int(m_fog_colorSecondary, color)
        end
    end
end)

client.register_callback("unload", function()
    visuals_other_removals:set_value(5, originals[3])
    
    -- CEnvTonemapController
    local entities = entitylist.get_entities_by_class_id(69)

    r_model_ambient_min:set_float(originals[1])
    mat_force_tonemap_scale:set_float(originals[2])

    for i = 1, #entities do   
        entities[i]:set_prop_float(m_custom_bloom_scale, 1.0)
    end

    -- CFogController
    entities = entitylist.get_entities_by_class_id(78)

    for i = 1, #entities do
        local entity = entities[i]

        entity:set_prop_bool(m_fog_enable, false)
        entity:set_prop_bool(m_fog_blend, false)

        entity:set_prop_float(m_fog_start, -1)
        entity:set_prop_float(m_fog_end, -1)
        entity:set_prop_float(m_fog_maxdensity, -1)

        entity:set_prop_int(m_fog_colorPrimary, 0)
        entity:set_prop_int(m_fog_colorSecondary, 0)
    end

    clientstate.force_full_update()
end)