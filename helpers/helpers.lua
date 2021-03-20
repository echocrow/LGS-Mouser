-- Build module.
module = {}

-- Copy a table.
function copy(t, deep)
  if type(t) ~= "table" then return t end
  local meta = getmetatable(t)
  local target = {}
  for k, v in pairs(t) do
    target[k] = (type(v) == "table" and deep) and copy(v, deep) or v
  end
  setmetatable(target, meta)
  return target
end
module.copy = copy

-- Clone (deep-copy) a table
function module.clone(t) return module.copy(t, true) end

-- Merge a table.
function module.merge(t1, t2)
  local mergedTable = copy(t1)
  for k,v in pairs(t2) do mergedTable[k] = v end
  return mergedTable
end

-- Return module.
return module
