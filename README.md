# IRIS

**Intermediate Representation & Interpretation System**

IRIS is a programming engine for Roblox built around **intermediate representation and buffer-backed data**.

It introduces a different way of writing Roblox systems, making data easier to represent, manipulate, observe and replicate while keeping the underlying representation compact and efficient.

IRIS is designed to make complex systems easier to build without requiring every system to implement its own representation, serialization and runtime logic.

## Features

* Buffer-backed data representation
* Typed values and data structures
* Intermediate representation
* Customizable interpreters
* Runtime hooks
* Reactive data observation
* Serialization and replication
* Data-oriented programming model

## Example

```lua
const player = iris.struct {
    name = iris.values.string("Exception"),
    level = iris.values.number(1),
    alive = iris.values.boolean(true),
}

player.level:set(10)
```

Values are represented by IRIS instead of relying directly on ordinary Lua values.

```lua
player.level:observer(function(level)
    print("Level:", level)
end)
```

## Intermediate Representation

IRIS can represent operations without executing them immediately.

```lua
const sequence = iris.sequence {
    iris.wait(1),
    iris.printLn("Hello"),
}
```

The representation can then be interpreted by an interpreter.

```lua
const interpreter = iris.interpreter()

interpreter:run(sequence)
```

### Custom Interpreters

The interpreter is extensible through custom hooks, allowing developers to define how IRIS operations are executed.

```lua
const interpreter = iris.interpreter {
    hooks = {
        printLn = function(value)
            print("[Custom]", value)
        end,
    },
}
```

This allows the same representation to be interpreted by different runtimes or execution models.

## Performance

IRIS is built around buffers as a fundamental data representation.

Instead of repeatedly converting between different data structures for serialization, replication and runtime processing, IRIS can operate directly on its buffer-backed representations.

This reduces unnecessary allocations and allows the engine to work with data in a more compact form.

## Philosophy

> **Representation ≠ Execution**

IRIS separates what a system **is** from how that system is **executed**.

The goal is not to provide another collection of Roblox utilities.

The goal is to provide a different programming model for building Roblox systems.

## Status

IRIS is currently under development.

The API is experimental and may change as the engine evolves.

## License

MIT
