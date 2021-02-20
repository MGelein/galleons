pregame = {
    gameModeSelected = false,
}

function pregame.load()
    pregame.gameModeSelected = false
    background.create('pregame')
    playerselectors.create()
    modeselector.create()
end

function pregame.start()
    sounds.playAmbience()
    pregame.gameModeSelected = false
    modeselector.timeout = 60
end

function pregame.draw()
    background.draw()
    modeselector.draw()
    playerselectors.draw()
    pregame.drawButtonPrompts()
end

function pregame.update(dt)
    background.update()
    playerselectors.update()
    modeselector.update()

    if playerselectors.isEveryoneReady() and pregame.gameModeSelected then
        game.players = playerselectors.getPlayers()
        game.mode = modeselector.mode
        game.roundTime = modeselector.updateRoundTime()
        gamestates.setActive(game)
    end

    if controller.A ~= nil and not playerselectors.isEveryoneReady() then
        if controller.A.isYDown() then
            gamestates.setActive(mainmenu)
        end
        if controller.A.isXDown() and pregame.gameModeSelected then
            pregame.modeUnset()
        end
    end
end

function pregame.modeSet()
    pregame.gameModeSelected = true
end

function pregame.modeUnset()
    pregame.gameModeSelected = false
    playerselectors.setTimeout(60)
end

function pregame.drawButtonPrompts()
    love.graphics.setFont(fonts.place)
    love.graphics.push()
    love.graphics.translate(320, 0)
    if pregame.gameModeSelected then
        love.graphics.translate(200, 0)
        love.graphics.circle('fill', 25, 45, 10)
        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.draw(sprites.ui_X, 0, 20)
        love.graphics.setColor(1, 1, 1, 1)
        fonts.outlineText('Back', 50, 15, 800, 'left')
    else
        love.graphics.translate(200, 0)
        love.graphics.circle('fill', 25, 45, 10)
        love.graphics.setColor(0.2, 0.8, 0.2)
        love.graphics.draw(sprites.ui_A, 0, 20)
        love.graphics.setColor(1, 1, 1, 1)
        fonts.outlineText('Accept', 50, 15, 800, 'left')
    end
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 325, 45, 10)
    love.graphics.setColor(0.8, 0.8, 0.2)
    love.graphics.draw(sprites.ui_Y, 300, 20)
    love.graphics.setColor(1, 1, 1, 1)
    
    fonts.outlineText('Main Menu', 350, 15, 800, 'left')
    love.graphics.pop()
end