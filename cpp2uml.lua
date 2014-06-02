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
	local plantUMLString = ""
	for k,v in ipairs(classTable.motherClass) do
		plantUMLString = plantUMLString..(v.." <|-- "..classTable.baseClass)
	end
	return plantUMLString
end

print("@startuml")

for index,headerFile in ipairs(arg) do
	if headerFile:match(".h$") then
		local file_ = io.open(headerFile)
		local file = file_:read("*a")
		file_:close()
		file = file:gsub("::","_"):gsub("#endif",":")
		local class = {}
		class.method = {}
		class.attribute = {}

		local classIt = file:gmatch("(.-):")
		local classPattern = "class[%s]+([%w%s:_,]-)[%s]*{"
		local classHead = file:match(classPattern)

		local baseClass, motherClass = classHead:match("(%w+)%s+:%s+([%s,%w]+)")
		if motherClass then
			class.baseClass = baseClass
			motherClass = motherClass:gmatch("(public%s+%w+)")
			class.motherClass = {}
			for mother in motherClass do
				local motherClassName = mother:gsub("public%s+","")
				table.insert(class.motherClass,motherClassName)
			end
		else
			if baseClass then
				table.baseClass = baseClass
			end
		end

		for chunk in classIt do
			chunk = chunk:gsub("//.-\n%s",""):gsub("/\*.*\*/","")
			for member in chunk:gmatch("%s(.-);%s") do
				local trimedMember = member:gsub("^%s*","")
				if member:match("%(") then
					table.insert(class.method,trimedMember)
				else
					table.insert(class.attribute,trimedMember)
				end
			end
		end
--		print(dump(class))
		print(toUML(class))
	end
end
print("@enduml")

