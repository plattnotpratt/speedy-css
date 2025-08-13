--- Generates the base css file with all styles based on params
function generateFile()
--    print("Padding:")
--    singleValueStyleWithRate("p", "padding")
--    singleValueStyleWithRate("pt", "padding-top")
--    singleValueStyleWithRate("pr", "padding-right")
--    singleValueStyleWithRate("pb", "padding-bottom")
--    singleValueStyleWithRate("pl", "padding-left")
--    print("Margin:")
--    singleValueStyleWithRate("m", "margin")
--    singleValueStyleWithRate("mt", "margin-top")
--    singleValueStyleWithRate("mr", "margin-right")
--    singleValueStyleWithRate("mb", "margin-bottom")
--    singleValueStyleWithRate("ml", "margin-left")
--    print("Border Radius:")
--    singleValueStyleWithRate("br", "border-radius")

end

--- Generates the a single value style from the single value class template based on initial parameters
--- for base css.
---@param selector_template string 
---@param style string
---@param limit number|nil [opt=6]
---@param rate number|nil [opt=5]
---@param unit string|nil [opt=px]
function singleValueStyleWithRate(selector_template, style, limit, rate, unit)
    limit = limit or 6
    rate = rate or 5
    unit = unit or "px"
    local count = 0
    while count <= limit do
        local selector = selector_template..'-'..count
        local value = "" .. count*rate .. "px"
        print(singleValueClassTemplate(selector, style, value))
        count = count + 1
    end
end





---Class String Generator
---@param selector string 
---@param style string
---@param value1 string
---@param value2 string
---@return string 'class style output'
function twoValueClassTemplate(selector, style, value1, value2)
    return ".".. selector .. "{"..style..":"..value1.." ".. value2.."}"
end



-- generateFile()