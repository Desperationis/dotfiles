function fish_greeting -d "Greeting message on shell session start up"

	echo ""
	echo  "           (              "			(welcome_message)
	echo  "            )             "
	echo  "           (              "			(show_os_info)	
	echo  "     /\\  .-\"\"\"-.  /\\      "		(show_cpu_cores)
	echo  "    //\\\\/  ,,,  \\//\\\\     "		(show_cpu_processors)
	echo  "    |/\\| ,;;;;;, |/\\|     "		
	echo  "    //\\\\\\;-\"\"\"-;///\\\\     "	(show_ip)
	echo  "   //  \\/   .   \\/  \\\\    "		(show_gateway)
	echo  "  (| ,-_| \\ | / |_-, |)   "			(show_nc_count)
	echo  "    //`__\\.-.-./__`\\\\     "
	echo  "   // /.-(() ())-.\\ \\\\    "
	echo  "  (\\ |)   '---'   (| /)   "
	echo  "   ` (|           |) `    "
	echo  "     \\)           (/      "
	echo ""
end


function welcome_message -d "Say welcome to user"
    set_color brblue
    echo -en "@"
    echo -en (whoami)
    set_color normal

    set --local up_time (uptime | cut -d "," -f1 | cut -d "p" -f2 | sed 's/^ *//g')

    set --local time (echo $up_time | cut -d " " -f2)
    set --local formatted_uptime $time

    switch $time
    case "days" "day"
        set formatted_uptime "$up_time"
    case "min"
        set formatted_uptime $up_time"utes"
    case '*'
        set formatted_uptime "$formatted_uptime hours"
    end

    echo -en " Today is "
    set_color brblue
    echo -en (date +%m/%d/%Y)
    set_color normal
    echo -en ", up for "
    set_color brblue
    echo -en "$formatted_uptime"
    set_color normal
    echo -en "."
end

function show_os_info -d "Prints operating system info"
	set --local os_type (uname -s)
	set --local os_name "$os_type"

	if test "$os_type" = "Linux"
		if test -f /etc/os-release
			# freedesktop.org and systemd
			set --local OS ( bash -c ". /etc/os-release && echo -en \$NAME" )
			set --local VER ( bash -c ". /etc/os-release && echo -en \$VERSION_ID" )
			set os_name $OS $VER
		else if type lsb_release >/dev/null 2>&1
			# linuxbase.org
			set --local OS (lsb_release -si)
			set --local VER (lsb_release -sr)
			set os_name $OS $VER
		else if test -f /etc/lsb-release
			# For some versions of Debian/Ubuntu without lsb_release command
			set --local OS (bash -c ". /etc/lsb-release && echo -en \$DISTRIB_ID")
			set --local VER (bash -c ". /etc/lsb-release && echo -en \$DISTRIB_RELEASE")
			set os_name $OS $VER
		else if test -f /etc/debian_version
			# Older Debian/Ubuntu/etc.
			set --local OS "Debian"
			set --local VER (cat /etc/debian_version)
			set os_name $OS $VER
		else if test -f /etc/SuSe-release
			# Older SuSE/etc.
			set os_name "SuSe"
		else if test -f /etc/redhat-release
			# Older Red Hat, CentOS, etc.
			set os_name "RedHat"
		end
	end

    set_color brmagenta
    echo -en "OS: "
    set_color normal
    echo -en $os_name
end

function show_cpu_cores -d "Prints # of cores"
	set --local os_type (uname -s)
	set --local cores ""

	if test "$os_type" = "Linux"
		set cores (grep "cpu cores" /proc/cpuinfo | head -1 | cut -d ":"  -f2 | tr -d " ")
	else if test "$os_type" = "Darwin"
		set cores (system_profiler SPHardwareDataType | grep "Cores" | cut -d ":" -f2 | tr -d " ")
	end

	set_color brmagenta
	echo -en "CPU Cores: "
	set_color normal
	echo -en "$cores"
end

function show_cpu_processors -d "Prints # of processors"
	set --local os_type (uname -s)
	set --local procs ""

	if test "$os_type" = "Linux"
        set procs (nproc)
	else if test "$os_type" = "Darwin"
        set procs (system_profiler SPHardwareDataType | grep "Number of Processors" | cut -d ":" -f2 | tr -d " ")
	end

	set_color brmagenta
	echo -en "CPU Processors: "
	set_color normal
	echo -en "$procs"
end

function show_cpu_name -d "Prints out CPU name"
	set --local os_type (uname -s)
	set --local cpu_name ""

	if test "$os_type" = "Linux"
        set cpu_name (grep "model name" /proc/cpuinfo | head -1 | cut -d ":" -f2)
	else if test "$os_type" = "Darwin"
        set cpu_name (system_profiler SPHardwareDataType | grep "Processor Name" | cut -d ":" -f2 | tr -d " ")
	end

	set_color brmagenta
	echo -en "CPU: "
	set_color normal
	echo -en "$cpu_name"
end


function show_nc_count -d "Prints out # of network devices"
    set --local os_type (uname -s)
    set --local nc_count ""

	if test "$os_type" = "Linux"
        set nc_count (ip -o link show | wc -l)
    end

    set_color brblack
    echo -en "Network Devices:"
    set_color normal
    echo -en "$nc_count"
end

function show_ip -d "Print out IP of network card"
    set --local os_type (uname -s)
    set --local ip ""

	if test "$os_type" = "Linux"
        set ip (ip address show | grep -E "inet .* brd .* dynamic" | cut -d " " -f6)
	else if test "$os_type" = "Darwin"
        set ip (ifconfig | grep -v "127.0.0.1" | grep "inet " | head -1 | cut -d " " -f2)
    end

    set_color brblack
    echo -en "IP:"
    set_color normal
    echo -en "$ip"
end

function show_gateway -d "Print out default gateway of network card"
    set --local os_type (uname -s)
    set --local gw ""

	if test "$os_type" = "Linux"
        set gw (ip route | grep default | cut -d " " -f3)
	else if test "$os_type" = "Darwin"
        set gw (netstat -nr | grep -E "default.*UGSc" | cut -d " " -f13)
    end

    set_color brblack
    echo -en "Gateway:"
    set_color normal
    echo -en "$gw"
end




if status is-interactive
	if test -d ~/bin 
		fish_add_path ~/bin
		fish_add_path ~/bin/gcc-arm-none-eabi-8-2019-q3-update/bin
	end
    # Commands to run in interactive sessions can go here
end
