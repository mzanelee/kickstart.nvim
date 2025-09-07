---@class (exact) HarpoonMarkDecorator: nvim_tree.api.decorator.UserDecorator
---@field private hm_icon nvim_tree.api.HighlightedString
local HarpoonMarkDecorator = require('nvim-tree.api').decorator.UserDecorator:extend()

function HarpoonMarkDecorator:new()
  self.enabled = true
  self.highlight_range = 'name'
  self.icon_placement = 'signcolumn'
  self.hm_icon = { str = '⇀', hl = { 'HarpoonMark' } }
  self:define_sign(self.hm_icon)
end

---@param node nvim_tree.api.Node
---@return nvim_tree.api.HighlightedString[]? icons
function HarpoonMarkDecorator:icons(node)
  local rel_path = vim.fn.fnamemodify(node.absolute_path, ':.')
  local mark = require('harpoon.mark').get_marked_file(rel_path)
  if mark ~= nil then
    return { self.hm_icon }
  else
    return nil
  end
end

---@param node nvim_tree.api.Node
---@return string? highlight_group
function HarpoonMarkDecorator:highlight_group(node)
  local rel_path = vim.fn.fnamemodify(node.absolute_path, ':.')
  local mark = require('harpoon.mark').get_marked_file(rel_path)
  if mark ~= nil then
    return 'HarpoonMark'
  else
    return nil
  end
end

return HarpoonMarkDecorator
