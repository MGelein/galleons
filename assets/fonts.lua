local function otf(url, size)
    return love.graphics.newFont('assets/font/' .. url .. '.otf', size)
end


fonts = {
    title = otf('chomsky', 32),
    normal = otf('chomsky', 32),
    place = otf('chomsky', 40),
    alert = otf('chomsky', 128),
    default = love.graphics.newFont(12),
}
fonts.countdown = fonts.place

fonts.shadow = sprites.colorFromName.black

function fonts.outlineText(text, x, y, limit, align)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(fonts.shadow.r, fonts.shadow.g, fonts.shadow.b, 1)
    love.graphics.printf(text, x + 1, y + 1, limit, align)
    love.graphics.setColor(r, g, b, a)
    love.graphics.printf(text, x, y, limit, align)
end