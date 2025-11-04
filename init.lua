vim.g.mapleader = ' ' 

--- General ====================================================================
vim.o.mouse       = 'a'            --- Enable mouse
vim.o.undofile    = true           --- Continous undo

--- UI =========================================================================
vim.o.wrap	  = false 	   --- Don't wrap lines
vim.o.number      = true           --- Linenumbers
vim.o.cursorline  = true           --- Highlight cursorline
vim.o.signcolumn  = 'yes'          --- Always show sign column
vim.o.list        = true           --- Show helpful text indicators
vim.o.winborder   = 'single'       --- Border for floating windows
vim.o.splitbelow  = true           --- Horizontal splits will be below
vim.o.splitkeep   = 'screen'       --- Reduce scroll during window split
vim.o.splitright  = true           --- Vertical splits will be to the right

--- Editing ====================================================================
vim.o.autoindent    = true    -- Use auto indent
vim.o.expandtab     = true    -- Convert tabs to spaces
vim.o.ignorecase    = true    -- Ignore case during search
vim.o.incsearch     = true    -- Show search matches while typing
vim.o.infercase     = true    -- Infer case in built-in completion
vim.o.shiftwidth    = 2       -- Use this number of spaces for indentation
vim.o.smartcase     = true    -- Respect case if search pattern has upper case
vim.o.smartindent   = true    -- Make indenting smart
vim.o.tabstop       = 2       -- Show tab as this number of spaces
vim.o.virtualedit   = 'block' -- Allow going past end of line in blockwise mode


--- Packages ===================================================================
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', name = 'main' }
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}


