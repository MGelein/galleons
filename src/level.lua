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
    colliders = {},
}

function level.createLagoonColliders()
    level.lagoon.centerZone = hc.circle(0, 0, 350)
    level.addLagoonCollider(level.lagoon.centerZone, 'center')

    local topLeftIsland = hc.polygon( -410,-330,  -330,-410,  -170,-410,  -160,-310,  -310,-170,  -410,-170)
    level.addLagoonCollider(topLeftIsland, 'land')

    local topRightIsland = hc.polygon( 410,-410,  410,-180,  310,-170,  190,-290,  120,-290,  110,-400)
    level.addLagoonCollider(topRightIsland, 'land')

    local bottomLeftIsland = hc.polygon( -410,410,  -410,170,  -250,170,  -170,250,  -170,410)
    level.addLagoonCollider(bottomLeftIsland, 'land')
    
    local bottomRightIsland = hc.polygon( 410,410,  120,410,  110,300,  290,290,  300,180,  400,170)
    level.addLagoonCollider(bottomRightIsland, 'land')
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

function level.update()
    if game.mode == game.kingOfTheHill then
        local shipAmt = 0
        for shape, delta in pairs(hc.collisions(level.lagoon.centerZone)) do
            if shape.class == 'ship' then 
                shipAmt = shipAmt + 1 
                level.king = shape.parent
            end
        end
        if shipAmt ~= 1 then level.king = nil end
        ships.setKing(level.king)
    end
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