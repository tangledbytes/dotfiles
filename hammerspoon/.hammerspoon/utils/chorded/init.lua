local Chorded = {}
Chorded.__index = Chorded

local function attach_post_hook(fn, post)
	return function()
		if fn ~= nil then
			fn()
		end

		post()
	end
end

local function attach_pre_hook(pre, fn)
	return function()
		pre()

		if fn ~= nil then
			fn()
		end
	end
end

function Chorded.new(mods, key, message, delay)
	local instance = setmetatable({}, Chorded)
	instance._internal = hs.hotkey.modal.new(mods, key, message)
	instance._timer = hs.timer.delayed.new(delay or 5, function() instance:exit(true) end)
	instance._entered = nil

	return instance
end

function Chorded:bind(mods, key, pressedfn, releasedfn, repeatFn)
	self._internal:bind(
		mods,
		key,
		attach_pre_hook(function() hs.alert.show(" " .. string.upper(key) .. " ", 1) end, pressedfn),
		attach_post_hook(releasedfn, function() self:exit() end),
		repeatFn
	)
	return self
end

function Chorded:entered(fn)
	local lself = self
	function self._internal:entered()
		lself._entered = true
		lself._timer:start()
		fn()
	end
end

function Chorded:enter()
	self._internal:enter()
	return self
end

function Chorded:exited(fn)
	function self._internal:exited()
		fn()
	end
end

function Chorded:exit(kind)
	if not self._entered then return self end

	self._entered = false
	self._internal:exit()
	if not kind then self._timer:stop() end

	return self
end

function Chorded:delete()
	self._internal:delete()
end

return Chorded
