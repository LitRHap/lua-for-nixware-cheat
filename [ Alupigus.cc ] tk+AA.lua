
local m_iTeamNum = se.get_netvar("DT_BasePlayer", "m_iTeamNum")
local a1 = 0
local a2 = 0
local a3 =
{
        " βπΌ ",
        " βπΌπ‘ ",
		" βπΌπ‘πͺ ",
        " βπΌπ‘πͺπ₯ ",
		" βπΌπ‘πͺπ₯π ",
        " βπΌπ‘πͺπ₯ππ ",
		" βπΌπ‘πͺπ₯πππͺ ",
        " βπΌπ‘πͺπ₯πππͺπ¨ ",
		" βπΌπ‘πͺπ₯πππͺπ¨. ",
        " βπΌπ‘πͺπ₯πππͺπ¨.π ",
		" βπΌπ‘πͺπ₯πππͺπ¨.ππ ",
        " βπΌπ‘πͺπ₯πππͺπ¨.ππ ",
		" βπΌπ‘πͺπ₯πππͺπ¨.π ",
        " βπΌπ‘πͺπ₯πππͺπ¨. ",
		" βπΌπ‘πͺπ₯πππͺπ¨ ",
        " βπΌπ‘πͺπ₯πππͺ ",
        " βπΌπ‘πͺπ₯ππ ",
	    " βπΌπ‘πͺπ₯π ",
        " βπΌπ‘πͺπ₯ ",
		" βπΌπ‘πͺ ",
	    " βπΌπ‘ ",
		" βπΌ ",


}

function paint()
	
    if engine.is_in_game() then
        if a1 < globalvars.get_tick_count() then     
            a2 = a2 + 1
            if a2 > 57 then
                a2 = 0
            end
            se.set_clantag(a3[a2])
            a1 = globalvars.get_tick_count() + 40
        end
    end
end

client.register_callback("paint", paint)

local messages = {
    {
        "get good. get βπΌπ‘πͺπ₯πππͺπ¨.ππ e",
        "owned by βπΌπ‘πͺπ₯πππͺπ¨.ππ "
    },
    {
        "Think you could do better? Not without βπΌπ‘πͺπ₯πππͺπ¨.ππ ",
        "If I was cheating, I'd use βπΌπ‘πͺπ₯πππͺπ¨.ππ ",
        "I'm not using www.EZFrags.co.uk, you're just bad",
        "Visit www.EZFrags.co.uk for the finest  private CS:GO cheats",
        "Stop being a noob! Get good with βπΌπ‘πͺπ₯πππͺπ¨.ππ ",
        "You just got pwned by βπΌπ‘πͺπ₯πππͺπ¨.ππ , the #1 CS:GO cheat"
    }
}

ui.Combo("kill spam", "misc_killsay", {
    "none",
    "Alupigus.cc",
    "antiaim v2",
    "1"
}, 0)

ui.Checkbox("include name", "misc_killsay_name", false)

client.RegisterCallback("FireGameEvent", function (event)
    local index = ui.GetInt("misc_killsay")

    if index == 0 then
        return
    end

    if event:GetName() == "player_death" then
        local attacker = engine.GetPlayerIndexByUserID(event:GetInt("attacker", 0))
        local dead = engine.GetPlayerIndexByUserID(event:GetInt("userid", 0))
        local me = engine.GetLocalPlayer()

        if attacker == me and dead ~= me then
            local target = entitylist.GetPlayerByIndex(dead)
            local text = ""

            if ui.GetBool("misc_killsay_name") then
                text = target:GetName() .. ", "
            end

            if messages[index] then
                local message = messages[index]

                text = text .. message[client.RandomInt(1, #message)]
            else
                text = text .. "1"
            end

            engine.ExecuteClientCmd("say " .. text)
        end
    end
end)


