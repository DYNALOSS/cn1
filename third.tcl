set ns [new Simulator]
set tf [open ex3.tr w]
$ns trace-all $tf
set nf [open ex3.nam w]
$ns namtrace-all $nf
set cwind [open cwind3.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 2Mb 2ms DropTail
$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n1 $n4 2Mb 2ms DropTail
$ns duplex-link $n3 $n5 2Mb 2ms DropTail
$ns duplex-link $n4 $n5 2Mb 2ms DropTail

$ns rtproto DV
$ns color 1 Red

set src [new Agent/TCP]
$ns attach-agent $n0 $src
set dst [new Agent/TCPSink]
$ns attach-agent $n4 $dst
$ns connect $src $dst
set app [new Application/FTP]
$app attach-agent $src
$src set fid_ 1

$ns at 0.1 "$app start"
$ns at 0.8 "plotWindow $src $cwind"
$ns rtmodel-at 1 down $n1 $n4
$ns rtmodel-at 3 up $n1 $n4
$ns at 10 "$app stop"
$ns at 10.1 "finish"

proc plotWindow {tcpSrc file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSrc set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSrc $file" }

proc finish {} {
global ns nf tf cwind
$ns flush-trace
close $nf
close $tf 
close $cwind 
exec nam ex3.nam &
exec xgraph cwind3.tr &
exit 0 }

$ns run
