
local m_iTeamNum = se.get_netvar("DT_BasePlayer", "m_iTeamNum")
local a1 = 0
local a2 = 0
local a3 =
{
        " >A ",
        " >Al ",
		" >Alu ",
        " >Alup ",
		" >Alupi ",
        " >Alupig ",
		" >Alupigu ",
        " >Alupigus ",
		" >Alupigus. ",
        " >Alupigus.c ",
		" >Alupigus.cc ",
        " >Alupigus.cc ",
		" >Alupigus.c ",
        " >Alupigus.",
		" >Alupigus ",
        " >Alupigu ",
        " >Alupig ",
	    " >Alupi ",
        " >Alup ",
		" >Alu ",
	    " >Al ",
		" >A ",


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

