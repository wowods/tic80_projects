-- title:  slide color
-- author: wowods
-- desc:   sliding puzzle with customize color
-- script: lua

function init()
  colors = {
    "140C1C",
    "442434",
    "30346D",
    "4E4A4F",
    "854C30",
    "346524",
    "D04648",
    "757161",
    "597DCE",
    "D27D2C",
    "8595A1",
    "6DAA2C",
    "D2AA99",
    "6DC2CA",
    "DAD45E",
    "DEEED6"
  }
end

function update()
end

function draw()
end

function changeColor(index, rgbString)
  
end

function generateColor(startIndex)
end

function rgbToHex(rgbDecimal)
  local color = {
    r = string.sub(rgbDecimal, 1, 3),
    g = string.sub(rgbDecimal, 4, 6),
    b = string.sub(rgbDecimal, 7, 9)
  }
  return decToHex(color.r)..decToHex(color.g)..decToHex(color.b);
end

function decToHex(decimal)
  local hex = ""
  decimal = decimal + 0
  trace("decimal:"..decimal)
  while decimal > 0 do
    local mod = math.floor(decimal % 16)
    trace("mod:"..mod)
    if mod <= 9 then
      hex = mod..hex
    elseif mod == 10 then
      hex = "A"..hex
    elseif mod == 11 then
      hex = "B"..hex
    elseif mod == 12 then
      hex = "C"..hex
    elseif mod == 13 then
      hex = "D"..hex
    elseif mod == 14 then
      hex = "E"..hex
    elseif mod == 15 then
      hex = "F"..hex
    end
    decimal = math.floor(decimal / 16)
    trace("hex:"..hex)
  end
  --must return string with length of 2
  -- while (string.len(hex) < 2) do
  --   hex = "0"..hex
  -- end
  return hex
end

init()
rgbInput = "100058112"
hexOutput = rgbToHex(rgbInput)
function TIC()
  cls(2)
  print(rgbInput, 10, 16, 15)
  print(hexOutput, 10, 22, 15)
  --update()
  --draw()
end