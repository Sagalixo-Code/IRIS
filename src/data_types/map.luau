export type entry = { any }

export type map = {

    __value: { [any]: any },

    set: (self: map, value: entry) -> boolean,
    query: (self: map, path: string | { string }) -> any,
    has: (self: map, key: any) -> boolean,
    delete: (self: map, key: any) -> boolean,
    clear: (self: map) -> (),
    size: (self: map) -> number,

    observer: (
        self: map,
        callback: (value: entry) -> ()
    ) -> () -> (),

    equals: (
        self: map,
        tupleToCompare: entry
    ) -> (boolean, boolean),

    buffer: (self: map) -> buffer,

    destroy: (self: map) -> (),

}

const signal = require("../process/signal")
const box = require("../process/box")

return function(object: { { any } }): map
    const onChange = signal {}

    const encode = function(value: { [any]: any }): buffer
        const entries = {}

        for key, item in value do
            table.insert(entries, {
                key,
                value = item,
            })
        end

        local size = 4

        for _, item in entries do
            assert(typeof(item.key) == "string", "[Map] Buffer encoding only supports string keys")
            assert(typeof(item.value) == "string" or typeof(item.value) == "number" or typeof(item.value) == "boolean", "[Map] Buffer encoding only supports primitive values")

            size += 5 + #item.key

            if typeof(item.value) == "string" then
                size += 4 + #item.value
            elseif typeof(item.value) == "number" then
                size += 8
            else
                size += 1
            end
        end

        const data = buffer.create(size)

        buffer.writeu32(data, 0, #entries)

        const offset = { value = 4 }

        for _, item in entries do
            const key = item.key :: string
            const itemValue = item.value
            const keyLength = #key

            buffer.writeu32(data, offset.value, keyLength)
            offset.value += 4

            buffer.writestring(data, offset.value, key)
            offset.value += keyLength

            if typeof(itemValue) == "string" then
                buffer.writeu8(data, offset.value, 1)
                offset.value += 1

                buffer.writeu32(data, offset.value, #itemValue)
                offset.value += 4

                buffer.writestring(data, offset.value, itemValue)
                offset.value += #itemValue

            elseif typeof(itemValue) == "number" then
                buffer.writeu8(data, offset.value, 2)
                offset.value += 1

                buffer.writef64(data, offset.value, itemValue)

                offset.value += 8

            else
                buffer.writeu8(data, offset.value, 3)
                offset.value += 1

                buffer.writeu8(data, offset.value, if itemValue :: boolean then 1 else 0)
                offset.value += 1
            end
        end

        return data
    end

    const descriptor = box(object, {
        set = function(self: map, value: entry)
            self.__value[value[1]] = value[2]

            onChange:fire(value)

            return true
        end,

        query = function(self: map, path: string | entry)
            if typeof(path) == "string" then
                local value = self.__value[path]

                if value == nil then
                    return nil
                end

                return {path, value}
            end

            const key = path[1]
            const expectedValue = path[2]

            const value = self.__value[key]

            if value == nil then
                return {"unknown", "unknown"}
            end

            if value ~= expectedValue then
                return {"unknown", "unknown"}
            end

            return {key, value}
        end,

        has = function(self: map, key)
            return self.__value[key] ~= nil
        end,

        delete = function(self: map, key)
            if self.__value[key] == nil then
                return false
            end

            self.__value[key] = nil

            onChange:fire({key, nil})

            return true
        end,

        clear = function(self: map)
            table.clear(self.__value)
        end,

        size = function(self: map)
            local size = 0

            for _ in self.__value do
                size += 1
            end

            return size
        end,

        observer = function(self: map, callback: (value: entry) -> ())
            return onChange:connect(callback)
        end,

        equals = function(self: map, tupleToCompare: entry)
            const indexEqual = self.__value[tupleToCompare[1]] ~= nil
            const valueEqual = self.__value[tupleToCompare[1]] == tupleToCompare[2]

            return valueEqual, indexEqual
        end,

        buffer = function(self: map)
            return encode(self.__value)
        end,

        destroy = function(self: map)
            onChange:disconnectAll()
            table.clear(self.__value)
        end,
    }) :: map
    
    return descriptor
end :: (object: { { any } }) -> map