gamestates = {
    transing = false,
    transState = 0,
    transVel = 0,
    transTargetY = config.window.height * 1.5,
    transTargetHalfway = config.window.height - sprites.transition:getHeight() * 0.75,
}
gamestates.transScale = config.window.height / sprites.transition:getHeight()
if gamestates.transScale < 1 then gamestates.transScale = 1 end
gamestates.transTargetEnd = -sprites.transition:getHeight() * gamestates.transScale
gamestates.transTargetY = gamestates.transTargetHalfway
gamestates.transY = gamestates.transTargetEnd

function gamestates.setActive(newState)
    gamestates.active = newState
    newState.load()
    if config.useTransitions then
        gamestates.transing = true
        sounds.playTransition()
    else
        newState.start()
    end
end

function gamestates.draw()
    gamestates.active.draw()
    if gamestates.transing then
        love.graphics.draw(sprites.transition, 0, gamestates.transY, 0, gamestates.transScale, gamestates.transScale)
    end
end

function gamestates.update(dt)
    if not gamestates.transing then gamestates.active.update(dt)
    else
        local diff = (gamestates.transTargetY - gamestates.transY)
        if math.abs(diff) < 1 then
            if gamestates.transState == 0 then
                gamestates.transState = 1
                gamestates.transTargetY = gamestates.transTargetEnd
            else
                gamestates.transing = false
                gamestates.transState = 0
                gamestates.active.start()
            end
        end
        gamestates.transVel = diff * (0.005 + 0.01 * gamestates.transState) + gamestates.transVel * 0.9
        gamestates.transY = gamestates.transY + gamestates.transVel
    end
end