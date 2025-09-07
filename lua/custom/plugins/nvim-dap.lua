return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'mrcarriga/nvim-dap-ui',
        url = 'git@my.github.com:rcarriga/nvim-dap-ui.git',
      },
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        ensure_installed = {
          'codelldb',
          'python',
        },
        automatic_installation = true,
        handlers = {},
      }

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      require('dap-python').setup()

      -- Keymaps for debugging
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug [B]reakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug Step [I]nto' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = '[D]ebug Step [O]ver' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = '[D]ebug Step [O]ut' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = '[D]ebug [R]EPL' })
      vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = '[D]ebug Run [L]ast' })
      vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = '[D]ebug [T]erminate' })

      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Error', linehl = '', numhl = '' })
    end,
  },
}
