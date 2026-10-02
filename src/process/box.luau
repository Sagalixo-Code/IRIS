type value = string | number | boolean | {any}

type method = (self: any, ...any) -> any

return function(value: value, methods: { [string]: method })
    const descriptor = setmetatable({__value = value}, {
        __mode = "kv",
        __tostring = function()
            return `{value}`
        end,
    })

    if methods then
        for key: string, callback: method in pairs(methods) do
            descriptor[key] = function(self, ...)
                return callback(self, ...)
            end
        end
    end

    return descriptor
end