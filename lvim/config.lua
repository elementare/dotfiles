-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.builtin.indentlines.options = {
  indent = {
    char = "│",
  },
  scope = {
    enabled = false,
  },
  exclude = {
    filetypes = {
      "help",
      "dashboard",
      "NvimTree",
      "TelescopePrompt",
      "",         -- empty buffer
      "conf",     -- <- adicione esse se for o filetype
      "dosini",   -- <- ou esse, depende do :set filetype?
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
    },
  },
}

local util = require("lspconfig.util")
local mason_js = vim.fn.stdpath("data") ..
  "/mason/packages/pyright/node_modules/pyright/dist/pyright-langserver.js"

require("lvim.lsp.manager").setup("pyright", {
  cmd = { "/usr/bin/node", mason_js, "--stdio" },
  root_dir = function(fname)
    return util.root_pattern(
      "pyproject.toml", "pyrightconfig.json", "setup.cfg",
      "setup.py", "requirements.txt", ".git"
    )(fname) or vim.fn.getcwd()
  end,
  single_file_support = true,
})

require("lvim.lsp.manager").setup("ruff", {
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
})

local rocks_config = {
    rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks",
}

vim.g.rocks_nvim = rocks_config

local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
    -- Remove the dylib and dll paths if you do not need macos or windows support
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dylib"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dylib"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dll"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dll"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))    
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste",
    ["*"] = "wl-paste",
  },
  cache_enabled = 0,
}

vim.opt.conceallevel = 2

lvim.keys.normal_mode["<leader>nn"] = ":Neorg workspace notes<CR>" -- Open Neorg Notes
lvim.keys.normal_mode["<leader>nr"] = ":Neorg workspace research<CR>" -- Open Research Notes
lvim.keys.normal_mode["<leader>lc"] = ":VimtexCompile<CR>" -- Compile LaTeX
lvim.keys.normal_mode["<leader>lp"] = ":VimtexView<CR>" -- Open PDF

lvim.keys.normal_mode["<leader>mt"] = ":RenderMarkdown buf_toggle<CR>"

lvim.keys.normal_mode["<leader>on"] = ":ObsidianNew<CR>" -- Nova nota
lvim.keys.normal_mode["<leader>os"] = ":ObsidianSearch<CR>" -- Pesquisar notas
lvim.keys.normal_mode["<leader>od"] = ":ObsidianToday<CR>" -- Nota diária
lvim.keys.normal_mode["<leader>ol"] = ":ObsidianLink<CR>" -- Link entre notas

lvim.keys.normal_mode["gt"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"] = ":BufferLineCyclePrev<CR>"

vim.opt.wrap = true

vim.opt.showbreak = '↪'

lvim.keys.normal_mode["<leader>w"] = ":set wrap!<CR>"
lvim.keys.normal_mode["<Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":bprevious<CR>"


vim.cmd([[function! PasteImage()
  " Prompt for a custom image name (without extension)
  let custom_name = input("Enter image name (without extension, blank for auto): ")
  if custom_name != ""
      let image_name = custom_name . ".png"
  else
      let image_name = strftime("%Y-%m-%d-%H%M%S") . ".png"
  endif

  " Determine folder paths based on file type:
  if &filetype ==# 'tex'
      " Assume current file is in text/; images folder is at the same level as text/
      let note_dir = expand("%:p:h")
      let project_dir = fnamemodify(note_dir, ":h")
      let image_folder = project_dir . "/images/"
      " Relative path for insertion: from text/ to images/ is ../images/
      let relative_path = "images/" . image_name
  else
      " Fallback: use your default images folder (adjust as needed)
      let image_folder = "~/Documents/Notes/images/"
      let relative_path = image_folder . image_name
  endif

  " Ensure the image folder exists, create it if necessary
  if !isdirectory(image_folder)
      call mkdir(image_folder, "p")
  endif

  " Build the full image file path
  let image_path = image_folder . image_name

  " Grab the image from the clipboard using wl-paste (Wayland) and save as PNG
  call system("wl-paste -t image/png > " . shellescape(image_path))

  " Insert the appropriate snippet based on file type:
  if &filetype ==# 'tex'
      " Insert a complete LaTeX figure environment snippet
      let snippet = [
            \ "\\begin{figure}[htbp]",
            \ "  \\centering",
            \ "  \\includegraphics[width=\\linewidth]{" . relative_path . "}",
            \ "  \\caption{Your caption here}",
            \ "  \\label{fig:your_label}",
            \ "\\end{figure}",
            \ ""
            \ ]
      " Insert the snippet after the current line
      call append(line('.'), snippet)
  else
      " For non-TeX files, insert a Markdown image link
      execute "normal! a![](" . relative_path . ")"
  endif
endfunction
  ]])

lvim.keys.normal_mode["<leader>pv"] = ":call PasteImage()<CR>"

lvim.transparent_window = true

lvim.keys.visual_mode["<leader>r"] = '"vy:lua ReplaceVisualSelection()<CR>'

function ReplaceVisualSelection()
  local selection = vim.fn.getreg("v")
  selection = vim.fn.escape(selection, "\\/")
  local cmd = ":%s/\\V" .. selection .. "/"
  vim.cmd("call feedkeys(':" ..cmd .. "', 'n')")
end

lvim.plugins = {
  {
    "IogaMaster/neocord",
    event = "VeryLazy",
    config = function()
      require("neocord").setup({
        logo                = "auto",                     -- Usa o logo automático
        logo_tooltip        = nil,                        -- Sem tooltip customizado
        main_image          = "language",                 -- Usa o filetype como imagem principal
        client_id           = "1157438221865717891",      -- Client ID padrão (não recomendado alterar)
        log_level           = nil,                        -- Nível de log padrão
        debounce_timeout    = 10,                         -- Debounce em segundos
        blacklist           = {},                         -- Nenhum arquivo/rota bloqueado
        show_time           = true,                       -- Mostra o timer
        global_timer        = false,                      -- O timer é local (atualiza só no buffer atual)
        editing_text        = "Editing %s",               -- Texto para arquivos editáveis
        file_explorer_text  = "Browsing %s",              -- Texto para explorador de arquivos
        git_commit_text     = "Committing changes",       -- Texto para commits
        plugin_manager_text = "Managing plugins",         -- Texto para gerenciamento de plugins
        reading_text        = "Reading %s",               -- Texto para arquivos somente leitura
        workspace_text      = "Working on %s",            -- Texto para o workspace
        line_number_text    = "Line %s out of %s",        -- Texto para números de linha
        terminal_text       = "Using Terminal",           -- Texto para terminal
      })
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("obsidian").setup({
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        workspaces = {
          {
            name = "default",
            path = "~/Notes", -- Caminho onde estão suas notas
          },
        },
        completion = {
          nvim_cmp = true, -- Ativa integração com o autocompletar do nvim-cmp
        },
        daily_notes = {
          folder = "Dailies", -- Pasta para notas diárias
          template = "daily.md", -- Template para novas notas
        },
        note_id_func = function(title)
          return title and title:gsub(" ", "-"):lower() or tostring(os.time())
        end,
        ui = {
          enable = false, -- Habilita UI de preview
          preview_cmd = "vsplit", -- Abre preview ao lado direito
        },
      })

      -- Keybinds
   end
  },
   {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "echasnovski/mini.nvim",
    },
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "obsidian" },
        completions = { lsp = { enabled = true } },
      })
    end,
  },
  {
        "HakonHarnes/img-clip.nvim",
        config = function()
            require("img-clip").setup({
                default = {
                    dir_path = "images", -- Where images will be stored
                    file_name = function()
                        return os.date("%Y-%m-%d-%H-%M-%S") .. ".png"
                    end,
                    affix = "![](%s)", -- Markdown image syntax
                }
            })
        end
  },
  -- LaTeX Support (vimtex)
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
     -- vim.g.vimtex_view_method = "zathura" -- Use Zathura PDF reader
      vim.g.vimtex_view_general_viewer = 'okular-smart'
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = '-lualatex'
      }
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-lualatex",
        },
      }    
    end,
  },

  -- Org-mode Alternative (Neorg)
 {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
  },
  -- Auto pairs for math symbols
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  -- Telescope for fast searching
}


