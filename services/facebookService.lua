local facebook = require( "facebook")
local json = require ("json")

require "readFile"

local fbAppID = "439199716214544"
local imageLink = "http://s3.postimg.org/6j3z3delv/Facebook_Photo.png"
-- fb secret key c09025958c8c56ebdbbdda72d1d4beb5

local platformName = system.getInfo( "platformName" )
local getDevice

if (platformName == "iPhone OS") then
	getDevice = "iOS"
elseif (platformName == "Android") then
	getDevice = "Android"
else
	getDevice = "Unknown"
end


facebookService = {}

function facebookService:new(score)
	local service = {}

	function service:networkCheck()
		-- checking internet connection
		local http = require("socket.http")
		local ltn12 = require("ltn12")

		if http.request( "http://www.google.com") == nil  then
		        native.showAlert( "Your device is not connected to the internet", "Please check again your internet connection.", { "Exit" }, print( "Internet connection is not available" ) )
			return false
		end

		print( "Internet connection success!" )
		return true
	end

	function service:userCheck()
		-- if connected to the internet
		local connection = self:networkCheck()

		if (connection) then
			local user = loadTable("userdata.json", system.DocumentsDirectory)
			if (user) then
				service:facebookLogin(1)
			else
				print( "Unknown user!" )
				-- Add listener to alert
				local function callback ( event )
				    if "clicked" == event.action then
				        if 1 == event.index then
				            service:facebookLogin(0)
				            timer.performWithDelay( 300, function() service:facebookLogin(1) end )
				        end
				    end
				end

				native.showAlert( "", "You have to authorize Endless to publish a post on your Facebook wall.", {"OK", "Later"}, callback )
			end
		end
	end


	function service:facebookLogin(command)
		print( "facebookLogin " .. command )

		-- if (command ==  0) then -- login or share
			native.setActivityIndicator( true )
		-- end

		-- debugging function
		local function printTable(t, label, level)
			if label then print( label ) end
			level = level or 1

			if t then
				for k,v in pairs( t ) do
					local prefix = ""
					for i=1,level do
						prefix = prefix .. "\t"
					end

					print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
					if type( v ) == "table" then
						print( prefix .. "{" )
						printTable( v, nil, level + 1 )
						print( prefix .. "}" )
					end
				end
			end
		end

		-- facebook listener
		local function facebookListener(event)
			-- Debug event parameters printout
			print( "Facebook listener events:" )

			local maxStr = 20
			local endStr

			for k,v in pairs(event) do
				local valueString = tostring(v)
				if (string.len(valueString) > maxStr) then
					endStr = "... #" .. tostring(string.len(valueString)) .. ")"
				else
					endStr = ")"
				end
				print( "   " .. tostring(k) .. "(" .. tostring(string.sub(valueString, 1, maxStr)) .. endStr )
			end
			-- end of debug event routine
			print( "event.name:", event.name )
			print( "event.type:", event.type)
			print( "isError:" .. tostring(event.isError) )
			print( "didComplete:" .. tostring(event.didComplete) )

			-- login phase (even if the app is already logged in, we will still get a "login" phase)
			if ("session" == event.type) then
				print( "Session status: " .. event.phase )

				if (event.phase ~= "login") then -- exit if login error
					return
				end

				-- Various facebook commands
				if (command == 0) then -- request user information
					print( "*** Requesting user information..." )
					facebook.request( "me" )
				elseif (command == 1) then -- share score
					print("*** Share score...")
					local attachment = {
						name = "Endless words" .. tostring(score),
						link = "http://v3.senja.co.uk/",
						caption = "Endless caption.",
						description = "Endless short desc",
						picture = imageLink,
						actions = json.encode( { { name = "About Developer", link = "http://v3.senja.co.uk/" } } )
					}

					facebook.request( "me/feed", "POST", attachment )
				end

			elseif ("request" == event.type) then
				local response = event.response

				if (not event.isError) then
					response = json.decode( event.response )

					if (command == 0) then -- getting Facebook name
						print( "getting facebook details" )
						local saveUserData = saveTable("userdata.json", system.DocumentsDirectory, event.response)

					elseif (command == 1) then -- posting photo
						printTable(response, "photo", 3)
						print( "*** Uploading post to Facebook..." )

						native.setActivityIndicator( false )
						native.showAlert( "Endless", "Your score has been published.", {"OK"} )
					else
						print( "Unknown Facebook command response" )
					end
				else -- failed post
					printTable(event.response, "Post failed response", 3)
				end

			elseif ("dialog" == event.type) then
				print( "dialog response:", event.response )
			end
		end

		if (command == 0) then
			facebook.login( fbAppID, facebookListener, {"publish_actions, user_games_activity"})
		else
			facebook.login(fbAppID, facebookListener)			
		end
	end

	service:userCheck()
end
