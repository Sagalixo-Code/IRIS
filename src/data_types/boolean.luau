const primitives = require("./primitives")

return function (value: boolean)
    return primitives(value, "boolean")
end :: (value: boolean) -> primitives.primitive