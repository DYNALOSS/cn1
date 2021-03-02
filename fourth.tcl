set ns [new Simulator]
set tf [open ex4.tr w]
$ns trace-all $tf
set nf [open ex4.nam w]
$ns namtrace-all $nf

set server [$ns node]
set client [$ns node]
$server label "server"
$client label "client"
$ns color 1 Blue

$ns duplex-link $client $server 10Mb 22ms DropTail
set src [new Agent/TCP]
$ns attach-agent $server $src
set dst [new Agent/TCPSink]
$ns attach-agent $client $dst
$ns connect $src $dst
set app [new Application/FTP]
$app attach-agent $src
$src set fid_ 1
$src set packetSize_ 1500

$ns at 0.1 "$app start"
$ns at 15 "$app stop"
$ns at 15.2 "finish"

proc finish {} {
global ns tf nf
$ns flush-trace
close $nf 
close $tf 
exec nam ex4.nam &
exit 0 }

$ns run

