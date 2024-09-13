local plugins = { list = {} }


love.filesystem.createDirectory('plugins')
love.filesystem.createDirectory('disabledplugins')

local folders = love.filesystem.getDirectoryItems('plugins')
for _,name in pairs(folders) do
    if love.filesystem.getInfo('plugins/' .. name .. '/plugin.lua', 'file') then
        table.insert(plugins.list, require('plugins.' .. name .. '.plugin'))
    end
end


function plugins.load()
    for _,p in ipairs(plugins.list) do
        p.load()
    end
end


function plugins.update(dt)
    for _,p in ipairs(plugins.list) do
        p.update(dt)
    end
end


function plugins.draw(z)
    for _,p in ipairs(plugins.list) do
        p.draw(z)
    end
end


function plugins.mousepressed(mx, my, b)
    for _,p in ipairs(plugins.list) do
        if p.mousepressed(mx, my, b) then
            return true
        end
    end
end


function plugins.keypressed(key)
    for _,p in ipairs(plugins.list) do
        if p.keypressed(key) then
            return true
        end
    end
end


return plugins
