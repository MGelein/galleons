require "imports"

function love.load()
    config.createWindow()
    gamestates.setActive(game)
end
 
function love.draw()
    gamestates.draw()
    fps.draw()
end
    
function love.update(dt)
    gamestates.update(dt)
    fps.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then love.event.quit() end
end
