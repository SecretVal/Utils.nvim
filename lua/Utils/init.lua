local M = {}

local function len(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

--- @class AutoInsertDefinition
local AutoInsertDefinition = {
    --- @type string
    filetype = nil,
    --- @type string[]
    value = nil,
}

--- @class UtilOpts
local UtilOpts = {
    --- @type AutoInsertDefinition[]
    auto_inserts = nil,
}

--- @param opts UtilOpts
function M.setup(opts)
    for _, def in ipairs(opts.auto_inserts) do
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = { def.filetype },
            callback = function(args)
                if vim.api.nvim_buf_get_text(args.buf, 0, 0, 0, 1, {})[1] == "" then
                    local lines = {}
                    for _, line in ipairs(def.value) do
                        table.insert(lines, vim.fn.expandcmd(line, { errmsg = true }))
                    end
                    vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, lines)
                end
            end,
        })
    end
end

return M
