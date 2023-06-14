

endfont = love.graphics.newFont(42)
midfont = love.graphics.newFont(24)
fontnorm = love.graphics.getFont()

function txtlen(txt)
    local font = love.graphics.getFont()
    local len = font:getWidth(txt)
    return len
end

chardisplay = {invulntime = {desc = "Resist: ", len = txtlen("Resist:  ")}, nukedelay = {desc = "Nuke cooldown: ", len = txtlen("Nuke cooldown:  ")}}

function printstats(width, height, gun)
    local x = 1
    local flamervalue = flamerammo * 16
    love.graphics.print("Gun: " .. gun, 10, 10)
    love.graphics.print("Player: " .. player.x .. " " .. player.y, 10, 30)
	love.graphics.print("Mouse: " .. mouseX .. " " .. mouseY, 10, 50)
	love.graphics.print("angle: " .. angle, 10, 70)
    love.graphics.print("Enemies: " .. #boxitems, 10, 90)
    love.graphics.print("Flamer Ammo", 10, 150)
    love.graphics.rectangle("line", 10, 170, 80, 400)
    love.graphics.rectangle("fill", 10, 570 - flamervalue, 80, flamervalue)
	love.graphics.print("SCORE: " .. scoretotal, width/2 - txtlen("SCORE: " .. scoretotal)/2, 10)
	love.graphics.print("HEALTH: " .. player.hp, width/2 - txtlen("HEALTH: " .. player.hp)/2, 30)
    love.graphics.setFont(midfont)
    love.graphics.print("Press F1 for Pause / Info", 10, height -40)
    love.graphics.setFont(fontnorm)
    if pause == true then
        love.graphics.setFont(midfont)
        love.graphics.setColor(.2,.2,.2,.85)
        love.graphics.rectangle("fill", width - width*.75, height - height*.75, width*.5, height*.5)
        love.graphics.setColor(.5,1,1)
        love.graphics.print('Use W,A,S,D keys to move the player.',width - width*.75 , height - height*.75)
        love.graphics.print('Change weapons and view info by pressing 1-4',width - width*.75 , height - height*.75 + 40)
        love.graphics.printf(PrintWeaponDesc(gun),width - width*.75 , height - height*.75 + 80, width*.5)
        love.graphics.setColor(1,1,.8)
        love.graphics.print('Enemies and the field',width - width*.75 , height - height*.5)
        love.graphics.printf("Enemies will spawn around you and try to tag you.  If successful, you will lose 1 health and the enemy will be destroyed.  A grace period is offered after each point of damage taken.  The arena is large, but not endless; Upon entering the Out-of-bounds area, you'll be given 7 seconds to return before the game ends."
        ,width - width*.75 , height - height*.5 + 40, width*.5)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Standard enemies move at a slow pace and are easy to dodge."
        ,width - width*.75 , height - height*.5 + 170, width*.5)
        love.graphics.setColor(.8,0,0)
        love.graphics.printf("'Elite' enemies spawn at random and are a bit faster than standard enemies and with 2x as much health."
        ,width - width*.75 , height - height*.5 + 200, width*.5)
        love.graphics.setColor(0,.5,.5)
        love.graphics.printf("An enemy which is too far from the player will be promoted to the fastest variant."
        ,width - width*.75 , height - height*.5 + 230, width*.5)
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(fontnorm)
    end
    if player.x > bgwidth * 5 + 20 or 
    player.y > bgheight * 5 + 20 or 
    player.x < bgwidth * -5 - 20 or 
    player.y < bgheight * -5 - 20 then
        love.graphics.setFont(endfont)
        
        love.graphics.print("--- RETURN TO ARENA ---", width/2 - txtlen("--- RETURN TO ARENA ---")/2, 100)
        love.graphics.print(math.ceil(oob), width/2 - txtlen(" "), 150)
        love.graphics.setFont(fontnorm)
    end
end

function printonchar()
    local iter = 1
    for i,v in pairs(varset) do
        if v > 0 then
        love.graphics.print(chardisplay[i].desc .. math.ceil(v), player.x + player.width/2 - chardisplay[i].len/2, player.y + player.height + iter * 18)
        iter = iter + 1
        end
    end
end



function endgamemsg()
    local width, height = love.graphics.getDimensions()
    love.graphics.setFont(endfont)
    local msg = "-- GAME OVER --"
    local len = txtlen(msg)
    love.graphics.print(msg, width/2 - len/2, height/2 - 100)
    local msg = "PRESS K TO PLAY AGAIN"
    local len = txtlen(msg)
    love.graphics.print(msg, width/2 - len/2, height/2 - 60)
    love.graphics.setFont(fontnorm)
    return
end

function PrintWeaponDesc(gun)
    desc = ""
    if gun == "sniper" then
        desc = "The sniper is a powerful 1-shot 1-kill weapon with infinitely penetrating bullets with slow fire-rate."
    elseif gun == "nuke" then
        desc = "The nuke is a powerful area of effect weapon with a 5-second cooldown."
    elseif gun == "shotgun" then
        desc = "The shotgun is a basic weapon, useful only at short range, but with quick refire rate and moderate damage"
    elseif gun == "flamer" then
        desc = "The flamer can dispatch targets quickly and without much aim.  It has regenerative ammo and becomes weak when it's supply is exhausted."
    end
    return desc
end