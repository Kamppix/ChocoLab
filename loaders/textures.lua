local textures = { list = {} }


function textures.add(id, type, plugin)
    local path = ''
    if plugin then
        path = 'plugins/' .. plugin.name .. '/assets/textures/' .. type .. '/' .. id .. '.png'
    else
        path = 'assets/textures/' .. type .. '/' .. id .. '.png'
    end

    if love.filesystem.getInfo(path) then
        textures.list[id] = love.graphics.newImage(path)
    else
        print('Could not find texture file at \'' .. path .. '\'')
    end
end

textures.add('title', 'gui')
textures.add('play', 'gui')
textures.add('quit', 'gui')
textures.add('inventory', 'gui')
textures.add('slot', 'gui')
textures.add('combine', 'gui')
textures.add('split', 'gui')
textures.add('transform', 'gui')
textures.add('heat', 'gui')
textures.add('cool', 'gui')
textures.add('start_process', 'gui')
textures.add('progress_bar', 'gui')
textures.add('guide', 'gui')
textures.add('sound_on', 'gui')
textures.add('sound_off', 'gui')
textures.add('music_on', 'gui')
textures.add('music_off', 'gui')
textures.add('star', 'gui')

textures.add('placeholder', 'items')


return textures
