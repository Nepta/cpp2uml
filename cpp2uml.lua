#!/usr/bin/lua
local files = arg[1]
--for k,v in ipairs(arg) do
--	print(k,v)
--end
print("@startuml")

local file = io.open(files):read("*a")

local classPattern = "class[%s]+([%w%s:_,]-)[%s]+{"
local classHead = file:match(classPattern)

local baseClass, motherClass = classHead:match("(%w+)%s+:%s+([%s,%w]+)")
motherClass = motherClass:gmatch("(public%s+%w+)")

for mother in motherClass do
	print("\t"..mother:gsub("public%s+","").." <|-- "..baseClass)
end

print("@enduml")
