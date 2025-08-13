
local function splitCSV(line)
    local result = {}
    for value in line:gmatch("([^,]+)") do
        value = string.gsub(value, "%s+", "")
        table.insert(result, value)
    end
    return result
end

local function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end


--- Generates a template with a selector and a style and value for the style.
--- @param selector string
--- @param style string
--- @param value string
--- @return string
local function singleValueClassTemplate(selector,  style, value)
    return "." .. selector .. "{ " .. style ..": " .. value .. "; }"
end

--- Returns a string of a class element with the parameters listed below.
---@param selector_template string
---@param style string
---@param value string
---@return string
local function singleValueStyle(selector_template, style, value)
    return singleValueClassTemplate(selector_template, style, value) .. "\n"
end

--- Generates the a single value style from the single value class template based on initial parameters
--- for base css.
---@param selector_template string 
---@param style string
---@param range number|nil [opt=6]
---@param rate number|nil [opt=5]
---@param unit string|nil [opt=px]
---@return string "concatonated string of classes within the range"
function singleValueStyleWithRange(selector_template, style, range, rate, unit)
    range = range or 6
    rate = rate or 5
    unit = unit or "px"
    local count = 0
    local output = ""
    while count <= range do
        local selector = selector_template..'-'..count
        local value = "" .. count*rate .. "px"
        output = output .. singleValueClassTemplate(selector, style, value) .. "\n"
        count = count + 1
    end
    return output
end

local file = io.open("styles.csv", "r")  -- "r" means read mode
if not file then error("Could not open file styles.csv") end
local header = file:lines()()
header = splitCSV(header)
local styles = {}
for line in file:lines() do
    local cols = splitCSV(line)
    local style = {}
    for i, colName in ipairs(header) do
        style[colName] = cols[i]
    end
    table.insert(styles, style)
end

file:close()
local outputFile = io.open("style.css", "w")
if not outputFile then error("File could not open: style.css") end
io.output(outputFile)

-- Print the table
for _, style in ipairs(styles) do
    if tonumber(style.range) == 0 then
        io.write(singleValueStyle(style.selector_template, style.style, style.value1))
    else
       io.write(singleValueStyleWithRange(style.selector_template, style.style, tonumber(style.value1), tonumber(style.value2), style.value3))
    end
end

io.close(outputFile)
