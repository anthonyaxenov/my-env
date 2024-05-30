local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    -----------------------------------------------------------------
    -- Example
    -----------------------------------------------------------------

    -- https://github.com/vendor/package
    -- { 'vendor/package' },

    -----------------------------------------------------------------
    -- Misc
    -----------------------------------------------------------------

    -- https://github.com/ThePrimeagen/vim-be-good
    { 'ThePrimeagen/vim-be-good' },

    -----------------------------------------------------------------
    -- Navigation
    -----------------------------------------------------------------

    -- https://github.com/smoka7/hop.nvim
    -- { 'smoka7/hop.nvim' },

    -- https://github.com/akinsho/nvim-toggleterm.lua
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
    },

    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    -- {
    --     'nvim-neo-tree/neo-tree.nvim',
    --     branch = 'v3.x',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    --         'MunifTanjim/nui.nvim',
    --         -- '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    --     }
    -- },

    -- https://github.com/nvim-telescope/telescope.nvim
    -- {
    --     'nvim-telescope/telescope.nvim',
    --     branch = '0.1.x',
    --     dependencies = { 'nvim-lua/plenary.nvim' }
    -- },

    -----------------------------------------------------------------
    -- Colors, themes & highlighting
    -----------------------------------------------------------------

    -- https://github.com/glepnir/dashboard-nvim
    -- {
    --     'glepnir/dashboard-nvim',
    --     event = 'VimEnter',
    --     dependencies = {{'nvim-tree/nvim-web-devicons'}}
    -- },

    -- https://github.com/joshdick/onedark.vim
    { 'joshdick/onedark.vim' },

    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- { 'nvim-treesitter/nvim-treesitter' },

    -- https://github.com/folke/todo-comments.nvim
    -- { 'folke/todo-comments.nvim' },

    -----------------------------------------------------------------
    -- LSP & autocomplete
    -----------------------------------------------------------------

    -- https://github.com/folke/neodev.nvim
    -- { 'folke/neodev.nvim' },

    -- https://github.com/williamboman/mason.nvim
    -- { 'williamboman/mason.nvim' },

    -- https://github.com/neovim/nvim-lspconfig
    -- { 'neovim/nvim-lspconfig' },

    -- https://github.com/hrsh7th/cmp-nvim-lsp
    -- { 'hrsh7th/cmp-nvim-lsp' },

    -- https://github.com/hrsh7th/cmp-buffer
    -- { 'hrsh7th/cmp-buffer' },

    -- https://github.com/hrsh7th/cmp-path
    -- { 'hrsh7th/cmp-path' },

    -- https://github.com/hrsh7th/cmp-cmdline
    -- { 'hrsh7th/cmp-cmdline' },

    -- https://github.com/hrsh7th/nvim-cmp
    -- { 'hrsh7th/nvim-cmp' },

})
