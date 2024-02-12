local M = {}

---@class Config
local config = {
	blacklist = require("treesitter-notify.blacklist").blacklist,
	debug = false,
}

---@type Config
M.config = config

local check_parser = function(blacklist)
	local parsers = require("nvim-treesitter.parsers")
	local buf_lang = parsers.get_buf_lang()

	for _, value in pairs(blacklist) do
		if buf_lang == value then
			return
		end
	end

	if not parsers.has_parser() then
		vim.notify("Parser not installed: " .. buf_lang, vim.log.levels.WARN)
	end
end

---@param args Config
M.setup = function(args)
	-- M.config = vim.tbl_deep_extend("error", M.config, args or {})
	-- M.config.debug = args.debug and false or true
	for _, v in pairs(args.blacklist or {}) do
		table.insert(M.config.blacklist, v)
	end

	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = "*",
		group = vim.api.nvim_create_augroup("_user_check_if_parser_installed", {}),
		callback = function()
			check_parser(M.config.blacklist)
		end,
	})
end

return M
