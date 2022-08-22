local ffi = require 'ffi'

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
]]

local ENTITY_LIST_POINTER = ffi.cast("void***", se.create_interface("client.dll", "VClientEntityList003")) or error("Failed to find VClientEntityList003!")
local GET_CLIENT_ENTITY_FN = ffi.cast("GetClientEntity_4242425_t", ENTITY_LIST_POINTER[0][3])

local ffi_helpers = {
    get_animstate_offset = function()
        return 14612
    end,

    get_entity_address = function(entity_index)
        local addr = GET_CLIENT_ENTITY_FN(ENTITY_LIST_POINTER, entity_index)
        return addr
    end
}

local function on_create_move(cmd) 
	local localplayer = entitylist.get_local_player()
	if not localplayer then return end
    ffi.cast("float*", ffi_helpers.get_entity_address(localplayer:get_index()) + 10100)[0] = 0
    --print('ya')
end

function leg_breaker(cmd)  
    if switch then
        switch = false
    else
         switch = true
    end

    if switch then
        local antiaim_active_movement_type = ui.get_combo_box("antihit_extra_leg_movement"):set_value(1)
    else
        local antiaim_active_movement_type = ui.get_combo_box("antihit_extra_leg_movement"):set_value(2)
    end
end

client.register_callback("create_move", on_create_move)
client.register_callback("create_move", leg_breaker)