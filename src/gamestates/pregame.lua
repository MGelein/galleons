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
end

function pregame.update(dt)
    background.update()
    playerselectors.update(pregame.state)

    if playerselectors.isEveryoneReady() then
        game.players = playerselectors.getPlayers()
        gamestates.setActive(game)
    end
end