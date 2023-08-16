#!/bin/bash
# nMonit Scipt for ASUSWRT (BusyBox) Router
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
agent_version="6.1"
POST="$POST{agent_version}$agent_version{/agent_version}"
POST="$POST{serverkey}xxxx{/serverkey}"
POST="$POST{gatewaydomain.tld/agent.php{/gateway}"
hostname=$(hostname)
POST="$POST{hostname}$hostname{/hostname}"
kernel=$(uname -r)
POST="$POST{kernel}$kernel{/kernel}"
time=$(date +%s)
POST="$POST{time}$time{/time}"
POST="$POST{os}ASUSWRT{/os}"
os_arch=$(uname -m)
POST="$POST{os_arch}$os_arch{/os_arch}"
cpu_model=$(cat /proc/cpuinfo | grep 'system type' | awk -F\: '{print $2}')
POST="$POST{cpu_model}$cpu_model{/cpu_model}"
cpu_cores=$(cat /proc/cpuinfo | grep processor | wc -l)
POST="$POST{cpu_cores}$cpu_cores{/cpu_cores}"
POST="$POST{cpu_speed}{/cpu_speed}"
cpu_load=$(cat /proc/loadavg | awk '{print $1","$2","$3}')
POST="$POST{cpu_load}$cpu_load{/cpu_load}"
cpu_info=$(grep -i cpu /proc/stat | awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11";"}' | tr -d '\n')
POST="$POST{cpu_info}$cpu_info{/cpu_info}"
cpu_info_current=$(grep -i cpu /proc/stat | awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11";"}' | tr -d '\n')
POST="$POST{cpu_info_current}$cpu_info_current{/cpu_info_current}"
disks=$(df | grep '^/' | awk '{print $1","$2","$3","$4","$5","$6","$7";"}' | tr -d '\n')
POST="$POST{disks}$disks{/disks}"
disks_inodes=$(df | grep '^/' | awk '{print $1","$2","$3","$4","$5","$6";"}' | tr -d '\n')
POST="$POST{disks_inodes}$disks_inodes{/disks_inodes}"
file_descriptors=$(cat /proc/sys/fs/file-nr | awk '{print $1","$2","$3}')
POST="$POST{file_descriptors}$file_descriptors{/file_descriptors}"
ram_total=$(free | awk 'FNR == 2 {print $2}')
POST="$POST{ram_total}$ram_total{/ram_total}"
ram_free=$(free | awk 'FNR == 2 {print $4}')
POST="$POST{ram_free}$ram_free{/ram_free}"
ram_caches=$(free | awk 'FNR == 2 {print $6}')
POST="$POST{ram_caches}$ram_caches{/ram_caches}"
ram_buffers=$(cat /proc/meminfo | grep ^Buffers: | awk '{print $2}')
POST="$POST{ram_buffers}$ram_buffers{/ram_buffers}"
ram_usage=$(free | awk 'FNR == 2 {print $3}')
POST="$POST{ram_usage}$ram_usage{/ram_usage}"
swap_total=$(cat /proc/meminfo | grep ^SwapTotal: | awk '{print $2}')
POST="$POST{swap_total}$swap_total{/swap_total}"
swap_free=$(cat /proc/meminfo | grep ^SwapFree: | awk '{print $2}')
POST="$POST{swap_free}$swap_free{/swap_free}"
swap_usage=$(($swap_total-$swap_free))
POST="$POST{swap_usage}$swap_usage{/swap_usage}"
default_interface=$(defaultInterface)
POST="$POST{default_interface}router0{/default_interface}"
all_interfaces=$(tail -n +3 /proc/net/dev | tr ":" " " | awk '{print $1","$2","$10","$3","$11";"}' | tr -d ':' | tr -d '\n')
POST="$POST{all_interfaces}$all_interfaces{/all_interfaces}"
all_interfaces_current=$(tail -n +3 /proc/net/dev | tr ":" " " | awk '{print $1","$2","$10","$3","$11";"}' | tr -d ':' | tr -d '\n')
POST="$POST{all_interfaces_current}$all_interfaces_current{/all_interfaces_current}"
ipv4_addresses=$(ip -f inet -o addr show | awk '{split($4,a,"/"); print $2","a[1]";"}' | tr -d '\n')
POST="$POST{ipv4_addresses}$ipv4_addresses{/ipv4_addresses}"
ipv6_addresses=$(ip -f inet6 -o addr show | awk '{split($4,a,"/"); print $2","a[1]";"}' | tr -d '\n')
POST="$POST{ipv6_addresses}$ipv6_addresses{/ipv6_addresses}"
active_connections=$(netstat -tun | tail -n +3 | wc -l)
POST="$POST{active_connections}$active_connections{/active_connections}"
ping_latency=$(ping -c 1 google.com | sed -n 's/.*time=\([[:digit:]]*\).*/\1/p')
POST="$POST{ping_latency}$ping_latency{/ping_latency}"
ssh_sessions=$(who | wc -l)
POST="$POST{ssh_sessions}$ssh_sessions{/ssh_sessions}"
uptime=$(cat /proc/uptime | awk '{print $1}')
POST="$POST{uptime}$uptime{/uptime}"
processes=$(ps -e -o pid,ppid,rss,vsz,uname,pmem,pcpu,comm,cmd --sort=-pcpu,-pmem | awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9";"}' | tr -d '\n')
POST="$POST{processes}$processes{/processes}"
POST="$POST{mdadm}{/mdadm}"
wget --no-check-certificate --post-data "data=$POST" http://url.to/agent.php
rm agent.php
unset POST
