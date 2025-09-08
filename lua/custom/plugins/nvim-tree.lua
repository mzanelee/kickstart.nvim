return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      { 'mzanelee/harpoon' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local api = require 'nvim-tree.api'
      local harpoon = require 'harpoon.mark'
      local harpoon_ui = require 'harpoon.ui'

      -- harpoon setup
      harpoon.on('changed', function()
        api.tree.reload()
      end)

      function nav_file(file_idx)
        return function()
          harpoon_ui.nav_file(file_idx)
        end
      end

      local function smart_ctrl_h()
        local pos = vim.api.nvim_win_get_position(0)
        local col = pos[2]

        if col == 0 then
          if vim.bo.filetype == 'NvimTree' then
            return
          end

          api.tree.open { find_file = true }
        else
          vim.cmd 'wincmd h'
        end
      end

      vim.keymap.set('n', '<leader>ba', harpoon.add_file, { desc = '[B]ookmark [A]dd File' })
      vim.keymap.set('n', '<leader>br', harpoon.rm_file, { desc = '[B]ookmark [R]emove File' })
      vim.keymap.set('n', '<leader>bn', harpoon_ui.nav_next, { desc = '[B]ookmark [N]ext' })
      vim.keymap.set('n', '<leader>bp', harpoon_ui.nav_prev, { desc = '[B]ookmark [P]revious' })
      vim.keymap.set('n', '<leader>b1', nav_file(1), { desc = '[B]ookmark Go To File [1]' })
      vim.keymap.set('n', '<leader>b2', nav_file(2), { desc = '[B]ookmark Go To File [2]' })
      vim.keymap.set('n', '<leader>b3', nav_file(3), { desc = '[B]ookmark Go To File [3]' })
      vim.keymap.set('n', '<leader>b4', nav_file(4), { desc = '[B]ookmark Go To File [4]' })
      vim.keymap.set('n', '<leader>b5', nav_file(5), { desc = '[B]ookmark Go To File [5]' })
      vim.keymap.set('n', '<leader>b6', nav_file(6), { desc = '[B]ookmark Go To File [6]' })
      vim.keymap.set('n', '<leader>b7', nav_file(7), { desc = '[B]ookmark Go To File [7]' })
      vim.keymap.set('n', '<leader>b8', nav_file(8), { desc = '[B]ookmark Go To File [8]' })
      vim.keymap.set('n', '<leader>b9', nav_file(9), { desc = '[B]ookmark Go To File [9]' })
      vim.keymap.set('n', '<leader>bc', harpoon.clear_all, { desc = '[B]ookmarks [C]lear All' })
      vim.keymap.set('n', '<leader>bm', harpoon_ui.toggle_quick_menu, { desc = '[B]ookmark [M]enu' })

      vim.keymap.set('n', '<C-h>', smart_ctrl_h, { desc = 'smart C-h: opens nvim-tree or move left', silent = true })

      local function set_custom_mappings(bufnr)
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        local function get_rel_path(node)
          return vim.fn.fnamemodify(node.absolute_path, ':.')
        end

        local function vsplit_preview()
          local node = api.tree.get_node_under_cursor()
          if node.nodes ~= nil then
            api.node.open.edit()
          else
            api.node.open.vertical()
          end

          api.tree.focus()
        end

        local function edit_and_close_tree()
          local node = api.tree.get_node_under_cursor()
          api.node.open.edit()
          if node.nodes == nil then
            api.tree.close()
          end
        end

        local function harpoon_toggle()
          local node = api.tree.get_node_under_cursor()
          local rel_path = get_rel_path(node)
          local mark = harpoon.get_marked_file(rel_path)
          if mark == nil then
            if node.nodes == nil then
              harpoon.add_file(rel_path, {})
            end
          else
            harpoon.rm_file(rel_path)
          end
        end

        local function remove_mark_with_action(action)
          return function()
            local rel_path = get_rel_path(api.tree.get_node_under_cursor())
            local mark = harpoon.get_marked_file(rel_path)
            if mark ~= nil then
              harpoon.rm_file(rel_path)
            end
            api.fs[action]()
          end
        end

        vim.keymap.set('n', 'l', api.node.open.edit, opts 'Edit Or Open')
        vim.keymap.set('n', 'L', vsplit_preview, opts 'Vsplit Preview')
        vim.keymap.set('n', '<CR>', edit_and_close_tree, opts 'Edit And Close')
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close')
        vim.keymap.set('n', 'H', api.tree.collapse_all, opts 'Collapse All')
        vim.keymap.set('n', 'N', api.fs.create, opts 'Create New')
        vim.keymap.set('n', 'd', remove_mark_with_action 'cut', opts 'Cut')
        vim.keymap.set('n', 'D', remove_mark_with_action 'remove', opts 'Delete')
        vim.keymap.set('n', 'r', remove_mark_with_action 'rename', opts 'Rename')
        vim.keymap.set('n', 'y', api.fs.copy.node, opts 'Copy')
        vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
        vim.keymap.set('n', 'b', harpoon_toggle, opts '[B]ookmark Toggle')
      end

      require('nvim-tree').setup {
        filters = { dotfiles = false },
        disable_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        on_attach = set_custom_mappings,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          width = 35,
          preserve_window_proportions = true,
        },
        renderer = {
          root_folder_label = false,
          highlight_git = true,
          indent_markers = { enable = true },
          decorators = {
            'Git',
            'Open',
            'Hidden',
            'Modified',
            'Diagnostics',
            'Copied',
            'Cut',
            require 'custom.decorators.HarpoonMarkDecorator',
          },
          icons = {
            git_placement = 'after',
            glyphs = {
              default = '󰈚',
              symlink = '󱓻',
              modified = '',
              hidden = '󱙝',
              folder = {
                default = '',
                empty = '',
                empty_open = '',
                open = '',
                symlink = '',
              },
              git = {
                unstaged = '×',
                staged = '',
                unmerged = '',
                untracked = '',
                renamed = '',
                deleted = '',
                ignored = '∅',
              },
            },
          },
        },
      }
    end,
  },
}
