local packer = nil

local function init()
	if packer == nil then
		packer = require("packer")
		packer.init()
	end

	local use = packer.use
	packer.reset()

	use("wbthomason/packer.nvim")

	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"go",
					"gomod",
					"gowork",
					"fish",
					"bash",
					"json",
					"jsonc",
					"yaml",
					"graphql",
					"css",
					"html",
					"php",
					"python",
					"c",
					"c_sharp",
					"cpp",
					"java",
					"zig",
					"haskell",
					"ninja",
					"make",
					"llvm",
					"scss",
					"jsdoc",
					"julia",
					"javascript",
					"norg",
					"bibtex",
					"perl",
					"kotlin",
					"typescript",
					"glsl",
					"dart",
					"latex",
					"ruby",
					"vue",
					"gdscript",
					"commonlisp",
					"r",
					"dockerfile",
					"markdown",
					"lua",
					"vim",
					"rst",
					"rust",
					"toml",
					"cmake",
					"elixir",
				},
				sync_install = false,
				autotag = {
					enable = true,
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	})
	use({
		"windwp/nvim-autopairs",
		requires = "hrsh7th/nvim-cmp",
		config = function()
			local autopairs = require("nvim-autopairs")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

			autopairs.setup({})
		end,
	})
	use({
		"EdenEast/nightfox.nvim",
		config = function()
			vim.cmd("colorscheme carbonfox")
		end,
	})
	use({
		"NvChad/nvim-colorizer.lua",
		config = function()
			local colorizer = require("colorizer")

			colorizer.setup()
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 500,
				},
			})
		end,
	})
	use({
		"hoob3rt/lualine.nvim",
		requires = {
			"EdenEast/nightfox.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					section_separators = { nil, nil },
					component_separators = { nil, nil },
					disabled_filetypes = {},
					globalstatus = true,
				},
				sections = {
					lualine_a = {
						"mode",
					},
					lualine_b = {
						"branch",
					},
					lualine_c = {
						"filename",
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							sections = { "error", "warn", "info", "hint" },
							diagnostics_color = {
								error = "DiagnosticError",
								warn = "DiagnosticWarn",
								info = "DiagnosticInfo",
								hint = "DiagnosticHint",
							},
							symbols = {
								error = "E",
								warn = "W",
								info = "I",
								hint = "H",
							},
							colored = true,
							update_in_insert = false,
							always_visible = false,
						},
					},

					lualine_x = {
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = {
						"progress",
					},
					lualine_z = {
						"location",
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	})
	use({
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup()
		end,
	})
	use({
		"onsails/lspkind.nvim",
		config = function()
			local lspkind = require("lspkind")
			lspkind.init({
				mode = "symbol_text",
			})
		end,
	})
	use({
		"williamboman/mason.nvim",
		config = function()
			local mason = require("mason")

			mason.setup()
		end,
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		requires = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local mason = require("mason")
			mason.setup()

			local lspconfig = require("lspconfig")

			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = {
					"omnisharp",
					"jdtls",
					"rust_analyzer",
					"clangd",
					"pyright",
					"tsserver",
					"zls",
					"lua_ls",
					"gopls",
					"phpactor",
				},
				automatic_installation = false,
			})

			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				omnisharp = function()
					lspconfig.omnisharp.setup({
						capabilities = capabilities,
						"omnisharp",
						"--languageserver",
						"--hostPID",
						tostring(vim.fn.getpid()),
					})
				end,
				jdtls = function()
					lspconfig.jdtls.setup({
						capabilities = capabilities,
						root_dir = lspconfig.util.root_pattern(
							"build.xml",
							"pom.xml",
							"settings.gradle",
							"settings.gradle.kts",
							".git"
						),
						init_options = {
							jvm_args = {
								["java.format.settings.url"] = vim.fn.stdpath("config") .. "/eclipse-formatter.xml",
							},
							workspace = vim.fn.stdpath("cache") .. "/java-workspaces",
						},
					})
				end,
			})

			vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
			vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
			vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
			vim.keymap.set("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
			vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
			vim.keymap.set("n", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
			vim.keymap.set("n", "<C-n>", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
			vim.keymap.set("n", "<C-p>", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
			vim.keymap.set("n", "<Leader>a", "<Cmd>lua vim.lsp.buf.format()<CR>")
		end,
	})
	use({
		"jay-babu/mason-null-ls.nvim",
		requires = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			local mason_null_ls = require("mason-null-ls")
			local null_ls = require("null-ls")

			mason_null_ls.setup({
				ensure_installed = {
					"stylua",
					"black",
					"gitlint",
				},
				automatic_setup = true,
			})
			mason_null_ls.setup_handlers()

			null_ls.setup()
		end,
	})
	use({
		"jayp0521/mason-nvim-dap.nvim",
		requires = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			local mason_nvim_dap = require("mason-nvim-dap")

			mason_nvim_dap.setup({
				ensure_installed = {
					"python",
				},
				automatic_setup = true,
			})
			mason_nvim_dap.setup_handlers()
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"L3MON4D3/LuaSnip",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
					["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
					["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
					["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
					["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "text_symbol",
						maxwidth = 80,
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "neorg" },
				},
			})
		end,
	})
	use({
		"folke/trouble.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local trouble = require("trouble")
			trouble.setup({
				auto_open = false,
				auto_close = true,
			})

			local trouble_telescope_provider = require("trouble.providers.telescope")

			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					mappings = {
						i = { ["<C-t>"] = trouble_telescope_provider.open_with_trouble },
						n = { ["<C-t>"] = trouble_telescope_provider.open_with_trouble },
					},
				},
			})
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			local nvim_tree = require("nvim-tree")

			nvim_tree.setup()

			vim.keymap.set("n", "<Leader>f", "<Cmd>NvimTreeToggle<CR>")
			vim.keymap.set("n", "<Leader>r", "<Cmd>NvimTreeRefresh<CR>")
			vim.keymap.set("n", "<Leader>g", "<Cmd>NvimTreeFindFile<CR>")

			vim.cmd([[highlight NvimTreeFolderIcon guibg=blue]])
		end,
	})
	use({
		"kwkarlwang/bufresize.nvim",
		config = function()
			local bufresize = require("bufresize")
			bufresize.setup()
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local indent_blankline = require("indent_blankline")

			indent_blankline.setup({
				show_current_context = true,
				show_current_context_start = false,
			})
		end,
	})
	use({
		"cshuaimin/ssr.nvim",
		config = function()
			local ssr = require("ssr")

			ssr.setup({
				keymaps = {
					close = "q",
					next_match = "n",
					prev_match = "N",
					replace_all = "<Leader><CR>",
				},
			})

			vim.keymap.set({ "n", "x" }, "<Leader>sr", function()
				ssr.open()
			end)
		end,
	})
	use({
		"vhyrro/neorg",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neorg/neorg-telescope",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local neorg = require("neorg")
			local neorg_callbacks = require("neorg.callbacks")

			neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
				keybinds.map_event_to_mode("norg", {
					n = {
						{ "gtd", "core.norg.qol.todo_items.todo.task_done" },
						{ "gtu", "core.norg.qol.todo_items.todo.task_undone" },
						{ "gtp", "core.norg.qol.todo_items.todo.task_pending" },
						{ "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },
					},
				}, {
					silent = true,
					noremap = true,
				})
			end)

			neorg.setup({
				load = {
					["core.defaults"] = {},
					["core.norg.concealer"] = {},
					["core.norg.completion"] = {
						config = {
							engine = "nvim-cmp",
						},
					},
					["core.norg.dirman"] = {
						config = {
							workspaces = {
								notes = "~/neorg",
							},
						},
					},
					["core.keybinds"] = {
						config = {
							default_keybinds = true,
							neorg_leader = "<Leader>o",
						},
					},
					["core.integrations.telescope"] = {},
				},
			})
		end,
	})
end

local plugins = setmetatable({}, {
	__index = function(_, key)
		init()
		return packer[key]
	end,
})

return plugins
