---@param contents string[]
---@param already_included string[]
---@param filename string
function PrivateDarwin_Addcfile(contents, already_included, filename)
    local file = io.open(filename, "r")
    if not file then
        error("file " .. filename .. "not provided")
    end
    local content = file:read("a")
    file:close()
    if PrivateDarwin_is_inside(already_included, content) then
        return
    end
    local COLLECTING_CHAR = 0
    local WAITING_INCLUDE = 1
    local COLLECTING_FILE = 2
    local state = COLLECTING_CHAR
    local filename = ""
    for i = 1, #content do
        local current_char = string.sub(content, i, i)
        local last_char = string.sub(content, i - 1, i - 1)
        if PrivateDarwin_is_string_at_point(content, "#include", i) then
            state = WAITING_INCLUDE
        end

        if state == WAITING_INCLUDE and last_char == '"' then
            state = COLLECTING_FILE
        end

        if state == COLLECTING_FILE and current_char ~= '"' then
            filename = filename .. current_char
        end

        --- ends collecting the filename
        if state == COLLECTING_FILE and current_char == '"' then
            PrivateDarwin_Addcfile(content, already_included, filename)
            filename = ""
            state = COLLECTING_CHAR
        end

        if state == COLLECTING_CHAR then
            contents[#contents + 1] = current_char
        end
    end
    contents[#contents + 1] = "\n"
end

---@param filename string
---@param folow_includes boolean | nil
---@param not_inside string[] | nil
function Addcfile(filename, folow_includes, not_inside)
    if not folow_includes then
        local content = io.open(filename)
        if not content then
            error("file " .. filename .. "not provided")
        end
        Addccode(content:read("a"))
        content:close()
        return
    end
    local contents = {}
    local already_included = {}
    PrivateDarwin_Addcfile(contents, already_included, filename)
    Addccode(table.concat(contents, ""))
end
