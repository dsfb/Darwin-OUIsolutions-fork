private_darwin.embed_lua_global_concat = function(value)
    private_darwin.lua_globals = private_darwin.lua_globals .. value
end

private_darwin.embed_lua_table = function(table_name, current_table)
    for key, val in pairs(current_table) do
        local key_type = type(key)
        local val_type = type(val)

        if not private_darwin.is_inside({ "string", "number" }, key_type) then
            error("invalid key on " .. table_name)
        end
        if not private_darwin.is_inside({ "string", "number", "table", "boolean" }, val_type) then
            error("invalid val on " .. table_name)
        end

        -- Format the key appropriately
        local formatted_key
        if key_type == "number" then
            formatted_key = string.format("[%d]", key)
        else
            formatted_key = string.format("[%q]", key)
        end

        -- Handle different value types
        if val_type == "number" then
            private_darwin.embed_lua_global_concat(
                string.format('%s%s = %f\n', table_name, formatted_key, val)
            )
        elseif val_type == "string" then
            local converted = private_darwin.create_lua_str_buffer(val)
            private_darwin.embed_lua_global_concat(
                string.format('%s%s = %s\n', table_name, formatted_key, converted)
            )
        elseif val_type == "boolean" then
            private_darwin.embed_lua_global_concat(
                string.format('%s%s = %s\n', table_name, formatted_key, tostring(val))
            )
        elseif val_type == "table" then
            private_darwin.embed_lua_global_concat(
                string.format('%s%s = {}\n', table_name, formatted_key)
            )
            private_darwin.embed_lua_table(
                table_name .. formatted_key,
                val
            )
        end
    end
end


private_darwin.embed_global_in_lua = function(name, var, var_type)
    -- For simple types (number, boolean, string)
    if var_type == "number" then
        private_darwin.embed_lua_global_concat(
            string.format('%s = %f\n', name, var)
        )
    end
    if var_type == "boolean" then
        private_darwin.embed_lua_global_concat(
            string.format('%s = %s\n', name, tostring(var))
        )
    end
    if var_type == "string" then
        local converted = private_darwin.create_lua_str_buffer(var)
        private_darwin.embed_lua_global_concat(
            string.format('%s = %s\n', name, converted)
        )
    end
    if var_type == "table" then
        private_darwin.embed_lua_global_concat(string.format('%s = {}\n', name))
        private_darwin.embed_lua_table(name, var)
    end
end
