local function loadApis()
    local apis = fs.list("/CC-DOS/apis/")
    for k,v in pairs(apis) do
        os.loadAPI("/CC-DOS/apis/"..v)
    end
end
local x,y = term.getCursorPos()

term.setCursorPos(x,y+1)
term.write("CC-DOS by Spaceboy_Ross")
term.setCursorPos(x,y+3)

if fs.exists(utils.dosPathToUnixPath("C:\\autoexec.lua")) then
    shell.run(utils.dosPathToUnixPath("C:\\autoexec.lua"))
end

local history = {}

while true do
    print(sys.getcache("sys").current_drive..":\\"..sys.getcache("sys").current_path.."> ")
    local x,y = term.getCursorPos()
    term.setCursorPos(x+string.len(sys.getcache("sys").current_drive..":\\"..sys.getcache("sys").current_path.."> "),y-1)
    local input = read(nil,history)
    history[#history+1] = input
    if string.len(input) > 0 then
        if input == "ls" then
            print("No such program")
        elseif input == "A:" or input == "B:" or input == "C:" then
            sys.cd(input:sub(1,1),"")
        else
            local args = utils.explode(input," ")
            local commands = fs.list(utils.dosPathToUnixPath("C:\\CC-DOS\\commands"))
            local found = false
            for k,v in pairs(commands) do
                if args[1] == v then
                    found = true
                    args[1] = "/CC-DOS/commands/"..args[1]
                    shell.run(table.concat(args," "))
                    break
                end
            end
            if not found then
                shell.run(unpack(args))
            end
        end
    end
end