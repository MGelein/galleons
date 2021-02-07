require "src.imports"

function love.load()
    config.createWindow()
end
 
function love.draw()
    gamestates.active.draw()
    fps.draw()
end
    
function love.update(dt)
    gamestates.active.update(dt)
    fps.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then love.event.quit() end
end
