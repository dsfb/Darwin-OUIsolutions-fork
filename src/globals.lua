private_darwin.resset_lua = function()
    private_darwin.main_lua_code          = ""
    private_darwin.require_parse_to_bytes = false
    private_darwin.globals_already_setted = {}
end

private_darwin.resset_c = function()
    private_darwin.cglobals_size    = 1
    private_darwin.cglobals         = ""

    private_darwin.include_code     = ""
    private_darwin.c_calls          = {}

    private_darwin.lua_globals_size = 1
    private_darwin.lua_globals      = ""
end

private_darwin.resset_all = function()
    private_darwin.resset_lua()
    private_darwin.resset_c()
end
