#!/usr/bin/lua
print("@startuml")
for index,headerFile in ipairs(arg) do
	if headerFile:match(".h$") then
		local file = io.open(headerFile):read("*a")

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
	end
end
print("@enduml")
