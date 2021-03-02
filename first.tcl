set ns [new Simulator]
set tf [open ex1.tr w]
$ns trace-all $tf
set nf [open ex1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 10ms DropTail
$ns queue-limit $n1 $n2 5

set tcpsrc [new Agent/TCP]
$ns attach-agent $n0 $tcpsrc
set tcpdst [new Agent/TCPSink]
$ns attach-agent $n3 $tcpdst
$ns connect $tcpsrc $tcpdst
set app1 [new Application/FTP]
$app1 attach-agent $tcpsrc

set udpsrc [new Agent/UDP]
$ns attach-agent $n1 $udpsrc
set udpdst  [new Agent/Null]
$ns attach-agent $n3 $udpdst
$ns connect $udpsrc $udpdst
set app2 [new Application/Traffic/CBR]
$app2 attach-agent $udpsrc

$ns at 0.1 "$app1 start"
$ns at 0.2 "$app2 start"
$ns at 10 "finish"

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf
exec nam ex1.nam &
exit 0 }

$ns run
