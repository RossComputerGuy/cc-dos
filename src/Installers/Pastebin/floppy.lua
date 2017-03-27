-- Variables

local build = {}
local drives = {}

build.dosver = "1.0"
build.gitrepo = "https://github.com/SpaceboyRoss01/cc-dos/raw/master/"

-- Functions

local function addDriveSide(side)
    if disk.isPresent(side) then
        if disk.hasData(side) then
            drives[#drives+1] = disk.getMountPath(side)
            return true
        else
            return false
        end
    end
    return false
end

local function progress(p)
    local prog = p/100
    local w,h = term.getSize()
    local per = "[ "..p.."% ]"
    term.setCursorPos(math.floor(w-string.len(per)),math.floor(h-1)/2)
    term.write(per)
end

term.clear()
term.setCursorPos(1,1)
print("CC-DOS Version "..build.dosver.." Floppy Disk Install Disk Creator")

print("Where is your drive? ")
local x,y = term.getCursorPos()
term.setCursorPos(x+string.len("Where is your drive? "),y-1)
local drive = read()

if addDriveSide(drive) not true then
    print("Could not continue, please run again after adding a floppy drive")
else
    print("Preparing to install...")
    term.clear()
    term.setCursorPos(1,1)
    progress(0)
    -- Creates DOS directory
    disk.setLabel(drive,"CC-DOS_Installer")
    fs.makeDir(disk.getMountPath(drive).."/DOS")
    progress(25)
    
    -- Downloads Startup file
    local startup_http = http.get(build.gitrepo.."src/Disk/startup.lua")
    local startup = fs.open(disk.getMountPath(drive).."/startup","wb")
    startup.write(startup_http.readAll())
    startup_http.close()
    startup.close()
    progress(50)
    
    -- Downloads DOS/dos file
    local dos_http = http.get(build.gitrepo.."src/Disk/DOS/dos")
    local dos = fs.open(disk.getMountPath(drive).."/DOS/dos","wb")
    dos.write(dos_http.readAll())
    dos_http.close()
    dos.close()
    progress(60)
    
    -- Downloads config.sys file
    local cfg_http = http.get(build.gitrepo.."src/Installer/config.sys")
    local cfg = fs.open(disk.getMountPath(drive).."/config.sys","wb")
    cfg.write(cfg_http.readAll())
    cfg_http.close()
    cfg.close()
    progress(75)
    
    -- Downloads command.lua file
    local cmd_http = http.get(build.gitrepo.."src/Installer/command.lua")
    local cmd = fs.open(disk.getMountPath(drive).."/command.lua","wb")
    cmd.write(cmd_http.readAll())
    cmd_http.close()
    cmd.close()
    progress(100)
    
    term.clear()
    term.setCursorPos(1,1)
    print("Done ;)")
end