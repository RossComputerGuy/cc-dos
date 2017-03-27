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
    elseif side == "C" then
        return drive
    end
end

local function addDriveSide(side,mnt)
    if side == "hdd" then
        drives[mnt] = Drive("hdd",mnt)
        return drives[mnt]
    else
        if drives["A"].side == side or drives["B"].side == side or drives["C"].side == side then
            return nil
        else
            if disk.isPresent(side) then
                if disk.hasData(side) then
                    drives[mnt] = Drive(side,mnt)
                    return drives[mnt]
                end
            end
        end
    end
    local file = fs.open("C:\\DOS\\.drives","wb")
    file.write(textutils.serialize(drives))
    file.close()
    return nil
end

local function addDrive(mnt)
    local drive = {}
    if mnt == "C" then
        drive = addDriveSide("hdd",mnt)
    else
        stat = addDriveSide("left",mnt)
        if stat not nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("right",mnt)
        if stat not nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("top",mnt)
        if stat not nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("bottom",mnt)
        if stat not nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("front",mnt)
        if stat not nil then
            drive = stat
            return drive
        end
        stat = addDriveSide("back",mnt)
        if stat not nil then
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
    local file = fs.open("C:\\config.sys","r")
    local data = textutils.unserialize(file.readAll())
    file.close()
    return data
end

local function bootstrap()
    os.loadAPI("/DOS/dos")
    local cache_file = fs.open("C:\\DOS\\.cache","wb")
    local cache = {}
    cache.current_drive = "C"
    cache.current_path = "\\"
    cache_file.write(textutils.serialize(cache))
    cache_file.close()
    
    addDrive("A")
    addDrive("B")
    addDrive("C")
    
    local cfg = getConfig()
    
    term.setCursorPos(1,1)
    print(os.version())
    
    if cfg.COMMAND not nil then
        -- TODO: Start command file
        shell.run(cfg.COMMAND)
    else
        shell.run("command.lua")
    end
end

bootstrap()
os.reboot()