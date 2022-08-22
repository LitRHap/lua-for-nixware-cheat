
g_FakelagModes = {

	"Disabled",
	"Matchmaking",
	"Static",
	"Break LC",
    "Random",
	"Velocity based"
}

g_ExploitFakelagModes = {

	"Disabled",
	"Small",
	"Medium",
	"Big",
    "Break Tickbase"
}

local g_Enabled = ui.add_check_box("Advanced Fakelag Modes", "_enabler", false)
local g_FakelagMode = ui.add_combo_box("Fakelag Mode", "_Fakelag_Mode", g_FakelagModes, 0)

local g_ExploitEnabled = ui.add_check_box("On Exploit Fakelag", "_Exploit_enabler", false)
local g_ExploitFakelagMode = ui.add_combo_box("Exploit Fakelag Mode", "_Exploit_Fakelag_Mode", g_ExploitFakelagModes, 0)

local g_ExploitBind = ui.get_key_bind("rage_active_exploit_bind")
local g_Exploit = ui.get_combo_box("rage_active_exploit")

function g_Exploits()
    if g_ExploitBind:is_active() and g_Exploit:get_value() > 0 then 
        return true
    end
end

client.register_callback("create_move", function(cmd)

    if g_Enabled:get_value(true) and not g_Exploits() then

        if g_FakelagMode:get_value() == 0 then --Disabled
            if clientstate.get_choked_commands() < 1 then
                cmd.send_packet = false
            end
        end

        if g_FakelagMode:get_value() == 1 then --Matchmaking
            if clientstate.get_choked_commands() < 6 then
                cmd.send_packet = false
            end
        end

        if g_FakelagMode:get_value() == 2 then --Static
            if clientstate.get_choked_commands() < 14 then
                cmd.send_packet = false
            end
        end

        if g_FakelagMode:get_value() == 3 then --Break LC
            if clientstate.get_choked_commands() < math.random(13, 15) then
                cmd.send_packet = false
            end
        end

        if g_FakelagMode:get_value() == 4 then --Random
            if clientstate.get_choked_commands() < math.random(3, 14) then
                cmd.send_packet = false
            end
        end

        if g_FakelagMode:get_value() == 5 then --Velocity based

            local g_Local = entitylist.get_local_player()

            m_vecVelocity = {
                [0] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[0]"),
                [1] = se.get_netvar("DT_BasePlayer", "m_vecVelocity[1]")
            }

            local g_Velocity = math.sqrt(g_Local:get_prop_float(m_vecVelocity[0]) ^ 2 + g_Local:get_prop_float(m_vecVelocity[1]) ^ 2)
            
            local Standing = math.floor(g_Velocity) < 5

            local Micro_Move = math.floor(g_Velocity) > 35

            local Pre_Moving = math.floor(g_Velocity) > 75
            local Moving = math.floor(g_Velocity) > 110

            local Pre_Running = math.floor(g_Velocity) > 175
            local Running = math.floor(g_Velocity) > 225

            if clientstate.get_choked_commands() < 4 and Standing then
                cmd.send_packet = false
            end

            if clientstate.get_choked_commands() < 5 and Micro_Move then
                cmd.send_packet = false
            end

            if clientstate.get_choked_commands() < 6 and Pre_Moving then
                cmd.send_packet = false
            end

            if clientstate.get_choked_commands() < 8 and Moving then
                cmd.send_packet = false
            end

            if clientstate.get_choked_commands() < 12 and Pre_Running then
                cmd.send_packet = false
            end

            if clientstate.get_choked_commands() < 15 and Running then
                cmd.send_packet = false
            end
        end
    end

    if g_ExploitEnabled:get_value(true) and g_Exploits() then

        if g_ExploitFakelagMode:get_value() == 0 then --Disabled
            if clientstate.get_choked_commands() < 0 then
                cmd.send_packet = false
            end
        end

        if g_ExploitFakelagMode:get_value() == 1 then --Small
            if clientstate.get_choked_commands() < 1 then
                cmd.send_packet = false
            end
        end
        
        if g_ExploitFakelagMode:get_value() == 2 then --Medium
            if clientstate.get_choked_commands() < 2 then
                cmd.send_packet = false
            end
        end

        if g_ExploitFakelagMode:get_value() == 3 then --Big
            if clientstate.get_choked_commands() < 3 then
                cmd.send_packet = false
            end
        end

        if g_ExploitFakelagMode:get_value() == 4 then --Break Tickbase
            if clientstate.get_choked_commands() < 4 then
                cmd.send_packet = false
            end
        end
    end
end)