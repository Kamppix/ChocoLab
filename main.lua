Item = {}
-- Item constructor
function Item.new(name, combiner, splitter, transformer, heater, cooler)
    local newItem = {}

    newItem.name = name
    newItem.combiner = combiner
    newItem.splitter = splitter
    newItem.transformer = transformer
    newItem.heater = heater
    newItem.cooler = cooler

    return newItem
end

Inventory = {}
-- Inventory constructor
function Inventory.new(x, y, size)
    local newInventory = {}

    newInventory.x = x
    newInventory.y = y
    newInventory.slots = {}

    for i = 1,size do
        table.insert(newInventory.slots, { x = 0, y = 0 })
    end

    return newInventory
end

function love.load()
    -- Settings
    love.window.setTitle('ChocoLab')
    love.window.setMode(960, 720)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(0.0812, 0.0741, 0.0718, 1)
    love.audio.setVolume(0.1)

    -- Texture load
    titleImg = love.graphics.newImage('assets/textures/gui/title.png')
    startImg = love.graphics.newImage('assets/textures/gui/play.png')
    quitImg = love.graphics.newImage('assets/textures/gui/quit.png')
    inventoryImg = love.graphics.newImage('assets/textures/gui/inventory.png')
    slotImg = love.graphics.newImage('assets/textures/gui/slot.png')
    combineImg = love.graphics.newImage('assets/textures/gui/combine.png')
    splitImg = love.graphics.newImage('assets/textures/gui/split.png')
    transformImg = love.graphics.newImage('assets/textures/gui/transform.png')
    heatImg = love.graphics.newImage('assets/textures/gui/heat.png')
    coolImg = love.graphics.newImage('assets/textures/gui/cool.png')
    startProcessImg = love.graphics.newImage('assets/textures/gui/start_process.png')
    guideImg = love.graphics.newImage('assets/textures/gui/guide.png')
    soundOnImg = love.graphics.newImage('assets/textures/gui/sound_on.png')
    soundOffImg = love.graphics.newImage('assets/textures/gui/sound_off.png')
    musicOnImg = love.graphics.newImage('assets/textures/gui/music_on.png')
    musicOffImg = love.graphics.newImage('assets/textures/gui/music_off.png')
    guideBoxImg = love.graphics.newImage('assets/textures/gui/guide_box.png')
    wonBoxImg = love.graphics.newImage('assets/textures/gui/won_box.png')
    completedBoxImg = love.graphics.newImage('assets/textures/gui/completed_box.png')
    starImg = love.graphics.newImage('assets/textures/gui/star.png')
    
    placeholderTextureImg = love.graphics.newImage('assets/textures/items/placeholder.png')

    progressBarImg = {}
    for i = 0,20 do
        local s = tostring(i)
        if string.len(s) == 1 then
            s = '0' .. s
        end
        table.insert(progressBarImg, love.graphics.newImage('assets/textures/gui/progress_bar/' .. s .. '.png'))
    end

    -- Sound load
    startSound = love.audio.newSource('assets/sounds/start.ogg', 'static')
    quitSound = love.audio.newSource('assets/sounds/quit.ogg', 'static')
    winSound = love.audio.newSource('assets/sounds/win.ogg', 'static')
    
    weakMusicSound = love.audio.newSource('assets/sounds/weak_music.ogg', 'static')
    musicSound = love.audio.newSource('assets/sounds/music.ogg', 'static')
    musicSound:setLooping(true)


    -- Text load
    local f = love.filesystem.newFile('assets/texts/guide.txt')
    f:open('r')
    guideText = f:read('string')
    f:close()

    local f = love.filesystem.newFile('assets/texts/won.txt')
    f:open('r')
    wonText = f:read('string')
    f:close()

    local f = love.filesystem.newFile('assets/texts/completed.txt')
    f:open('r')
    completedText = f:read('string')
    f:close()


    -- Item table load
    items = {
        trash = Item.new('Trash', nil, nil, nil, nil, nil),


        water = Item.new('Water', { fat = 'milk' }, nil, nil, 'salt', 'ice'),
        gravel = Item.new('Gravel', { cucumber = 'peas', zucchini = 'peas' }, nil, nil, nil, nil),
        cucumber = Item.new('Cucumber', { salt = 'pickle', turnip = 'carrot', gravel = 'peas' }, nil, 'zucchini', nil, nil),


        salt = Item.new('Salt', { cucumber = 'pickle', raw_beef = 'salted_raw_beef', fried_potato = 'potato_chips' }, nil, 'sugar', nil, nil),

        pickle = Item.new('Pickle', nil, { 'salt', 'cucumber' }, 'beetroot', nil, nil),

        beetroot = Item.new('Beetroot', { zucchini = 'eggplant' }, { 'red_food_coloring', 'turnip' }, 'pickle', nil, nil),

        turnip = Item.new('Turnip', { red_food_coloring = 'beetroot', cucumber = 'carrot' }, nil, nil, nil, nil),

        carrot = Item.new('Carrot', nil, { 'turnip', 'cucumber' }, 'potato', nil, nil),

        potato = Item.new('Potato', nil, nil, 'carrot', 'fried_potato', nil),

        fried_potato = Item.new('Fried Potato', { salt = 'potato_chips' }, nil, nil, nil, nil),

        red_food_coloring = Item.new('Red Food Coloring', { turnip = 'beetroot', peas = 'raw_beef' }, nil, nil, nil, nil),

        peas = Item.new('Peas', { red_food_coloring = 'raw_beef', chocolate_chips = 'cocoa_nibs' }, nil, nil, nil, nil),

        raw_beef = Item.new('Raw Beef', { salt = 'salted_raw_beef' }, nil, nil, 'cooking_grease', nil),

        salted_raw_beef = Item.new('Salted Raw Beef', nil, { 'salt', 'raw_beef' }, nil, 'cooking_grease', nil),

        cooking_grease = Item.new('Cooking Grease', nil, nil, nil, nil, 'fat'),

        fat = Item.new('Fat', { water = 'milk', milk = 'cream' }, nil, nil, nil, nil),

        sugar = Item.new('Sugar', { potato_chips = 'chocolate_chips', cocoa_nibs = 'cocoa_powder' }, nil, 'salt', nil, nil),

        potato_chips = Item.new('Potato Chips', { sugar = 'chocolate_chips' }, { 'salt', 'fried_potato' }, nil, nil, nil),

        chocolate_chips = Item.new('Chocolate Chips', { peas = 'cocoa_nibs', cookie_dough = 'chocolate_chip_cookie' }, { 'sugar', 'potato_chips' }, nil, nil, nil),
        
        cocoa_nibs = Item.new('Cocoa Nibs', { sugar = 'cocoa_powder' }, { 'chocolate_chips', 'peas' }, nil, nil, nil),
        
        cocoa_powder = Item.new('Cocoa Powder', { milk = 'chocolate_milk' }, { 'cocoa_nibs', 'sugar' }, nil, nil, nil),

        milk = Item.new('Milk', { cocoa_powder = 'chocolate_milk', flour = 'cookie_dough', chocolate_chip_cookie = 'dunked_chocolate_chip_cookie', fat = 'cream', chocolate = 'white_chocolate' }, { 'water', 'fat' }, nil, nil, nil),

        chocolate_milk = Item.new('Chocolate Milk', nil, { 'cocoa_powder', 'milk' }, nil, 'hot_chocolate', nil),

        hot_chocolate = Item.new('Hot Chocolate', nil, nil, 'tea', nil, 'chocolate'),

        chocolate = Item.new('Chocolate Bar', { milk = 'white_chocolate' }, { 'chocolate_chips', 'chocolate_chips' }, nil, 'hot_chocolate', nil),


        zucchini = Item.new('Zucchini', { beetroot = 'eggplant', gravel = 'peas' }, nil, 'cucumber', nil, nil),
        eggplant = Item.new('Eggplant', nil, { 'beetroot', 'zucchini' }, nil, nil, nil),
        tea = Item.new('Tea', { ice = 'iced_tea' }, nil, 'hot_chocolate', nil, nil),
        iced_tea = Item.new('Iced Tea', nil, { 'tea', 'ice' }, nil, 'tea', nil),
        ice = Item.new('Ice', { cream = 'ice_cream', tea = 'iced_tea' }, nil, nil, 'water', nil),
        ice_cream = Item.new('Ice Cream', { cookie_dough = 'cookie_dough_ice_cream' }, { 'ice', 'cream' }, nil, 'cream', nil),
        cream = Item.new('Cream', { ice = 'ice_cream' }, { 'fat', 'milk' }, nil, nil, 'ice_cream'),
        white_chocolate = Item.new('"Milk" Chocolate Bar', nil, { 'chocolate', 'milk' }, nil, nil, nil),
        flour = Item.new('Flour', { milk = 'cookie_dough' }, nil, nil, nil, nil),
        cookie_dough = Item.new('Cookie Dough', { chocolate_chips = 'chocolate_chip_cookie', ice_cream = 'cookie_dough_ice_cream' }, { 'flour', 'milk' }, nil, nil, nil),
        cookie_dough_ice_cream = Item.new('Cookie Dough Ice Cream', nil, nil, nil, 'cream', nil),
        chocolate_chip_cookie = Item.new('Chocolate Chip Cookie', { milk = 'dunked_chocolate_chip_cookie' }, { 'chocolate_chips', 'cookie_dough' }, nil, nil, nil),
        dunked_chocolate_chip_cookie = Item.new('Dunked Chocolate Chip Cookie', nil, { 'chocolate_chips', 'cookie_dough' }, nil, nil, nil),
    }

    -- Item texture set
    for i,item in pairs(items) do
        local filename = 'assets/textures/items/' .. i .. '.png'
        local f = love.filesystem.newFile('assets/texts/completed.txt')
        f:open('r')

        if f ~= nil then
            f:close()
            item.texture = love.graphics.newImage('assets/textures/items/' .. i .. '.png')
        else
            item.texture = placeholderTextureImg
        end
    end

    -- Initialize stuff
    timer = { on = false }
    soundEnabled = true
    musicEnabled = true
    gameWon = false
    stars = { false, false, false, false, false }
    starScore = 0

    -- Set title screen
    gameState = 0
    love.audio.play(weakMusicSound)
end
 
 
function love.update(dt)
    -- Start music loop
    if not weakMusicSound:isPlaying() and not musicSound:isPlaying() and musicEnabled then
        love.audio.play(musicSound)
    end

    if gameState ~= 0 then
        -- Reduce machine timers
        for i,inv in pairs(inventory) do
            if inv.on then
                inv.time = inv.time - dt
            end
        end

        -- Stop combiner
        if inventory.combiner.on and inventory.combiner.time < 0 then
            local result = getRecipe('combiner')

            inventory.combiner.slots[1].item = nil
            inventory.combiner.slots[2].item = nil
            inventory.combiner.slots[3].item = result

            inventory.combiner.on = false
        end

        -- Stop splitter
        if inventory.splitter.on and inventory.splitter.time < 0 then
            local result = getRecipe('splitter')

            inventory.splitter.slots[1].item = nil
            inventory.splitter.slots[2].item = result[1]
            inventory.splitter.slots[3].item = result[2]

            inventory.splitter.on = false
        end

        -- Stop transformer
        if inventory.transformer.on and inventory.transformer.time < 0 then
            local result = getRecipe('transformer')

            inventory.transformer.slots[1].item = nil
            inventory.transformer.slots[2].item = result

            inventory.transformer.on = false
        end

        -- Stop heater
        if inventory.heater.on and inventory.heater.time < 0 then
            local result = getRecipe('heater')

            inventory.heater.slots[1].item = nil
            inventory.heater.slots[2].item = result

            inventory.heater.on = false
        end

        -- Stop cooler
        if inventory.cooler.on and inventory.cooler.time < 0 then
            local result = getRecipe('cooler')

            inventory.cooler.slots[1].item = nil
            inventory.cooler.slots[2].item = result

            inventory.cooler.on = false
        end

        -- Win game
        if not gameWon and gameState == 2 and cursorItem == 'chocolate' then
            timer.on = false
            timer.stop = os.time()
            timer.m = math.floor((timer.stop - timer.start) / 60)
            timer.s = (timer.stop - timer.start) % 60
            gameState = 3
            playSound(winSound:clone())
        end

        -- Get stars
        if stars[1] == false and cursorItem == 'eggplant' then
            stars[1] = true
            updateStarScore()

        elseif stars[2] == false and cursorItem == 'dunked_chocolate_chip_cookie' then
            stars[2] = true
            updateStarScore()

        elseif stars[3] == false and cursorItem == 'iced_tea' then
            stars[3] = true
            updateStarScore()

        elseif stars[4] == false and cursorItem == 'cookie_dough_ice_cream' then
            stars[4] = true
            updateStarScore()

        elseif stars[5] == false and cursorItem == 'white_chocolate' then
            stars[5] = true
            updateStarScore()
        end

        -- Complete game
        if starScore == 5 and timer.on then
            timer.on = false
            timer.stop = os.time()
            timer.m = math.floor((timer.stop - timer.start) / 60)
            timer.s = (timer.stop - timer.start) % 60
            gameState = 4
            playSound(winSound:clone())
        end
    end
end
 
 
function love.draw()
    local mx, my = love.mouse.getPosition()

    -- Draw sound icon
    if soundEnabled then
        drawHoverable(mx, my, 33, 43, soundOnImg, true)
    else
        drawHoverable(mx, my, 33, 43, soundOffImg, true)
    end

    -- Draw music icon
    if musicEnabled then
        drawHoverable(mx, my, 80, 43, musicOnImg, true)
    else
        drawHoverable(mx, my, 80, 43, musicOffImg, true)
    end

    if gameState == 0 then
        -- Draw title screen
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(titleImg, 285, 70)

        drawHoverable(mx, my, 363, 349, startImg, false)
        drawHoverable(mx, my, 399, 516, quitImg, false)

    else
        -- Draw title
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(titleImg, 382.5, 40, 0, 0.5, 0.5)

        -- Draw player inventory grid
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(inventoryImg, inventory.player.x - 4, inventory.player.y - 4)


        for i,inv in pairs(inventory) do
            for j,slot in pairs(inv.slots) do
                -- Draw machine inventory slots
                if inv ~= inventory.player then
                    love.graphics.draw(slotImg, inv.x + slot.x - 4, inv.y + slot.y - 4)
                end

                if slot.item ~= nil then
                    -- Draw inventory items
                    if not inv.on and drawHoverable(mx, my, inv.x + slot.x, inv.y + slot.y, items[slot.item].texture, false) then
                        love.graphics.print(items[slot.item].name, inventory.player.x, inventory.player.y - 20)
                    else
                        love.graphics.draw(items[slot.item].texture, inv.x + slot.x, inv.y + slot.y)
                    end
                end
            end
        end

        -- Draw combiner
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(combineImg, inventory.combiner.x - 58, inventory.combiner.y - 2)
        drawProgress(inventory.combiner, inventory.combiner.x - 45, inventory.combiner.y - 40, mx, my)

        -- Draw combiner result
        local result = getRecipe('combiner')

        if result ~= nil then
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.draw(items[result].texture, inventory.combiner.x + inventory.combiner.slots[3].x, inventory.combiner.y + inventory.combiner.slots[3].y)
        end


        -- Draw splitter
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(splitImg, inventory.splitter.x - 58, inventory.splitter.y - 2)
        drawProgress(inventory.splitter, inventory.splitter.x - 45, inventory.splitter.y - 40, mx, my)
       
        -- Draw splitter result
        local result = getRecipe('splitter')

        if result ~= nil then
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.draw(items[result[1]].texture, inventory.splitter.x + inventory.splitter.slots[2].x, inventory.splitter.y + inventory.splitter.slots[2].y)
            love.graphics.draw(items[result[2]].texture, inventory.splitter.x + inventory.splitter.slots[3].x, inventory.splitter.y + inventory.splitter.slots[3].y)
        end


        -- Draw transformer
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(transformImg, inventory.transformer.x - 58, inventory.transformer.y - 2)
        drawProgress(inventory.transformer, inventory.transformer.x - 45, inventory.transformer.y - 40, mx, my)

        -- Draw transformer result
        local result = getRecipe('transformer')

        if result ~= nil then
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.draw(items[result].texture, inventory.transformer.x + inventory.transformer.slots[2].x, inventory.transformer.y + inventory.transformer.slots[2].y)
        end

        
        -- Draw heater
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(heatImg, inventory.heater.x - 58, inventory.heater.y - 2)
        drawProgress(inventory.heater, inventory.heater.x - 45, inventory.heater.y - 40, mx, my)

        -- Draw heater result
        local result = getRecipe('heater')

        if result ~= nil then
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.draw(items[result].texture, inventory.heater.x + inventory.heater.slots[2].x, inventory.heater.y + inventory.heater.slots[2].y)
        end
        

        -- Draw cooler
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(coolImg, inventory.cooler.x - 58, inventory.cooler.y - 2)
        drawProgress(inventory.cooler, inventory.cooler.x - 45, inventory.cooler.y - 40, mx, my)

        -- Draw cooler result
        local result = getRecipe('cooler')

        if result ~= nil then
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.draw(items[result].texture, inventory.cooler.x + inventory.cooler.slots[2].x, inventory.cooler.y + inventory.cooler.slots[2].y)
        end


        -- Draw star score
        if starScore > 0 then
            local starPos = {}

            if starScore == 1 then
                starPos = { 463 }
            elseif starScore == 2 then
                starPos = { 443, 483 }
            elseif starScore == 3 then
                starPos = { 423, 463, 503 }
            elseif starScore == 4 then
                starPos = { 403, 443, 483, 523 }
            else
                starPos = { 383, 423, 463, 503, 543 }
            end
        
            love.graphics.setColor(1, 1, 1, 1)
            for i = 1,starScore do
                love.graphics.draw(starImg, starPos[i], 145)
            end
        end


        -- Draw guide icon
        drawHoverable(mx, my, 900, 43, guideImg, false)

        
        -- Draw guide box
        if gameState == 1 then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(guideBoxImg, 208, 120)
            love.graphics.print(guideText, 216, 128)
        end

        -- Draw won box
        if gameState == 3 then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(wonBoxImg, 294, 250)
            love.graphics.print(string.format(wonText, getTimeString()), 302, 258)
        end

        -- Draw completed box
        if gameState == 4 then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(completedBoxImg, 272, 250)
            love.graphics.print(string.format(completedText, getTimeString()), 280, 258)
        end


        -- Draw cursor item
        if cursorItem ~= nil then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(items[cursorItem].texture, mx - 24, my - 24)
        end
    end
end


function love.keypressed(char)
    if gameState > 0 and string.len(char) == 1 then
        if cheatString == nil then
            cheatString = ''
        end

        cheatString = cheatString .. char

        if string.len(cheatString) > 10 then
            cheatString = string.sub(cheatString, 2)
        end

        -- "Cheat codes"
        if string.sub(cheatString, -3) == 'any' and inventory.player.slots[14].item == nil then
            inventory.player.slots[14].item = 'flour'
            cheatString = ''

        elseif gameState == 3 and string.sub(cheatString, -2) == 'no' then
            gameWon = true
            timer.on = true
            gameState = 2
            cheatString = ''

        elseif gameState == 4 and string.sub(cheatString, -1) == 'l' then
            gameState = 2
            cheatString = ''
            
        elseif string.sub(cheatString, -4) == 'aqua' then
            for i = 1,10 do
                if inventory.player.slots[i].item == nil then
                    inventory.player.slots[i].item = 'water'
                    cheatString = ''
                    break
                end
            end
        end
    end
end


function love.mousepressed(mx, my, b)
    if gameState == 0 then
        -- Start game
        if imageClicked(b, mx, my, startImg, 363, 349) then
            playSound(startSound:clone())
            initGame()
        end

        -- Quit
        if imageClicked(b, mx, my, quitImg, 399, 516) then
            os.exit()
        end

    elseif gameState == 1 then
        -- Close guide
        if timer.start == nil then
            timer.start = os.time()
            timer.on = true
        end
        gameState = 2
        playSound(quitSound:clone())
        return

    elseif gameState == 2 then
        -- Inventory interaction
        for i,inv in pairs(inventory) do
            if not inv.on then
                for j,slot in pairs(inv.slots) do
                    if areaClicked(b, mx, my, inv.x + slot.x, inv.y + slot.y, 48, 48) then
                        if j == 15 then
                            cursorItem = nil

                        elseif j > 10 then
                            if cursorItem == nil then
                                cursorItem = slot.item
                            end

                        elseif (slot.item ~= nil or cursorItem ~= nil) then
                            local insert = cursorItem
                            cursorItem = slot.item
                            slot.item = insert
                        end
                    end
                end
            end
        end

        -- Start processes
        if not inventory.combiner.on
            and getRecipe('combiner') ~= nil
            and imageClicked(b, mx, my, progressBarImg[1], inventory.combiner.x - 45, inventory.combiner.y - 40) then

            inventory.combiner.time = 5.0
            inventory.combiner.on = true

            playSound(startSound:clone())

        elseif not inventory.splitter.on
            and getRecipe('splitter') ~= nil
            and imageClicked(b, mx, my, progressBarImg[1], inventory.splitter.x - 45, inventory.splitter.y - 40) then

            inventory.splitter.time = 5.0
            inventory.splitter.on = true

            playSound(startSound:clone())

        elseif not inventory.transformer.on
            and getRecipe('transformer') ~= nil
            and imageClicked(b, mx, my, progressBarImg[1], inventory.transformer.x - 45, inventory.transformer.y - 40) then

            inventory.transformer.time = 5.0
            inventory.transformer.on = true

            playSound(startSound:clone())

        elseif not inventory.heater.on
            and getRecipe('heater') ~= nil
            and imageClicked(b, mx, my, progressBarImg[1], inventory.heater.x - 45, inventory.heater.y - 40) then

            inventory.heater.time = 5.0
            inventory.heater.on = true

            playSound(startSound:clone())

        elseif not inventory.cooler.on
            and getRecipe('cooler') ~= nil
            and imageClicked(b, mx, my, progressBarImg[1], inventory.cooler.x - 45, inventory.cooler.y - 40) then

            inventory.cooler.time = 5.0
            inventory.cooler.on = true

            playSound(startSound:clone())
        end

        -- Guide
        if imageClicked(b, mx, my, guideImg, 900, 43) then
            gameState = 1
            playSound(startSound:clone())
        end
    end

    -- Sound control
    if imageClicked(b, mx, my, soundOnImg, 33, 43) then
        if soundEnabled then
            soundEnabled = false
        else
            soundEnabled = true
            playSound(startSound:clone())
        end
    end

    -- Music control
    if imageClicked(b, mx, my, musicOnImg, 80, 43) then
        if musicEnabled then
            love.audio.stop(weakMusicSound)
            love.audio.stop(musicSound)
            musicEnabled = false
            playSound(quitSound:clone())
        else
            love.audio.play(weakMusicSound)
            musicEnabled = true
            playSound(startSound:clone())
        end
    end
end


function initGame()
    inventory = {}

    -- Initialize inventory
    inventory.player = Inventory.new(348, 490, 15)
    for i = 1,15 do
        local x = 54 * ((i - 1) % 5)
        local y = 54 * math.floor((i - 1) / 5)
        inventory.player.slots[i].x = x
        inventory.player.slots[i].y = y
    end

    inventory.player.slots[11].item = 'water'
    inventory.player.slots[12].item = 'cucumber'
    inventory.player.slots[13].item = 'gravel'
    inventory.player.slots[15].item = 'trash'

    -- Initialize machines
    inventory.combiner = Inventory.new(love.graphics:getWidth() / 6, 240, 3)
    inventory.combiner.name = 'combiner'
    inventory.combiner.slots[1].x = -54
    inventory.combiner.slots[2].x = 6
    inventory.combiner.slots[3].x = -24
    inventory.combiner.slots[3].y = 130

    inventory.splitter = Inventory.new(love.graphics:getWidth() / 3, 240, 3)
    inventory.splitter.name = 'splitter'
    inventory.splitter.slots[1].x = -24
    inventory.splitter.slots[2].x = -54
    inventory.splitter.slots[2].y = 130
    inventory.splitter.slots[3].x = 6
    inventory.splitter.slots[3].y = 130

    inventory.transformer = Inventory.new(love.graphics:getWidth() / 2, 240, 2)
    inventory.transformer.name = 'transformer'
    inventory.transformer.slots[1].x = -24
    inventory.transformer.slots[2].x = -24
    inventory.transformer.slots[2].y = 130

    inventory.heater = Inventory.new(love.graphics:getWidth() / 3 * 2, 240, 2)
    inventory.heater.name = 'heater'
    inventory.heater.slots[1].x = -24
    inventory.heater.slots[2].x = -24
    inventory.heater.slots[2].y = 130

    inventory.cooler = Inventory.new(love.graphics:getWidth() / 6 * 5, 240, 2)
    inventory.cooler.name = 'cooler'
    inventory.cooler.slots[1].x = -24
    inventory.cooler.slots[2].x = -24
    inventory.cooler.slots[2].y = 130

    for i,inv in pairs(inventory) do
        inv.on = false
        inv.time = 0.0
    end

    inventory.player.on = false

    -- Set game state
    gameState = 1
end


function getRecipe(type)
    local slots = inventory[type].slots

    if type == 'combiner' then
        if slots[3].item == nil then
            local ingredient = slots[1].item

            if ingredient ~= nil and items[ingredient].combiner ~= nil then
                local result = items[ingredient].combiner[slots[2].item]

                if result ~= nil then
                    return result
                end
            end
        end

        return nil
    end
    if type == 'splitter' or type == 'transformer' or type == 'heater' or type == 'cooler' then
        if slots[1].item ~= nil and slots[2].item == nil and (slots[3] == nil or slots[3].item == nil) then
            local result = items[slots[1].item][type]
            
            if result ~= nil then
                return result
            end
        end

        return nil
    end

    return nil
end


function drawProgress(inv, x, y, mx, my)
    if inv.on then
        local p = 21 - math.floor(inv.time * 21 / 5.0)
        love.graphics.draw(progressBarImg[p], x, y)
    else
        if getRecipe(inv.name) == nil then
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.draw(startProcessImg, x, y)
        else
            drawHoverable(mx, my, x, y, startProcessImg, false)
        end
    end
end


function imageClicked(b, mx, my, img, x, y)
    if b == 1 and mouseOnImage(mx, my, img, x, y) then
        return true
    end

    return false
end


function areaClicked(b, mx, my, x, y, w, h)
    if b == 1 and mouseInArea(mx, my, x, y, w, h) then
        return true
    end

    return false
end


function mouseOnImage(mx, my, img, x, y)
    if mx >= x and mx < x + img:getWidth()
        and my >= y and my < y + img:getHeight() then
        return true
    end

    return false
end


function mouseInArea(mx, my, x, y, w, h)
    if mx >= x and mx < x + w
        and my >= y and my < y + h then
        return true
    end

    return false
end


function drawHoverable(mx, my, x, y, img, ignoreTextBox)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(img, x, y)

	if (gameState ~= 1 and (ignoreTextBox or (gameState ~= 3 and gameState ~= 4)) and mouseInArea(mx, my, x, y, img:getWidth(), img:getHeight())) then 
		love.graphics.setBlendMode('add')
		love.graphics.setColor(1, 1, 1, 0.3)
		love.graphics.draw(img, x, y)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setBlendMode('alpha')

        return true
	end

    return false
end


function playSound(sound)
    if soundEnabled then
        love.audio.play(sound)
    end
end


function getTimeString()
    local timeString = ''
    if timer.m == 1 then
        timeString = '1 minute'

    elseif timer.m > 1 then
        timeString = timer.m .. ' minutes'
    end

    if timer.m > 0 and timer.s > 0 then
        timeString = timeString .. ' and '
    end

    if timer.s == 1 then
        timeString = timeString .. '1 second'

    elseif timer.s > 1 then
        timeString = timeString .. timer.s .. ' seconds'
    end

    if timer.m == 0 and timer.s == 0 then
        timeString = 'no time'
    end

    return timeString
end


function updateStarScore()
    starScore = 0
    for i = 1,5 do
        if stars[i] == true then
            starScore = starScore + 1
        end
    end
end
