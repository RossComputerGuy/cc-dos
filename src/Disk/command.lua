os.loadAPI("/DOS/dos")
local x,y = term.getCursorPos()

function explode(inputstr,sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

term.setCursorPos(x,y+1)
term.write("CC-DOS by Spaceboy_Ross")
term.setCursorPos(x,y+3)

while true do
    print(dos.getCurrentDrive().mount..":\\"..dos.getCurrentPath().."> ")
    local x,y = term.getCursorPos()
    term.setCursorPos(x+string.len(dos.getCurrentDrive().mount..":\\"..dos.getCurrentPath().."> "),y-1)
    local input = read()
    if string.len(input) > 0 then
        local x,y = term.getCursorPos()
        term.setCursorPos(x,y+1)
        if input == "ls" then
            print("No such program")
        elseif input == "ver" then
            print(os.version())
        elseif input == "A:" or input == "B:" or input == "C:" then
            dos.changeDrive(input[1])
        else
            local args = explode(input," ")
            shell.run(unpack(args))
        end
        local x,y = term.getCursorPos()
        term.setCursorPos(x,y+1)
    end
end