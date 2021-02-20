minimap = {}
minimap.size = sprites.ui_minimap_bg:getWidth()
minimap.margin = 10

function minimap.draw(w, h)
    love.graphics.push()
    love.graphics.translate(minimap.margin, h - minimap.margin - minimap.size)
    gui.useFontColor()
    love.graphics.draw(sprites.ui_minimap_bg)

    for name, spawn in pairs(spawns.list) do
        local coord = minimap.coordToMap(spawn.x, spawn.y)
        love.graphics.setColor(spawn.color.r, spawn.color.g, spawn.color.b)
        love.graphics.rectangle("fill", coord.x - 2, coord.y - 2, 4, 4)
    end

    for i, ship in ipairs(ships.list) do
        local coord = minimap.coordToMap(ship.x, ship.y)
        love.graphics.setColor(ship.color.r, ship.color.g, ship.color.b)
        love.graphics.circle("fill", coord.x, coord.y, 5)
    end

    for i, powerup in ipairs(powerups.list) do
        local coord = minimap.coordToMap(powerup.x, powerup.y)
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.circle("fill", coord.x, coord.y, 1)
    end
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

function minimap.coordToMap(x, y)
    local rx = (x / bounds.size) * 0.95 + 0.5
    local ry = (y / bounds.size) * 0.95 + 0.5
    return {x = rx * minimap.size, y = ry * minimap.size}
end