-- ============================================================
--  LunarVim config — Obsidian-style workflow
--  Arch Linux / Hyprland
--  Drop this at: ~/.config/lvim/config.lua
-- ============================================================

-- ────────────────────────────────────────────────────────────
--  SECTION 0
-- ────────────────────────────────────────────────────────────
package.path = package.path .. ";/home/elementare/.luarocks/share/lua/5.1/?.lua;/home/elementare/.luarocks/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";/home/elementare/.luarocks/lib/lua/5.1/?.so"

vim.opt.wrap        = true
vim.opt.showbreak   = "↪"
vim.opt.cursorline  = true
vim.opt.signcolumn  = "yes:1"
vim.opt.conceallevel = 2
vim.opt.linespace   = 2

vim.g.maplocalleader = ","
lvim.transparent_window = false
vim.deprecate = function() end

vim.g.clipboard = {
  name  = "wl-clipboard",
  copy  = { ["+"] = "wl-copy",  ["*"] = "wl-copy"  },
  paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
  cache_enabled = 0,
}

-- ────────────────────────────────────────────────────────────
--  SECTION 1 — indent-blankline
-- ────────────────────────────────────────────────────────────
lvim.builtin.indentlines.options = {
  indent = { char = "│" },
  scope  = { enabled = false },
  exclude = {
    filetypes = { "help","dashboard","NvimTree","TelescopePrompt","","conf","dosini","norg" },
    buftypes  = { "terminal","nofile","quickfix" },
  },
}

-- ────────────────────────────────────────────────────────────
--  SECTION 2 — LSP
-- ────────────────────────────────────────────────────────────
local util     = require("lspconfig.util")
local mason_js = vim.fn.stdpath("data") ..
  "/mason/packages/pyright/node_modules/pyright/dist/pyright-langserver.js"

require("lvim.lsp.manager").setup("pyright", {
  cmd = { "/usr/bin/node", mason_js, "--stdio" },
  root_dir = function(fname)
    return util.root_pattern(
      "pyproject.toml","pyrightconfig.json","setup.cfg",
      "setup.py","requirements.txt",".git"
    )(fname) or vim.fn.getcwd()
  end,
  single_file_support = true,
})

require("lvim.lsp.manager").setup("ruff", {
  capabilities = { offsetEncoding = { "utf-16" } },
})

-- ────────────────────────────────────────────────────────────
--  SECTION 3 — luarocks / rocks.nvim path
-- ────────────────────────────────────────────────────────────
local rocks_config = { rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks" }
vim.g.rocks_nvim   = rocks_config

local luarocks_path = {
  vim.fs.joinpath(rocks_config.rocks_path,"share","lua","5.1","?.lua"),
  vim.fs.joinpath(rocks_config.rocks_path,"share","lua","5.1","?","init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path,";")

local luarocks_cpath = {
  vim.fs.joinpath(rocks_config.rocks_path,"lib","lua","5.1","?.so"),
  vim.fs.joinpath(rocks_config.rocks_path,"lib64","lua","5.1","?.so"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath,";")
vim.opt.runtimepath:append(
  vim.fs.joinpath(rocks_config.rocks_path,"lib","luarocks","rocks-5.1","rocks.nvim","*")
)

-- ────────────────────────────────────────────────────────────
--  SECTION 4 — highlight groups (colorscheme-independent)
-- ────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local s = vim.api.nvim_set_hl
    s(0, "AlphaClock",    { fg = "#676e95", italic = true })
    s(0, "AlphaGreeting", { fg = "#c792ea", bold   = true })
    s(0, "AlphaHeader",   { fg = "#9580ff" })
    s(0, "AlphaButtons",  { fg = "#4ec9b0" })

    s(0, "@markup.heading.1.markdown",  { fg = "#c792ea", bold = true })
    s(0, "@markup.heading.2.markdown",  { fg = "#9580ff", bold = true })
    s(0, "@markup.heading.3.markdown",  { fg = "#7b93ff", bold = true })
    s(0, "@markup.heading.4.markdown",  { fg = "#4ec9b0" })
    s(0, "@markup.raw.markdown_inline", { fg = "#4ec9b0", bg = "#0f0f1a" })
    s(0, "@markup.italic",              { fg = "#7c7fa3", italic = true })
    s(0, "@markup.rule.markdown",       { fg = "#2a2a3d" })
    s(0, "@markup.list.checked",        { fg = "#4ec9b0", strikethrough = true })
    s(0, "@markup.list.unchecked",      { fg = "#676e95" })

    s(0, "@neorg.headings.1.prefix", { fg = "#c792ea", bold = true })
    s(0, "@neorg.headings.2.prefix", { fg = "#9580ff", bold = true })
    s(0, "@neorg.headings.3.prefix", { fg = "#7b93ff" })
    s(0, "@neorg.headings.1.title",  { fg = "#c792ea", bold = true })
    s(0, "@neorg.headings.2.title",  { fg = "#9580ff", bold = true })
    s(0, "@neorg.headings.3.title",  { fg = "#7b93ff" })
    s(0, "@neorg.todo_items.undone", { fg = "#676e95" })
    s(0, "@neorg.todo_items.done",   { fg = "#4ec9b0", strikethrough = true })
    s(0, "@neorg.todo_items.pending",{ fg = "#ffb86c" })

    s(0, "RenderMarkdownH1",    { fg = "#c792ea", bold = true })
    s(0, "RenderMarkdownH2",    { fg = "#9580ff", bold = true })
    s(0, "RenderMarkdownH3",    { fg = "#80a0ff", bold = true })
    -- s(0, "RenderMarkdownH1Bg",  { bg = "#150a20" })
    -- s(0, "RenderMarkdownH2Bg",  { bg = "#0f0a1e" })
    -- s(0, "RenderMarkdownH3Bg",  { bg = "#080a1a" })
    s(0, "RenderMarkdownH1Bg",  { bg = "#03000d" })
    s(0, "RenderMarkdownH2Bg",  { bg = "#03000d" })
    s(0, "RenderMarkdownH3Bg",  { bg = "#03000d" })
    s(0, "RenderMarkdownCode",  { bg = "#0f0f1a" })
    s(0, "RenderMarkdownBullet",{ fg = "#9580ff" })

    s(0, "NvimTreeFolderName",       { fg = "#9580ff" })
    s(0, "NvimTreeOpenedFolderName", { fg = "#c792ea", bold = true })
    s(0, "NvimTreeRootFolder",       { fg = "#c792ea" })
    s(0, "CursorLine",               { bg = "#110d1a" })

    s(0, "Normal",       { bg = "#03000d" })
    s(0, "NormalNC",     { bg = "#03000d" })  -- inactive windows
    s(0, "NormalFloat",  { bg = "#03000d" })  -- floating windows
    s(0, "SignColumn",   { bg = "#03000d" })
    s(0, "StatusLine",   { bg = "#03000d" })
    s(0, "TabLineFill",  { bg = "#03000d" })
  end,
})

-- ────────────────────────────────────────────────────────────
--  SECTION 5 — PARA FOLDER STRUCTURE
--  Call :PARAInit to scaffold ~/Notes
-- ────────────────────────────────────────────────────────────
vim.api.nvim_create_user_command("PARAInit", function()
  local base = vim.fn.expand("~/Notes")
  local dirs = {
    base .. "/Daily",
    base .. "/Projects",
    base .. "/Areas",
    base .. "/Resources",
    base .. "/Archive",
    base .. "/Templates",
  }
  for _, d in ipairs(dirs) do
    vim.fn.mkdir(d, "p")
    print("Created: " .. d)
  end
  local tpl = base .. "/Templates/daily.norg"
  if vim.fn.filereadable(tpl) == 0 then
    local f = io.open(tpl, "w")
    if f then
      f:write(table.concat({
        "@document.meta",
        "title: {date}",
        "description: Daily note",
        "categories: [daily]",
        "@end",
        "",
        "* {date} — {weekday}",
        "",
        "** Foco do dia",
        "   Uma frase, intenção ou meta que define o tom do dia.",
        "",
        "** Prioridades",
        "   - ( ) ",
        "   - ( ) ",
        "   - ( ) ",
        "",
        "** Hábitos",
        "   | Hábito            | Feito |",
        "   | Academia          | [ ]   |",
        "   | Alimentação saud. | [ ]   |",
        "   | Leitura           | [ ]   |",
        "   | Estudo técnico    | [ ]   |",
        "   | Japonês/Chinês    | [ ]   |",
        "   | Pesquisa mestrado | [ ]   |",
        "",
        "** Profissional",
        "",
        "** Pessoal",
        "",
        "** Log do Dia",
        "",
        "** Revisão Noturna",
        "   O que funcionou bem?",
        "   - ",
        "",
        "   O que travar ou melhorar amanhã?",
        "   - ",
        "",
        "   Energia do dia (1-5): ",
        "   Foco do dia (1-5): ",
      }, "\n"))
      f:close()
    end
  end
  print("PARA structure ready at " .. base)
end, {})

-- ────────────────────────────────────────────────────────────
--  SECTION 6 — HABIT TRACKER
-- ────────────────────────────────────────────────────────────
local habits_module = {}

habits_module.open = function()
  local date      = os.date("%Y-%m-%d")
  local note_dir  = vim.fn.expand("~/Notes/Daily")
  local note_path = note_dir .. "/" .. date .. ".norg"

  if vim.fn.filereadable(note_path) == 0 then
    local tpl = vim.fn.expand("~/Notes/Templates/daily.norg")
    if vim.fn.filereadable(tpl) == 1 then
      local src = io.open(tpl, "r")
      local dst = io.open(note_path, "w")
      if src and dst then
        local content = src:read("*a")
        src:close()
        local weekday = os.date("%A")
        content = content:gsub("{date}", date):gsub("{weekday}", weekday)
        dst:write(content)
        dst:close()
      end
    end
  end
  vim.cmd("edit " .. note_path)
end

_G.habits = habits_module

-- ────────────────────────────────────────────────────────────
--  SECTION 7 — KEY BINDINGS
-- ────────────────────────────────────────────────────────────
lvim.keys.normal_mode["<leader>h"]  = ":Alpha<CR>"
lvim.keys.normal_mode["<leader>nn"] = ":lua _G.habits.open()<CR>"
lvim.keys.normal_mode["<leader>np"] = ":Telescope find_files cwd=~/Notes/Projects<CR>"
lvim.keys.normal_mode["<leader>na"] = ":Telescope find_files cwd=~/Notes/Areas<CR>"
lvim.keys.normal_mode["<leader>nr"] = ":Telescope find_files cwd=~/Notes/Resources<CR>"
lvim.keys.normal_mode["<leader>nd"] = ":Telescope find_files cwd=~/Notes/Daily<CR>"
lvim.keys.normal_mode["<leader>nf"] = ":Telescope find_files cwd=~/Notes<CR>"
lvim.keys.normal_mode["<leader>ng"] = ":Telescope live_grep  cwd=~/Notes<CR>"
lvim.keys.normal_mode["<leader>nc"] = ":CalendarVR<CR>"
lvim.keys.normal_mode["<leader>nw"] = ":Neorg workspace notes<CR>"

lvim.keys.normal_mode["gt"]      = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"]      = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<Tab>"]   = ":bnext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":bprevious<CR>"

lvim.keys.normal_mode["<leader>w"]  = ":set wrap!<CR>"
lvim.keys.normal_mode["<leader>lc"] = ":VimtexCompile<CR>"
lvim.keys.normal_mode["<leader>lp"] = ":VimtexView<CR>"
lvim.keys.normal_mode["<leader>mt"] = ":RenderMarkdown buf_toggle<CR>"
lvim.keys.normal_mode["<leader>pv"] = ":call PasteImage()<CR>"

lvim.keys.normal_mode["<localleader>mi"] = ":MoltenInit<CR>"
lvim.keys.normal_mode["<localleader>e"]  = ":MoltenEvaluateOperator<CR>"
lvim.keys.normal_mode["<localleader>rl"] = ":MoltenEvaluateLine<CR>"
lvim.keys.normal_mode["<localleader>rr"] = ":MoltenReevaluateCell<CR>"
lvim.keys.visual_mode["<localleader>r"]  = ":<C-u>MoltenEvaluateVisual<CR>gv"
lvim.keys.normal_mode["<localleader>rd"] = ":MoltenDelete<CR>"
lvim.keys.normal_mode["<localleader>oh"] = ":MoltenHideOutput<CR>"
lvim.keys.normal_mode["<localleader>os"] = ":noautocmd MoltenEnterOutput<CR>"
lvim.keys.normal_mode["<localleader>oy"] = ":noautocmd MoltenEnterOutput<CR>ggVG\"+y:q<CR>"


local runner = require("quarto.runner")

lvim.keys.normal_mode["<localleader>rc"] = { runner.run_cell}
lvim.keys.normal_mode["<localleader>ra"] = { runner.run_above}
lvim.keys.normal_mode["<localleader>rA"] = { runner.run_all}
lvim.keys.normal_mode["<localleader>rl"] = { runner.run_line}
lvim.keys.visual_mode["<localleader>r"]  = { runner.run_range }



vim.g.molten_virt_text_output    = true
vim.g.molten_auto_open_output    = false
vim.g.molten_virt_text_max_lines = 20

-- ────────────────────────────────────────────────────────────
--  SECTION 9 — PLUGINS
-- ────────────────────────────────────────────────────────────
lvim.plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    -- do NOT add a config function — let LunarVim handle it
  },
  -- ── Theme ──────────────────────────────────────────────────
  -- ── Dashboard ──────────────────────────────────────────────
  
  -- ── Neorg (notes engine) ───────────────────────────────────
  {
    "nvim-neorg/neorg",
    build = ":TSInstall norg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"]  = {},
          ["core.concealer"] = {
            config = {
              icon_preset = "varied",
              icons = {
                heading = {
                  level_1 = { icon = "◈" },
                  level_2 = { icon = "◇" },
                  level_3 = { icon = "◆" },
                  level_4 = { icon = "○" },
                },
                todo = {
                  undone  = { icon = " " },
                  done    = { icon = "✓" },
                  pending = { icon = "◐" },
                },
              },
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes    = "~/Notes",
                daily    = "~/Notes/Daily",
                projects = "~/Notes/Projects",
                research = "~/Notes/Resources",
              },
              default_workspace = "notes",
            },
          },
          ["core.completion"] = {
            config = { engine = "nvim-cmp" },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader     = "<localleader>",
            },
          },
          ["core.journal"] = {
            config = {
              workspace      = "daily",
              journal_folder = ".",
              template_name  = "daily.norg",
            },
          },
        },
      })
    end,
  },

  -- ── Calendar ───────────────────────────────────────────────
  {
    "itchyny/calendar.vim",
    cmd = { "Calendar", "CalendarVR" },
    config = function()
      vim.g.calendar_google_calendar = 0
      vim.g.calendar_google_task     = 0
      vim.g.calendar_first_day       = "monday"
      vim.g.calendar_date_separator  = "-"
      vim.g.calendar_clock_12hour    = 0
    end,
  },

  -- ── Markdown rendering ─────────────────────────────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "echasnovski/mini.nvim" },
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "norg" },
        render_modes = { "n", "c", "i" },
        completions = { lsp = { enabled = true } },
        heading = {
          sign  = false,
          icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
          width = "full",
        },
        code = {
          sign   = false,
          style  = "full",
          border = "thin",
        },
        bullet = {
          enabled = true,
          icons   = { "●", "○", "◆", "◇" },
        },
        checkbox = {
          unchecked = { icon = "󰄱 " },
          checked   = { icon = "󰱒 " },
        },
      })
    end,
  },

  -- ── Neorg + render integration ─────────────────────────────
  {
    "benlubas/neorg-se",
    dependencies = { "nvim-neorg/neorg" },
    ft = "norg",
  },

  -- ── img-clip ───────────────────────────────────────────────
  {
    "HakonHarnes/img-clip.nvim",
    config = function()
      require("img-clip").setup({
        default = {
          dir_path  = "images",
          file_name = function() return os.date("%Y-%m-%d-%H-%M-%S") .. ".png" end,
          affix     = "![](%s)",
        },
      })
    end,
  },

  -- ── Telescope ──────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix   = "  ",
          selection_caret = "  ",
          path_display    = { "truncate" },
          layout_strategy = "horizontal",
          layout_config   = { horizontal = { preview_width = 0.55 } },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ── LaTeX ──────────────────────────────────────────────────
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      vim.g.vimtex_view_general_viewer      = "okular-smart"
      vim.g.vimtex_compiler_method          = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
      vim.g.vimtex_compiler_latexmk = {
        build_dir  = "", callback = 1, continuous = 1,
        executable = "latexmk",
        options    = {
          "-shell-escape","-verbose","-file-line-error",
          "-interaction=nonstopmode","-synctex=1","-lualatex",
        },
      }
    end,
  },

  -- ── Molten (Jupyter) ───────────────────────────────────────
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
  },
  { "GCBallesteros/jupytext.nvim", ft = { "ipynb" } },
  {
    "quarto-dev/quarto-nvim",
    ft           = { "markdown","quarto","ipynb" },
    dependencies = { "jmbuhr/otter.nvim","nvim-treesitter/nvim-treesitter" },
  },

  -- ── Neocord ────────────────────────────────────────────────
  {
    "IogaMaster/neocord",
    event = "VeryLazy",
    config = function()
      require("neocord").setup({
        logo             = "auto",
        main_image       = "language",
        client_id        = "1157438221865717891",
        debounce_timeout = 10,
        show_time        = true,
        editing_text     = "Editing %s",
        workspace_text   = "Working on %s",
        terminal_text    = "Using Terminal",
      })
    end,
  },

  -- ── Utilities ──────────────────────────────────────────────
  {
    "sunnytamang/neodoc.nvim",
    config = function()
      require("neodoc").setup({
        python_interpreter = "python3",
        docstring_style    = "numpy",
        enable_keymaps     = true,
        keymap             = "<leader>d",
      })
    end,
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp","hrsh7th/cmp-buffer","hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip","L3MON4D3/LuaSnip","rafamadriz/friendly-snippets",
    },
  },
}

-- ────────────────────────────────────────────────────────────
--  SECTION 10 — JUPYTEXT / QUARTO / MOLTEN
-- ────────────────────────────────────────────────────────────
require("jupytext").setup({
  style            = "markdown",
  output_extension = "md",
  force_ft         = "markdown",
})

local quarto = require("quarto")
quarto.setup({
  lspFeatures = {
    languages   = { "python" },
    chunks      = "all",
    diagnostics = { enabled = true, triggers = { "BufWritePost" } },
    completion  = { enabled = true },
  },
  codeRunner = { enabled = true, default_method = "molten" },
})

local imb = function(e)
  vim.schedule(function()
    local kernels     = vim.fn.MoltenAvailableKernels()
    local kernel_name = nil
    local ok, metadata = pcall(function()
      local f = io.open(e.file,"r")
      if not f then return nil end
      local content = f:read("a"); f:close()
      return vim.json.decode(content).metadata
    end)
    if ok and metadata and metadata.kernelspec then
      kernel_name = metadata.kernelspec.name
    end
    if kernel_name == nil or not vim.tbl_contains(kernels, kernel_name) then
      local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
      if venv then
        local name = string.match(venv,"/.+/(.+)")
        if name and vim.tbl_contains(kernels, name) then kernel_name = name end
      end
    end
    if kernel_name ~= nil then vim.cmd("MoltenInit " .. kernel_name)
    else vim.cmd("MoltenInit") end
    vim.cmd("MoltenImportOutput")
  end)
end

vim.api.nvim_create_autocmd("BufAdd",   { pattern = {"*.ipynb"}, callback = imb })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern  = {"*.ipynb"},
  callback = function(e)
    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then imb(e) end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern  = {"*.ipynb"},
  callback = function()
    if require("molten.status").initialized() == "Molten" then
      vim.cmd("MoltenExportOutput!")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.md", "*.norg" },
  callback = function()
    vim.defer_fn(function()
      local ok = pcall(vim.treesitter.get_parser, 0, vim.bo.filetype)
      if ok then
        pcall(require("render-markdown").enable)
      end
    end, 50)
  end,
})
-- ────────────────────────────────────────────────────────────
--  SECTION 11 — PASTE IMAGE
-- ────────────────────────────────────────────────────────────
vim.cmd([[function! PasteImage()
  let custom_name = input("Enter image name (without extension, blank for auto): ")
  if custom_name != ""
      let image_name = custom_name . ".png"
  else
      let image_name = strftime("%Y-%m-%d-%H%M%S") . ".png"
  endif
  if &filetype ==# 'tex'
      let note_dir     = expand("%:p:h")
      let project_dir  = fnamemodify(note_dir, ":h")
      let image_folder = project_dir . "/images/"
      let relative_path = "images/" . image_name
  else
      let image_folder  = "~/Documents/Notes/images/"
      let relative_path = image_folder . image_name
  endif
  if !isdirectory(image_folder)
      call mkdir(image_folder, "p")
  endif
  let image_path = image_folder . image_name
  call system("wl-paste -t image/png > " . shellescape(image_path))
  if &filetype ==# 'tex'
      let snippet = [
            \ "\\begin{figure}[htbp]",
            \ "  \\centering",
            \ "  \\includegraphics[width=\\linewidth]{" . relative_path . "}",
            \ "  \\caption{Your caption here}",
            \ "  \\label{fig:your_label}",
            \ "\\end{figure}",
            \ "" ]
      call append(line('.'), snippet)
  else
      execute "normal! a![](" . relative_path . ")"
  endif
endfunction]])

-- ────────────────────────────────────────────────────────────
--  SECTION 12 — MISC
-- ────────────────────────────────────────────────────────────
vim.deprecate = function() end

vim.api.nvim_create_user_command("Today", function()
  _G.habits.open()
end, {})

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  local path     = opts.args .. ".ipynb"
  local template = [[{
 "cells": [{"cell_type":"markdown","metadata":{},"source":["# New Notebook\n"]}],
 "metadata": {
  "kernelspec": {"display_name":"Python 3","language":"python","name":"python3"},
  "language_info": {"name":"python","file_extension":".py"}
 },
 "nbformat": 4, "nbformat_minor": 5
}]]
  local file = io.open(path,"w")
  if not file then print("Failed to create notebook"); return end
  file:write(template); file:close()
  vim.cmd("edit " .. path)
end, { nargs = 1 })


vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    local ok, alpha = pcall(require, "alpha")
    if not ok then return end

    local dashboard = require("alpha.themes.dashboard")

    local function get_greeting()
      local hour = tonumber(os.date("%H"))
      if hour < 12 then return "Good morning, elementare." end
      if hour < 18 then return "Good afternoon, elementare." end
      return "Good evening, elementare."
    end

    local function get_clock()
      return os.date("  %H:%M   %A, %d %B %Y")
    end

    local function recent_notes()
      local notes_dir = vim.fn.expand("~/Notes")
      local handle = io.popen(
        'find "'..notes_dir..'" -name "*.norg" -o -name "*.md" | xargs ls -t 2>/dev/null | head -7'
      )
      if not handle then return {} end
      local result = handle:read("*a")
      handle:close()
      local items = {}
      for line in result:gmatch("[^\n]+") do
        local name = line:match("([^/]+)%.[nm][do]?r?g?$") or line
        local l = line
        table.insert(items, dashboard.button(
          tostring(#items + 1),
          "  " .. name,
          "<cmd>edit " .. l .. "<CR>"
        ))
      end
      return items
    end

    alpha.setup({
      layout = {
        { type = "padding", val = 4 },
        {
          type = "text",
          val  = { get_clock(), "", get_greeting() },
          opts = { position = "center", hl = "AlphaClock" },
        },
        { type = "padding", val = 2 },
        {
          type = "group",
          val  = {
            dashboard.button("n", "  Today's note",  "<cmd>Today<CR>"),
            dashboard.button("f", "  Find note",     "<cmd>Telescope find_files cwd=~/Notes<CR>"),
            dashboard.button("g", "  Grep notes",    "<cmd>Telescope live_grep  cwd=~/Notes<CR>"),
            dashboard.button("c", "  Calendar",      "<cmd>CalendarVR<CR>"),
            dashboard.button("p", "  Projects",      "<cmd>Telescope find_files cwd=~/Notes/Projects<CR>"),
            dashboard.button("q", "  Quit",          "<cmd>qa<CR>"),
          },
          opts = { spacing = 1 },
        },
        { type = "padding", val = 2 },
        {
          type = "text",
          val  = { "  Recent" },
          opts = { position = "center", hl = "AlphaHeader" },
        },
        {
          type = "group",
          val  = recent_notes,
          opts = { spacing = 0 },
        },
      },
      opts = { margin = 5 },
    })

    -- Guard stale buffer redraws
    local _orig = alpha.redraw
    alpha.redraw = function()
      local buf = vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if vim.bo[buf].filetype ~= "alpha" then return end
      pcall(_orig)
    end

    -- Show dashboard if no file was passed
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        alpha.start(true)
      end, 100)
    end
  end,
})
