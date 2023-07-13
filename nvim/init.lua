vim.g.mapleader = " "
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set("v", "<C-c>", '"*y :let @+=@*<CR>', { silent=true })
vim.keymap.set("n", "<C-v>", '"+p', { silent=true})
vim.keymap.set("n", "<C-h>", '<c-w>h', {})
vim.keymap.set("n", "<C-j>", '<c-w>j', {})
vim.keymap.set("n", "<C-k>", '<c-w>k', {})
vim.keymap.set("n", "<C-l>", '<c-w>l', {})
vim.keymap.set("n", "<C-n>", vim.cmd.NERDTreeToggle)

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use('preservim/nerdtree')


  use {
    "folke/which-key.nvim",
    event = "VimEnter",
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  -- Debugging
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    event = "BufReadPre",
    module = { "dap" },
    wants = { 
      "nvim-dap-virtual-text", 
      "nvim-dap-ui", 
      "nvim-dap-ruby",
      "telescope.nvim",
      "telescope-dap.nvim",
      "which-key.nvim",
    },
    requires = {
      "0000marcell/nvim-dap-ruby",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      --require('telescope').load_extension('dap')
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }
      local dap, dapui = require "dap", require "dapui"
      dap.set_log_level('TRACE')
      dapui.setup {
        icons = {},
        layouts = {
          {
            elements = {
              {
                id = "watches",
                size = 0.5
              },
              {
                id = "scopes",
                size = 0.5
              },
            },
            position = "bottom",
            size = 10
          }
        },
      } -- use default
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      require('dap-ruby').setup()


      local whichkey = require "which-key"

      local keymap = {
        d = {
          name = "Debug",
          a = { "<cmd>lua require'dap'.restart()<cr>", "Restart" },
          c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
          C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
          i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
          o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
          j = { "<cmd>lua require'dap'.up()<cr>", "Go up the stack frame" },
          k = { "<cmd>lua require'dap'.down()<cr>", "Go down the stack frame" },
          f = { "<cmd>Telescope dap frames<cr>", "Telescope frames" },
          b = { "<cmd>Telescope dap list_breakpoints<cr>", "Telescope list breakpoints" },
          r = { "<cmd>lua  require('dapui').float_element('repl', { width = 100, height = 20, enter = true, position = 'center' })<cr>", "Toggle Repl" },
          v = { "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>", "Toggle Repl" },
          s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
          t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
          x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
          u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
          h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
          U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
          e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
        },
      }

      whichkey.register(keymap, {
        mode = "n",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
      })

      local keymap_v = {
        name = "Debug",
        e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
      }
      whichkey.register(keymap_v, {
        mode = "v",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
      })
    end,
  }
end)


