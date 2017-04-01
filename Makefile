BIN=./bin
SRC=./src

DISK_SRC=${SRC}/Disk

LRP_SRC=${SRC}/LRP

VM_SRC=${SRC}/VM

lpr:
	@cd ${LRP_SRC}/assets/computercraft/lua/ && zip -r *
	@mv ${LRP_SRC}/assets/computercraft/lua/CC-DOS.zip ${BIN}/lpr.zip
	@cp ${BIN}/lpr.zip ${VM_SRC}/lua/sys.zip

vm:
	@cd ${DISK_SRC} && zip -r Disk.zip .
	@mv ${DISK_SRC}/Disk.zip ${VM_SRC}/lua/dos.zip
	@http-server -s ${VM_SRC}