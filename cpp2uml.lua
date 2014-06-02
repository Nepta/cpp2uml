#!/usr/bin/lua
function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
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
--				print("\t"..mother:gsub("public%s+","").." <|-- "..baseClass)
				local motherClassName = mother:gsub("public%s+","")
				table.insert(class.motherClass,motherClassName)
			end
		else
			if baseClass then
--				print("\t"..(baseClass or ""))
				table.baseClass = baseClass
			end
		end

		for chunk in classIt do
			chunk = chunk:gsub("//.-\n%s",""):gsub("/\*.*\*/","")
			for member in chunk:gmatch("%s(.-);%s") do
				if member:match("%(") then
--					print("method: ", member)
					table.insert(class.method,member)
				else
--					print("attribute: ",member)
					table.insert(class.attribute,member)
				end
			end
		end
		print(dump(class))
	end
end
print("@enduml")

