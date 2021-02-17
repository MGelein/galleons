pregame = {
    gameModeSelected = true,
}

function pregame.load()
    pregame.gameModeSelected = true
    background.create('pregame')
    playerselectors.create()
end

function pregame.start()
    sounds.playAmbience()
end

function pregame.draw()
    background.draw()
    playerselectors.draw()
    pregame.drawButtonPrompts()
end

function pregame.update(dt)
    background.update()
    playerselectors.update()

    if playerselectors.isEveryoneReady() then
        game.players = playerselectors.getPlayers()
        gamestates.setActive(game)
    end

    if controller.A ~= nil then
        if controller.A.isYDown() then
            gamestates.setActive(mainmenu)
        end
        if controller.A.isXDown() and pregame.gameModeSelected then
            pregame.gameModeSelected = false
        end
    end
end

function pregame.drawButtonPrompts()
    love.graphics.setFont(fonts.place)
    love.graphics.push()
    love.graphics.translate(520, 0)
    if pregame.gameModeSelected then
        love.graphics.circle('fill', 25, 45, 10)
        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.draw(sprites.ui_X, 0, 20)
        love.graphics.setColor(1, 1, 1, 1)
        fonts.outlineText('Back', 50, 15, 800, 'left')
    end
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 325, 45, 10)
    love.graphics.setColor(0.8, 0.8, 0.2)
    love.graphics.draw(sprites.ui_Y, 300, 20)
    love.graphics.setColor(1, 1, 1, 1)
    
    fonts.outlineText('Main Menu', 350, 15, 800, 'left')
    love.graphics.pop()
end