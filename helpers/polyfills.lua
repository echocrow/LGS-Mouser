-- Polyfill "unpack()".
if unpack == nil then
  function unpack (t, i)
    i = i or 1
    if t[i] ~= nil then
      return t[i], unpack(t, i + 1)
    end
  end
end

-- Polyfill "math.atan2()".
if math.atan2 == nil then
  function math.atan2(x, y)
    if (x == 0 and y == 0) then return 0 end
    local atanRes = math.atan(x / y)
    local offsetFactor = (y < 0) and ((x >= 0) and 1 or -1) or 0
    local offset = math.pi * offsetFactor
    return atanRes + offset
  end
end
