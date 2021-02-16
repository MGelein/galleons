islands = {}

islands.list = {}

function islands.create()

end

function islands.new(sprite, posX, posY, posR)
    local island = {

    }
    island.collider.class = 'land'
    island.collider.parent = island
    table.insert(islands.list, island)
end

function islands.removeAll()
    for i, island in ipairs(islands.list) do
        hc.remove(island.collider)
    end
    islands.list = {}
end