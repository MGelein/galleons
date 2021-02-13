pregame = {}

function pregame.load()
    background.create('pregame')
    playerselectors.create()
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
    playerselectors.update()

    if playerselectors.isEveryoneReady() then
        game.players = playerselectors.getPlayers()
        gamestates.setActive(game)
    end
end