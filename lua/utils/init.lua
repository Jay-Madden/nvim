local utils = {}

function utils.map(mode, lhs, rhs, opts)
	vim.tbl_deep_extend("force", { buffer = buffer, silent = true, noremap = true }, opts)
	vim.keymap.set(mode, lhs, rhs, opts)
end

return utils

