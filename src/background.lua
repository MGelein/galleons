background = {}
background.elements = {}

function background.newElement(image, posX, posY)
    local el = {
        sprite = image,
        x = posX,
        y = posY,
        r = 0,
        vx = 0,
        vy = 0,
        looping = true,
    }
    table.insert(background.elements, el)
    return el
end

function background.create(name)
    background.elements = {}
    background.newElement(sprites.sky, 0, 0)
    background.newElement(sprites.island, 0, config.video.height - sprites.island:getHeight())
    local sea = background.newElement(sprites.sea, 0, config.video.height - sprites.sea:getHeight())
    sea.vx = 8
    local seaLeft = background.newElement(sprites.sea, -sprites.sea:getWidth(), config.video.height - sprites.sea:getHeight())
    seaLeft.vx = 8
    local seaRight = background.newElement(sprites.sea, sprites.sea:getWidth(), config.video.height - sprites.sea:getHeight())
    seaRight.vx = 8

    for i, sprite in ipairs(animations.clouds.frames) do
        local cloud = background.newElement(sprite, love.math.random() * config.video.width, love.math.random() * config.video.height / 2)
        cloud.vx = love.math.random() * 0.5 + 0.1
        local cloud2 = background.newElement(sprite, love.math.random() * config.video.width, love.math.random() * config.video.height / 2)
        cloud2.vx = love.math.random() * 0.5 + 0.1
        cloud2.r = math.pi
    end
end

function background.update()
    for i, element in ipairs(background.elements) do
        element.x = element.x + element.vx
        element.y = element.y + element.vy
        
        if element.looping and element.x >= config.video.width + element.sprite:getWidth() then
            element.x = -element.sprite:getWidth()
        end
    end
end

function background.draw()
    for i, element in ipairs(background.elements) do
        love.graphics.draw(element.sprite, element.x, element.y, element.r)
    end
end