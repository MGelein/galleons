settings = {}

function settings.load()
    background.create()
end

function settings.start()
    sounds.playAmbience()
end

function settings.draw()
    background.draw()
    settings.drawButtonPrompts()
end

function settings.update(dt)
    background.update()

    if controller.A ~= nil then
        settings.parseControlInput(controller.A)
    end
end

function settings.parseControlInput(controller)
    
end

function settings.drawButtonPrompts()
    love.graphics.setFont(fonts.place)
    love.graphics.push()
    love.graphics.translate(520, 0)
    love.graphics.circle('fill', 25, 45, 10)
    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.draw(sprites.ui_A, 0, 20)
    love.graphics.setColor(1, 1, 1, 1)
    fonts.outlineText('Apply', 50, 15, 800, 'left')
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 325, 45, 10)
    love.graphics.setColor(0.8, 0.8, 0.2)
    love.graphics.draw(sprites.ui_Y, 300, 20)
    love.graphics.setColor(1, 1, 1, 1)
    
    fonts.outlineText('Main Menu', 350, 15, 800, 'left')
    love.graphics.pop()
end