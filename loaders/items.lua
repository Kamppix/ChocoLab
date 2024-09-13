local items = { list = {} }


Item = {}
function Item.new(name, combiner, splitter, transformer, heater, cooler)
    local item = {}

    item.name = name
    item.combiner = combiner
    item.splitter = splitter
    item.transformer = transformer
    item.heater = heater
    item.cooler = cooler

    return item
end


function items.add(id, item, plugin)
    items.list[id] = item

    local path = ''
    if plugin then
        path = 'plugins/' .. plugin.name .. '/assets/textures/items/' .. id .. '.png'
    else
        path = 'assets/textures/items/' .. id .. '.png'
    end

    if love.filesystem.getInfo(path) then
        item.texture = love.graphics.newImage(path)
    else
        print('Could not find texture file at \'' .. path .. '\'')
        item.texture = game.textures.placeholder
    end
end


function items.remove(id)
    items.list[id] = nil
end


items.add('trash_can', Item.new('Trash Can', nil, nil, nil, nil, nil))

items.add('water', Item.new('Water', { fat = 'milk' }, nil, nil, 'salt', 'ice'))
items.add('gravel', Item.new('Gravel', { cucumber = 'peas', zucchini = 'peas' }, nil, nil, nil, nil))
items.add('cucumber', Item.new('Cucumber', { salt = 'pickle', turnip = 'carrot', gravel = 'peas' }, nil, 'zucchini', nil, nil))

items.add('salt', Item.new('Salt', { cucumber = 'pickle', raw_beef = 'salted_beef', fried_potato = 'potato_chips' }, nil, 'sugar', nil, nil))
items.add('pickle', Item.new('Pickle', nil, { 'salt', 'cucumber' }, 'beetroot', nil, nil))
items.add('beetroot', Item.new('Beetroot', { zucchini = 'eggplant' }, { 'red_food_coloring', 'turnip' }, 'pickle', nil, nil))
items.add('turnip', Item.new('Turnip', { red_food_coloring = 'beetroot', cucumber = 'carrot' }, nil, nil, nil, nil))
items.add('carrot', Item.new('Carrot', nil, { 'turnip', 'cucumber' }, 'potato', nil, nil))
items.add('potato', Item.new('Potato', nil, nil, 'carrot', 'fried_potato', nil))
items.add('fried_potato', Item.new('Fried Potato', { salt = 'potato_chips' }, nil, nil, nil, nil))
items.add('red_food_coloring', Item.new('Red Food Coloring', { turnip = 'beetroot', peas = 'raw_beef' }, nil, nil, nil, nil))
items.add('peas', Item.new('Peas', { red_food_coloring = 'raw_beef', chocolate_chips = 'cocoa_nibs' }, nil, nil, nil, nil))
items.add('raw_beef', Item.new('Raw Beef', { salt = 'salted_beef' }, nil, nil, 'cooking_grease', nil))
items.add('salted_beef', Item.new('Salted Beef', nil, { 'salt', 'raw_beef' }, nil, 'cooking_grease', nil))
items.add('cooking_grease', Item.new('Cooking Grease', nil, nil, nil, nil, 'fat'))
items.add('fat', Item.new('Fat', { water = 'milk', milk = 'cream' }, nil, nil, nil, nil))
items.add('sugar', Item.new('Sugar', { potato_chips = 'chocolate_chips', cocoa_nibs = 'cocoa_powder' }, nil, 'salt', nil, nil))
items.add('potato_chips', Item.new('Potato Chips', { sugar = 'chocolate_chips' }, { 'salt', 'fried_potato' }, nil, nil, nil))
items.add('chocolate_chips', Item.new('Chocolate Chips', { peas = 'cocoa_nibs', cookie_dough = 'chocolate_chip_cookie' }, { 'sugar', 'potato_chips' }, nil, nil, nil))
items.add('cocoa_nibs', Item.new('Cocoa Nibs', { sugar = 'cocoa_powder' }, { 'chocolate_chips', 'peas' }, nil, nil, nil))    
items.add('cocoa_powder', Item.new('Cocoa Powder', { milk = 'chocolate_milk' }, { 'cocoa_nibs', 'sugar' }, nil, nil, nil))
items.add('milk', Item.new('Milk', { cocoa_powder = 'chocolate_milk', flour = 'cookie_dough', chocolate_chip_cookie = 'dunked_chocolate_chip_cookie', fat = 'cream', chocolate = 'white_chocolate' }, { 'water', 'fat' }, nil, nil, nil))
items.add('chocolate_milk', Item.new('Chocolate Milk', nil, { 'cocoa_powder', 'milk' }, nil, 'hot_chocolate', nil))
items.add('hot_chocolate', Item.new('Hot Chocolate', nil, nil, 'tea', nil, 'chocolate'))
items.add('chocolate', Item.new('Chocolate Bar', { milk = 'white_chocolate' }, { 'chocolate_chips', 'chocolate_chips' }, nil, 'hot_chocolate', nil))

items.add('zucchini', Item.new('Zucchini', { beetroot = 'eggplant', gravel = 'peas' }, nil, 'cucumber', nil, nil))
items.add('eggplant', Item.new('Eggplant', nil, { 'beetroot', 'zucchini' }, nil, nil, nil))
items.add('tea', Item.new('Tea', { ice = 'iced_tea' }, nil, 'hot_chocolate', nil, nil))
items.add('iced_tea', Item.new('Iced Tea', nil, { 'tea', 'ice' }, nil, 'tea', nil))
items.add('ice', Item.new('Ice', { cream = 'ice_cream', tea = 'iced_tea' }, nil, nil, 'water', nil))
items.add('ice_cream', Item.new('Ice Cream', { cookie_dough = 'cookie_dough_ice_cream' }, { 'ice', 'cream' }, nil, 'cream', nil))
items.add('cream', Item.new('Cream', { ice = 'ice_cream' }, { 'fat', 'milk' }, nil, nil, 'ice_cream'))
items.add('white_chocolate', Item.new('"Milk" Chocolate Bar', nil, { 'chocolate', 'milk' }, nil, nil, nil))
items.add('flour', Item.new('Flour', { milk = 'cookie_dough' }, nil, nil, nil, nil))
items.add('cookie_dough', Item.new('Cookie Dough', { chocolate_chips = 'chocolate_chip_cookie', ice_cream = 'cookie_dough_ice_cream' }, { 'flour', 'milk' }, nil, nil, nil))
items.add('cookie_dough_ice_cream', Item.new('Cookie Dough Ice Cream', nil, nil, nil, 'cream', nil))
items.add('chocolate_chip_cookie', Item.new('Chocolate Chip Cookie', { milk = 'dunked_chocolate_chip_cookie' }, { 'chocolate_chips', 'cookie_dough' }, nil, nil, nil))
items.add('dunked_chocolate_chip_cookie', Item.new('Dunked Chocolate Chip Cookie', nil, { 'chocolate_chips', 'cookie_dough' }, nil, nil, nil))


return items
