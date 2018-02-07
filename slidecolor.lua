-- title:  slide color
-- author: wowods
-- desc:   sliding puzzle with customize color
-- script: lua

SCENE_MENU = "menu"
SCENE_PLAY = "play"
COLOR_RED = "RED"
COLOR_GREEN = "GREEN"
COLOR_BLUE = "BLUE"

function init()
  scene = SCENE_MENU
  colors = {
    { r = 25,  g = 25,  b = 25,  isChanged = true  }, -- 1
    { r = 68,  g = 36,  b = 52,  isChanged = false }, -- 2
    { r = 200, g = 75,  b = 100, isChanged = true  }, -- 3
    { r = 78,  g = 74,  b = 79,  isChanged = false }, -- 4
    { r = 133, g = 76,  b = 48,  isChanged = false }, -- 5
    { r = 52,  g = 101, b = 36,  isChanged = false }, -- 6
    { r = 25,  g = 75,  b = 225,  isChanged = true }, -- 7
    { r = 117, g = 113, b = 97,  isChanged = false }, -- 8
    { r = 50,  g = 175, b = 50,  isChanged = true  }, -- 9
    { r = 210, g = 125, b = 44,  isChanged = false }, -- 10
    { r = 133, g = 149, b = 161, isChanged = false }, -- 11
    { r = 109, g = 170, b = 44,  isChanged = false }, -- 12
    { r = 210, g = 170, b = 153, isChanged = false }, -- 13
    { r = 109, g = 194, b = 202, isChanged = false }, -- 14
    { r = 218, g = 212, b = 94,  isChanged = false }, -- 15
    { r = 222, g = 238, b = 214, isChanged = false }, -- 16
  }
  anyChanges = true
  menuValues = {
    { color = 1, rStep = 1, gStep = 1, bStep = 1 },
    { color = 3, rStep = 8, gStep = 3, bStep = 4 },
    { color = 7, rStep = 1, gStep = 3, bStep = 9 },
    { color = 9, rStep = 2, gStep = 7, bStep = 2 }
  }
  cursorPos = 1
end

function update()
  if scene == SCENE_MENU then
    updateMenu()
  elseif scene == SCENE_PLAY then
    updatePlay()
  end
end

function updateMenu()
  --moving cursor up and down
  if btnp(0, 0, 30) and cursorPos > 1 then
    cursorPos = cursorPos - 1
  end
  if btnp(1, 0, 30) and cursorPos < 13 then
    cursorPos = cursorPos + 1
  end
  --changing value by pressing left and right
  if cursorPos < 13 then
    if btnp(2, 0, 30) then
      mvIndex = math.floor((cursorPos-1) / 3) + 1
      mvColor = ((cursorPos-1) % 3)
      mvStep = mvColor == 0 and "rStep" or (mvColor == 1 and "gStep" or "bStep")
      colCons = mvColor == 0 and COLOR_RED or (mvColor == 1 and COLOR_GREEN or COLOR_BLUE)
      if (menuValues[mvIndex][mvStep] > 1) then
        menuValues[mvIndex][mvStep] = menuValues[mvIndex][mvStep] - 1
        changeColor(menuValues[mvIndex]["color"], colCons, -1)
      end
    end
    if btnp(3, 0, 30) then
      mvIndex = math.floor((cursorPos-1) / 3) + 1
      mvColor = ((cursorPos-1) % 3)
      mvStep = mvColor == 0 and "rStep" or (mvColor == 1 and "gStep" or "bStep")
      colCons = mvColor == 0 and COLOR_RED or (mvColor == 1 and COLOR_GREEN or COLOR_BLUE)
      if (menuValues[mvIndex][mvStep] < 10) then
        menuValues[mvIndex][mvStep] = menuValues[mvIndex][mvStep] + 1
        changeColor(menuValues[mvIndex]["color"], colCons, 1)
      end
    end
  end
  --changing color on memory
  if (anyChanges) then
    for i,v in pairs(colors) do
      if v["isChanged"] then
        pal(i, v.r, v.g, v.b)
        v["isChanged"] = false
      end
    end
    anyChanges = false
  end
end

function updatePlay()
end

function draw()
  if scene == SCENE_MENU then
    drawMenu()
  elseif scene == SCENE_PLAY then
    drawPlay()
  end
end

function drawMenu()
  --draw menu options
  rect(15, 10, 30, 30, 1)

  print("R : "..menuValues[1].rStep, 60, 10, 15)
  print("G : "..menuValues[1]["gStep"], 60, 25, 15)
  print("B : "..menuValues[1]["bStep"], 60, 40, 15)
  rect(15, 70, 30, 30, 3)
  print("R : "..menuValues[2]["rStep"], 60, 70, 15)
  print("G : "..menuValues[2]["gStep"], 60, 85, 15)
  print("B : "..menuValues[2]["bStep"], 60, 100, 15)

  rect(135, 10, 30, 30, 7)
  print("R : "..menuValues[3]["rStep"], 180, 10, 15)
  print("G : "..menuValues[3]["gStep"], 180, 25, 15)
  print("B : "..menuValues[3]["bStep"], 180, 40, 15)
  rect(135, 70, 30, 30, 9)
  print("R : "..menuValues[4]["rStep"], 180, 70, 15)
  print("G : "..menuValues[4]["gStep"], 180, 85, 15)
  print("B : "..menuValues[4]["bStep"], 180, 100, 15)

  print("START?", 120, 125, 15)

  --draw cursor
  if cursorPos <= 3 then
    spr(1, 50, cursorPos * 15 - 6)
  elseif cursorPos <= 6 then
    spr(1, 50, cursorPos * 15 + 9)
  elseif cursorPos <= 9 then
    spr(1, 170, (cursorPos-6) * 15 - 6)
  elseif cursorPos <= 12 then
    spr(1, 170, (cursorPos-6) * 15 + 9)
  else
    spr(1, 110, 124)
  end
end

function drawPlay()
end

--function to changing color based on input
function changeColor(index, color, delta)
  --increase colors value
  if color == COLOR_RED then
    colors[index]["r"] = colors[index]["r"] + (delta * 25)
  elseif color == COLOR_GREEN then
    colors[index]["g"] = colors[index]["g"] + (delta * 25)
  elseif color == COLOR_BLUE then
    colors[index]["b"] = colors[index]["b"] + (delta * 25)
  end
  colors[index]["isChanged"] = true
  anyChanges = true
end

--function to generate color based on every corner
function generateColor()
  calculateColor(2, 1, 3)
  calculateColor(4, 1, 7)
  calculateColor(6, 3, 9)
  calculateColor(8, 7, 9)
  anyChanges = true
end
--function to calculate intermediate color
function calculateColor(target, indexA, indexB)
  colors[target]["r"] = (colors[indexA]["r"] + colors[indexB]["r"]) / 2
  colors[target]["g"] = (colors[indexA]["g"] + colors[indexB]["g"]) / 2
  colors[target]["b"] = (colors[indexA]["b"] + colors[indexB]["b"]) / 2
  colors[target]["isChanged"] = true
end
--sets the palette indice i to specified rgb
--or return the colors if no rgb values are declared.
function pal(i,r,g,b)
	--sanity checks
	if i<0 then i=0 end
	if i>15 then i=15 end
	--returning color r,g,b of the color
	if r==nil and g==nil and b==nil then
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0 end
		if g==nil or g<0 then g=0 end
		if b==nil or b<0 then b=0 end
		if r>255 then r=255 end
		if g>255 then g=255 end
		if b>255 then b=255 end
		poke(0x3fc0+(i*3)+2,b)
		poke(0x3fc0+(i*3)+1,g)
		poke(0x3fc0+(i*3),r)
	end
end

-- function rgbToHex(rgbDecimal)
--   local color = {
--     r = string.sub(rgbDecimal, 1, 3),
--     g = string.sub(rgbDecimal, 4, 6),
--     b = string.sub(rgbDecimal, 7, 9)
--   }
--   return decToHex(color.r)..decToHex(color.g)..decToHex(color.b);
-- end

-- function decToHex(decimal)
--   local hex = ""
--   decimal = decimal + 0
--   while decimal > 0 do
--     local mod = math.floor(decimal % 16)
--     if mod <= 9 then
--       hex = mod..hex
--     elseif mod == 10 then
--       hex = "A"..hex
--     elseif mod == 11 then
--       hex = "B"..hex
--     elseif mod == 12 then
--       hex = "C"..hex
--     elseif mod == 13 then
--       hex = "D"..hex
--     elseif mod == 14 then
--       hex = "E"..hex
--     elseif mod == 15 then
--       hex = "F"..hex
--     end
--     decimal = math.floor(decimal / 16)
--   end
--   --must return string with length of 2
--   while (string.len(hex) < 2) do
--     hex = "0"..hex
--   end
--   return hex
-- end

init()
function TIC()
  cls(10)
  update()
  draw()
end