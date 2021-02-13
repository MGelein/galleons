bounds = {}
bounds.size = config.bounds.internalDim
bounds.width = 1000
bounds.dim = bounds.size + bounds.width * 2
bounds.halfSize = bounds.size / 2

function bounds.create()
    bounds.list = {}
    local dim = bounds.dim
    local dim2 = dim / 2
    local width = bounds.width
    bounds.new(-dim2 - width, -dim2, dim + 2 * width, width)
    bounds.new(-dim2 - width, dim2 - width, dim + 2 * width, width)
    bounds.new(-dim2, -dim2 + width, width, bounds.size)
    bounds.new(dim2 - width, -dim2 + width, width, bounds.size)
end

function bounds.new(posX, posY, width, height)
    local bound = {
        x = posX,
        y = posY,
        w = width,
        h = height,
        collider = hc.rectangle(posX, posY, width, height)
    }
    bound.collider.class = 'border'
    table.insert(bounds.list, bound)
end

function bounds.draw()
    for i, border in ipairs(bounds.list) do
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.rectangle('fill', border.x, border.y, border.w, border.h)
        love.graphics.setColor(1, 1, 1, 1)
        if config.showColliders then border.collider:draw('line') end
    end
end