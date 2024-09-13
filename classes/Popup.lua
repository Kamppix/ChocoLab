Popup = {}

function Popup.new(id, w, h, content, blockInput, key, closeAction, x, y)
    local p = {}

    p.id = id
    p.w = w
    p.h = h
    p.content = content
    p.blockInput = blockInput
    p.key = key
    p.closeAction = closeAction
    p.x = x or love.graphics:getWidth() / 2 - p.w / 2
    p.y = y or love.graphics:getHeight() / 2 - p.h / 2

    function p.update(dt)
        for _,c in ipairs(p.content) do
            c.update(dt)
        end
    end

    function p.draw()
        love.graphics.setColor(0, 0, 0, 0.69)
        love.graphics.rectangle('fill', p.x - 2, p.y - 2, p.w + 4, p.h + 4)
        love.graphics.setColor(0.463, 0.463, 0.463, 1)
        love.graphics.rectangle('line', p.x, p.y, p.w, p.h)
        love.graphics.rectangle('line', p.x + 1, p.y + 1, p.w - 2, p.h - 2)
        love.graphics.setColor(0.392, 0.392, 0.392, 1)
        love.graphics.rectangle('line', p.x + 2, p.y + 2, p.w - 4, p.h - 4)
        love.graphics.rectangle('line', p.x + 3, p.y + 3, p.w - 6, p.h - 6)

        for _,c in ipairs(p.content) do
            c.draw(p.x, p.y)
        end
    end

    function p.mousepressed(mx, my, b)
        if p.key and (p.key == 0 or p.key == b) then
            game.removePopup(p.id)
            return true
        elseif p.blockInput then
            return true
        end
    end

    function p.keyInput(code)
        if p.key and (p.key == 0 or string.sub(code, -string.len(p.key)) == p.key) then
            game.removePopup(p.id)
            return true
        elseif p.blockInput then
            return true
        end
    end

    return p
end
