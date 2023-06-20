
---@class OOPLib
OOP = {
    _Classes = {}, ---@type table<string, table>
}

---------------------------------------------
-- CLASSES
---------------------------------------------

---@class Class
---@field protected __name string
---@field protected __ParentClasses string[]
---@field protected __ClassDefinition Class
local Class = {}

---Creates a new table with the metatable of the class set.
---@protected
---@param data table?
---@return Class
function Class:__Create(data)
    local classTable = self ---@cast classTable table|Class
    ---@cast data Class

    setmetatable(data, {
        __index = function (instance, key)
            -- Check field presence in class definition
            if classTable[key] ~= nil then
                return classTable[key]
            end

            -- Check presence in parent classes
            for _,tbl in ipairs(instance:GetParentClasses()) do
                if tbl[key] ~= nil then
                    return tbl[key]
                end
            end

            -- Check dedicated __index method in class definition
            if classTable.__index ~= nil then
                return classTable.__index(instance, key)
            end
        end,
        -- TODO support multiple inheritance for these
        __newindex = classTable.__newindex,
        __mode = classTable.__mode,
        __call = classTable.__call,
        __metatable = classTable.__metatable,
        __tostring = classTable.__tostring,
        __len = classTable.__len,
        __pairs = classTable.__pairs,
        __ipairs = classTable.__ipairs,
        __name = classTable.__name,

        __unm = classTable.__unm,
        __add = classTable.__add,
        __sub = classTable.__sub,
        __mul = classTable.__mul,
        __div = classTable.__div,
        __idiv = classTable.__idiv,
        __mod = classTable.__mod,
        __pow = classTable.__pow,
        __concat = classTable.__concat,

        __band = classTable.__band,
        __bor = classTable.__bor,
        __bxor = classTable.__bxor,
        __bnot = classTable.__bnot,
        __shl = classTable.__shl,
        __shr = classTable.__shr,

        __eq = classTable.__eq,
        __lt = classTable.__lt,
        __le = classTable.__le,
    })

    return data
end

---Returns the name of the class.
---@return string
function Class:GetClassName()
    return self.__name
end

---Returns whether this class implements another.
---Hierarchies are considered.
---@param className string
---@return boolean
function Class:ImplementsClass(className)
    local implements = false

    for _,class in ipairs(self:GetParentClasses()) do
        if class:GetClassName() == className or class:ImplementsClass(className) then
            implements = true
            break
        end
    end

    return implements
end

---Returns the parent classes of the class.
---@return Class[]
function Class:GetParentClasses()
    local classes = {}

    for i,className in ipairs(self.__ParentClasses) do
        classes[i] = OOP.GetClass(className)
    end

    return classes
end

---Returns the main table that defines this class instance.
---@return Class
function Class:GetClassDefinition()
    return self.__ClassDefinition
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Registers a class.
---@generic T
---@param className string|`T`
---@param class table
---@param parentClasses string[]? Classes this one inherits from.
---@return `T`
function OOP.RegisterClass(className, class, parentClasses)
    ---@cast class Class
    
    -- Copy Class methods onto the class definition table
    for k,v in pairs(Class) do
        if type(v) == "function" then
            class[k] = v -- TODO proper inheritance
        end
    end

    ---@diagnostic disable invisible
    class.__ClassDefinition = class
    class.__ParentClasses = parentClasses or {}
    class.__name = class.__name or className

    OOP._Classes[className] = class

    local indexmethod = class.__index
    
    -- Set metatable for static access
    setmetatable(class, {
        __index = function (instance, key)
            -- Check presence in parent classes
            for _,tbl in ipairs(Class.GetParentClasses(class)) do
                if tbl[key] ~= nil then
                    return tbl[key]
                end
            end

            if indexmethod ~= nil then
                return indexmethod(instance, key)
            end
        end,
    })

    ---@diagnostic enable invisible

    return class
end

---Returns the base table for a class.
---@generic T
---@param className `T`
---@return `T`
function OOP.GetClass(className)
    local class = OOP._Classes[className]

    if not class then
        error("Class is not registered: " .. className)
    end

    return class 
end

---Returns whether a table is a class table or instance.
---@param tbl table
---@param className string?
---@return boolean
function OOP.IsClass(tbl, className)
    local isClassed = false
    
    if type(tbl) == "table" then
        if tbl.__name then
            local class = OOP.GetClass(tbl.__name) ~= nil
            local isCorrectClass = className == nil or class.__name == className

            if isCorrectClass then
                isClassed = true
            end
        end
    end

    return isClassed
end

---Sets a table's metatable.
---@param table table Mutated.
---@param metatable table
function OOP.SetMetatable(table, metatable)
    local indexTable = metatable
    if metatable.__index then
        indexTable = function(tbl, key) -- TODO cleaner declaration for classes
            if metatable[key] ~= nil then -- TODO consider multiple inheritance
                return metatable[key]
            else
                return metatable.__index(tbl, key)
            end
        end
    end

    setmetatable(table, {
        __index = indexTable, -- Can't assign `.__index or metatable` because inheriting fields in metatable would break
        __newindex = metatable.__newindex,
        __mode = metatable.__mode,
        __call = metatable.__call,
        __metatable = metatable.__metatable,
        __tostring = metatable.__tostring,
        __len = metatable.__len,
        __pairs = metatable.__pairs,
        __ipairs = metatable.__ipairs,
        __name = metatable.__name,

        __unm = metatable.__unm,
        __add = metatable.__add,
        __sub = metatable.__sub,
        __mul = metatable.__mul,
        __div = metatable.__div,
        __idiv = metatable.__idiv,
        __mod = metatable.__mod,
        __pow = metatable.__pow,
        __concat = metatable.__concat,

        __band = metatable.__band,
        __bor = metatable.__bor,
        __bxor = metatable.__bxor,
        __bnot = metatable.__bnot,
        __shl = metatable.__shl,
        __shr = metatable.__shr,

        __eq = metatable.__eq,
        __lt = metatable.__lt,
        __le = metatable.__le,
    })
end