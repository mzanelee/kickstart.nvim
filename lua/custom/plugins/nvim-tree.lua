return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local function set_custom_mappings(bufnr)
        local api = require 'nvim-tree.api'

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
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

        vim.keymap.set('n', 'l', api.node.open.edit, opts 'Edit Or Open')
        vim.keymap.set('n', 'L', vsplit_preview, opts 'Vsplit Preview')
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close')
        vim.keymap.set('n', 'H', api.tree.collapse_all, opts 'Collapse All')
        vim.keymap.set('n', 'N', api.fs.create, opts 'Create New')
        vim.keymap.set('n', 'd', api.fs.cut, opts 'Cut')
        vim.keymap.set('n', 'D', api.fs.remove, opts 'Delete')
        vim.keymap.set('n', 'y', api.fs.copy.node, opts 'Copy')
        vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
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
          icons = {
            glyphs = {
              default = '󰈚',
              folder = {
                default = '',
                empty = '',
                empty_open = '',
                open = '',
                symlink = '',
              },
              git = { unmerged = '' },
            },
          },
        },
      }
    end,
  },
}
