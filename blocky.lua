-- title:  blocky.tic
-- author: wowods
-- desc:   need description here
-- script: lua

-- Declare some constant here
MIN_GRID = 0
MAX_GRID = 7
player = {
  x = 0,
  y = 0,
}

function init()
end

function draw()
  drawPlayer()
  print("x --> "..player.x, 8, 8)
  print("y --> " ..player.y, 8, 18)
end

function drawPlayer()
  local posX = player.x * 16
  local posY = player.y * 16
  spr(1, posX, posY, 0, 1, 0, 0, 2, 2)
end

function update()
  actionButton()
end

function actionButton()
  -- button up is pressed
  if btnp(0, 0, 30) then
    -- skipping top corner movement
    if player.y == (MIN_GRID + 1) then
      if player.x == MIN_GRID then
        player.x = (MIN_GRID + 1)
        player.y = MIN_GRID
      elseif player.x == MAX_GRID then
        player.x = (MAX_GRID - 1)
        player.y = MIN_GRID
      end
    -- up movement
    elseif player.y > MIN_GRID then
        player.y = player.y - 1
    end
  end
  -- button down is pressed
  if btnp(1, 0, 30) then
    -- skipping down corner movement
    if player.y == (MAX_GRID - 1) then
        if player.x == MIN_GRID then
          player.x = (MIN_GRID + 1)
          player.y = MAX_GRID
        elseif player.x == MAX_GRID then
          player.x = (MAX_GRID - 1)
          player.y = MAX_GRID
        end
      -- down movement
    elseif player.y < MAX_GRID then
          player.y = player.y + 1
      end
  end

  -- button left is pressed
  if btnp(2, 0, 30) then
    -- skipping left corner movement
    if player.x == (MIN_GRID + 1) then
      if player.y == MIN_GRID then
        player.x = MIN_GRID
        player.y = (MIN_GRID + 1)
      elseif player.y == MAX_GRID then
        player.x = MIN_GRID
        player.y = (MAX_GRID - 1)
      end
    -- up movement
    elseif player.x > MIN_GRID then
        player.x = player.x - 1
    end
  end
  -- button right is pressed
  if btnp(3, 0, 30) then
    -- skipping right corner movement
    if player.x == (MAX_GRID - 1) then
        if player.y == MIN_GRID then
          player.x = MAX_GRID
          player.y = (MIN_GRID + 1)
        elseif player.y == MAX_GRID then
          player.x = MAX_GRID
          player.y = (MAX_GRID - 1)
        end
      -- up movement
      elseif player.x > MIN_GRID then
          player.x = player.x + 1
      end
  end
end

-- Here is the implementation of all these codes
init()
function TIC()
    cls(2)
    update()
    draw()
end