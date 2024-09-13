local sounds = { list = {} }


function sounds.add(id, type, plugin)
    local path = ''
    if plugin then
        path = 'plugins/' .. plugin.name .. '/assets/sounds/' .. id .. '.ogg'
    else
        path = 'assets/sounds/' .. id .. '.ogg'
    end

    if love.filesystem.getInfo(path) then
        sounds.list[id] = love.audio.newSource(path, type)
    else
        print('Could not find sound file at \'' .. path .. '\'')
    end
end


function sounds.remove(id)
    sounds.list[id] = nil
end


sounds.add('start', 'static')
sounds.add('quit', 'static')
sounds.add('win', 'static')

sounds.add('weak_music', 'static')
sounds.add('music', 'static')
sounds.list['music']:setLooping(true)


return sounds
