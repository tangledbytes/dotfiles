---@diagnostic disable-next-line: lowercase-global
_pickers = {}

local M = {}

M.register_picker = function(name, fn, ph)
  local ch = hs.chooser.new(fn)
  _pickers[name] = ch:placeholderText(ph or "Type to search")
end

M.choice_fn_for_picker = function(name)
  local ch = _pickers[name]
  return function(arg) ch.choices(ch, arg) end
end

M.show_picker = function(name)
  _pickers[name]:show()
end

M.picker_register_query_changed_callback = function(name, fn)
  local ch = _pickers[name]
  ch:queryChangedCallback(fn)
end

return M