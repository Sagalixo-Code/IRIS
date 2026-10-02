const primitives = require("./primitives")

return function (value: string)
    return primitives(value, "string")
end :: (value: string) -> primitives.primitive