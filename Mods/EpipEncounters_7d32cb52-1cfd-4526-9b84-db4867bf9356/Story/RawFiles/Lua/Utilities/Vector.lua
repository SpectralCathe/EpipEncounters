
---@class VectorLib : Library
---@field zero2 Vector Shorthand for Vector.Create(0, 0)
---@field zero3 Vector Shorthand for Vector.Create(0, 0, 0)
---@operator call:Vector Equivalent to Vector.Create()
Vector = {}
Epip.InitializeLibrary("Vector", Vector)
setmetatable(Vector, {
    __index = function(self, key)
        if key == "zero2" then
            return Vector.Create(0, 0)
        elseif key == "zero3" then
            return Vector.Create(0, 0, 0)
        else
            return getmetatable(self)[key]
        end
    end,
    __call = function(...) -- Shorthand for creating vectors.
        return Vector.Create(...)
    end,
})

---------------------------------------------
-- VECTOR TABLE
---------------------------------------------

---@alias Vector2 Vector
---@alias Vector2D Vector
---@alias Vector3 Vector
---@alias Vector3D Vector
---@alias Vector4 Vector

---@class Vector
---@field Arity integer Getter. Equivalent to #self.
---@field Length number Getter. Equivalent to Vector.GetLength()
---@field unpack fun(self:Vector):...number Equivalent to table.unpack(self)
---@operator add(Vector):Vector Equivalent to Vector.Sum()
---@operator mul(Vector):number Equivalent to Vector.DotProduct()
---@operator sub(Vector):Vector Equivalent to Vector.Subtract()
---@operator unm:Vector Equivalent to Vector.Negate()
local _Vector = {
    __index = function(self, key)
        -- Alternative way to fetch arity.
        if key == "Arity" then
            return #self
        elseif key == "unpack" then
            return function(vector)
                return table.unpack(vector)
            end
        elseif key == "Length" then
            return Vector.GetLength(self)
        end
    end,
    __add = function(self, v) return Vector.Sum(self, v) end,
    __sub = function(self, v) return Vector.Subtract(self, v) end,
    __mul = function(self, v) return Vector.DotProduct(self, v) end,
    __unm = function(self) return Vector.Negate(self) end,
}

---------------------------------------------
-- METHODS
---------------------------------------------

---Creates a vector of variable length.
---@vararg number|table If using tables, provide one parameter only.
---@return Vector
function Vector.Create(...)
    local vector = {...} ---@type Vector

    -- Unpack table. Only first param is considered in this case.
    if #vector == 1 and type(vector[1]) == "table" then
        vector = {table.unpack(vector[1])}
    end

    setmetatable(vector, _Vector)

    return vector
end

---Performs a dot product between two vectors of the same dimensions.
---@param v1 Vector
---@param v2 Vector
---@return number
function Vector.DotProduct(v1, v2)
    if v1.Arity ~= v2.Arity then Vector:Error("DotProduct", "Vector dimension mismatch") end

    local value = 0

    for i=1,#v1,1 do
        value = value + v1[i] * v2[i]
    end

    return value
end

---Performs a scalar product of a vector, multiplying each of its components.
---@param v Vector
---@param scalar number
---@return Vector
function Vector.ScalarProduct(v, scalar)
    local output = Vector.Clone(v)

    for i=1,#v,1 do
        output[i] = v[1] * scalar
    end

    return output
end

---Sums the components of two vectors of the same dimensions.
---@param v1 Vector
---@param v2 Vector
---@return Vector
function Vector.Sum(v1, v2)
    if v1.Arity ~= v2.Arity then Vector:Error("Sum", "Vector dimension mismatch") end

    local v = Vector.Clone(v1)

    for i=1,#v1,1 do
        v[i] = v1[i] + v2[i]
    end

    return v
end

---Subtracts the components of two vectors of the same dimension.
---@param v1 Vector
---@param v2 Vector
---@return Vector
function Vector.Subtract(v1, v2)
    return Vector.Sum(v1, Vector.Negate(v2))
end

---@param v Vector
---@return Vector
function Vector.Negate(v)
    v = Vector.Clone(v)

    for i=1,#v,1 do
        v[i] = -v[i]
    end

    return v
end

---@param vector Vector
---@return Vector
function Vector.Clone(vector)
    local values = {}

    for i=1,#vector,1 do
        table.insert(values, vector[i])
    end

    return Vector.Create(table.unpack(values))
end 

---@param vector Vector
---@return Vector New instance; does not mutate.
function Vector.GetNormalized(vector)
    vector = Vector.Clone(vector)
    local length = vector.Length

    for i=1,#vector,1 do
        vector[i] = vector[i] / length
    end

    return vector
end

---@param vector Vector
---@return number
function Vector.GetLength(vector)
    local length = 0

    for i=1,#vector,1 do
        length = length + vector[i] ^ 2
    end

    length = math.sqrt(length)

    return length
end