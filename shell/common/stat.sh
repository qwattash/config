source ~/git/config/term/colors.sh

# Mem statistics
MemTot=$(cat /proc/meminfo | grep "MemTotal" | cut -d":" -f2 | sed -r "s/[ \t]+([0-9]+) ?kB/\1/")
MemAvail=$(cat /proc/meminfo | grep "MemAvail" | cut -d":" -f2 | sed -r "s/[ \t]+([0-9]+) ?kB/\1/")
MemUsed=$((${MemTot} - ${MemAvail}))
MemPercent=$((${MemUsed} * 100 / ${MemTot}))

# Fs statistics
FsRootTot=$(df -h | grep "/$" | sed -n "s/ \+/ /gp" | cut -d" " -f4)
FsRootUsed=$(df -h | grep "/$" | sed -n "s/ \+/ /gp" | cut -d" " -f3)
FsRootPercent=$(df -h | grep "/$" | sed -n "s/ \+/ /gp" | cut -d" " -f5)
FsHomeTot=$(df -h | grep "/home$" | sed -n "s/ \+/ /gp" | cut -d" " -f4)
FsHomeUsed=$(df -h | grep "/home$" | sed -n "s/ \+/ /gp" | cut -d" " -f3)
FsHomePercent=$(df -h | grep "/home$" | sed -n "s/ \+/ /gp" | cut -d" " -f5)

# Process statistics
ProcNo=$(pidstat | wc -l)

# battery
# percent value
BatPerc=$(acpi | sed "s/,//g" | cut -d " " -f4 | sed "s/%//g")
# charging / discharging
BatSt=$(acpi | sed "s/,//g" | cut -d " " -f3)
# remaining time
BatEst=$(acpi | sed "s/,//g" | cut -d " " -f5)

# color of battery status
if [[ "${BatSt}" == "Discharging" ]]; then 
    BatSCol=${LRed}
else 
    BatSCol=${LGreen}
fi
# color of battery level
if [[ "${BatPerc}" -lt "30" ]]; then
    BatLCol=${LRed}
else
    BatLCol=${LGreen}
fi

User=$(whoami)
Host=$(uname -n)
Kernel=$(uname -r)
Cpu=$(cat /proc/cpuinfo | grep "model name" | uniq | cut -d':' -f2)
Arch=$(uname -m)

FsRootString="${LGreen}${FsRootUsed}${LGray}/${DGreen}${FsRootTot} ${Purple}${FsRootPercent}"
FsHomeString="${LGreen}${FsHomeUsed}${LGray}/${DGreen}${FsHomeTot} ${Purple}${FsHomePercent}"
MemString="${LGreen}${MemUsed}K${LGray}/${DGreen}${MemTot}K ${Purple}${MemPercent}%"
BatString="${BatLCol}${BatPerc}% ${Purple}${BatEst} ${BatSCol}${BatSt}"

function build_stat_widget() {
echo -ne "\
${LGray}+----------------------------------------------------------+  
${LGray}|
${LGray}|    ${Brown}User: ${Purple}${User}
${LGray}|    ${Brown}Host: ${Purple}${Host}
${LGray}|    ${Brown}Kernel: ${Purple}${Kernel} ${Arch}
${LGray}|
${LGray}|    ${Brown}System: ${Purple}${Cpu}
${LGray}|
${LGray}|    ${Brown}/: ${FsRootString}
${LGray}|    ${Brown}/home: ${FsHomeString}
${LGray}|
${LGray}|
${LGray}|    ${Brown}Procs: ${Purple}${ProcNo}
${LGray}|    ${Brown}Mem: ${MemString}
${LGray}|
${LGray}|
${LGray}|
${LGray}|    ${Brown}Battery: ${BatString}
${LGray}|
${LGray}+----------------------------------------------------------+"
}
