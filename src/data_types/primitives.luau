type primitiveType = "string" | "number" | "boolean"

type primitiveValue = string | number | boolean

export type primitive = {
    __value: buffer,
    
    set: (self: primitive, value: primitiveValue) -> boolean,
    get: (self: primitive) -> primitiveValue,
    equals: (self: primitive, value: primitiveValue) -> boolean,
    observer: (
        self: primitive,
        callback: (value: primitiveValue) -> ()
    ) -> () -> (),
    buffer: (self: primitive) -> buffer,
    destroy: (self: primitive) -> (),
}

const signal = require("../process/signal")
const box = require("../process/box")

return function(value: primitiveValue, valueType: primitiveType): primitive
    const onChange = signal {}

    const encode = function(value: primitiveValue): buffer
        if valueType == "number" then
            const data = buffer.create(8)
            buffer.writef64(data, 0, value :: number)

            return data
        end

        if valueType == "boolean" then
            const data = buffer.create(1)
            buffer.writeu8(data, 0, if value :: boolean then 1 else 0)

            return data
        end

        const length = #(value :: string)
        const data = buffer.create(4 + length)

        buffer.writeu32(data, 0, length)
        buffer.writestring(data, 4, value :: string)

        return data
    end

    const decode = function(data: buffer): primitiveValue
        if valueType == "number" then
            return buffer.readf64(data, 0)
        end

        if valueType == "boolean" then
            return buffer.readu8(data, 0) == 1
        end

        const length = buffer.readu32(data, 0)

        return buffer.readstring(data, 4, length)
    end

    return box(encode(value), {
        set = function(self: primitive, newValue: primitiveValue)
            if typeof(newValue) ~= valueType then
                return false
            end

            if self:get() == newValue then
                return true
            end

            self.__value = encode(newValue)

            onChange:fire(newValue)

            return true
        end,

        get = function(self: primitive)
            return decode(self.__value)
        end,

        equals = function(self: primitive, valueToCompare: primitiveValue)
            if typeof(valueToCompare) ~= valueType then
                return false
            end

            return self:get() == valueToCompare
        end,

        observer = function(self: primitive, callback: (value: primitiveValue) -> ())
            return onChange:connect(callback)
        end,

        buffer = function(self: primitive)
            return self.__value
        end,

        destroy = function(self: primitive)
            onChange:disconnectAll()
        end,
    }) :: primitive

end :: (value: primitiveValue, valueType: primitiveType) -> primitive