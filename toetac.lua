-- title:  toetac.tic
-- author: wowods
-- desc:   short desc
-- script: lua

--Constant about player one and two
p1 = 1
p1Color = 6
p2 = 2
p2Color = 8
--Constants for drawing sprite
size = 16
scale = 2
centerSpriteX = (240 - (size*scale)) // 2
centerSpriteY = (136 - (size*scale)) // 2

function init()
  winner = nil
  grid = {
    { 0, 0, 0 },
    { 0, 0, 0 },
    { 0, 0, 0 }
  }
  game = {
    turn = p1,
    turnCount = 0,
    slidePhase = false,
    winnningPhase = false
  }
  cursor = {
    x = 1,
    y = 1,
    prev_x = 0,
    prev_y = 0,
    pawn = p1,
    isGripPawn = true, --flag if cursor is carrying pawn
    showTemp = false --flag to draw temporary cursor
  }
  textNotif = {
    x = 0,
    y = 0,
    width = 0,
    text = "Cannot put it here!",
    prevText = "Cannot put it here!",
    duration = 60, --1s
    timer = 0
  }
  textNotif.width = print(textNotif.text, 0, -6)
  textNotif.x = (240 - textNotif.width) // 2
  textNotif.y = 136 - (6 * 2)
end

function draw()
  --drawing text
  drawUI()
  drawText()
  --draw the grid
  for i,rows in pairs(grid) do
    for j,value in pairs(rows) do
      if value == p1 then
        drawSprite(2, i, j)
      elseif value == p2 then
        drawSprite(4, i, j)
      end
    end
  end
  --drawing temporary cursor
  --also check if cursor followed by pawn
  if cursor.showTemp then
    drawSprite(0, cursor.prev_x, cursor.prev_y)
  end
  --drawing cursor
  --also check if cursor followed by pawn
  if game.turn == p1 then
    drawSprite(6, cursor.x, cursor.y)
    if cursor.isGripPawn then
      drawSprite(2, cursor.x, cursor.y)
    end
  elseif game.turn == p2 then
    drawSprite(8, cursor.x, cursor.y)
    if cursor.isGripPawn then
      drawSprite(4, cursor.x, cursor.y)
    end
  end
end

function drawText()
  if textNotif.timer > 0 then
    textNotif.timer = textNotif.timer - 1
    --if text is changing, re-calculate before print it
    if textNotif.text ~= textNotif.prevText then
      textNotif.width = print(textNotif.text, 0, -6)
      textNotif.x = (240 - textNotif.width) // 2
      textNotif.prevText = textNotif.text
    end
    print(textNotif.text, textNotif.x, textNotif.y)
  else
    textNotif.timer = 0
  end
end

function drawUI()
  local textColor = 15
  --print how many turns has been passed
  print("Turns: "..game.turnCount, size, 12, textColor, false, 1)
  --print which turn is it
  if game.turn == p1 then
    textColor = p1Color
  elseif game.turn == p2 then
    textColor = p2Color
  end
  print("Player "..game.turn.." turn", size, 4, textColor, false, 1)
  --draw the board
  spr(32, (240-(scale*size*3))//2, (136-(scale*size*3))//2, 0, scale, 0, 0, 6, 6)
  
end

function drawSprite(index, x, y)
  local posX = centerSpriteX + ((x-2)*size*scale)
  local posY = centerSpriteY + ((y-2)*size*scale)
  spr(index, posX, posY, 0, scale, 0, 0, 2, 2) 
end

function update()
  --reset button
  if btnp(7, 0, 30) then
    init()        
  end
  if not game.winnningPhase then
    --cursor movement button
    if btnp(0, 0, 30) then 
      cursor.y = cursor.y - 1
    elseif btnp(1, 0, 30) then
      cursor.y = cursor.y + 1
    elseif btnp(2, 0, 30) then
      cursor.x = cursor.x - 1
    elseif btnp(3, 0, 30) then
      cursor.x = cursor.x + 1
    end
    --clamp cursor position
    if cursor.x < 1 then 
      cursor.x = 1
    end
    if cursor.x > 3 then
      cursor.x = 3
    end
    if cursor.y < 1 then
      cursor.y = 1
    end
    if cursor.y > 3 then
      cursor.y = 3
    end
    actionButton()
  end
end

function checkWinningCondition()
  local temp = {
    { x=1, y=1 },
    { x=2, y=2 },
    { x=3, y=3 }
  }
  for i,v in pairs(temp) do
    local value = grid[v.x][v.y]
    if value > 0 then
      if v.x == 1 then
        winner = checkHorizontalVertical(value, v.x, v.y, 1)
      elseif v.x == 2 then
        winner = checkCenter(value)
      elseif v.x == 3 then
        winner = checkHorizontalVertical(value, v.x, v.y, -1)
      end
    end
    if winner ~= nil then
      return true
    end
  end
  return false
end

function checkHorizontalVertical(value, x, y, delta)
  if (value == grid[x+delta][y] and value == grid[x+(delta*2)][y])
      or (value == grid[x][y+delta] and value == grid[x][y+(delta*2)]) then
    return value
  else 
    return nil
  end
end

function checkCenter(value)
  if (value == grid[1][2] and value == grid[3][2])
     or (value == grid[2][1] and value == grid[2][3])
     or (value == grid[1][1] and value == grid[3][3])
     or (value == grid[1][3] and value == grid[3][1]) then
    return value
  else
    return nil
  end
end

function actionButton()
  --when button A is pressed
  if btnp(4, 0, 30) then
    --logic for put pawn to the grid
    if cursor.isGripPawn then
      if gridEmpty(cursor.x, cursor.y) and isMoveValid() then
        grid[cursor.x][cursor.y] = cursor.pawn
        cursor.isGripPawn = false
        cursor.showTemp = false
        goToNextTurn()
      else
        textNotif.text = "Cannot put it here!"
        textNotif.timer = textNotif.duration
      end
    --logic for get pawn from the grid
    else
      if not gridEmpty(cursor.x, cursor.y) then
        if grid[cursor.x][cursor.y] == game.turn then
          grid[cursor.x][cursor.y] = 0
          cursor.isGripPawn = true
          cursor.prev_x = cursor.x
          cursor.prev_y = cursor.y
          cursor.showTemp = true
        else
          textNotif.text = "Cannot pick this pawn!"
          textNotif.timer = textNotif.duration
        end
      end
    end
  end
  --when button B is pressed, it'll cancel last picked pawn
  if btn(5) and cursor.isGripPawn then
    grid[cursor.prev_x][cursor.prev_y] = cursor.pawn
    cursor.isGripPawn = false
    cursor.showTemp = false
  end  
end

function goToNextTurn()
  --check winning condition first
  if checkWinningCondition() then
    game.winnningPhase = true
    textNotif.text = "Player "..winner.." WIN!"
    textNotif.timer = 60000
  end
  --change the turn to other player
  game.turnCount = game.turnCount + 1
  if (game.turnCount % 2 == 0) then
    game.turn = p1
  else
    game.turn = p2
  end
  cursor.pawn = game.turn
  --set when to change to slide phase
  if not game.slidePhase then
    if game.turnCount >= 6 then
      game.slidePhase = true
      cursor.isGripPawn = false
    else
      cursor.isGripPawn = true
    end
  end
end

function gridEmpty(x, y)
  return grid[x][y] == 0 and true or false
  -- if grid[x][y] == 0 then
  --   return true
  -- else
  --   return false
  -- end
end

function isMoveValid()
  --check if cursor on original grid
  if cursor.x == cursor.prev_x and cursor.y == cursor.prev_y then
    return false
  end
  --check if movement is possible
  if cursor.prev_x > 0 and cursor.prev_y > 0 then
    if (cursor.prev_x == 2 and cursor.prev_y == 2)
        or (cursor.x == 2 and cursor.y == 2) then
      return true
    else
      local delta = math.abs(cursor.x - cursor.prev_x) + math.abs(cursor.y - cursor.prev_y)
      return delta == 1 and true or false
    end
  else
    return true
  end
end

init()
function TIC()
  cls(2)
  update()
  draw()
end
