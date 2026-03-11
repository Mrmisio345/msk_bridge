local target <const> = {}

---Toggle the availability of the targeting menu.
---Setting state to true will turn off the targeting eye if it is active
---and prevent it from reopening until state is set to false again.
---@param state boolean - true = disable targeting, false = enable targeting
target.disableTargeting = function(state)
    assert(type(state) == 'boolean', 'disableTargeting: state must be a boolean')
end

---Creates new targetable options which are displayed at all times.
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name (e.g. 'fas fa-hand')
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addGlobalOption = function(options)
    assert(type(options) == 'table', 'addGlobalOption: options must be a table')
end

---Removes all options from the global options list with the option names.
---@param optionNames string|string[] - Option name(s) to remove
target.removeGlobalOption = function(optionNames)
    assert(optionNames ~= nil, 'removeGlobalOption: optionNames is required (string|string[])')
end

---Creates new targetable options for all Object entity types.
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name (e.g. 'fas fa-box')
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addGlobalObject = function(options)
    assert(type(options) == 'table', 'addGlobalObject: options must be a table')
end

---Removes all options from the global Object list with the option names.
---@param optionNames string|string[] - Option name(s) to remove
target.removeGlobalObject = function(optionNames)
    assert(optionNames ~= nil, 'removeGlobalObject: optionNames is required (string|string[])')
end

---Creates new targetable options for all Ped entity types (excluding players).
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name (e.g. 'fas fa-person')
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addGlobalPed = function(options)
    assert(type(options) == 'table', 'addGlobalPed: options must be a table')
end

---Removes all options from the global Ped list with the option names.
---@param optionNames string|string[] - Option name(s) to remove
target.removeGlobalPed = function(optionNames)
    assert(optionNames ~= nil, 'removeGlobalPed: optionNames is required (string|string[])')
end

---Creates new targetable options for all Player entities.
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name (e.g. 'fas fa-user')
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addGlobalPlayer = function(options)
    assert(type(options) == 'table', 'addGlobalPlayer: options must be a table')
end

---Removes all options from the global Player list with the option names.
---@param optionNames string|string[] - Option name(s) to remove
target.removeGlobalPlayer = function(optionNames)
    assert(optionNames ~= nil, 'removeGlobalPlayer: optionNames is required (string|string[])')
end

---Creates new targetable options for all Vehicle entity types.
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name (e.g. 'fas fa-car')
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addGlobalVehicle = function(options)
    assert(type(options) == 'table', 'addGlobalVehicle: options must be a table')
end

---Removes all options from the global Vehicle list with the option names.
---@param optionNames string|string[] - Option name(s) to remove
target.removeGlobalVehicle = function(optionNames)
    assert(optionNames ~= nil, 'removeGlobalVehicle: optionNames is required (string|string[])')
end

---Creates new targetable options for a specific model or list of models.
---@param models number|string|table<number|string> - Model hash(es) or name(s) to target
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name (e.g. 'fas fa-cube')
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addModel = function(models, options)
    assert(models ~= nil, 'addModel: models is required (number|string|table)')
    assert(type(options) == 'table', 'addModel: options must be a table')
end

---Removes all options from the models list with the option names.
---@param models number|string|table<number|string> - Model hash(es) or name(s)
---@param optionNames string|string[] - Option name(s) to remove
target.removeModel = function(models, optionNames)
    assert(models ~= nil, 'removeModel: models is required (number|string|table)')
    assert(optionNames ~= nil, 'removeModel: optionNames is required (string|string[])')
end

---Creates new targetable options for a specific network id or list of network ids.
---Use NetworkGetNetworkIdFromEntity to get the network id of an entity.
---@param netIds number|number[] - Network ID(s) of the entity(ies)
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addEntity = function(netIds, options)
    assert(netIds ~= nil, 'addEntity: netIds is required (number|number[])')
    assert(type(options) == 'table', 'addEntity: options must be a table')
end

---Removes all options from the networked entities list with the option names.
---@param netIds number|number[] - Network ID(s) of the entity(ies)
---@param optionNames string|string[] - Option name(s) to remove
target.removeEntity = function(netIds, optionNames)
    assert(netIds ~= nil, 'removeEntity: netIds is required (number|number[])')
    assert(optionNames ~= nil, 'removeEntity: optionNames is required (string|string[])')
end

---Creates new targetable options for a specific entity handle or list of entity handles.
---These are non-networked entities (local only).
---@param entities number|number[] - Entity handle(s)
---@param options table - Array of target option tables
---@param options[].name string - Unique option identifier
---@param options[].label string - Display label shown to the player
---@param options[].icon? string - Icon name
---@param options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param options[].distance? number - Max interaction distance
---@param options[].bones? string|string[] - Required bone names
---@param options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param options[].items? string|string[]|table - Required item(s) in inventory
---@param options[].anyItem? boolean - If true, only one of the items is required
---@param options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string, bone?: number): boolean
---@param options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string, bone?: number })
target.addLocalEntity = function(entities, options)
    assert(entities ~= nil, 'addLocalEntity: entities is required (number|number[])')
    assert(type(options) == 'table', 'addLocalEntity: options must be a table')
end

---Removes all options from the entities list with the option names.
---@param entities number|number[] - Entity handle(s)
---@param optionNames string|string[] - Option name(s) to remove
target.removeLocalEntity = function(entities, optionNames)
    assert(entities ~= nil, 'removeLocalEntity: entities is required (number|number[])')
    assert(optionNames ~= nil, 'removeLocalEntity: optionNames is required (string|string[])')
end

---Creates a new targetable sphere zone.
---@param parameters table - Zone configuration
---@param parameters.coords vector3 - Center position of the sphere
---@param parameters.name? string - Optional name to refer to the zone instead of using the id
---@param parameters.radius? number - Sphere radius
---@param parameters.debug? boolean - Draw debug sphere (default: false)
---@param parameters.drawSprite? boolean - Draw a sprite at the centroid of the zone (default: true)
---@param parameters.options table - Array of target option tables
---@param parameters.options[].name string - Unique option identifier
---@param parameters.options[].label string - Display label shown to the player
---@param parameters.options[].icon? string - Icon name
---@param parameters.options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param parameters.options[].distance? number - Max interaction distance
---@param parameters.options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param parameters.options[].items? string|string[]|table - Required item(s) in inventory
---@param parameters.options[].anyItem? boolean - If true, only one of the items is required
---@param parameters.options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string): boolean
---@param parameters.options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string })
---@return number id - Zone identifier used for removal
target.addSphereZone = function(parameters)
    assert(type(parameters) == 'table', 'addSphereZone: parameters must be a table')
    assert(parameters.coords ~= nil, 'addSphereZone: parameters.coords is required (vector3)')
    assert(type(parameters.options) == 'table', 'addSphereZone: parameters.options must be a table')
end

---Creates a new targetable box zone.
---@param parameters table - Zone configuration
---@param parameters.coords vector3 - Center position of the box
---@param parameters.name? string - Optional name to refer to the zone instead of using the id
---@param parameters.size? vector3 - Box dimensions (width, length, height)
---@param parameters.rotation? number - Box Y-axis rotation in degrees (default: 0)
---@param parameters.debug? boolean - Draw debug box (default: false)
---@param parameters.drawSprite? boolean - Draw a sprite at the centroid of the zone (default: true)
---@param parameters.options table - Array of target option tables
---@param parameters.options[].name string - Unique option identifier
---@param parameters.options[].label string - Display label shown to the player
---@param parameters.options[].icon? string - Icon name
---@param parameters.options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param parameters.options[].distance? number - Max interaction distance
---@param parameters.options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param parameters.options[].items? string|string[]|table - Required item(s) in inventory
---@param parameters.options[].anyItem? boolean - If true, only one of the items is required
---@param parameters.options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string): boolean
---@param parameters.options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string })
---@return number id - Zone identifier used for removal
target.addBoxZone = function(parameters)
    assert(type(parameters) == 'table', 'addBoxZone: parameters must be a table')
    assert(parameters.coords ~= nil, 'addBoxZone: parameters.coords is required (vector3)')
    assert(type(parameters.options) == 'table', 'addBoxZone: parameters.options must be a table')
end

---Creates a new targetable polygon zone.
---@param parameters table - Zone configuration
---@param parameters.points vector3[] - Array of 3d points defining the polygon's shape
---@param parameters.name? string - Optional name to refer to the zone instead of using the id
---@param parameters.thickness? number - The height of the polygon (default: 4)
---@param parameters.debug? boolean - Draw debug polygon (default: false)
---@param parameters.drawSprite? boolean - Draw a sprite at the centroid of the zone (default: true)
---@param parameters.options table - Array of target option tables
---@param parameters.options[].name string - Unique option identifier
---@param parameters.options[].label string - Display label shown to the player
---@param parameters.options[].icon? string - Icon name
---@param parameters.options[].iconColor? string - Icon color (e.g. '#ffffff')
---@param parameters.options[].distance? number - Max interaction distance
---@param parameters.options[].groups? table - Allowed job/group names { ['police'] = 0 }
---@param parameters.options[].items? string|string[]|table - Required item(s) in inventory
---@param parameters.options[].anyItem? boolean - If true, only one of the items is required
---@param parameters.options[].canInteract? function(entity: number, distance: number, coords: vector3, name: string): boolean
---@param parameters.options[].onSelect? function(data: { entity: number, distance: number, coords: vector3, name: string })
---@return number id - Zone identifier used for removal
target.addPolyZone = function(parameters)
    assert(type(parameters) == 'table', 'addPolyZone: parameters must be a table')
    assert(type(parameters.points) == 'table', 'addPolyZone: parameters.points must be a table (vector3[])')
    assert(type(parameters.options) == 'table', 'addPolyZone: parameters.options must be a table')
end

---Removes a targetable zone with the given id (returned by addSphereZone/addBoxZone/addPolyZone)
---or the string name given to the zone.
---@param id number|string - The number id returned by addSphereZone/addBoxZone/addPolyZone OR the string name given to the zone
target.removeZone = function(id)
    assert(id ~= nil, 'removeZone: id is required (number|string)')
end

return target