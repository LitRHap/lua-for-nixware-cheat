--Spastil Soull♥

local screen = engine.get_screen_size()

local lbg = ui.add_key_bind("Legit Bot", "lbg", 0, 2)
local bctr = ui.add_key_bind("Backtrack", "backtracking", 0, 2)
local chams = ui.add_key_bind("Chams", "chams", 0, 2)
local legitaa = ui.add_key_bind("Legit AA", "LegitAA", 0, 2)
local esp1 = ui.add_key_bind("ESP", "esp1", 0, 2)
local esp2 = ui.add_key_bind("Sound Esp Only", "esp2", 0, 2)
local indw = ui.add_check_box("Indicators", "idnw", false)
local sx = ui.add_slider_int('Position x', 'lh_indicators_pos_x', 0, screen.x, 20)
local sy = ui.add_slider_int('Position y', 'lh_indicators_pos_y', 0, screen.y, 120)
-----------------------------------------------------------------------------------
local legit_enable = ui.get_check_box("legit_enable")
client.register_callback("paint", function()
    if lbg:is_active() then
        legit_enable:set_value(true)
    else
        legit_enable:set_value(false)
    end
end)

-----------------------------------------------------------------------------------
local legit_backtracking = ui.get_check_box("legit_backtracking")
client.register_callback("paint", function()
    if bctr:is_active() then
        legit_backtracking:set_value(true)
    else
        legit_backtracking:set_value(false)
    end
end)

-----------------------------------------------------------------------------------
local visuals_models_enemy_enable = ui.get_check_box("visuals_models_enemy_enable")
client.register_callback("paint", function()
    if chams:is_active() then
        visuals_models_enemy_enable:set_value(true)
    else
        visuals_models_enemy_enable:set_value(false)
    end
end)

-----------------------------------------------------------------------------------
local visuals_models_enemy_enable = ui.get_check_box("visuals_models_enemy_enable")
client.register_callback("paint", function()
    if chams:is_active() then
        visuals_models_enemy_enable:set_value(true)
    else
        visuals_models_enemy_enable:set_value(false)
    end
end)

--------------------------------------------------------------------------
local antihit_antiaim_enable = ui.get_check_box("antihit_antiaim_enable")
client.register_callback("paint", function()
    if legitaa:is_active() then
        antihit_antiaim_enable:set_value(true)
    else
        antihit_antiaim_enable:set_value(false)
    end
end)

-----------------------------------------------------------------------------------
local visuals_esp_enemy_enable = ui.get_check_box("visuals_esp_enemy_enable")
client.register_callback("paint", function()
    if esp1:is_active() then
        visuals_esp_enemy_enable:set_value(true)
    else
        visuals_esp_enemy_enable:set_value(false)
    end
end)

-----------------------------------------------------------------------------------
local visuals_esp_enemy_box = ui.get_check_box("visuals_esp_enemy_box")
local visuals_esp_enemy_name = ui.get_check_box("visuals_esp_enemy_name")
local visuals_esp_enemy_weapon = ui.get_check_box("visuals_esp_enemy_weapon")
local visuals_esp_enemy_weapon_icon = ui.get_check_box("visuals_esp_enemy_weapon_icon")
local visuals_esp_enemy_ammo = ui.get_check_box("visuals_esp_enemy_ammo")
local visuals_esp_enemy_skeleton = ui.get_check_box("visuals_esp_enemy_skeleton")
local visuals_esp_enemy_history_skeleton = ui.get_check_box("visuals_esp_enemy_history_skeleton")
local visuals_esp_enemy_multipoints = ui.get_check_box("visuals_esp_enemy_multipoints")
local visuals_esp_enemy_sound = ui.get_check_box("visuals_esp_enemy_sound")
local visuals_esp_enemy_health = ui.get_check_box("visuals_esp_enemy_health")
local visuals_esp_enemy_glow = ui.get_check_box("visuals_esp_enemy_glow")
local visuals_esp_enemy_armor = ui.get_check_box("visuals_esp_enemy_armor")
local visuals_esp_enemy_arrows = ui.get_check_box("visuals_esp_enemy_arrows")
local visuals_esp_enemy_tracers = ui.get_check_box("visuals_esp_enemy_tracers")

client.register_callback("paint", function()                                       
    if esp2:is_active() then
        visuals_esp_enemy_box:set_value(false)
        visuals_esp_enemy_name:set_value(false)
        visuals_esp_enemy_weapon:set_value(false)
        visuals_esp_enemy_weapon_icon:set_value(false)
        visuals_esp_enemy_ammo:set_value(false)
        visuals_esp_enemy_skeleton:set_value(false)
        visuals_esp_enemy_history_skeleton:set_value(false)
        visuals_esp_enemy_multipoints:set_value(false)
        visuals_esp_enemy_sound:set_value(true)
        visuals_esp_enemy_health:set_value(false)
        visuals_esp_enemy_glow:set_value(false)
        visuals_esp_enemy_armor:set_value(false)
        visuals_esp_enemy_arrows:set_value(false)
        visuals_esp_enemy_tracers:set_value(false)
    else
        visuals_esp_enemy_box:set_value(false)
        visuals_esp_enemy_name:set_value(true)
        visuals_esp_enemy_weapon:set_value(false)
        visuals_esp_enemy_weapon_icon:set_value(false)
        visuals_esp_enemy_ammo:set_value(false)
        visuals_esp_enemy_skeleton:set_value(false)
        visuals_esp_enemy_history_skeleton:set_value(false)
        visuals_esp_enemy_multipoints:set_value(false)
        visuals_esp_enemy_sound:set_value(false)
        visuals_esp_enemy_health:set_value(true)
        visuals_esp_enemy_glow:set_value(true)
        visuals_esp_enemy_armor:set_value(false)
        visuals_esp_enemy_arrows:set_value(false)
        visuals_esp_enemy_tracers:set_value(false)
    end
end)

local font = renderer.setup_font('C:/Windows/Fonts/TahomaBD.ttf', 30, 16)

local indicators = {}

local binds = {
    { name = 'LegitBot', cfg = lbg ,type = 'key_bind' },
    { name = 'Backtrack', cfg = bctr, type = 'key_bind' },
    { name = 'Chams', cfg = chams, type = 'key_bind' },
    { name = 'LegitAA', cfg = legitaa, type = 'key_bind' },
    { name = 'ESP', cfg = esp1, type = 'key_bind' },
    { name = 'Sound Only', cfg = esp2, type = 'key_bind' }
}


local function add_indicator(indicator)
    table.insert(indicators, indicator)
end

local function render_text(text, x, y, color)
    renderer.text(tostring(text), font, vec2_t.new(x, y + 1), 30, color_t.new(0, 0, 0, 255))
    renderer.text(tostring(text), font, vec2_t.new(x, y), 30, color)
end

local function render_filled_rect(x, y, w, h, color)
    renderer.rect_filled(vec2_t.new(x, y), vec2_t.new(x+w, y+h), color)
end

local function draw_indicators()
    local x = sx:get_value()
    local h = screen.y - 50 - sy:get_value()
    local y = 30 * #indicators
    for key, value in pairs(indicators) do
        local addition = 0
        local sizes = renderer.get_text_size(font, 30, value.text)
       
        render_text(value.text, x, h - y, value.color)
        addition = addition - sizes.y
        y = y + addition
    end
end

local function on_paint()
    if not indw:get_value() then 
        return
    end

    if not engine.is_in_game() then return end
    local player = entitylist.get_local_player()
    indicators = {}
    if not player or not player:is_alive() then return end
    for i = 1, #binds do
        local bind = binds[i]
        local name = bind.name
           
        if type(name) == 'table' then
            name = name[e + 1]
        end

        local information = {}
   
        if bind.type == 'key_bind' then
            if bind.cfg:is_active() then
                information = {
                    text = name,
                    color = color_t.new(0, 255, 0, 255)
                }
            end
        end

        if information.text then
            add_indicator(information)
        end

    end
    draw_indicators()
end

client.register_callback('paint', on_paint)