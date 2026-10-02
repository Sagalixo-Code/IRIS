const number_data = require("../src/data_types/number")
const string_data = require("../src/data_types/string")
const boolean_data = require("../src/data_types/boolean")
const map_data = require("../src/data_types/map")

const stringExample = function()
    const exampleString = string_data("Saga")

    exampleString:observer(function(value: string)
        print(value)
    end)

    exampleString:set("Exception")
    exampleString:destroy()
end

const numberExample = function()
    const exampleNumber = number_data(1)

    exampleNumber:observer(function(value: number)
        print(value)
        print(exampleNumber:equals(67))
    end)

    exampleNumber:set(67)
    exampleNumber:destroy()
end

const booleanExample = function()
    const exampleBool = boolean_data(false)

    exampleBool:observer(function(value: boolean)
        print(value)
        print(exampleBool:equals(true))
    end)

    exampleBool:set(true)
    exampleBool:destroy()
end

const mapExample = function()
    const exampleMap = map_data({
        {"1", string_data("exampleForMap")}
    })

    exampleMap:observer(function(value: map_data.entry)
        print(value[1])
        print(value[2])
    end)

    exampleMap:set({
        "1",
        string_data("Exception")
    })
    exampleMap:destroy()

    for key, value in exampleMap:query{"1", "Exception"} do
        if key == "unknown" or value == "unknown" then
            continue
        end

        print(`Query have a good result! key is: {key} and value is {value}`)
    end
end

stringExample()
numberExample()
booleanExample()
mapExample()