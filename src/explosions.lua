explosions = {}
explosions.list = {}
explosions.toRemove = {}

function explosions.new(xPos, yPos)
    local explosion = {
        x = xPos,
        y = yPos,
        r = math.random() * math.twopi,
        s = math.random() * .5 + .5,
        frame = 3,
        frameCounter = 0,
        playDir = -1,
    }
    table.insert(explosions.list, explosion)
end

function explosions.withOffset(xPos, yPos, offset)
    local offX = love.math.random() * (2 * offset) - offset + xPos
    local offY = love.math.random() * (2 * offset) - offset + yPos
    splash.newSilent(offX, offY, love.math.random() * 10 + 5)
    explosions.new(offX, offY)
end

function explosions.draw()
    for i, explosion in ipairs(explosions.list) do
        local img = animations.explosion.frames[explosion.frame]
        local ox = img:getWidth() / 2
        local oy = img:getHeight() / 2
        love.graphics.draw(img, explosion.x, explosion.y, explosion.r, explosion.s, explosion.s, ox, oy)
    end
end

function explosions.update()
    for i, explosion in ipairs(explosions.list) do
        explosion.frameCounter = explosion.frameCounter + 1
        if explosion.frameCounter >= animations.explosion.speed then
            explosion.frameCounter = 0
            explosion.frame = explosion.frame + explosion.playDir
            if explosion.frame > #animations.explosion.frames then
                explosions.remove(explosion)
            end
            if explosion.frame < 1 then
                explosion.playDir = 1
                explosion.frame = explosion.frame + explosion.playDir * 2
                smoke.new(explosion.x, explosion.y)
            end
        end
    end

    if #explosions.toRemove > 0 then
        for index, explosionsToRemove in ipairs(explosions.toRemove) do
            local foundIndex = -1
            for i, explosion in ipairs(explosions.list) do
                if explosion == explosionsToRemove then
                    foundIndex = i 
                    break
                end
            end
            if foundIndex > -1 then table.remove(explosions.list, foundIndex) end
        end
        explosions.toRemove = {}
    end
end

function explosions.remove(explosion)
    table.insert(explosions.toRemove, explosion)
end

function explosions.removeAll()
    explosions.list = {}
    explosions.toRemove = {}
end