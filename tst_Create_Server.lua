




local function main()


	local function createTcpServer( host, port, backLog )
		--host is ip address or host name, if character "*" then bind to all local interfaces using the INADDR_ANY constant ?
		--port for 1 to 2^16, if 0 will auto chose port
		-- backLog is specifies the number of client connections that can be queued waiting for service. 
				--If the queue is full and another client attempts connection, the connection is refused.
		local coroutine = coroutine
		local socket = require("socket")
		local tcp_master, err = socket.tcp() 
		print(tcp_master: getsockname())

		if err then --error trap
			return nil , err
		end
		
		local res , err = tcp_master:bind( host , port ) -- bind tcp_ser to port of local host or ip address

		if err then 
			print("Cant blind")
			return nil, err
		end

		local res , err = tcp_master:listen( backLog ) --Specifies the socket is willing to receive connections, 
														---transforming the master into a server object

		if err then 
			print("Cant listern")
			return nil, err
		end
		local ip, port = tcp_master:getsockname()
		print("please connect to ip ".. ip .. " and port "..port)
		return tcp_master
	end

	local tcp_ser, err = createTcpServer("*",0,3)
	print( tcp_ser,err )

	local function runTcpServer( srv )
		local stop_server = 0
		local srv = srv

		while stop_server == 0 do print("check")
			srv:settimeout(10)
			local tcp_client , err = srv:accept()
			if err then print("check1")
				stop_server = 1
				break
			else
				local client_msg, err = tcp_client:receive("*1")
				if err then print("check2")
					stop_server = 1
					break
				else
					tcp_client:send( client_msg.."\n")
					tcp_client:close()
				end

			end
		end
		coroutine.yield()
	end

	local co = coroutine.create( runTcpServer )
	print(co)
	coroutine.resume(co,tcp_ser)
	print("end")

end
main()