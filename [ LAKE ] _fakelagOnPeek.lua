
--credits: https://nixware.cc/members/73215/

fakelag = true

fakelag_condition_enabled = ui.add_check_box("enabled", "fakelag_condition_enabled", false)
fakelag_condition_limit = ui.add_slider_int("condition limit", "fakelag_condition_limit", 0, 14, 0)

client.register_callback("shot_fired", function(shot_info)

    if fakelag_condition_enabled:get_value() == true then
        
        fakelag = false

        ui.get_check_box("antihit_fakelag_enable"):set_value(fakelag)
        ui.get_slider_int("antihit_fakelag_trigger_limit"):set_value(fakelag_condition_limit:get_value())
        
    end
end)

client.register_callback("create_move", function(cmd)

    if fakelag_condition_enabled:get_value() == false then return end

    if fakelag == true then

        ui.get_check_box("antihit_fakelag_enable"):set_value(fakelag)
    end

    if fakelag == false and IsWeaponCanShoot() == true then

        fakelag = true
        ui.get_check_box("antihit_fakelag_enable"):set_value(fakelag)
    end
end)

function IsWeaponCanShoot()

    local weapon = entitylist.get_entity_from_handle(entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BaseCombatCharacter", "m_hActiveWeapon")))
    local servertime = entitylist.get_local_player():get_prop_int(se.get_netvar("DT_BasePlayer", "m_nTickBase")) * globalvars.get_interval_per_tick()

    return weapon:get_prop_float(se.get_netvar("DT_BaseCombatWeapon", "m_flNextPrimaryAttack")) <= servertime;

end