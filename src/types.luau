export type signal<T> = (...any) -> {
    connect: (self: T, callback: (...any) -> ()) -> (() -> ()),
    once: (self: T, callback: (...any) -> ()) -> (() -> ()),
    fire: (self: T, ...any) -> (),
    disconnect: (self: T, callback: (...any) -> ()) -> (),
    disconnectAll: (self: T) -> (),
    wait: (self: T) -> ...any,
    destroy: (self: T) -> (),
}

return {}