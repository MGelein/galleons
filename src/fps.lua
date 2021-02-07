fps = {
    visible = config.showFPS,
    average = 60,
    draw = function()
        love.graphics.setFont(fonts.default)
        if not fps.visible then return end
        love.graphics.draw(sprites.debug_background, 0, 0)
        love.graphics.print(math.floor(fps.average + .5) .. " FPS", 4, 2)
        love.graphics.print(math.floor(collectgarbage('count')) .. " kB", 4, 20)
    end,

    update = function(dt)
        fps.average = fps.average + ((1 / dt) - fps.average) * .1
    end
}