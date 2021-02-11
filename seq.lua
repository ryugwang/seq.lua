local mt = {}
mt.__index = mt

mt.length = function(self)
	return #self.data
end

mt.current = function(self, str)
	if str then self.data[self.cursor] = str end
	return self.data[self.cursor]
end

mt.peek = function(self, offset)
	return self.data[self.cursor + offset]
end

mt.next = function(self, offset)
	local offset = offset or 1
	self.cursor = self.cursor + offset
	return self.data[self.cursor]
end

mt.prev = function(self, offset)
	offset = offset or 1
	self.cursor = self.cursor - offset
	return self.data[self.cursor]
end

mt.unget = mt.prev

mt.seek = function(self, offset)
	self.cursor = offset
end

mt.reset = function(self)
	mt.seek(self, 1)
end

mt.iter = function(self)
	self:prev()
	return function()
		return self:next()
	end
end

mt.append = function(self, t)
	if type(t) == 'table' then
		for _, v in ipairs(t) do
			table.insert(self.data, v)
		end
	else
		table.insert(self.data, t)
	end
	self.count = self.count + #t
	
end

mt.concat = function(self, delim)
	return table.concat(self.data, delim)
end

local function array_to_sequence(t)
	local inst = {}
	setmetatable(inst, mt)
	inst.data = t or {}
	inst.count = #inst.data
	inst.cursor = 1
	return inst
end

local util = {
	explode = function(src, sep, no_regex) -- ref. http://lua-users.org/wiki/SplitJoin
		local result = {}
		local cur = 0
		if (#src == 1) then return {src} end
		while true do
			local i, j = string.find(src, sep, cur, no_regex)
			if i then
				table.insert(result, src:sub(cur, i-1))
				cur = j + 1
			else
				table.insert(result, src:sub(cur))
				break
			end
		end
		return result
	end
	, load_lines = function(filename)
		local t = {}
		local f, err
		if filename == '--stdin' then
			f = io.stdin
		else
			f, err = io.open(filename)
		end
		if f then
			for line in f:lines() do
				table.insert(t, line)
			end
			f:close()
			return t
		else
			return nil, err
		end
	end

	, load_text = function(filename)
		return io.open(filename):read'*a'
	end

	, trim = function(s)
	  -- from PiL2 20.4
	  return (s:gsub("^%s*(.-)%s*$", "%1"))
	end
}

local function new_from_string(str)
	return array_to_sequence(
		util.explode(str, "\n")
	)
end

local function new_from_file(filename)
	local lines, err = util.load_lines(filename)
	if err then return nil, err end
	return array_to_sequence(lines)
end
----------------------------------------
return {
	new = array_to_sequence
,	new_from_file = new_from_file
,	new_from_string = new_from_string
,	util = util
}
