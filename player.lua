Player = Object:extend()

function Player:new(source, x, y)
  self.x = x
  self.y = y
  img = love.graphics.newImage(source)
  self.width = img:getWidth()
  self.height = img:getHeight()
  self.speed = 450
  self.hp = 4
  return img
end

function Player:update(dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
    if self.hp == 0 then
        endgame = true
    end
end


function Player:draw()
  if math.abs(angle) >= math.abs(1.5) then
  love.graphics.draw(img, self.x, self.y, 0, 1, 1)
  elseif math.abs(angle) < 1.5 then
  love.graphics.draw(img2, self.x, self.y, 0, 1, 1)
  end

  
end


