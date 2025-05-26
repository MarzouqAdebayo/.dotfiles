local fn = vim.fn

function _G.qftf(info)
	local items
	local ret = {}

	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end

	local limit = 31
	local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
	local validFmt = "%s │%5d:%-3d│%s %s"

	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local fname = "[No Name]" -- Default filename if missing
		local str

		if e.valid == 1 then
			if e.bufnr and e.bufnr > 0 then
				local bufname = fn.bufname(e.bufnr)
				if bufname ~= "" then
					fname = bufname:gsub("^" .. vim.env.HOME, "~")
				end
				if #fname <= limit then
					fname = fnameFmt1:format(fname)
				else
					fname = fnameFmt2:format(fname:sub(1 - limit))
				end
			end

			local lnum = e.lnum and (e.lnum > 99999 and -1 or e.lnum) or 0
			local col = e.col and (e.col > 999 and -1 or e.col) or 0
			local qtype = e.type and e.type ~= "" and " " .. e.type:sub(1, 1):upper() or ""
			local text = e.text or "[No Message]" -- Default message if missing

			str = validFmt:format(fname, lnum, col, qtype, text)
		else
			str = e.text or "[Invalid Entry]" -- Default for invalid entries
		end

		table.insert(ret, str)
	end

	return ret
end

-- vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
if not pcall(require, "bqf") then
	vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
end

-- Adapt fzf's delimiter in nvim-bqf
-- require("bqf").setup {
-- 	filter = {
-- 		fzf = {
-- 			extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
-- 		},
-- 	},
-- }

return {
	"kevinhwang91/nvim-bqf",
	config = function()
		require("bqf").setup {}
	end,
}
