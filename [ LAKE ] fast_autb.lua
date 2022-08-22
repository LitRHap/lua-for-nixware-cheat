local buybotOn = ui.add_check_box("BuyBot Enable", "buybotOn", false)
local primary_buy = ui.add_combo_box("Primary", "primary_buy", { "None", "Auto", "Scout", "AWP"}, 0)
local secondary_buy = ui.add_combo_box("Secondary", "secondary_buy", { "None", "Deagle/R8", "Duals", "P250", "Fiveseven/Tec9/Cz75"}, 0)
local utility_buy = ui.add_multi_combo_box("Utilities", "utility_buy",  { "Full Armor", "HE Grenade", "Molotov/Incendiary Grenade", "Smoke Grenade", "Taser", "Defuse Kit" }, { false, false, false, false, true, false })

local primary_b =
{
    [1] = ("buy scar20; buy g3sg1"),
    [2] = ("buy ssg08"),
    [3] = ("buy awp"),
}

local secondary_b =
{
    [1] = ("buy revolver; buy deagle"),
    [2] = ("buy elite"),
    [3] = ("buy p250"),
    [4] = ("buy tec9; buy fiveseven"),
}

local function buybot_act()
	
    if primary_buy:get_value() ~= 0 then
        engine.execute_client_cmd(primary_b[primary_buy:get_value()])
    end

    if secondary_buy:get_value() ~= 0 then
        engine.execute_client_cmd(secondary_b[secondary_buy:get_value()])
    end
    
    if utility_buy:get_value(0) ~= false then
        engine.execute_client_cmd("buy vest; buy vesthelm")
    end
    
    if utility_buy:get_value(1) ~= false then
        engine.execute_client_cmd("buy hegrenade")
    end
    if utility_buy:get_value(2) ~= false then
        engine.execute_client_cmd("buy molotov; buy incgrenade")
    end
    if utility_buy:get_value(3) ~= false then
        engine.execute_client_cmd("buy smokegrenade")
    end    

    if utility_buy:get_value(4) ~= false  then
        engine.execute_client_cmd("buy taser")
    end

    if utility_buy:get_value(5) ~= false then
        engine.execute_client_cmd("buy defuser")
    end
    
    return
    
end

client.register_callback("round_prestart", function(event)

    if buybotOn:get_value() == true then 
        buybot_act()
    end
end)