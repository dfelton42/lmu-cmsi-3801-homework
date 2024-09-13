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
    local result = 1
    while result <= limit do
      coroutine.yield(result)
      result = result * base
    end
  end)
end
-- Write your say function here
function say(word)
  local sentence = word or ""
  return function(next_word)
    if next_word then
      sentence = sentence .. " " .. next_word
      return say(sentence)
    else
      return sentence
    end
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
  return setmetatable({a = a, b = b, c = c, d = d}, Quaternion)
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

function Quaternion.__add(q1, q2)
  return Quaternion.new(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)
end

function Quaternion.__mul(q1, q2)
  return Quaternion.new(
    q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
    q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
    q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
    q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a
  )
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion.__tostring(q)
  local result = tostring(q.a)
  if q.b ~= 0 then result = result .. (q.b > 0 and "+" or "") .. tostring(q.b) .. "i" end
  if q.c ~= 0 then result = result .. (q.c > 0 and "+" or "") .. tostring(q.c) .. "j" end
  if q.d ~= 0 then result = result .. (q.d > 0 and "+" or "") .. tostring(q.d) .. "k" end
  return result
end
