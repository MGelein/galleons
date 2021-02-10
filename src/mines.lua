mines = {
    ox = sprites.mine:getWidth() / 2, 
    oy = sprites.mine:getHeight() / 2
}
mines.list = {}
mines.toRemove = {}
mines.shockwaves = {}
mines.shockwavesToRemove = {}

function mines.new(parent, newX, newY)
    local mine = {
        ship = parent,
        detonated = false,
        x = newX,
        y = newY,
        ttl = config.powerups.mineFuse,
        age = 0,
        r = love.math.random() * math.pi * 2,
        vr = 0.01,
        s = 1,
        baseScale = 0,
        a = love.math.random() * math.pi * 2,
        collider = hc.circle(0, 0, mines.ox)
    }
    mine.collider.parent = mine
    mine.collider.class = 'mine'
    mine.collider:moveTo(mine.x, mine.y)
    table.insert(mines.list, mine)
end

function mines.draw()
    for i, mine in ipairs(mines.list) do
        love.graphics.draw(sprites.mine, mine.x, mine.y, mine.r, mine.s, mine.s, mines.ox, mines.oy)
        if config.showColliders then mine.collider:draw('line') end
    end
    for i, shockwave in ipairs(mines.shockwaves) do
        shockwave.age = shockwave.age + 1
        collisions.handleShockwave(shockwave)
        if shockwave.age > 2 then mines.removeShockwave(shockwave) end
        if config.showColliders then shockwave.collider:draw('line') end
    end
end

function mines.update()
    for i, mine in ipairs(mines.list) do
        mine.r = mine.r + mine.vr
        mine.baseScale = mine.baseScale + (1 - mine.baseScale) * 0.1
        mine.s = math.sin(mine.a) * 0.08 + mine.baseScale
        mine.a = mine.a + love.math.random() * 0.08
        
        if mine.age == mine.ttl - 10 then 
            explosions.withOffset(mine.x, mine.y, 10) 
        elseif mine.age == mine.ttl - 20 then 
            explosions.withOffset(mine.x, mine.y, 10)
        elseif mine.age == mine.ttl - 30 then
            if not mine.detonated then mines.detonate(mine) end
            explosions.withOffset(mine.x, mine.y, 10)
            sounds.explosion:stop()
            sounds.explosion:play()
        elseif mine.age > mine.ttl then
            mines.remove(mine)
        end
        mine.age = mine.age + 1
    end
    
    if #mines.toRemove > 0 then
        for index, mineToRemove in ipairs(mines.toRemove) do
            local foundIndex = -1
            for i, mine in ipairs(mines.list) do
                if mine == mineToRemove then
                    foundIndex = i 
                    break
                end
            end
            if foundIndex > -1 then table.remove(mines.list, foundIndex) end
        end
        mines.toRemove = {}
    end

    if #mines.shockwavesToRemove > 0 then
        for index, shockwaveToRemove in ipairs(mines.shockwavesToRemove) do
            local foundIndex = -1
            for i, shockwave in ipairs(mines.shockwaves) do
                if shockwave == shockwaveToRemove then
                    foundIndex = i 
                    break
                end
            end
            if foundIndex > -1 then table.remove(mines.shockwaves, foundIndex) end
        end
        mines.shockwavesToRemove = {}
    end
end

function mines.remove(mine)
    table.insert(mines.toRemove, mine)
    explosions.withOffset(mine.x, mine.y, 10)
end

function mines.removeShockwave(shockwave)
    hc.remove(shockwave.collider)
    table.insert(mines.shockwavesToRemove, shockwave)
end

function mines.detonate(mine)
    hc.remove(mine.collider)
    mine.detonated = true
    mine.age = mine.ttl - 30
    for i = 1, 3 do
        local shockwave = {
            ship = mine.ship,
            age = 0,
            collider = hc.circle(mine.x, mine.y, config.powerups.mineShockwaveRadius * i)
        }
        splash.newSilent(mine.x, mine.y, config.powerups.mineShockwaveRadius * i / 4)
        shockwave.collider.class = 'shockwave'
        shockwave.collider.parent = shockwave
        table.insert(mines.shockwaves, shockwave)
    end
end