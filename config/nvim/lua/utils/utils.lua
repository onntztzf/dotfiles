local M = {}

local function isEmpty(data)
    return data == nil or next(data) == nil
end

function M.isEmpty(data)
    return isEmpty(data)
end

local function print_dump(data, showMetatable, lastCount)
    if type(data) ~= "table" then
        -- Value
        if type(data) == "string" then
            io.write("\"", data, "\"")
        else
            io.write(tostring(data))
        end
    else
        -- Format
        local count = lastCount or 0
        count = count + 1
        io.write("{\n")
        -- Metatable
        if showMetatable then
            for i = 1, count do
                io.write("\t")
            end
            local mt = getmetatable(data)
            io.write("\"__metatable\" = ")
            print_dump(mt, showMetatable, count) -- 如果不想看到元表的元表，可将showMetatable处填nil
            io.write(",\n") -- 如果不想在元表后加逗号，可以删除这里的逗号
        end
        -- Key
        for key, value in pairs(data) do
            for i = 1, count do
                io.write("\t")
            end
            if type(key) == "string" then
                io.write("\"", key, "\" = ")
            elseif type(key) == "number" then
                io.write("[", key, "] = ")
            else
                io.write(tostring(key))
            end
            print_dump(value, showMetatable, count) -- 如果不想看到子table的元表，可将showMetatable处填nil
            io.write(",\n") -- 如果不想在table的每一个item后加逗号，可以删除这里的逗号
        end
        -- Format
        for i = 1, lastCount or 0 do
            io.write("\t")
        end
        io.write("}")
    end
    -- Format
    if not lastCount then
        io.write("\n")
    end
end

function M.print_dump(data, showMetatable, lastCount)
    print_dump(data, showMetatable, lastCount)
end

function M.keymap(mode, lhs, rhs, opts)
    if lhs == '' then
        return
    end
    opts = opts or {
        noremap = true,
        silent = true,
        desc = "desc"
    }
    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
