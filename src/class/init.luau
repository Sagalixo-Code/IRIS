--!strict

const ts = require("@self/types")

export type objectType = ts.object
export type classType = ts.class
export type componentType<K, V> = ts.components<K, V>
export type classRType = ts.classReturn

return function(object: objectType)
    const constructor = object.constructor

    if not constructor then
        warn(`[Class] Expected constructor, but got nil`)
        return
    end

    const class = {}
    const privates = {}

    class.__index = class

    function class:__call(components: componentType<string, any>)
        const self = components or {}
        setmetatable(self, class)

        return self
    end

    function class:extend()
        const derivedClass = setmetatable({}, self)
        derivedClass.__index = derivedClass

        return derivedClass
    end

    function class:public(components: componentType<any, any>)
        for key, value in components do
            self[key] = value
        end
    end

    function class:private(components: componentType<any, any>)
        for key, value in components do
            privates[key] = value
        end
    end

    function class:get(key)
        return privates[key]
    end

    return ((setmetatable(class, {
        __call = function(_, components)
            return class:__call(components)
        end,
    })) :: any)
end :: classType?