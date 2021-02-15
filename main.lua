require "imports"

function love.load()
    config.createWindow()
    gamestates.setActive(postgame)

end
 
function love.draw()
    love.graphics.setCanvas(screens.main)
    gamestates.draw()
    fps.draw()
    love.graphics.setCanvas()
    love.graphics.scale(screens.mainScale.x, screens.mainScale.y)
    love.graphics.draw(screens.main)
end
    
function love.update(dt)
    gamestates.update(dt)
    fps.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then love.event.quit() end
end
