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

    if controller.A ~= nil then
        if controller.A.isXDown() then
            gamestates.setActive(game)
        end
    end
end