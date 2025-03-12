local M = {}

--- @class AutoInsertDefinition
local AutoInsertDefinition = {
    --- @type string
    filetype = nil,
    --- @type string,
    filesuffix = nil,
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
                if def.filesuffix and vim.fn.expand("%:t:e") ~= def.filesuffix then
                    return
                end
                if vim.api.nvim_buf_get_text(args.buf, 0, 0, 0, 1, {})[1] == "" then
                    local lines = {}
                    for _, line in ipairs(def.value) do
                        table.insert(lines, vim.fn.expandcmd(line))
                    end
                    vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, lines)
                end
            end,
        })
    end
end

return M
