-- Variables

local build = {}

build.dosver = "1.0"
build.gitrepo = "https://github.com/SpaceboyRoss01/cc-dos/raw/master/"

-- Functions

local function progress(p)
    local prog = p/100
    local w,h = term.getSize()
    local per = "[ "..p.."% ]"
    term.setCursorPos(math.floor(w-string.len(per)),math.floor(h-1)/2)
    term.write(per)
end

term.clear()
term.setCursorPos(1,1)
print("CC-DOS Version "..build.dosver.." Installer")

progress(0)

os.setComputerLabel("CC-DOS")
fs.makeDir("/DOS")
progress(25)

local startup_http = http.get(build.gitrepo.."src/Disk/startup.lua")
local startup = fs.open("/startup","wb")
startup.write(startup_http.readAll())
startup_http.close()
startup.close()
progress(50)

local dos_http = http.get(build.gitrepo.."src/Disk/DOS/dos")
local dos = fs.open("/DOS/dos","wb")
dos.write(dos_http.readAll())
dos_http.close()
dos.close()
progress(60)

local cfg_http = http.get(build.gitrepo.."src/Disk/config.sys")
local cfg = fs.open("/config.sys","wb")
cfg.write(cfg_http.readAll())
cfg_http.close()
cfg.close()
progress(75)

local cmd_http = http.get(build.gitrepo.."src/Disk/command.lua")
local cmd = fs.open("/command.lua","wb")
cmd.write(cmd_http.readAll())
cmd_http.close()
cmd.close()
progress(100)

os.reboot()