# Box Bullies
#### Video Demo:  https://www.youtube.com/watch?v=eVO7CaK8pnY
#### Description:

**Box Bullies** is a Simple game made using Lua with LÖVE.


## Project contents
### Borrowed content
- Background tile image borrowed from https://architextures.org/textures/242.
- Classic, a small class library https://github.com/rxi/classic
### Created content

#### Main.lua file
>This is the main lua file, used to load, update, and draw elements.
#### bullet.lua
>bullet.lua holds the necessary functions to create, update, and draw bullets independently.  This file also holds all of the weapon stats such as refire delay, bullet sizes, projectile lifetime, projectile speed, and damage.
#### enemy.lua
>enemy.lua contains the class information for enemy boxes which spawn.  It assigns a random speed within a range, and 'promotes' certain enemy blocks if their speed passes a certain threshold, as well as if they become too far from the player.
#### player.lua
>player.lua is likely the shortest and simplest of all the files
#### printfunctions.lua
>printfunctions.lua simply prints useful information around the screen such as player health, score, enemy count, etc.  It also prints the Invulnerability time, shown as 'Resist', and the Nuke weapon's cooldown timer, but these values only appear when relevant.k
## Gameplay

The current state of the game is simply to accumulate the highest score possible by defeating squares(boxes) which spawn around the player. The player has access to 4 different weapons, each of which offer different utility and power.  The boxes will attempt to prusue and Tag the player, dealing damage to the player and destroying themselves in the process. Upon defeating all boxes, a new wave of boxes will be generated around the player, increasing the box count by 10 for each wave. After taking 4 hits from the boxes, a Game Over will occur. Additionally, the player is limited to a graciously sized arena and will be allowed to remain out of bounds no longer than 7 seconds before Game Over.
### Enemies
There are 3 enemy types found in the game:
- White(Standard) boxes, which pose little threat as they're much slower than the others.
- Red(Elite) boxes, which have double the normal health pool and move quicker than standard boxes.
- Blue(Promoted) boxes, which become promoted when the player becomes too far from any box.  These are the fastest.

## Unexpected points of development
### Enemy Spawning
In an attempt to ensure boxes don't spawn immediately on the player, i decided to create a buffer/safety zone to allow some breathing room for each newly spawned wave of boxes. I had originally thought to create the buffer zone as a radius around the player, but my initial code caused boxes to spawn in groups diagonally to the player as enemies were unable to spawn directly above, below, or to the side of the player.  Ultimately, I chose to leave it this way to allow the player to slip between groups of freshly spawned enemies.
```lua
function Enemy:new()
    self.x = player.x + rand1()
    self.y = player.y + rand1()
    ...

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
```
---
### Flamer weapon
The "flame thrower" weapon, a.k.a. Flamer, wasn't considered initially.  While playing around with the shotgun, I accidentally lowered the refire delay to nearly 0.  With a very rapid-firing shotgun at its current damage, all box waves were immediately trivialized. Creating the flamer from the shotgun base was just a few simple steps:

- Lower damage appropriately
- Increase bullet count per shot (50 per 'burst', up from shotgun's 10)
- Reduce/remove firing delay
- Adding a regenerative ammo to help balance and encourage using other weapons.

## Retrospect
As I learned the basics of Lua/LÖVE, my code steadily became less cluttered and more efficient.  There are many places in my code which are redundant or not well implemented, as often times I would dream up a new thing to add which wasn't readily compatible with my existing code. As an example, bullets from most guns update the same, but the Nuke needs its own update sequence and collision instead of using the same code as rectangular bullets.
