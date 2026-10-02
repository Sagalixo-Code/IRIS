const class = require("../class")

const signal = class {
    constructor = function(this: class.classRType, ...: any) end,
}

signal:private({
    __callbacks = {}
})

signal:public({

    connect = function(this: class.classRType, callback: (...any) -> ())
        assert(type(callback) == "function", "Signal.connect expected a function")

        const callbacks = signal:get("__callbacks")
        table.insert(callbacks, callback)

        return function()
            this:disconnect(callback)
        end
    end,

    once = function(this: class.classRType, callback: (...any) -> ())
        assert(type(callback) == "function", "Signal.once expected a function")

        local connection

        connection = this:connect(function(...)
            connection()
            callback(...)
        end)

        return connection
    end,

    fire = function(this: class.classRType, ...)
        const callbacks = signal:get("__callbacks")

        for index, callback in ipairs(callbacks) do
            if callback then
                task.spawn(callback, ...)
            end
        end
    end,

    disconnect = function(this: class.classRType, callback: (...any) -> ())
        const callbacks = signal:get("__callbacks")

        for index, registeredCallback in ipairs(callbacks) do
            if registeredCallback == callback then
                table.remove(callbacks, index)
                return
            end
        end
    end,

    disconnectAll = function(this: class.classRType)
        const callbacks = signal:get("__callbacks")
        table.clear(callbacks)
    end,

    wait = function(this: class.classRType)
        const thread = coroutine.running()

        local connection

        connection = this:connect(function(...)
            connection()
            task.spawn(thread, ...)
        end)

        return coroutine.yield()
    end,

    destroy = function(this: class.classRType)
        this:disconnectAll()
    end,

})

return signal :: (...any) -> {
    connect: (self: class.classRType, callback: (...any) -> ()) -> (() -> ()),
    once: (self: class.classRType, callback: (...any) -> ()) -> (() -> ()),
    fire: (self: class.classRType, ...any) -> (),
    disconnect: (self: class.classRType, callback: (...any) -> ()) -> (),
    disconnectAll: (self: class.classRType) -> (),
    wait: (self: class.classRType) -> ...any,
    destroy: (self: class.classRType) -> (),
}