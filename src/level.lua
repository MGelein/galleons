level = {}
local spawnOffset = 1500
level.spawns = { 
    locations = {
        {x = -spawnOffset, y = -spawnOffset},
        {x = spawnOffset, y = -spawnOffset},
        {x = spawnOffset, y = spawnOffset},
        {x = -spawnOffset, y = spawnOffset},
    }
}

level.islands = {
    locations = {
        {x = -spawnOffset, y = 0, r = 0},
        {x = spawnOffset, y = 0, r = 0},
        {x = 0, y = -spawnOffset, r = 0},
        {x = 0, y = spawnOffset, r = 0},
    }
}

level.lagoon = {
    sprite = sprites.lagoon,
    ox = sprites.lagoon:getWidth() / 2,
    oy = sprites.lagoon:getHeight() / 2,
    colliders = {}
}

function level.createLagoonColliders()
    local centerZone = hc.circle(0, 0, 350)
    level.addLagoonCollider(centerZone, 'center')

    local topLeftIsland = hc.polygon( -410,-330,  -330,-410,  -170,-410,  -160,-310,  -310,-170,  -410,-170)
    level.addLagoonCollider(topLeftIsland, 'land')

    local bottomLeftIsland = hc.polygon( -410,410,  -410,170,  -250,170,  -170,250,  -170,410)
    level.addLagoonCollider(bottomLeftIsland, 'land')
end

function level.addLagoonCollider(collider, class)
    collider.class = class
    table.insert(level.lagoon.colliders, collider)
end

function level.drawLagoon()
    love.graphics.draw(level.lagoon.sprite, 0, 0, 0, 1, 1, level.lagoon.ox, level.lagoon.oy)
    if config.showColliders then 
        for i, collider in ipairs(level.lagoon.colliders) do
            collider:draw('line') 
        end
    end
end

function level.create()
    bounds.create()
    spawns.create()
    islands.create()
    level.createLagoonColliders()
    sounds.playAmbience()
end

function level.draw(screen)
    love.graphics.draw(sprites.seabg, -screen.ox + screen.ox % 128 - 256, -screen.oy + screen.oy % 128 - 256, 0, 2, 2)
    spawns.draw()
    bounds.draw()
    islands.draw()
    level.drawLagoon()
end

function level.destroy()
    bounds.removeAll()
    spawns.removeAll()
    sounds.stopAmbience()

    for i, collider in ipairs(level.lagoon.colliders) do
        hc.remove(collider)
    end
    level.lagoon.colliders = {}
end