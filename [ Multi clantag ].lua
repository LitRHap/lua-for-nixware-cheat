os.execute("mkdir C:\\BetterClantags")

local clantags_enabled = ui.add_check_box("Enable BetterClantags", "clantags_enabled", false)
local clantag_type = ui.add_combo_box("Clantag", "clantag_type", {"Custom", "YIFENG", "Fatality", "Ev0lve", "NeverLose", "GameSense", "YIFENG2"}, 0)
local custom_clantag_type = ui.add_combo_box("Custom clantag type", "custom_clantag_type", {"Static", "Dynamic (From file)"}, 0)
local custom_clantag = ui.add_text_input("Custom clantag / Clantag file", "custom_clantag", "Enter ur clantag / clantag file")
local a1 = 0
local a2 = 0
local clantag = " "

client.notify("BetterClantags v1.0 by rednik")


function set_ctag()

    if clantag_type:get_value() == 0 and clantags_enabled:get_value() == true then
        if custom_clantag_type:get_value() == 0 then

            clantag = {
                custom_clantag:get_value(),
            }

        elseif custom_clantag_type:get_value() == 1 then
            clantag = {}
            for line in io.lines("C:\\BetterClantags\\" .. custom_clantag:get_value()) do
                clantag[#clantag+ 1] = line
            end
        end

    elseif clantag_type:get_value() == 1 and clantags_enabled:get_value() == true then
        clantag = {
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
            "逸风nix",
        }

    elseif clantag_type:get_value() == 2 and clantags_enabled:get_value() == true then
        clantag = {
            " ",
            "f",
            "fa",
            "fat",
            "fata",
            "fatal",
            "fatali",
            "fatality",
            "fatality",
            "fatality",
            "fatality",
            "fatality",
            "atality",
            "tality",
            "ality",
            "lity",
            "ity",
            "ty",
            "y",
            " ",
        }

    elseif clantag_type:get_value() == 3 and clantags_enabled:get_value() == true then
        clantag = {
            " ",
            "e",
            "ev",
            "ev0",
            "ev0l",
            "ev0l",
            "ev0lv",
            "ev0lve",
            "ev0lve.",
            "ev0lve.x",
            "ev0lve.xy",
            "ev0lve.xyz",
            "ev0lve.xyz",
            "ev0lve.xyz",
            "ev0lve.xyz",
            "ev0lve.xyz",
            "ev0lve.xyz",
            "v0lve.xyz",
            "0lve.xyz",
            "lve.xyz",
            "ve.xyz",
            "e.xyz",
            ".xyz",
            "xyz",
            "yz",
            "z",
            " ",
        }

    elseif clantag_type:get_value() == 4 and clantags_enabled:get_value() == true then
        clantag = {
            " ",
            "N ",
            "N3 ",
            "Ne ",
            "Ne\\ ",
            "Ne\\/ ",
            "Nev ",
            "Nev3 ",
            "Neve ",
            "Neve| ",
            "Neve|2 ",
            "Never| ",
            "Never|_ ",
            "Neverl ",
            "Neverl0 ",
            "Neverlo ",
            "Neverlo5 ",
            "Neverlos ",
            "Neverlos3 ",
            "Neverlose ",
            "Neverlose. ",
            "Neverlose.< ",
            "Neverlose.c< ",
            "Neverlose.cc ",
            "Neverlose.c< ",
            "Neverlose.< ",
            "Neverlose. ",
            "Neverlose ",
            "Neverlos3 ",
            "Neverlos ",
            "Neverlo_ ",
            "Neverlo5 ",
            "Neverlo ",
            "Neverl_ ",
            "Never|0 ",
            "Never| ",
            "Neve|2 ",
            "Neve| ",
            "Neve ",
            "Nev3 ",
            "Nev ",
            "Ne\\/ ",
            "Ne\\ ",
            "Ne ",
            "N3 ",
            "N ",
            "|\\| ",
    
        }

    elseif clantag_type:get_value() == 5 and clantags_enabled:get_value() == true then
        clantag = {
            "g              ",
            "ga             ",
            "gam            ",
            "game           ",
            "games          ",
            "gamese         ",
            "gamesen        ",
            "gamesens       ",
            "gamesense      ",
             "      amesense",
             "       mesense",
             "        esense",
             "         sense",
             "          ense",
             "           nse",
             "            se",
             "            ",
        }

    elseif clantag_type:get_value() == 6 and clantags_enabled:get_value() == true then
        clantag = {
            "逸",
            "逸风",
            "逸风n",
            "逸风n",
            "逸风ni",
            "逸风ni",
            "逸风nix",
            "逸风nix",
        }
    else
        clantag = {
            " ",
        }
    end

    if engine.is_in_game() then
        if a1 < globalvars.get_tick_count() then     
            a2 = a2 + 1
            if a2 > 50 then
                a2 = 0
            end
            se.set_clantag(clantag[a2])
            a1 = globalvars.get_tick_count() + 20
        end
    end
end


client.register_callback("paint", set_ctag)