---@class (exact) HarpoonMarkDecorator: nvim_tree.api.decorator.UserDecorator
---@field private icon_one nvim_tree.api.HighlightedString
---@field private icon_two nvim_tree.api.HighlightedString
---@field private icon_three nvim_tree.api.HighlightedString
---@field private icon_four nvim_tree.api.HighlightedString
---@field private icon_five nvim_tree.api.HighlightedString
local HarpoonMarkDecorator = require('nvim-tree.api').decorator.UserDecorator:extend()

function HarpoonMarkDecorator:new()
  self.enabled = true
  self.highlight_range = 'name'
  self.icon_placement = 'signcolumn'
  self.icon_one = { str = '1', hl = { 'Mark1' } }
  self.icon_two = { str = '2', hl = { 'Mark2' } }
  self.icon_three = { str = '3', hl = { 'Mark3' } }
  self.icon_four = { str = '4', hl = { 'Mark4' } }
  self.icon_five = { str = '5', hl = { 'Mark5' } }

  self:define_sign(self.icon_one)
  self:define_sign(self.icon_two)
  self:define_sign(self.icon_three)
  self:define_sign(self.icon_four)
  self:define_sign(self.icon_five)
end

---@param node nvim_tree.api.Node
---@return nvim_tree.api.HighlightedString[]? icons
function HarpoonMarkDecorator:icons(node)
  local rel_path = vim.fn.fnamemodify(node.absolute_path, ':.')
  local mark_idx = require('harpoon.mark').get_index_of(rel_path)
  if mark_idx == 1 then
    return { self.icon_one }
  elseif mark_idx == 2 then
    return { self.icon_two }
  elseif mark_idx == 3 then
    return { self.icon_three }
  elseif mark_idx == 4 then
    return { self.icon_four }
  elseif mark_idx == 5 then
    return { self.icon_five }
  else
    return nil
  end
end

---@param node nvim_tree.api.Node
---@return string? highlight_group
function HarpoonMarkDecorator:highlight_group(node)
  local rel_path = vim.fn.fnamemodify(node.absolute_path, ':.')
  local mark_idx = require('harpoon.mark').get_index_of(rel_path)
  return mark_idx and ('Mark' .. mark_idx) or nil
end

return HarpoonMarkDecorator
