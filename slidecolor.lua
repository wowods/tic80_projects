-- title:  slide color
-- author: wowods
-- desc:   sliding puzzle with customize color
-- script: lua

-- constants used in this project
SCENE_MENU = "menu"
SCENE_PLAY = "play"
COLOR_RED = "RED"
COLOR_GREEN = "GREEN"
COLOR_BLUE = "BLUE"
MOVE_UP = "UP"
MOVE_DOWN = "DOWN"
MOVE_LEFT = "LEFT"
MOVE_RIGHT = "RIGHT"
START_WIDTH = print("START", 0, 0)

function init()
  scene = SCENE_MENU
  menuMessage = {
    x = 0,
    y = 115,
    width = 0,
    text = "Menu Message",
    prevText = "Menu Message",
    duration = 90, --1.5s
    timer = 0
  }
  menuMessage.width = print(menuMessage.text, 0, -20)
  menuMessage.x = (240 - menuMessage.width) // 2
  playMessage = {
    x = 0,
    y = 0,
    width = 0,
    text = "Play Message",
    prevText = "Play Message",
    timer = 0
  }
  playMessage.width = print(playMessage.text, 0, -20)
  playMessage.x = (240 - playMessage.width) // 2

  --init variables for menu
  colors = {
    { r = 55,  g = 55,  b = 55,  isChanged = true  }, -- 1
    { r = 68,  g = 36,  b = 52,  isChanged = false }, -- 2
    { r = 215, g = 115, b = 135, isChanged = true  }, -- 3
    { r = 78,  g = 74,  b = 79,  isChanged = false }, -- 4
    { r = 10,  g = 10,  b = 10,  isChanged = true  }, -- 5
    { r = 52,  g = 101, b = 36,  isChanged = false }, -- 6
    { r = 75,  g = 115, b = 235, isChanged = true  }, -- 7
    { r = 117, g = 113, b = 97,  isChanged = false }, -- 8
    { r = 95,  g = 195, b = 95,  isChanged = true  }, -- 9
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
  

  --init variables for playing
  grid = {
    { 1, 2, 3 },
    { 4, 0, 6 },
    { 7, 8, 9 }
  }
  emptyGrid = { x = 2, y = 2 }
  isWinning = false
end

function update()
  if scene == SCENE_MENU then
    updateMenu()
  elseif scene == SCENE_PLAY then
    updatePlay()
  end
end

function draw()
  if scene == SCENE_MENU then
    drawMenu()
  elseif scene == SCENE_PLAY then
    drawPlay()
  end
  --print menuMessage
  if menuMessage.timer > 0 then
    --re-calculate text width if text changed
    if menuMessage.text ~= menuMessage.prevText then
      menuMessage.width = print(menuMessage.text, 0, -20)
      menuMessage.x = (240 - menuMessage.width) // 2
    end
    print(menuMessage.text, menuMessage.x, menuMessage.y)
    menuMessage.timer = menuMessage.timer - 1
  end
  --print playMessage
  if playMessage.timer > 0 then
    --re-calculate text width if text changed
    if playMessage.text ~= playMessage.prevText then
      playMessage.width = print(playMessage.text, 0, -20)
      playMessage.x = (240 - playMessage.width) // 2
    end
    print(playMessage.text, playMessage.x, playMessage.y)
  end
end

function updateMenu()
  --moving cursor up and down
  if btnp(0, 0, 30) then
    if cursorPos > 1 then
      cursorPos = cursorPos - 1
    else
      cursorPos = 13
    end
  end
  if btnp(1, 0, 30) then
    if cursorPos < 13 then
      cursorPos = cursorPos + 1
    else
      cursorPos = 1
    end
  end
  --changing value by pressing left and right
  --or start the game if cursor on start label
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
  elseif btnp(2, 0, 30) or btnp(3, 0, 30) then
    --preparing to go to SCENE_PLAY
    goToScenePlay()
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

function drawMenu()
  --draw menu options
  rect(15, 10, 30, 30, 1)
  print("1", 25, 20, 5, false, 2)
  print("R : "..menuValues[1]["rStep"], 60, 10, 15)
  print("G : "..menuValues[1]["gStep"], 60, 25, 15)
  print("B : "..menuValues[1]["bStep"], 60, 40, 15)
  rect(135, 10, 30, 30, 3)
  print("2", 145, 20, 5, false, 2)
  print("R : "..menuValues[2]["rStep"], 180, 10, 15)
  print("G : "..menuValues[2]["gStep"], 180, 25, 15)
  print("B : "..menuValues[2]["bStep"], 180, 40, 15)
  
  rect(15, 70, 30, 30, 7)
  print("3", 25, 80, 5, false, 2)
  print("R : "..menuValues[3]["rStep"], 60, 70, 15)
  print("G : "..menuValues[3]["gStep"], 60, 85, 15)
  print("B : "..menuValues[3]["bStep"], 60, 100, 15)  
  rect(135, 70, 30, 30, 9)
  print("4", 145, 80, 5, false, 2)
  print("R : "..menuValues[4]["rStep"], 180, 70, 15)
  print("G : "..menuValues[4]["gStep"], 180, 85, 15)
  print("B : "..menuValues[4]["bStep"], 180, 100, 15)

  --draw start menu at the bottom of screen
  print("START", (240-START_WIDTH)//2, 125, 15)

  --draw cursor
  if cursorPos <= 3 then
    spr(1, 50, cursorPos * 15 - 6, 5)
  elseif cursorPos <= 6 then
    spr(1, 170, (cursorPos-3) * 15 - 6, 5)
  elseif cursorPos <= 9 then
    spr(1, 50, (cursorPos-3) * 15 + 9, 5)
  elseif cursorPos <= 12 then
    spr(1, 170, (cursorPos-6) * 15 + 9, 5)
  else
    spr(1, (240-START_WIDTH)/2-10, 124, 5)
  end
end

--preparing to go to SCENE_PLAY
function goToScenePlay()
  if checkSelectedColors() then
    generateColor()
    randomizeGrid()
    scene = SCENE_PLAY
  end
end

--function to changing color based on input
function changeColor(index, color, delta)
  --increase colors value
  if color == COLOR_RED then
    colors[index]["r"] = colors[index]["r"] + (delta * 20)
  elseif color == COLOR_GREEN then
    colors[index]["g"] = colors[index]["g"] + (delta * 20)
  elseif color == COLOR_BLUE then
    colors[index]["b"] = colors[index]["b"] + (delta * 20)
  end
  colors[index]["isChanged"] = true
  anyChanges = true
end

--function to check if selected color in menu is valid or not
function checkSelectedColors()
  local color1 = menuValues[1]
  local color3 = menuValues[2]
  local color7 = menuValues[3]
  local color9 = menuValues[4]
  if color1.rStep == color3.rStep and
     color1.gStep == color3.gStep and 
     color1.bStep == color3.bStep then
    menuMessage.text = "Color 1 and 2 can't be the same color"
    menuMessage.timer = menuMessage.duration
    return false
  elseif color1.rStep == color7.rStep and
         color1.gStep == color7.gStep and 
         color1.bStep == color7.bStep then
    menuMessage.text = "Color 1 and 3 can't be the same similar"
    menuMessage.timer = menuMessage.duration
    return false
  elseif color1.rStep == color9.rStep and
         color1.gStep == color9.gStep and 
         color1.bStep == color9.bStep then
    menuMessage.text = "Color 1 and 4 can't be the same similar"
    menuMessage.timer = menuMessage.duration
    return false
  elseif color3.rStep == color7.rStep and
         color3.gStep == color7.gStep and 
         color3.bStep == color7.bStep then
    menuMessage.text = "Color 2 and 3 can't be the same similar"
    menuMessage.timer = menuMessage.duration
    return false
  elseif color3.rStep == color9.rStep and
         color3.gStep == color9.gStep and 
         color3.bStep == color9.bStep then
    menuMessage.text = "Color 2 and 4 can't be the same similar"
    menuMessage.timer = menuMessage.duration
    return false
  elseif color7.rStep == color9.rStep and
         color7.gStep == color9.gStep and 
         color7.bStep == color9.bStep then
    menuMessage.text = "Color 3 and 4 can't be the same similar"
    menuMessage.timer = menuMessage.duration
    return false
  else
    return true
  end
end

--function to generate color based on every corner
function generateColor()
  calculateColor(2, 1, 3)
  calculateColor(4, 1, 7)
  calculateColor(6, 3, 9)
  calculateColor(8, 7, 9)
  ----for background color on playing scene
  --calculateColor(5, 5, 2)
  --calculateColor(5, 5, 4)
  --calculateColor(5, 5, 6)
  --calculateColor(5, 5, 8)
  anyChanges = true
end

--function to calculate intermediate color
function calculateColor(target, indexA, indexB)
  colors[target]["r"] = (colors[indexA]["r"] + colors[indexB]["r"]) / 2
  colors[target]["g"] = (colors[indexA]["g"] + colors[indexB]["g"]) / 2
  colors[target]["b"] = (colors[indexA]["b"] + colors[indexB]["b"]) / 2
  colors[target]["isChanged"] = true
end

--https://github.com/nesbox/TIC-80/wiki/code-examples-and-snippets#pal-function
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

--function to randomize the grid
function randomizeGrid()
  local randomStep = math.random(20, 50)
  local lastStep
  local currentStep
  local i = 0
  while(i < randomStep) do
    local step = math.random(80) % 4
    currentStep = (step == 0) and MOVE_UP or 
                  (step == 1) and MOVE_DOWN or
                  (step == 2) and MOVE_LEFT or
                  (step == 3) and MOVE_RIGHT
    --skip if current step is canceling last step
    --also check if move is valid
    if currentStep ~= lastStep and isValidMove(currentStep) then
      slideGrid(currentStep)
      lastStep = oppositeMove(currentStep)
      i = i + 1
    end
  end
end

function isValidMove(move)
  if move == MOVE_UP and emptyGrid.x < 3 then
    return true
  elseif move == MOVE_DOWN and emptyGrid.x > 1 then
    return true
  elseif move == MOVE_LEFT and emptyGrid.y < 3 then
    return true
  elseif move == MOVE_RIGHT and emptyGrid.y > 1 then
    return true
  else
    return false
  end
end

function oppositeMove(move)
  if move == MOVE_UP then
    return MOVE_DOWN
  elseif move == MOVE_DOWN then
    return MOVE_UP
  elseif move == MOVE_LEFT then
    return MOVE_RIGHT
  elseif move == MOVE_RIGHT then
    return MOVE_LEFT
  else
    return nil
  end
end

function slideGrid(move)
  if move == MOVE_UP then
    grid[emptyGrid.x][emptyGrid.y] = grid[emptyGrid.x + 1][emptyGrid.y]
    grid[emptyGrid.x + 1][emptyGrid.y] = 0
    emptyGrid.x = emptyGrid.x + 1
  elseif move == MOVE_DOWN then
    grid[emptyGrid.x][emptyGrid.y] = grid[emptyGrid.x - 1][emptyGrid.y]
    grid[emptyGrid.x - 1][emptyGrid.y] = 0
    emptyGrid.x = emptyGrid.x - 1
  elseif move == MOVE_LEFT then
    grid[emptyGrid.x][emptyGrid.y] = grid[emptyGrid.x][emptyGrid.y + 1]
    grid[emptyGrid.x][emptyGrid.y + 1] = 0
    emptyGrid.y = emptyGrid.y + 1
  elseif move == MOVE_RIGHT then
    grid[emptyGrid.x][emptyGrid.y] = grid[emptyGrid.x][emptyGrid.y - 1]
    grid[emptyGrid.x][emptyGrid.y - 1] = 0
    emptyGrid.y = emptyGrid.y - 1
  end
  if scene == SCENE_PLAY then
    isWinning = checkStatus()
  end
end
--return true if all grid values are according to it's correct position
function checkStatus()
  result = true
  for row,v in pairs(grid) do
    for col,val in pairs(v) do
      correct_answer = col + ((row-1) * 3)
      if correct_answer == 5 and val == 0 then
        result = (result and true)
      elseif val ~= correct_answer then
        return false
      end
    end
  end
  return result
end

function updatePlay()
  if isWinning then
    playMessage.text = "You WIN!!!"
    playMessage.timer = 1
  else
    --control where to slide
    if btnp(0, 0, 30) then
      --up button
      if isValidMove(MOVE_UP) then slideGrid(MOVE_UP) end
    end
    if btnp(1, 0, 30) then
      --down button
      if isValidMove(MOVE_DOWN) then slideGrid(MOVE_DOWN) end
    end
    if btnp(2, 0, 30) then
      --left button
      if isValidMove(MOVE_LEFT) then slideGrid(MOVE_LEFT) end
    end
    if btnp(3, 0, 30) then
      --right button
      if isValidMove(MOVE_RIGHT) then slideGrid(MOVE_RIGHT) end
    end
    if btnp(4, 0, 30) then
      checkStatus()
    end
  end
end

function drawPlay()
  drawBoard()
  --draw 3x3 playing grid
  for i,row in pairs(grid) do
    for j, val in pairs(row) do
      if val > 0 then
        --drawing play grid
        rect(((4*j)-1)*8, ((4*i)-1)*8, 32, 32, val)
      end
    end
  end
end

function drawBoard()
  --draw star in the middle
  spr(21, 56, 56, 5, 2, 0, 0, 2, 2)
  --draw top and bottom border
  for i=0,4,4 do
    for j=0,4 do
      spr((i*16)+16+j, ((4*j)-1)*8, ((4*i)-1)*8, 5, 4)
    end
  end
  --draw left and right border
  for j=0,4,4 do
    for i=1,3 do
      local spr_id = j + 16 + (i*16)
      spr(spr_id, ((4*j)-1)*8, ((4*i)-1)*8, 5, 4)
    end
  end
  --draw check status grid
  --drawing check status grid
  for i=1,3 do
    for j=1,3 do
      current_value = grid[i][j]
      correct_value = (i==2 and j==2) and 0 or (j + ((i-1) * 3))
      trace('current: '..current_value..' - correct:'..correct_value)
      -- if i==2 and j==2 then
      --   correct_value = 0
      -- else
      --   correct_value = j + ((i-1) * 3)
      -- end
      --draw the sprite either its correct or false
      posx = 124 + (j*24)
      posy = i*24
      sprid = current_value == correct_value and 25 or 23
      trace('x: '..posx..' y:'..posy..' - sprid:'..sprid)
      spr(sprid, posx, posy, 5, 1, 0, 0, 2, 2)
      -- if current_value == correct_value then
      --   spr(25, posx, posy, 5, 1, 0, 0, 2, 2)
      -- else
      --   spr(23, posx, posy, 5, 1, 0, 0, 2, 2)
      -- end
    end
  end
end

init()
function TIC()
  cls(5)
  update()
  draw()
end