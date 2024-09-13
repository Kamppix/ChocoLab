local recipes = {}


function recipes.add(result, machine, item, combineWith)
    if machine == 'combiner' then
        game.items.list[item][machine][combineWith] = result
        game.items.list[combineWith][machine][item] = result
    else
        game.items.list[item][machine] = result
    end
end


function recipes.remove(machine, item, combineWith)
    game.items.list[item][machine] = nil
    if machine == 'combiner' then
        game.items.list[combineWith][machine] = nil
    end
end


recipes.add('ice', 'cooler', 'water')
recipes.add('milk', 'combiner', 'water', 'fat')
recipes.add('chocolate_milk', 'combiner', 'milk', 'cocoa_powder')
recipes.add('hot_chocolate', 'heater', 'chocolate_milk')
recipes.add('chocolate', 'cooler', 'hot_chocolate')


return recipes
