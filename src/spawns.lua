spawns = {}
spawns.list = {}
spawns.sprites = {sprites.baseA, sprites.baseB, sprites.baseC, sprites.baseD}
spawns.flagDist = 90

function spawns.get(letter)
    return spawns.list[letter]
end

function spawns.create()
    spawns.list.A = spawns.createNumber(1)
    spawns.list.B = spawns.createNumber(2)
    spawns.list.C = spawns.createNumber(3)
    spawns.list.D = spawns.createNumber(4)
end

function spawns.createNumber(index)
    local tex = spawns.sprites[index]
    local loc = level.spawns.locations[index]
    local w2 = tex:getWidth() / 2
    local spawn = {
        sprite = tex,
        x = loc.x,
        y = loc.y,
        r = math.pi * (index * .5 + .25),
        ox = w2,
        oy = w2,
        color = {r = 255, g = 255, b = 255},
        colorName = '',
        
        flagAngle = love.math.random() * math.pi / 2,
        flagTime = love.math.random() * math.pi,
        flagSway = 0,
        flagSwayTime = love.math.random() * math.pi,
        flag1 = 'none',
        flag2 = 'none',
        flag3 = 'none',
        flag4 = 'none',
        flag5 = 'none',
    }
    spawn.collider = hc.rectangle(-w2 * .75, -w2 * .75, w2 * 1.5, w2 * 1.5)
    spawn.collider.parent = spawn
    spawn.collider.class = 'spawn'
    spawn.collider:moveTo(spawn.x, spawn.y)
    spawn.collider:rotate(spawn.r)
    return spawn
end

function spawns.update()
    for letter, spawn in pairs(spawns.list) do
        spawn.flagSway = math.sin(spawn.flagSwayTime) * 0.3
        spawn.flagAngle = math.sin(spawn.flagTime) * spawn.flagSway
        spawn.flagTime = spawn.flagTime + 0.02 * love.math.random()
        spawn.flagSwayTime = spawn.flagSwayTime + 0.021 * love.math.random()
    end
    if game.mode == game.captureTheFlag then spawns.countFlags() end
end

function spawns.draw()
    for name, data in pairs(spawns.list) do
        love.graphics.draw(data.sprite, data.x, data.y, data.r, 1, 1, data.ox, data.oy)
        if(config.showColliders) then data.collider:draw('line') end
        spawns.drawFlags(data)
    end
end

function spawns.drawFlags(spawn)
    local flag = flags.colorToSprite[spawn.flag1]
    spawns.drawFlag(flag, spawn.x, spawn.y, spawn.flagAngle)
    flag = flags.colorToSprite[spawn.flag2]
    spawns.drawFlag(flag, spawn.x - spawns.flagDist, spawn.y, spawn.flagAngle)
    flag = flags.colorToSprite[spawn.flag3]
    spawns.drawFlag(flag, spawn.x + spawns.flagDist, spawn.y, spawn.flagAngle)
    flag = flags.colorToSprite[spawn.flag4]
    spawns.drawFlag(flag, spawn.x, spawn.y - spawns.flagDist, spawn.flagAngle)
    flag = flags.colorToSprite[spawn.flag5]
    spawns.drawFlag(flag, spawn.x, spawn.y + spawns.flagDist, spawn.flagAngle)
end

function spawns.drawFlag(flag, x, y, r)
    if flag == nil then return end
    love.graphics.draw(flag, x, y, r, 1, 1, 0, flags.oy)
    love.graphics.draw(sprites.cannonBall, x, y, 0, 1, 1, bullets.ox, bullets.oy)
end

function spawns.addFlag(spawn, color)
    if spawn.flag1 == 'none' and spawn.flag1 ~= color then spawn.flag1 = color
    elseif spawn.flag2 == 'none' and spawn.flag2 ~= color then spawn.flag2 = color
    elseif spawn.flag3 == 'none' and spawn.flag3 ~= color then spawn.flag3 = color
    elseif spawn.flag4 == 'none' and spawn.flag4 ~= color then spawn.flag4 = color
    elseif spawn.flag5 == 'none' and spawn.flag5 ~= color then spawn.flag5 = color
    end
end

function spawns.getFlag(spawn)
    if spawn.flag5 ~= 'none' then
        local temp = spawn.flag5
        spawn.flag5 = 'none'
        return temp
    elseif spawn.flag4 ~= 'none' then
        local temp = spawn.flag4
        spawn.flag4 = 'none'
        return temp
    elseif spawn.flag3 ~= 'none' then
        local temp = spawn.flag3
        spawn.flag3 = 'none'
        return temp
    elseif spawn.flag2 ~= 'none' then
        local temp = spawn.flag2
        spawn.flag2 = 'none'
        return temp
    elseif spawn.flag1 ~= 'none' then
        local temp = spawn.flag1
        spawn.flag1 = 'none'
        return temp
    else
        return 'none'
    end
end

function spawns.countFlags()
    local hiscore = 0
    for name, spawn in pairs(spawns.list) do
        local score = spawns.countFlagsFor(spawn)
        if score > hiscore then hiscore = score end
        local ship = ships.getBySpawn(spawn)
        if ship then ship.score = score end
    end
    if hiscore == #ships.list then game.stop() end
end

function spawns.countFlagsFor(spawn)
    local count = 0
    if spawn.flag1 ~= 'none' then count = count + 1 end
    if spawn.flag2 ~= 'none' then count = count + 1 end
    if spawn.flag3 ~= 'none' then count = count + 1 end
    if spawn.flag4 ~= 'none' then count = count + 1 end
    if spawn.flag5 ~= 'none' then count = count + 1 end
    return count
end

function spawns.stealFlag(spawn, ship)
    if ship.color == spawn.color then 
        if string.find(ship.powerup, 'Flag') then
            local color = string.gsub(ship.powerup, 'Flag', '')
            ships.setPowerup(ship, 'none')
            spawns.addFlag(spawn, color)
        end 
    else
        if ship.powerup == 'none' then
            local flag = spawns.getFlag(spawn) .. 'Flag'
            ships.setPowerup(ship, flag)
        end
    end
end

function spawns.removeAll()
    for i, spawn in ipairs(spawns.list) do
        hc.remove(spawn.collider)
    end
    spawns.list = {}
end