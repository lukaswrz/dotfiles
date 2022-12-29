vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require("plugins")

vim.opt.background = "dark"

vim.opt.termguicolors = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.display = "lastline"
vim.opt.scrolloff = 5
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.shortmess = "F"
vim.opt.list = true
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.spell = false
vim.opt.virtualedit = "block"

vim.opt.listchars = {
	tab = "› ",
	nbsp = "␣",
	trail = "•",
	extends = "⟩",
	precedes = "⟨",
}

vim.opt.guifont = "monospace,Symbols Nerd Font Mono:h12"
vim.g.neovide_cursor_vfx_mode = "wireframe"
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_cursor_trail_length = 1.0
vim.g.neovide_cursor_vfx_opacity = 50.0
vim.g.neovide_hide_mouse_when_typing = true

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.conf",
	callback = function()
		vim.opt_local.filetype = "conf"
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.config", "config" },
	callback = function()
		vim.opt_local.filetype = "config"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"css",
		"scss",
		"html",
		"htmldjango",
		"template",
		"xml",
		"svg",
		"sh",
		"fish",
		"ninja",
		"conf",
		"config",
		"toml",
		"markdown",
	},
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"lua",
	},
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.expandtab = false
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"php",
		"java",
		"javascript",
		"fish",
		"sh",
		"bash",
		"json",
		"jsonc",
		"perl",
		"vim",
		"rust",
		"zig",
		"c",
		"cpp",
	},
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.expandtab = true
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go" },
	callback = function()
		vim.opt_local.shiftwidth = 8
		vim.opt_local.tabstop = 8
		vim.opt_local.expandtab = false
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go" },
	callback = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "<buffer>",
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end,
})
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

vim.api.nvim_create_user_command("PackerInstall", function()
	vim.cmd([[packadd packer.nvim]])
	require("plugins").install()
end, { bang = true })
vim.api.nvim_create_user_command("PackerUpdate", function()
	vim.cmd([[packadd packer.nvim]])
	require("plugins").update()
end, { bang = true })
vim.api.nvim_create_user_command("PackerSync", function()
	vim.cmd([[packadd packer.nvim]])
	require("plugins").sync()
end, { bang = true })
vim.api.nvim_create_user_command("PackerClean", function()
	vim.cmd([[packadd packer.nvim]])
	require("plugins").clean()
end, { bang = true })
vim.api.nvim_create_user_command("PackerCompile", function()
	vim.cmd([[packadd packer.nvim]])
	require("plugins").compile()
end, { bang = true })

vim.g.mapleader = vim.api.nvim_replace_termcodes("<Space>", true, false, true)

vim.keymap.set("n", "<Leader>/", "<Cmd>nohl<CR>")

vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>")
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>")

vim.keymap.set("n", "<Leader>u", "<Cmd>update<CR>")

vim.keymap.set("n", "<Leader>h", "<C-w>h")
vim.keymap.set("n", "<Leader>j", "<C-w>j")
vim.keymap.set("n", "<Leader>k", "<C-w>k")
vim.keymap.set("n", "<Leader>l", "<C-w>l")

vim.keymap.set("n", "<Leader>sp", "<Cmd>set spell!<CR>")

vim.keymap.set("v", "<Leader>so", "<Cmd>sort<CR>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")

vim.keymap.set("n", "Y", "y$")
