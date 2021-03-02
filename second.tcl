set ns [new Simulator]
set tf [open ex2.tr w]
$ns trace-all $tf
set nf [open ex2.nam w]
$ns namtrace-all $nf
set cwind [open cwind2.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 0.4Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 2ms DropTail
$ns duplex-link $n4 $n6 2Mb 2ms DropTail

$ns color 1 Red
$ns color 2 Blue

set src1 [new Agent/TCP]
$ns attach-agent $n1 $src1
set dst1 [new Agent/TCPSink]
$ns attach-agent $n6 $dst1
$ns connect $src1 $dst1
set app1 [new Application/FTP]
$app1 attach-agent $src1
$src1 set fid_ 1

set src2 [new Agent/TCP]
$ns attach-agent $n2 $src2
set dst2 [new Agent/TCPSink]
$ns attach-agent $n5 $dst2
$ns connect $src2 $dst2
set app2 [new Application/Telnet]
$app2 attach-agent $src2
$src2 set fid_ 2

$ns at 0.1 "$app1 start"
$ns at 0.2 "$app2 start"
$ns at 0.3 "plotWindow $src1 $cwind"
$ns at 0.4 "plotWindow $src2 $cwind"
$ns at 10 "finish"

proc plotWindow {tcpSrc file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSrc set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSrc $file" }

proc finish {} {
global ns tf nf cwind
$ns flush-trace
close $tf
close $nf
close $cwind
exec nam ex2.nam &
exec xgraph cwind2.tr &
exit 0 }
$ns run
