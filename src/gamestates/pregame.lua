pregame = {}

function pregame.load()
    background.create('pregame')
end

function pregame.start()
    sounds.playAmbience()
end

function pregame.draw()
    background.draw()
end

function pregame.update(dt)
    background.update()
end