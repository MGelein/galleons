gamestates = {}

function gamestates.setActive(newState)
    gamestates.active = newState
    newState.load()
end

function gamestates.draw()
    gamestates.active.draw()
end

function gamestates.update(dt)
    gamestates.active.update(dt)
end