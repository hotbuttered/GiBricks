-- https://github.com/ar2rsawseen/dataSaver.git

module("dataSaver", package.seeall)

if not json then
	require "json"
end

function saveValue(key, value)
	--temp variable
	local app
	--default data storage
	local path = "|D|app.txt"
	--open file
	local file = io.open(path, "r")
	if file then
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		--Decode json
		app = json.decode(contents)
		io.close( file )	-- close the file after using it
		--if file was empty
		if(not app.data) then
			app.data = {}
		end
		--store value in table
		app.data[key] = value
		--Encode table to json
		contents = json.encode(app)
		--open file
		local file = io.open( path, "w" )
		--store Json string in file
		file:write( contents )
		--close file
		io.close( file )
	else
		--if file doesn't exist
		--create default structure
		app = {data = {}}
		--store value
		app.data[key] = value
		--Encode in Json
		local contents = json.encode(app)
		--create file
		local file = io.open( path, "w" )
		--save Json string in file
		file:write( contents )
		--close file
		io.close( file )
	end
end
function loadValue(key)
	--temp variable
	local app
	local path = "|D|app.txt"
	--open file
	local file = io.open( path, "r" )
	if file then
		--read contents
		local contents = file:read( "*a" )
		--Decode Json
		app = json.decode(contents)
		if(not app.data) then app.data = {}; end
		--close file
		io.close( file )
		--return value
		return app.data[key]
	end
	--if doesn't exist
	return nil
end
function save( filename, dataTable )
	local path = filename..".json"
	--Encode table into Json string
	local JsonString = json.encode( dataTable )
	-- io.open opens a file at path. Creates one if doesn't exist
	local file = io.open( path, "w" )
	if file then
		--write Json string into file
	   file:write( JsonString )
	   -- close the file after using it
	   io.close( file )
	end
end

function load( filename )
	local path = filename..".json"

	-- will hold contents of file
	local contents

	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
		-- read all contents of file into a string
		contents = file:read( "*a" )
		-- close the file after using it
		io.close( file )
		--return Decoded Json string
		return json.decode( contents )
	else
		--or return nil if file didn't ex
		return nil
	end
end

