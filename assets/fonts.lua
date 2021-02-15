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

fonts.black = sprites.colorFromName.black

function fonts.outlineText(text, x, y, limit, align)
    love.graphics.setColor(fonts.black.r, fonts.black.g, fonts.black.b, 1)
    love.graphics.printf(text, x + 1, y + 1, limit, align)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(text, x, y, limit, align)
end