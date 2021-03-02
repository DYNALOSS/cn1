set ns [new Simulator -multicast on]
set tf [open ex5.tr w]
$ns trace-all $tf
set nf [open ex5.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns color 1 Red
$ns color 2 Blue

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n3 $n5 2Mb 2ms DropTail
set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

set group1 [Node allocaddr]
set group2 [Node allocaddr]

set src1 [new Agent/UDP]
$ns attach-agent $n0 $src1
$src1 set fid_ 1
$src1 set dst_addr_ $group1
$src1 set dst_port_ 0
set app1 [new Application/Traffic/CBR]
$app1 attach-agent $src1

set src2 [new Agent/UDP]
$ns attach-agent $n1 $src2
$src2 set fid_ 2
$src2 set dst_addr_ $group2
$src2 set dst_port_ 0
set app2 [new Application/Traffic/CBR]
$app2 attach-agent $src2

set dst2 [new Agent/Null]
$ns attach-agent $n2 $dst2
set dst3 [new Agent/Null]
$ns attach-agent $n3 $dst3
set dst4 [new Agent/Null]
$ns attach-agent $n4 $dst4
set dst5 [new Agent/Null]
$ns attach-agent $n5 $dst5

$ns at 0.1 "$app1 start"
$ns at 0.15 "$app2 start"
$ns at 0.2 "$n2 join-group $dst2 $group1"
$ns at 0.25 "$n3 join-group $dst3 $group2"
$ns at 0.3 "$n4 join-group $dst4 $group1"
$ns at 0.31 "$n5 join-group $dst5 $group2"
$ns at 0.5 "$n4 leave-group $dst4 $group1"
$ns at 0.51 "$n5 leave-group $dst5 $group2"
$ns at 0.6 "$n3 leave-group $dst3 $group2"
$ns at 0.61 "$n2 leave-group $dst2 $group1"
$ns at 0.65 "$app1 stop"
$ns at 0.65 "$app2 stop"
$ns at 0.66 "finish"

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf 
close $nf 
exec nam ex5.nam &
exit 0 }

$ns run
