-- CC-DOS v1.0

local drives = {}

-- Functions

local function Drive(side,mnt)
    local drive = {}
    if disk.isPresent(side) then
        drive.label = disk.getLabel(side)
    elseif mnt == "C" then
        drive.label = "CC-DOS"
    end
    
    if disk.isPresent(side) then
        drive.id = disk.getID(side)
    end
    
    if disk.isPresent(side) then
        drive.free_mem = fs.getFreeSpace(disk.getMountPath(side))
    elseif mnt == "C" then
        drive.free_mem = fs.getFreeSpace("/")
    end
    
    if disk.isPresent(side) then
        drive.path = disk.getMountPath(side)
    elseif mnt == "C" then
        drive.path = "/"
    end
    
    if disk.isPresent(side) then
        return drive
    elseif mnt == "C" then
        return drive
    end
end

local function addDriveSide(side,mnt)
    local d = nil
    if side == "hdd" then
        drives[mnt] = Drive("hdd",mnt)
        d = drives[mnt]
    else
        if not drives["A"] == nil or not drives["B"] == nil or not drives["C"] == nil then
            if drives["A"].side == side or drives["B"].side == side or drives["C"].side == side then
                return nil
            end
        else
            if disk.isPresent(side) then
                if disk.hasData(side) then
                    drives[mnt] = Drive(side,mnt)
                    d = drives[mnt]
                end
            end
        end
    end
    local file = fs.open("DOS/.drives","w")
    file.write(textutils.serialize(drives))
    file.close()
    return d
end

local function addDrive(mnt)
    local drive = false
    if mnt == "C" then
        drive = addDriveSide("hdd",mnt)
        if drive == nil then
        	return false
        else
        	return drive
        end
    else
        stat = addDriveSide("left",mnt)
        if not stat == nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("right",mnt)
        if not stat == nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("top",mnt)
        if not stat == nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("bottom",mnt)
        if not stat == nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("front",mnt)
        if not stat == nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("back",mnt)
        if not stat == nil then
            drive = stat
            return drive
        end
    end
    return drive
end

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

local function getConfig()
    local file = fs.dosOpen("C:\\config.sys","r")
    local data = textutils.unserialize(file.readAll())
    file.close()
    return data
end

local function bootstrap()
    for k,v in pairs(shell.aliases()) do
        shell.clearAlias(k)
    end
    os.loadAPI("/DOS/dos")
    local cache_file = fs.dosOpen("C:\\DOS\\.cache","w")
    local cache = {}
    cache.current_drive = "C"
    cache.current_path = ""
    cache.drive_type = "hdd"
    cache_file.write(textutils.serialize(cache))
    cache_file.close()
    
    term.setCursorPos(1,1)
    print(os.version())
    
    term.setCursorPos(1,3)
    
    if addDrive("A") == false then
    	print("Drive A is disabled")
    end
    
    if addDrive("B") == false then
    	print("Drive B is disabled")
    end
    
    if addDrive("C") == false then
    	print("Drive C is disabled")
    end
    
    local cfg = getConfig()
    
    if not cfg.COMMAND == nil then
        shell.run(cfg.COMMAND)
    else
        shell.run("command.lua")
    end
end

bootstrap()
os.reboot()