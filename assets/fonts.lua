local function otf(url, size)
    return love.graphics.newFont('assets/font/' .. url .. '.otf', size)
end


fonts = {
    title = otf('chomsky', 200),
    normal = otf('chomsky', 32),
    place = otf('chomsky', 40),
    result = otf('chomsky', 64),
    score = otf('chomsky', 48),
    alert = otf('chomsky', 128),
    default = love.graphics.newFont(12),
}
fonts.countdown = fonts.place

function fonts.outlineText(text, x, y, limit, align)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(config.ui.shd.r, config.ui.shd.g, config.ui.shd.b, config.ui.shd.a)
    love.graphics.printf(text, x + 1, y + 1, limit, align)
    if config.fullFontOutlining then
        love.graphics.printf(text, x + 1, y + 0, limit, align)
        love.graphics.printf(text, x + 1, y - 1, limit, align)
        love.graphics.printf(text, x + 0, y + 1, limit, align)
        love.graphics.printf(text, x + 0, y + 0, limit, align)
        love.graphics.printf(text, x + 0, y - 1, limit, align)
        love.graphics.printf(text, x - 1, y + 1, limit, align)
        love.graphics.printf(text, x - 1, y + 0, limit, align)
        love.graphics.printf(text, x - 1, y - 1, limit, align)
    end
    gui.useFontColor()
    love.graphics.printf(text, x, y, limit, align)
    love.graphics.setColor(r, g, b, a)
end