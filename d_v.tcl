set ns [new Simulator]
#File openings
set traceFile [open out.tr w]
$ns trace-all $traceFile


#NAM trace file
set namFile [open out.nam w]
$ns namtrace-all $namFile


proc finish {} {
global ns traceFile namFile
$ns flush-trace
close $traceFile
close $namFile
exec nam out.nam &
exit 0
}

$ns rtproto DV   


#Create Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$n0 color red
$n4 color yellow

#Create node links
$ns duplex-link $n0 $n2 20Mb 10ms DropTail
$ns duplex-link $n0 $n1 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 20Mb 10ms DropTail
$ns duplex-link $n3 $n4 20Mb 10ms DropTail
$ns duplex-link $n0 $n3 20Mb 10ms DropTail
$ns duplex-link $n1 $n4 20Mb 10ms DropTail
$ns duplex-link $n0 $n4 20Mb 10ms DropTail
$ns duplex-link $n1 $n3 20Mb 10ms DropTail
$ns duplex-link $n2 $n3 20Mb 10ms DropTail
$ns duplex-link $n2 $n4 20Mb 10ms DropTail

#UDP Connection node1 to node7 [Agent+NULL]
set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n4 $null1
$ns connect $udp1 $null1
$udp1 set fid_ 1

#CBR over UDP node1 to node7
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 500
$cbr1 set rate_ 1.5Mb

#Time slots + Launch
$ns at 0.5 "$cbr1 start"

$ns rtmodel-at 2.0 down $n0 $n4
$ns rtmodel-at 5.0 up $n0 $n4


$ns at 9.0 "finish"
$ns run


