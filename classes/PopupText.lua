PopupText = {}


function PopupText.new(x, y, text, scale)
    local t = {}

    t.x = x
    t.y = y
    t.text = text
    t.scale = scale or 1

    function t.update(dt)
    end

    function t.draw(x, y)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(t.text, x + t.x, y + t.y, 0, t.scale, t.scale)
    end

    return t
end