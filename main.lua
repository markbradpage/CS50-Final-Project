function love.load()
	--love.window.setFullscreen(true)
	love.window.setMode(0, 0)
	Object = require("classic")
	require("printfunctions")
	require("player")
	require("bullet")
	require("enemy")
	player = Player("dudeleft.png", 50, 50)
	img2 = love.graphics.newImage("duderight.png")
	background = love.graphics.newImage("bgtest2.png")
	background:setWrap("repeat", "repeat")
	bgwidth, bgheight = background:getWidth(), background:getHeight()
	bg_quad = love.graphics.newQuad(0, 0, bgwidth * 10, bgheight * 10, bgwidth, bgheight)
	pause = false
	endgame = false
	bullets = {}
	nukes = {}
	gun = "shotgun"
	varset = {invulntime = 0, nukedelay = 0}
	sniperdelay = 0
	shotgundelay = 0
	boxitems = {}
	scoretotal = 0
	cycles = 1
	varsetcount = 0
	oobtime = 7
	flamerammo = 25
	for i,v in pairs(varset) do
		varsetcount = varsetcount + 1
	end
	
end

function love.update(dt)
	if endgame == true then
		pause = true
		dt = 0
		return
	elseif pause == true then
		dt = 0
		return
	end
	if player.x > bgwidth * 5 + 20 or 
		player.y > bgheight * 5 + 20 or 
		player.x < bgwidth * -5 - 20 or 
		player.y < bgheight * -5 - 20 then
        oob = oob - dt
		if oob <= 0 then
		oob = 0
		endgame = true
		end
	else
		oob = oobtime
    end
	if varset.invulntime > 0 then
		varset.invulntime = varset.invulntime - 1 * dt
	else 
		varset.invulntime = 0
	end
	shotgundelay = shotgundelay - dt
	sniperdelay = sniperdelay - dt
	if varset.nukedelay > 0 then
		varset.nukedelay = varset.nukedelay - dt
	end
	player:update(dt)
	startX = player.x + player.width / 2
	startY = player.y + player.height / 2
	local width, height = love.graphics.getDimensions()
	mouseX = (love.mouse.getX() - width/2) + startX
	mouseY = (love.mouse.getY() - height/2) + startY
	angle = math.atan2(mouseY - startY, mouseX - startX)
	linex =  math.cos(angle)
	liney =  math.sin(angle)

	if love.mouse.isDown(1) then
		Bullet.Fire(gun, dt)
	end
	if love.mouse.isDown(1) and gun == "flamer" and flamerammo < 25 then
		flamerammo = flamerammo + dt * .25
	elseif flamerammo < 25 then
		flamerammo = flamerammo + dt * 2
	end
	if #bullets > 0 then
		for i,v in ipairs(bullets) do
			v:update(dt)
			if v.life <=0 then
				table.remove(bullets, i)		
			end
			for j,v2 in ipairs(boxitems) do
				v:checkCollision(v2)
				if v.dead == true then
					v.dead = nil
					if v.type == 2 then
						Bullet.Nuke(v.x, v.y)
						table.remove(bullets, i)
					elseif v.type == "nuke" then
						v2.hp = v2.hp - v.damage
					elseif v.type == 1 then
						v2.hp = v2.hp - v.damage
					else
						v2.hp = v2.hp - v.damage
						table.remove(bullets, i)
					end
					if v2.hp <= 0 then
						table.remove(boxitems, j)
						scoretotal = scoretotal + 1
					end
				end
			end
		end
	end

	for k = #boxitems, 1, -1 do
		boxitems[k]:update(dt)
		boxitems[k]:checkCollision(player)
		if boxitems[k].touch and varset.invulntime == 0 then
			boxitems[k].touch = false
			table.remove(boxitems, k)
			player.hp = player.hp - 1
			varset.invulntime = 3
		end
	end
	if #boxitems == 0 then
		for i=1,cycles*10 do
			table.insert(boxitems, Enemy())
		end
		cycles = cycles + 1
	end
end

function love.draw()
	love.graphics.push()
		local width, height = love.graphics.getDimensions()
		love.graphics.translate(-(player.x + (player.width/2)) + (width/2), -(player.y + (player.height/2)) + (height/2))
		love.graphics.setColor(.3,.3,.3)
		love.graphics.draw(background,bg_quad, bgwidth * -5, bgheight * -5)
		love.graphics.setColor(1,1,1)
		player:draw()
		for i,v in ipairs(bullets) do
			v:draw()
		end
		pxcenter = player.x + (player.height / 2)
		pycenter = player.y + (player.height / 2)
		love.graphics.line(pxcenter, pycenter, pxcenter + (.25 * linex * math.sqrt((mouseX - pxcenter)^2 + (mouseY - pycenter)^2)), pycenter + (.25 * liney * math.sqrt((mouseX - pxcenter)^2 + (mouseY - pycenter)^2)))
		love.graphics.line(bgwidth * -5 - 20, bgheight * -5 - 20, bgwidth * 5 + 20, bgheight * -5 - 20, bgwidth * 5 + 20, bgheight * 5 + 20, bgwidth * -5 - 20, bgheight * 5 + 20, bgwidth * -5 - 20, bgheight * -5 - 20)

		
		for j,v in ipairs(boxitems) do
			v:draw()
		end
		
		
		printonchar()
	love.graphics.pop()
	
	printstats(width, height, gun)
	if endgame == true then
		endgamemsg()
	end
end


function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "1" then
		gun = "sniper"
	elseif key == "2" then
		gun = "nuke"
	elseif key == "3" then
		gun = "shotgun"
	elseif key == "4" then
		gun = "flamer"
	end
	if key == "k" and endgame == true then
		endgame = false
		love.load()
	end
	if key == "f1" and endgame == false then
		pause = not pause
	end
end

