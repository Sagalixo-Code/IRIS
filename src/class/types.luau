export type object = {
    constructor: (...any) -> any,
    [string]: any
}

export type components<K, V> = { [K]: V }

export type classReturn = {
    __index: classReturn,

    extend: (self: classReturn) -> classReturn,
    public: (self: classReturn, components: components<any, any>) -> (),
    private: (self: classReturn, components: components<any, any>) -> (),
    get: (self: classReturn, key: string) -> any,

    [string]: any
}

export type class = (object: object) -> classReturn?

return {}