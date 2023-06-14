Enemy = Object:extend()

function Enemy:new()
    self.x = player.x + rand1()
    self.y = player.y + rand1()
    self.width = 75
    self.height = 75
    self.mode = "fill"
    self.nuked = 0
    self.speed = love.math.random(200, 450)
    if self.speed > 350 then
        self.hp = 20
    else
        self.hp = 10
    end
end

function Enemy:update(dt)

    local startX = self.x + self.width / 2
	local startY = self.y + self.height / 2
	local width, height = love.graphics.getDimensions()
	local playerX = player.x
	local playerY = player.y
	local angle = math.atan2(playerY - startY, playerX - startX)
	local linex =  math.cos(angle)
	local liney =  math.sin(angle)

    self.x = self.x + (linex * dt) * self.speed
    self.y = self.y + (liney * dt) * self.speed
    if math.sqrt((self.x - player.x)^2 + (self.y - player.y)^2) > 1500 then
        self.speed = 700
    end
end

function Enemy:draw()
    
    if self.speed > 500 then
        love.graphics.setColor(0,.5,.5)
    elseif self.speed > 350 then
        love.graphics.setColor(.8,0,0)
    end
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
    love.graphics.setColor(.5, .5, .5)
    love.graphics.print(math.floor(self.hp * 100 + .5)/100, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end

function Enemy:checkCollision(obj)

    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom 
    and varset.invulntime == 0 then
        self.touch = true
    end
end

function rand1()
    local side = love.math.random(1,2)
    if side == 1 then
        side = 1
    elseif
        side == 2 then
        side = -1
    end
    return love.math.random(500, 1000) * side
end