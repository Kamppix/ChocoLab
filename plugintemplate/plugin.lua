local plugin = { name = 'plugintemplate' }


function plugin.load()
end


function plugin.update(dt)
end


function plugin.draw(z, hoverEnabled)
    --[[
        Z-LEVELS
        0: background
        1: title
        2: machine arrows
        3: inventory slots
        4: recipe results
        5: items
        6: machine buttons
        7: cursor item
        8: stars
        9: popups
        10: guide button
    ]]
end


function plugin.mousepressed(mx, my, b)
end


function plugin.keypressed(key)
end


return plugin
