-- eliminantes unwanted prints
darwin.add_c_code("\n#undef printf\n")
darwin.add_c_code("#define printf(...) \n")




darwin.add_c_file("LuaDoTheWorld/src/one.c", true, function(import, path)
    -- to make the luacembe not be imported twice
    if import == "../dependencies/dependency.LuaCEmbed.h" then
        return false
    end
    return true
end)

darwin.add_c_file("candangoEngine/src/main.c", true, function(import, path)
    -- to make the luacembe not be imported twice
    if import == "../dependencies/depB.LuaCEmbed.h" then
        return false
    end
    return true
end)

darwin.add_c_code("\n#undef printf\n")



---@type Asset[]
local assets = {}

local assets_files = dtw.list_files_recursively("assets", false)
for i = 1, #assets_files do
    local current_item = assets_files[i]
    local path = "assets/" .. current_item
    assets[#assets + 1] = {
        path = current_item,
        content = dtw.load_file(path)
    }
end

local assets_dirs = dtw.list_dirs_recursively("assets", false)
for i = 1, #assets_dirs do
    local current_item  = assets_dirs[i]
    ---removing / at the end of the the dir
    current_item        = string.sub(current_item, 0, #current_item - 1)
    assets[#assets + 1] = {
        path = current_item
    }
end


darwin.embed_global("PRIVATE_DARWIN_ASSETS", assets)
local types = ""
local types_files = dtw.list_files_recursively("types", true)
for i = 1, #types_files do
    types = types .. "\n" .. dtw.load_file(types_files[i])
end
darwin.embed_global("PRIVATE_DARWIN_TYPES", types)


darwin.load_lualib_from_c("load_luaDoTheWorld", "dtw")
darwin.load_lualib_from_c("candango_engine_start_point", "private_darwin_candango")

darwin.add_lua_code("darwin = {}")
darwin.add_lua_code("private_darwin = {actions={}}")

local src_files = dtw.list_files_recursively("src", true)
for i = 1, #src_files do
    local current = src_files[i]
    darwin.add_lua_code("-- file " .. current)
    darwin.add_lua_file(current)
end
darwin.add_lua_code("private_darwin.main()")
darwin.generate_lua_output("debug.lua")
darwin.generate_c_executable_output("darwin013.c")
os.execute("gcc darwin013.c -o  darwin013.o")
