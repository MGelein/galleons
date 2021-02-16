level = {}
local spawnOffset = 1500
level.spawns = { 
    locations = {
    {x = -spawnOffset, y = -spawnOffset},
    {x = spawnOffset, y = -spawnOffset},
    {x = spawnOffset, y = spawnOffset},
    {x = -spawnOffset, y = spawnOffset},
}}

level.islands = {
    locations = {
        {x = -spawnOffset, y = 0, r = 0},
        {x = spawnOffset, y = 0, r = 0},
        {x = 0, y = -spawnOffset, r = 0},
        {x = 0, y = spawnOffset, r = 0},
    }
}

function level.create()
    bounds.create()
    spawns.create()
    islands.create()
    sounds.playAmbience()
end

function level.draw(screen)
    love.graphics.draw(sprites.seabg, -screen.ox + screen.ox % 128 - 256, -screen.oy + screen.oy % 128 - 256, 0, 2, 2)
    spawns.draw()
    bounds.draw()
    islands.draw()
end

function level.destroy()
    bounds.removeAll()
    spawns.removeAll()
    sounds.stopAmbience()
end