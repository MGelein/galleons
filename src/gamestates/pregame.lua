pregame = {
    state = 0,
}

function pregame.load()
    pregame.state = 1
    background.create('pregame')
    playerselectors.create()
    playerselectors.show()
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
    playerselectors.update(pregame.state)

    if playerselectors.isEveryoneReady() then
        game.players = playerselectors.getPlayers()
        gamestates.setActive(game)
    end
end

function pregame.drawButtonPrompts()
    love.graphics.push()
    love.graphics.translate(520, 0)
    love.graphics.circle('fill', 25, 45, 10)
    love.graphics.setColor(0.2, 0.2, 0.8)
    love.graphics.draw(sprites.ui_X, 0, 20)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 325, 45, 10)
    love.graphics.setColor(0.8, 0.8, 0.2)
    love.graphics.draw(sprites.ui_Y, 300, 20)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts.place)

    fonts.outlineText('Back', 50, 15, 800, 'left')
    fonts.outlineText('Main Menu', 350, 15, 800, 'left')
    love.graphics.pop()
end