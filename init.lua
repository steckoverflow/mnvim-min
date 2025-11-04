--- Notes
--- Welcome to my attempt to reach an IDE like full development experience.
--- I want to use as few plugins as possible and have the code explained.

--- ===============================================
---                 NATIVE VS PLUGIN
--- ===============================================
--- Lsp:              X
--- Statusline        X
--- Completion                  X (Blink.cmp)
--- File explorer     X

--- TODO:
--- - Read native lsp configuration
--- - Read native diagnostics section
--- - Read native statusline section
--- - Read blink.cmp docs
--- - Add readme with deps, bob, hint

---=============================================================================
--- OPTIONS
--------------------------------------------------------------------------------
--- Global  ====================================================================
vim.g.mapleader = " "

--- General ====================================================================
local o = vim.opt
o.mouse = "a"               --- Enable mouse
o.undofile = true           --- Continous undo
o.swapfile = false          --- Disable swap files
o.termguicolors = true      --- Enable true colors
o.clipboard = 'unnamedplus' --- System clipboard
o.updatetime = 250
-- o.timeoutlen = 300

--- UI =========================================================================
o.wrap = false         --- Don't wrap lines
o.colorcolumn = "80"   --- Highlight column 80
o.number = true        --- Linenumbers
o.cursorline = true    --- Highlight cursorline
o.signcolumn = "yes"   --- Always show sign column
o.list = true          --- Show helpful text indicators
o.winborder = "single" --- Border for floating windows
o.splitbelow = true    --- Horizontal splits will be below
o.splitkeep = "screen" --- Reduce scroll during window split
o.splitright = true    --- Vertical splits will be to the right
o.scrolloff = 8        --- Keep 8 lines above and below the cursor
o.laststatus = 2       --- Always show builint statusline

--- Editing ====================================================================
o.autoindent = true     -- Use auto indent
o.expandtab = true      -- Convert tabs to spaces
o.ignorecase = true     -- Ignore case during search
o.incsearch = true      -- Show search matches while typing
o.infercase = true      -- Infer case in built-in completion
o.shiftwidth = 2        -- Use this number of spaces for indentation
o.shiftround = true     -- Round indent to multiple of shiftwidth
o.smartcase = true      -- Respect case if search pattern has upper case
o.smartindent = true    -- Make indenting smart
o.tabstop = 2           -- Show tab as this number of spaces
o.softtabstop = 2       -- Number of spaces for a tab when editing
o.virtualedit = "block" -- Allow going past end of line in blockwise mode

---=============================================================================
--- KEYMAPS
--------------------------------------------------------------------------------
--- General ====================================================================
local map = vim.keymap.set
local s = { silent = true }
map("n", "<space>", "<Nop>")
map("n", "<esc>", "<cmd>nohlsearch<CR>") -- Clear highlight
map("n", "<Leader>fo", ":lua vim.lsp.buf.format()<CR>", s)
map("n", "<leader>ps", '<cmd>lua vim.pack.update()<CR>')
map("n", "<leader>t", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>r", ":split<CR>", { desc = "Horizontal split" })

--- Files ======================================================================
map("n", "<leader>e", "<cmd>Ex %:p:h<CR>") -- Open Netrw in current files dir

--- Navigation =================================================================
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--- Save & Load ================================================================
map("n", "<leader>w", "<cmd>w!<CR>", s)                               -- Write file
map("n", "<leader>s", ":source $HOME/.config/mnvim-min/init.lua<CR>") -- Source
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Window" })

-- This is supposed to save and exit Neovim
map("n", "<leader>x", function()
  -- Close all terminal buffers first
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.cmd("wqa")
end, { desc = "Kill terminals and exit" })

--- Plugins ===================================================================
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/saghen/blink.cmp",       version = vim.version.range("^1") },
  { src = "https://github.com/spaceduck-theme/nvim",   name = "spaceduck" },
  -- { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "main" },
})

-- NOTE:
-- Dont forget to install language servers
-- Checkhealth :checkhealth vim.lsp
require("mason").setup({})
require('gitsigns').setup()

-- Blink vs native
-- https://cmp.saghen.dev/#compared-to-built-in-completion
require('blink.cmp').setup({
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
  keymap = {
    preset = "super-tab"
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = {
      auto_show = true,
    }
  },
  sources = { default = { "lsp" } }
})

vim.cmd.colorscheme("spaceduck")

---=============================================================================
--- Builin
--------------------------------------------------------------------------------
--- Lsp ========================================================================
vim.lsp.enable({
  "lua_ls",
})
vim.diagnostic.config({ virtual_text = true })

--- Statusline ====================================================================
Statusline = {}

function Statusline.active()
  -- `%P` shows the scroll percentage but says 'Bot', 'Top' and 'All' as well.
  return "[%f]%=%y [%P %l:%c]"
end

function Statusline.inactive()
  return " %t"
end

---=============================================================================
--- Autocommands
--------------------------------------------------------------------------------
--- General ====================================================================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 170 })
  end,
  group = highlight_group,
})

local group = augroup("Statusline", { clear = true })

autocmd({ "WinEnter", "BufEnter" }, {
  group = group,
  desc = "Activate statusline on focus",
  callback = function()
    vim.opt_local.statusline = "%!v:lua.Statusline.active()"
  end,
})

autocmd({ "WinLeave", "BufLeave" }, {
  group = group,
  desc = "Deactivate statusline when unfocused",
  callback = function()
    vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
  end,
})
