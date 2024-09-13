function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here
  function first_then_lower_case(strings, predicate)
    for _, str in ipairs(strings) do
      if predicate(str) then
        return string.lower(str)
      end
    end
    return nil
  end
-- Write your powers generator here

function powers_generator(base, limit)
  return coroutine.create(function()
      local value = 1
      while value <= limit do
          coroutine.yield(value)
          value = value * base
      end
  end)
end

-- Write your say function here
  function say(first)
    if first == nil then
      return ""
    end
    return function(second)
      if second == nil then
        return first
      end
      return say(first .. " " .. second)
    end
  end

-- Write your line count function here
  function meaningful_line_count(filename)
    local file = io.open(filename, "r")
    if not file then error("No such file") end
    
    local count = 0
    for line in file:lines() do
      local trimmed_line = line:match("^%s*(.-)%s*$")
      if trimmed_line ~= "" and not trimmed_line:match("^%s*%-%-") then
        count = count + 1
      end
    end
    file:close()
    return count
  end

-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
    local self = setmetatable({}, Quaternion)
    self.a = a
    self.b = b
    self.c = c
    self.d = d
    return self
end
function Quaternion:plus(q)
    return Quaternion.new(
        self.a + q.a,
        self.b + q.b,
        self.c + q.c,
        self.d + q.d
    )
end
function Quaternion:times(q)
    return Quaternion.new(
        q.a * self.a - q.b * self.b - q.c * self.c - q.d * self.d,
        q.a * self.b + q.b * self.a - q.c * self.d + q.d * self.c,
        q.a * self.c + q.b * self.d + q.c * self.a - q.d * self.b,
        q.a * self.d - q.b * self.c + q.c * self.b + q.d * self.a
    )
end

function Quaternion:conjugate()
    return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion:coefficients()
    return {self.a, self.b, self.c, self.d}
end

function Quaternion:__tostring()
  local components = {}
  local function format_component(value, symbol)
      if value == 0 then return "" end
      if value == 1 then return symbol end
      if value == -1 then return "-" .. symbol end
      return tostring(value) .. symbol
  end
  if self.a ~= 0 or (self.b == 0 and self.c == 0 and self.d == 0) then
      table.insert(components, tostring(self.a))
  end
  local b_part = format_component(self.b, "i")
  local c_part = format_component(self.c, "j")
  local d_part = format_component(self.d, "k")
  if b_part ~= "" then table.insert(components, (self.b > 0 and #components > 0 and "+" or "") .. b_part) end
  if c_part ~= "" then table.insert(components, (self.c > 0 and #components > 0 and "+" or "") .. c_part) end
  if d_part ~= "" then table.insert(components, (self.d > 0 and #components > 0 and "+" or "") .. d_part) end

  return #components > 0 and table.concat(components) or "0"
end
function Quaternion.__eq(a, b)
    return a.a == b.a and a.b == b.b and a.c == b.c and a.d == b.d
end

function Quaternion.__add(a, b)
    return a:plus(b)
end

function Quaternion.__mul(a, b)
    return a:times(b)
end

setmetatable(Quaternion, {
    __index = Quaternion,
    __eq = Quaternion.__eq,
    __add = Quaternion.__add,
    __mul = Quaternion.__mul,
})

