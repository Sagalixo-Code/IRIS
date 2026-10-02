const primitives = require("./primitives")

return function (value: number)
    return primitives(value, "number")
end :: (value: number) -> primitives.primitive