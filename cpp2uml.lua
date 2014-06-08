#!/usr/bin/lua
function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '\n['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '}\n '
	else
		return tostring(o)
	end
end

function toUML(classTable)
	local plantUMLString = "class "..classTable.baseClass.."\n"
	for k,v in ipairs(classTable.motherClass) do
		plantUMLString = plantUMLString..(v.." <|-- "..classTable.baseClass).."\n"
	end

	for k,v in ipairs(classTable.attribute) do
		plantUMLString = plantUMLString..(classTable.baseClass.." : "..v).."\n"
	end

	for k,v in ipairs(classTable.method) do
		plantUMLString = plantUMLString..(classTable.baseClass.." : "..v).."\n"
	end
	
	return plantUMLString
end

print("@startuml")
print("skinparam classAttributeIconSize 0")
for headerFile in io.input():lines() do
	if headerFile:match(".h$") then
		local file_ = io.open(headerFile)
		local file = file_:read("*a")
		file_:close()
		local classIt = file:gmatch("(.-):")
		file = file:gsub("::","_"):gsub("#endif",":"):gsub("enum.-;","")
		local class = {}
		class.motherClass = {}
		class.method = {}
		class.attribute = {}

		file = file:gsub("};",":")
		local classPattern = "class%s+([%w%s:_,]-)%s*{"
		local classHead = file:match(classPattern)
		file = file:gsub("class "..classHead,"",1)
		local baseClass, motherClass = classHead:match("(%w+)%s*:%s*([%s,%w]+)")
		if motherClass then
			class.baseClass = baseClass
			motherClass = motherClass:gmatch("(public%s+%w+)")
			class.motherClass = {}
			for mother in motherClass do
				local motherClassName = mother:gsub("public%s+","")
				table.insert(class.motherClass,motherClassName)
			end
		else
			class.baseClass = classHead
		end

		local classIt = file:gmatch("(.-):")
		for chunk in classIt do
			chunk = chunk:gsub("//.-\n%s",""):gsub("/\*.*\*/",""):gsub("^#.*$","")
			for member in chunk:gmatch("%s(.-)[;|{]}?%s") do
				local trimedMember = member:gsub("^%s*",""):gsub("\n%s*"," ")
				if member:match("%(") then
					table.insert(class.method,trimedMember)
				elseif trimedMember ~= "" then
					table.insert(class.attribute,trimedMember)
				end
			end
		end
--		print(dump(class))
		print(toUML(class))
	end
end
print("@enduml")

