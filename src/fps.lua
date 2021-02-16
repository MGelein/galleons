fps = {
    visible = config.showFPS,
    average = 60,
    draw = function()
        love.graphics.setFont(fonts.default)
        if not fps.visible then return end
        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.rectangle('fill', 0, 0, 60, 40)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(math.floor(fps.average + .5) .. " FPS", 4, 2)
        love.graphics.print(math.floor(collectgarbage('count')) .. " kB", 4, 20)
    end,

    update = function(dt)
        fps.average = fps.average + ((1 / dt) - fps.average) * .1
    end
}