#!/usr/bin/lua
print("@startuml")
local method = {}
local attribute = {}
for index,headerFile in ipairs(arg) do
	if headerFile:match(".h$") then
		local file_ = io.open(headerFile)
		local file = file_:read("*a")
		file_:close()
		file = file:gsub("::","_"):gsub("#endif",":")
		local classIt = file:gmatch("(.-):")

		local classPattern = "class[%s]+([%w%s:_,]-)[%s]*{"
		local classHead = file:match(classPattern)

		local baseClass, motherClass = classHead:match("(%w+)%s+:%s+([%s,%w]+)")
		if motherClass then
			motherClass = motherClass:gmatch("(public%s+%w+)")

			for mother in motherClass do
				print("\t"..mother:gsub("public%s+","").." <|-- "..baseClass)
			end
		else
			print("\t"..(baseClass or ""))
		end

		for chunk in classIt do
			chunk = chunk:gsub("//.-\n%s",""):gsub("/\*.*\*/","")
			for member in chunk:gmatch("%s(.-);%s") do
				if member:match("%(") then
					print("method: ", member)
--					table.insert(method,member)
				else
					print("attribute: ",member)
--					table.insert(attribute,member)
				end
			end
		end
	end
end
--print("method:")
--for k,v in pairs(method) do
--	print(v)
--end
--print("\nattribute: ")
--for k,v in pairs(attribute) do
--	print(v)
--end
print("@enduml")
