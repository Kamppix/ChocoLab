local text = {}


function text.add(id, plugin)
    local path = ''
    if plugin then
        path = 'plugins/' .. plugin.name .. '/assets/text/' .. id .. '.txt'
    else
        path = 'assets/text/' .. id .. '.txt'
    end

    if love.filesystem.getInfo(path) then
        local f = love.filesystem.newFile(path)
        f:open('r')
        text[id] = f:read('string')
        f:close()
    else
        print('Could not find text file at \'' .. path .. '\'')
    end
end


text.add('guide')
text.add('won')
text.add('completed')


return text
