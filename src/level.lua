level = {}
local spawnOffset = 1500
level.spawns = { 
    locations = {
    {x = -spawnOffset, y = -spawnOffset},
    {x = spawnOffset, y = -spawnOffset},
    {x = spawnOffset, y = spawnOffset},
    {x = -spawnOffset, y = spawnOffset},
}}

function level.create()
    bounds.create()
    spawns.create()
    sounds.playAmbience()
end

function level.draw(screen)
    love.graphics.draw(sprites.seabg, -screen.ox + screen.ox % 128 - 256, -screen.oy + screen.oy % 128 - 256, 0, 2, 2)
    spawns.draw()
    bounds.draw()
end

function level.destroy()
    bounds.removeAll()
    spawns.removeAll()
    sounds.stopAmbience()
end