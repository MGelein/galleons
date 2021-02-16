islands = {}

islands.list = {}

function islands.create()
    for i, position in ipairs(level.islands.locations) do
        islands.new(animations.islands.frames[i], position.x, position.y, position.r)
    end
end

function islands.new(image, posX, posY, posR)
    local island = {
        x = posX,
        y = posY,
        r = posR,
        sprite = image,
        ox = image:getWidth() / 2,
        oy = image:getHeight() / 2,
        collider = hc.circle(posX, posY, (image:getWidth() / 2) * 0.5)
    }
    island.collider.class = 'land'
    island.collider.parent = island
    table.insert(islands.list, island)
end

function islands.draw()
    for i, island in ipairs(islands.list) do
        love.graphics.draw(island.sprite, island.x, island.y, island.r, 1, 1, island.ox, island.oy)
        if config.showColliders then island.collider:draw('line') end
    end
end

function islands.removeAll()
    for i, island in ipairs(islands.list) do
        hc.remove(island.collider)
    end
    islands.list = {}
end