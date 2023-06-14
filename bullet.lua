Bullet = Object:extend()

guns = {}
guns.sniperspeed = 1200
guns.snipersize = 10
guns.sniperdamage = 5
guns.nukespeed = 450
guns.nukesize = 25
guns.nukedamage = .2
guns.sgspeed = 1200
guns.sgsize = 3
guns.sgdamage = 5
guns.flamerspeed = 1200
guns.flamersize = 1
guns.flamerdamage = .025
flamerdelay = 0

function Bullet:new(type, x, y, dX, dY, width, height, speed, damage)

    self.x = x
    self.y = y
    self.speed = speed
    self.dx = dX * self.speed
    self.dy = dY * self.speed
    self.damage = damage
    self.dead = false

    if type == 1 then
        self.type = 1
        self.width = width
        self.height = height
        self.life = 2
    elseif type == 2 then
        self.type = 2
        self.radius = width
        self.life = 3
    elseif type == 3 then
        self.type = 3
        self.radius = width
        self.life = .5
        self.dx = self.dx + (love.math.random(-3000, 3000) / 10)
        self.dy = self.dy + (love.math.random(-3000, 3000) / 10)
    elseif type == "nuke" then
        self.type = "nuke"
        self.radius = width
        self.life = 2
    end
end


function Bullet:update(dt)
    if self.type == 1 then
        self.x = self.x + (self.dx * dt)
        self.y = self.y + (self.dy * dt)

    elseif self.type == 2 or self.type == 3 then
        self.x = self.x + (self.dx * dt)
        self.y = self.y + (self.dy * dt)

    elseif self.type == "nuke" then
        self.radius = self.radius + self.life* 75 * (self.life^2) * dt
    end
    self.life = self.life - dt

end

function Bullet:draw()
    if self.type == 1 then
	    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    elseif self.type == 2 then
        love.graphics.circle("fill", self.x, self.y, self.radius)
    elseif self.type == 3 then
        love.graphics.circle("fill", self.x, self.y, self.radius)
    elseif self.type == "nuke" then
        love.graphics.circle("line", self.x, self.y, self.radius)
    end


end

function Bullet.Fire(gun, dt)
local width, height = love.graphics.getDimensions()
local startX = player.x + player.width / 2
local startY = player.y + player.height / 2
local mouseX = (love.mouse.getX() - width/2) + startX
local mouseY = (love.mouse.getY() - height/2) + startY

local angle = math.atan2((mouseY - startY), (mouseX - startX))

local bulletDx = math.cos(angle)
local bulletDy = math.sin(angle)
			
    if gun == "sniper" then
        if sniperdelay <= 0 then
            table.insert(bullets, Bullet(1, startX, startY, bulletDx, bulletDy, guns.snipersize, guns.snipersize, guns.sniperspeed, guns.sniperdamage))
            sniperdelay = 2
        end
    end
    if gun == "nuke" then
        if varset.nukedelay <= 0 then	
			table.insert(bullets, Bullet(2, startX, startY, bulletDx, bulletDy, guns.nukesize, 0, guns.nukespeed, 0))
			varset.nukedelay = 5
		end
    end
    if gun == "shotgun" then
        if shotgundelay <= 0 then
            for i=1,10 do
			    table.insert(bullets, Bullet(3, startX, startY, bulletDx, bulletDy, guns.sgsize, 0, guns.sgspeed, guns.sgdamage))
            end
			shotgundelay = 1
		end
    end
    if gun == "flamer" then
        if flamerdelay <= 0 then
            if flamerammo > 1 then
                for i=1,50 do
                    table.insert(bullets, Bullet(3, startX, startY, bulletDx, bulletDy, guns.flamersize, 0, guns.flamerspeed, guns.flamerdamage))
                end
                flamerammo = flamerammo - dt * 5
                flamerdelay = 0
            end		
		end
    end
end

function Bullet.Nuke(x, y)
    table.insert(bullets, Bullet("nuke", x, y, 1, 1, 30, 0, 0, guns.nukedamage))
end



function Bullet:checkCollision(obj)

    if self.type == 1 then
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
        and self_top < obj_bottom then
            self.dead = true
        end
    elseif self.type == 2 or self.type == 3 or self.type == "nuke" then
        local self_x = self.x
        local self_y = self.y
        local self_radius = self.radius
        
        local obj_left = obj.x - self_radius
        local obj_right = obj.x + obj.width + self_radius
        local obj_top = obj.y - self_radius
        local obj_bottom = obj.y + obj.height + self_radius

        if self.x > obj_left
        and self.x < obj_right
        and self.y > obj_top
        and self.y < obj_bottom then
            self.dead = true
        end
    end
end
