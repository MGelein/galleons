spawns = {}
spawns.list = {}
spawns.sprites = {sprites.baseA, sprites.baseB, sprites.baseC, sprites.baseD}

function spawns.draw()
    for name, data in pairs(spawns.list) do
        love.graphics.draw(data.sprite, data.x, data.y, data.r, 1, 1, data.ox, data.oy)
        if(config.showColliders) then data.collider:draw('line') end
    end
end

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
        color = {r = 255, g = 255, b = 255}
    }
    spawn.collider = hc.rectangle(-w2 * .75, -w2 * .75, w2 * 1.5, w2 * 1.5)
    spawn.collider.parent = spawn
    spawn.collider.class = 'land'
    spawn.collider:moveTo(spawn.x, spawn.y)
    spawn.collider:rotate(spawn.r)
    return spawn
end

function spawns.removeAll()
    for i, spawn in ipairs(spawns.list) do
        hc.remove(spawn.collider)
    end
    spawns.list = {}
end