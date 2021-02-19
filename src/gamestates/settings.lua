settings = {}

function settings.load()
    background.create()
end

function settings.start()
    sounds.playAmbience()
end

function settings.draw()
    background.draw()
end

function settings.update(dt)
    background.update()
end
