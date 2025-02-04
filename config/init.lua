-------------------------------------------------------------------------------
-- Wenzels NVIM configuration.
-------------------------------------------------------------------------------
--
-- Reminder to self about various hotkeys:
--
--    A+<hjkl>  : navigate between windows
--    A+m       : maximize window (toggles)
--    A+e       : equalize window sizes
--    A+d       : delete buffer but keep window (:q to close it)
--
--    Q         : justify the current paragraph or visual selection
--
--
-- Leader (",")-prefixed commands:
--
--    Fuzzy finders
--    ------------------------------
--    ,  -- find in buffer list
--    se -- find using file explorer
--    sh -- find in nvim help
--    sh -- find in files
--    sw -- find cursor word in files
--    sg -- find via grep
--    sd -- find diagnostic
--
--    e  -- toggle diagnostic view
--
-------------------------------------------------------------------------------
-- User interface options
-------------------------------------------------------------------------------

-- Enable 24 bit colors in the terminal and load the theme
vim.opt.termguicolors = true

-- Lines don't wrap
vim.opt.wrap = false

-- Enable line numbers
vim.opt.number = true

-- Always show the sign column to avoid popping
vim.wo.signcolumn = "yes"

-- Show one status line at the bottom
vim.opt.laststatus = 3

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make internal tab-completion more intuitive:
-- 1st tab: fills longest completion and shows options,
-- 2nd tab: enters UI for moving through options
vim.opt.wildmode = 'longest:list,full'

-- don't show the mode (the statusline already does so)
vim.opt.showmode = false

-------------------------------------------------------------------------------
-- Indentation-related options
-------------------------------------------------------------------------------

-- Smart indentation with 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-------------------- Key bindings --------------------

-- Set comma as the leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Replace colon and semicolon
vim.keymap.set('n', ':', ';', { noremap=true })
vim.keymap.set('n', ';', ':', { noremap=true })
vim.keymap.set('v', ':', ';', { noremap=true })
vim.keymap.set('v', ';', ':', { noremap=true })

-- Disable horizontal/vertical mouse wheel scrolling
vim.keymap.set('n', '<ScrollWheelLeft>', '', { noremap=true })
vim.keymap.set('n', '<ScrollWheelRight>', '', { noremap=true })

--  Use Alt+<hjkl> to switch between windows
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<A-.>', '<cmd>vsplit<cr>', { desc = 'split the window vertically' })
vim.keymap.set('n', '<A-,>', '<cmd>split<cr>', { desc = 'split the window horizontally' })


-- Jump back and forth when navigating through multiple buffers (esp. with JSP go to reference)
vim.keymap.set('n', 'gj', '<C-o>', { noremap=true, nowait=true, silent=true, desc='Jump list: next' })
vim.keymap.set('n', 'gk', '<C-i>', { noremap=true, nowait=true, silent=true, desc='Jump list: previous' })

-- vim.keymap.set('n', '', builtin.grep_string, { desc = '[S]earch current [W]ord' })

-- Use the 'Q' key to reformat paragraphs
vim.keymap.set('v', 'Q', 'gq')
vim.keymap.set('n', 'Q', 'gqap')

-------------------- Other tweaks ---------------------

-- Save undo history
vim.opt.undofile = true

local backup_dir = vim.fn.stdpath 'data' .. '/backup'
vim.fn.mkdir(backup_dir, "p", "0o700")

-- Enable backups (to 'backuppath')
vim.opt.backupdir = backup_dir
vim.opt.backup = true

vim.opt.spellfile = vim.env.TERM_TOOLS .. '/config/spell.en.utf-8.add'
vim.opt.spelllang = 'en_us'

-- Use njnja-build as 'Make' program by default
vim.opt.makeprg='ninja'

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Trigger the 'CursorHold' event after a relatively short time (original : 4000ms)
vim.opt.updatetime = 1500

-- Disable NetRW
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install the 'lazy' package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Load the theme first
  {
    'RRethy/base16-nvim',
    lazy=false,
    priority=1000, -- before all other plugins
    config = function()
      base16 = require("base16-colorscheme")
      base16.with_config({
        telescope = false,
        indentblankline = false,
        notify = true,
        cmp = true
      })
      vim.cmd('hi clear')
      -- variant of base16-tomorrow-night. Modified the background (base00) and
      -- made the base0e purple color more muted
      base16.setup({
        base00 = '#262626', base01 = '#282a2e', base02 = '#373b41', base03 = '#969896',
        base04 = '#b4b7b4', base05 = '#bcbcbc', base06 = '#e0e0e0', base07 = '#ffffff',
        base08 = '#cc6666', base09 = '#de935f', base0A = '#f0c674', base0B = '#b5bd68',
        base0C = '#8abeb7', base0D = '#81a2be', base0E = '#af87ae', base0F = '#a3685a'
      })

      -- Identifiers were previously using 'base08' as highlight color, which
      -- is very red and distracting. This reassigns it to the neutral base05
      local base05 = base16.colors.base05
      vim.cmd('hi Identifier guifg='..base05)
      vim.cmd('hi TSVariable guifg='..base05)

      -- lighter gray for line numbers and splits
      vim.cmd('hi LineNr guifg=#404040')
      vim.cmd('hi VertSplit guifg=#505050')

      -- visually highhight spelling mistakes
      vim.cmd('hi SpellBad gui=bold,undercurl guifg=#ff3333')
    end,
  },

  ---- Status line and miscellaneous 'mini' plugins
  {
    'echasnovski/mini.nvim',
    version = false,
    lazy = false,
    config = function()
      -- Statusline configuration
      statusline = require('mini.statusline')
      statusline.setup({ set_vim_settings = false })
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Display and delete trailing space
      require('mini.trailspace').setup({})
      vim.cmd('hi MiniTrailspace guibg=#b03030')

      -- Delete buffers without disturbing the window layout
      require('mini.bufremove').setup({})

      -- Comment and uncomment code snippets
      require('mini.comment').setup({
         mappings = {
           comment_visual = '<Leader>c',
           comment_line = '<Leader>c'
         }
      })
    end,
    keys = {{ "<leader>fw", function() MiniTrailspace.trim() end, desc = "Fix [W]hitespace" },
            { "<A-d>", function() MiniBufremove.delete() end, desc = "Remove buffer" }}
  },

  -- Remember the last position in files
  {
    "vladdoster/remember.nvim",
    opts={ }
  },

  -- Personal settings
  {
    "wjakob/wjakob.nvim",
    opts={ }
  },

  -- Nice visual notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      vim.notify = notify
      notify.setup()
    end
  },

  -- Async job processor (builds, etc.)
  {
    'stevearc/overseer.nvim',
    lazy=true
  },

  -- Git decorations
  {
    'lewis6991/gitsigns.nvim',
    config=function()
      require('gitsigns').setup{
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']h', function()
            if vim.wo.diff then return ']h' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc="Git: Next [H]unk"})

          map('n', '[c', function()
            if vim.wo.diff then return '[h' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc="Git: Previous [H]unk"})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc='[S]tage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc='[R]eset hunk' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc='[U]nstage hunk' })
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gs.stage_buffer, { desc='[S]tage buffer'})
          map('n', '<leader>hR', gs.reset_buffer, { desc='[R]eset buffer'})
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc='Show [B]lame'})

          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  },

  -- Convenient interface for diagnostics. <leader>t
  {
    "folke/trouble.nvim",
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { },
    init = function()
      vim.keymap.set(
        "n", "<leader>e",
        function()
          require("trouble").toggle("document_diagnostics")
        end,
        { desc = 'Show [E]rrors' })
    end
  },

  -- Document key bindings from this configuration
  {
    'folke/which-key.nvim',
    lazy = true,
    event = "VeryLazy",
    keys = { "<leader>", "<cmd>WhickKey<cr>", desc = "toggle whichkey" },
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({ })
    end
  },

  { -- Directory browser
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
          "icon",
          "size",
          "mtime",
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name,_)
            return name == ".." or name == ".git"
          end,
        }
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },

  { -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
--    event = 'VimEnter',
    lazy=false,
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      telescope.setup {
        extensions = {
          -- Use Telescope to handle vim.ui.select
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        pickers = {
          colorscheme = {
            theme = "ivy",
            enable_preview = true
          }
        },
        defaults = {
          mappings = {
            i = {
              -- These are actually rempaped from C-j/C-k by tmux
              ["<PageDown>"] = actions.move_selection_next,
              ["<PageUp>"] = actions.move_selection_previous,
              ["<Escape>"] = actions.close
            }
          }
        }
      }
      -- Enable telescope extensions
      telescope.load_extension('fzf')
      telescope.load_extension('ui-select')

      find_files = function()
          cwd = vim.loop.cwd()
          if vim.endswith(cwd, "/build") then
            cwd = vim.fs.dirname(cwd)
          end
          builtin.find_files({cwd = cwd})
      end

      live_grep = function()
          cwd = vim.loop.cwd()
          if vim.endswith(cwd, "/build") then
            cwd = vim.fs.dirname(cwd)
          end
          builtin.live_grep({cwd = cwd})
      end

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sf', find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[,] Search existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end, { desc = '[/] Fuzzy search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in open files' })
    end,
  },

  -- Tree-sitter integration
  {
      'nvim-treesitter/nvim-treesitter',
      event = "VeryLazy",
      dependencies = {
          'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ':TSUpdate',
      config = function ()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                'c', 'cpp', 'lua', 'python', 'toml', 'rust', 'bash', 'asm',
                'cmake', 'cuda', 'rst', 'markdown', 'comment', 'vim', 'vimdoc'
            },
            auto_install = true,
            sync_install = false,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false
            },
            indent = { enable = true },
            incremental_selection = { enable = false },
          })
      end
  },


  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = {
      inlay_hints = { enabled = true },
    },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim'
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch document [s]ymbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch workspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>fr', vim.lsp.buf.rename, '[R]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          vim.keymap.set(
            {"n", "v"}, "<leader>ff",
            function() vim.lsp.buf.format({ }) end,
            { buffer = event.buf, desc = 'LSP: [F]ormat selection or buffer' }
          )

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Broadcast capabilities to LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      local servers = {
        -- cmake = {},
        clangd = {
            cmd = {
              "clangd",
              "--offset-encoding=utf-16",
            },
        },
        pyright = {},
        --ruff_lsp = {},
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
    config = function()
      -- See `:help cmp`
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          -- Move between items
          ['<PageUp>'] = cmp.mapping.select_prev_item(),
          ['<PageDown>'] = cmp.mapping.select_next_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
        },
        sources = {
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' }
        },
      }

      vim.keymap.set('i', '<C-space>', vim.lsp.buf.signature_help, { noremap=true, silent=true })
    end,
  },

  -- PyTest integration
  --{
  --  "nvim-neotest/neotest",
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --    "antoinemadec/FixCursorHold.nvim",
  --    "nvim-treesitter/nvim-treesitter",
  --    'nvim-neotest/neotest-python'
  --  },
  --  event="VeryLazy",
  --  config=function()
  --    require("neotest").setup({
  --      adapters = {
  --        require("neotest-python")({ })
  --      },
  --      output = { open_on_run = true },
  --      quickfix = {
  --        open = function()
  --          require("trouble").open({ mode = "quickfix", focus = false })
  --        end,
  --      },
  --    })
  --    local map = function(keys, func, desc)
  --       vim.keymap.set('n', keys, func, {  desc = 'Test: ' .. desc })
  --    end
  --    map("<leader>tt", function() vim.api.nvim_command('silent update') require("neotest").run.run(vim.fn.expand("%")) end, "Run File")
  --    map("<leader>tT", function() vim.api.nvim_command('silent update') require("neotest").run.run(vim.loop.cwd()) end, "Run All Test Files")
  --    map("<leader>tr", function() vim.api.nvim_command('silent update') require("neotest").run.run() end, "Run Nearest")
  --    map("<leader>tl", function() vim.api.nvim_command('silent update') require("neotest").run.run_last() end, "Run Last")
  --    map("<leader>ts", function() require("neotest").summary.toggle() end, "Toggle Summary")
  --    map("<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, "Show Output")
  --    map("<leader>tO", function() require("neotest").output_panel.toggle() end, "Toggle Output Panel")
  --    map("<leader>tS", function() require("neotest").run.stop() end, "Stop")
  --  end
  --},

  -- Maximize/equalize windows with Alt-M/Alt-E
  { "anuvyklack/windows.nvim",
     event="VeryLazy",
     dependencies={ "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
     config = function()
       vim.o.winwidth = 10
       vim.o.winminwidth = 0
       vim.o.winminheight = 0
       vim.o.equalalways = false
       require('windows').setup({
           autowidth = { enable = false }
       })
       vim.keymap.set('n', '<A-m>', '<cmd>WindowsMaximize<CR>')
       vim.keymap.set('n', '<A-e>', '<cmd>WindowsEqualize<CR>')
     end
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      search = {
        multi_window = false,
        wrap = false,
      },
      -- don't use for f/F/t/T motions
      modes = {
        char = {
          enabled = false
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  --{
  --  'github/copilot.vim'
  --}
}, {})

vim.g.copilot_filetypes = {cpp = true, python=true}

-------------------------------------------------------------------------------
-- Miscellaneous
-------------------------------------------------------------------------------

-- Flash yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
})


-- Enable spell-checking when editing text files
vim.api.nvim_create_autocmd('FileType', {
  pattern = "text,tex,plaintex,html,rst,markdown,gitcommit",
  callback = function()
    vim.opt_local.spell = true
  end
})

-- vim.diagnostic.config({
--   virtual_text = {severity = {min = vim.diagnostic.severity.WARN}},
--   signs = {severity = {min = vim.diagnostic.severity.WARN}},
--   underline = {severity = {min = vim.diagnostic.severity.WARN}},
-- })


wk = require("which-key")
--vim.keymap.set('n', 'gn', '<Nop>')
--vim.keymap.set('n', 'gN', '<Nop>')

wk.add(
  {
    { "<leader>f", group = "[F]ix .." },
    { "<leader>s", group = "[S]earch .." },
    { "<leader>t", group = "[T]est .." },
    { "gn", hidden = true },
  }
)

-- Edit this file
vim.keymap.set(
  'n', '<leader>l',
  function()
    vim.cmd('e ' .. vim.env.TERM_TOOLS .. '/config/init.lua')
  end,
  { desc = 'Edit [L]ua configuration' }
)

-- Reload the file when changed outside of the editor
vim.api.nvim_create_autocmd({'VimResume', 'FocusGained'}, {
  callback = function()
    vim.api.nvim_command('checktime')
  end
})

vim.api.nvim_create_user_command("Make", function(params)
  -- Insert args at the '$*' in the makeprg
  local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
  if num_subs == 0 then
    cmd = cmd .. " " .. params.args
  end
  local task = require("overseer").new_task({
    cmd = vim.fn.expandcmd(cmd),
    components = {
      { "on_output_quickfix", open = not params.bang, open_height = 8 },
      "default",
    },
  })
  task:start()
end, {
  desc = "Run your makeprg as an Overseer task",
  nargs = "*",
  bang = true,
})

vim.keymap.set('n', '<leader>m', "<cmd>Make<cr>", { desc='[M]ake' })
vim.keymap.set('n', '<leader>H',
    function()
      if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end
)
