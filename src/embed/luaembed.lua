--@param value string
function PrivateDarwinEmbed_lua_global_concat(value)
    PrivateDarwin_lua_globals = PrivateDarwin_lua_globals .. value
end

---@param table_name string
---@param current_table table
function Private_embed_lua_table(table_name, current_table)
    for key, val in pairs(current_table) do
        local key_type = type(key)
        local val_type = type(val)

        if not PrivateDarwin_is_inside({ "string", "number" }, key_type) then
            error("invalid key on " .. table_name)
        end
        if not PrivateDarwin_is_inside({ "string", "number", "table", "boolean" }, val_type) then
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
            PrivateDarwinEmbed_lua_global_concat(
                string.format('%s%s = %f\n', table_name, formatted_key, val)
            )
        elseif val_type == "string" then
            local converted = PrivateDarwin_create_lua_str_buffer(val)
            PrivateDarwinEmbed_lua_global_concat(
                string.format('%s%s = %s\n', table_name, formatted_key, converted)
            )
        elseif val_type == "boolean" then
            PrivateDarwinEmbed_lua_global_concat(
                string.format('%s%s = %s\n', table_name, formatted_key, tostring(val))
            )
        elseif val_type == "table" then
            PrivateDarwinEmbed_lua_global_concat(
                string.format('%s%s = {}\n', table_name, formatted_key)
            )
            Private_embed_lua_table(
                table_name .. formatted_key,
                val
            )
        end
    end
end

---@param name string
---@param var any
---@param var_type string
function Private_embed_global_in_lua(name, var, var_type)
    -- For simple types (number, boolean, string)
    if var_type == "number" then
        PrivateDarwinEmbed_lua_global_concat(
            string.format('%s = %f\n', name, var)
        )
    end
    if var_type == "boolean" then
        PrivateDarwinEmbed_lua_global_concat(
            string.format('%s = %s\n', name, tostring(var))
        )
    end
    if var_type == "string" then
        local converted = PrivateDarwin_create_lua_str_buffer(var)
        PrivateDarwinEmbed_lua_global_concat(
            string.format('%s = %s\n', name, converted)
        )
    end
    if var_type == "table" then
        PrivateDarwinEmbed_lua_global_concat(string.format('%s = {}\n', name))
        Private_embed_lua_table(name, var)
    end
end
