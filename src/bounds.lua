bounds = {}
bounds.dim = config.bounds.externalDim
bounds.width = 300
bounds.size = bounds.dim - 2 * bounds.width
bounds.halfSize = bounds.size / 2

function bounds.create()
    local dim = bounds.dim
    local dim2 = dim / 2
    local width = 300
    local top = hc.rectangle(-dim2, -dim2, dim, width)
    local left = hc.rectangle(-dim2, -dim2, width, dim)
    local right = hc.rectangle(dim2 - width, -dim2, width, dim)
    local bottom = hc.rectangle(-dim2, dim2 - width, dim, width)
    bounds.list = {top, left, right, bottom}
    for i, border in ipairs(bounds.list) do
        border.class = 'border'
    end
end

function bounds.draw()
    for i, border in ipairs(bounds.list) do
        if config.showColliders then border:draw('line') end
    end
end