# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================


set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    CMUPriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     8                         ;# number of mobilenodes
set val(rp)     DSR                      ;# routing protocol
set val(x)      1500                      ;# X dimension of topography
set val(y)      1000                      ;# Y dimension of topography
set val(stop)   30.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open dsr.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open dsr.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
$ns use-newtrace
set chan [new $val(chan)]


#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -energyModel "EnergyModel" \
                -initialEnergy 4.0 \
                -txPower 31.32e-3 \
                -rxPower 35.28e-3 \
                -idlePower 712e-6 \
                -sleepPower 144e-9 \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 10 nodes
for {set i 0} {$i < $val(nn) } { incr i } {
	set n($i) [$ns node]	
}

# Provide initial location of mobilenodes
$n(0) set X_ 602.0
$n(0) set Y_ 467.0
$n(0) set Z_ 0.0

$n(1) set X_ 748.0
$n(1) set Y_ 557.0
$n(1) set Z_ 0.0

$n(2) set X_ 932.0
$n(2) set Y_ 556.0
$n(2) set Z_ 0.0

$n(3) set X_ 1124.0
$n(3) set Y_ 560.0
$n(3) set Z_ 0.0

$n(4) set X_ 1268.0
$n(4) set Y_ 507.0
$n(4) set Z_ 0.0

$n(5) set X_ 752.0
$n(5) set Y_ 301.0
$n(5) set Z_ 0.0

$n(6) set X_ 960.0
$n(6) set Y_ 300.0
$n(6) set Z_ 0.0

$n(7) set X_ 1189.0
$n(7) set Y_ 291.0
$n(7) set Z_ 0.0

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
$ns initial_node_pos $n($i) 30 ;#30 defines the node size for NAM
}

# Generation of movements
$ns at 20.0 " $n(2) setdest 950.0 950.0 20 "
$ns at 25.0 " $n(2) setdest 932.0 556.0 25 "

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
for {set i 0} {$i < $val(nn)} { incr i } {
	set tcp($i) [new Agent/TCP]
	$ns attach-agent $n($i) $tcp($i)
	
	set sink($i) [new Agent/TCPSink]
	$ns attach-agent $n($i) $sink($i)
}
set tcp(15) [new Agent/TCP]
$ns attach-agent $n(1) $tcp(15)
set sink(15) [new Agent/TCPSink]
$ns attach-agent $n(5) $sink(15)
$ns connect $tcp(15) $sink(15)

set tcp(26) [new Agent/TCP]
$ns attach-agent $n(2) $tcp(26)
set sink(26) [new Agent/TCPSink]
$ns attach-agent $n(6) $sink(26)
$ns connect $tcp(26) $sink(26)

set tcp(37) [new Agent/TCP]
$ns attach-agent $n(3) $tcp(37)
set sink(37) [new Agent/TCPSink]
$ns attach-agent $n(7) $sink(37)
$ns connect $tcp(37) $sink(37)

set tcp(36) [new Agent/TCP]
$ns attach-agent $n(3) $tcp(36)
set sink(36) [new Agent/TCPSink]
$ns attach-agent $n(6) $sink(36)
$ns connect $tcp(36) $sink(36)

$ns connect $tcp(0) $sink(1)
$ns connect $tcp(1) $sink(2)
$ns connect $tcp(2) $sink(3)
$ns connect $tcp(3) $sink(4)
$ns connect $tcp(4) $sink(7)
$ns connect $tcp(7) $sink(6)
$ns connect $tcp(6) $sink(5)
$ns connect $tcp(5) $sink(0)

#Setup a UDP connection
for {set i 0} {$i < $val(nn)} { incr i } {
	set udp($i) [new Agent/UDP]
	$ns attach-agent $n($i) $udp($i)
	
	set null($i) [new Agent/Null]
	$ns attach-agent $n($i) $null($i)
}
set udp(15) [new Agent/UDP]
$ns attach-agent $n(1) $udp(15)
set null(15) [new Agent/Null]
$ns attach-agent $n(5) $null(15)
$ns connect $udp(15) $null(15)

set udp(26) [new Agent/UDP]
$ns attach-agent $n(2) $udp(26)
set null(26) [new Agent/Null]
$ns attach-agent $n(6) $null(26)
$ns connect $udp(26) $null(26)

set udp(37) [new Agent/UDP]
$ns attach-agent $n(3) $udp(37)
set null(37) [new Agent/Null]
$ns attach-agent $n(7) $null(37)
$ns connect $udp(37) $null(37)

set udp(36) [new Agent/UDP]
$ns attach-agent $n(3) $udp(36)
set null(36) [new Agent/Null]
$ns attach-agent $n(6) $null(36)
$ns connect $udp(36) $null(36)

$ns connect $udp(0) $null(1)
$ns connect $udp(1) $null(2)
$ns connect $udp(2) $null(3)
$ns connect $udp(3) $null(4)
$ns connect $udp(4) $null(7)
$ns connect $udp(7) $null(6)
$ns connect $udp(6) $null(5)
$ns connect $udp(5) $null(0)

#===================================
#        Applications Definition        
#===================================
for {set i 0} {$i < $val(nn)} { incr i } {
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
}

set ftp(15) [new Application/FTP]
$ftp(15) attach-agent $tcp(15)

set ftp(26) [new Application/FTP]
$ftp(26) attach-agent $tcp(26)

set ftp(36) [new Application/FTP]
$ftp(36) attach-agent $tcp(36)

set ftp(37) [new Application/FTP]
$ftp(37) attach-agent $tcp(37)

for {set i 0} {$i < $val(nn)} { incr i } {
	set cbr($i) [new Application/Traffic/CBR]
	$cbr($i) attach-agent $udp($i)
}

set cbr(15) [new Application/Traffic/CBR]
$cbr(15) attach-agent $udp(15)

set cbr(26) [new Application/Traffic/CBR]
$cbr(26) attach-agent $udp(26)

set cbr(36) [new Application/Traffic/CBR]
$cbr(36) attach-agent $udp(36)

set cbr(37) [new Application/Traffic/CBR]
$cbr(37) attach-agent $udp(37)

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam dsr.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$n($i) reset"
}

$ns at 0.1 "$ftp(0) start"
$ns at 3.0 "$ftp(0) stop"
$ns at 4.1 "$ftp(1) start"
$ns at 7.0 "$ftp(1) stop"
$ns at 6.1 "$ftp(7) start"
$ns at 9.0 "$ftp(7) stop"
$ns at 10.1 "$ftp(4) start"
$ns at 11.0 "$ftp(4) stop"
$ns at 17.1 "$ftp(3) start"
$ns at 19.0 "$ftp(3) stop"
$ns at 21.1 "$ftp(6) start"
$ns at 24.0 "$ftp(6) stop"
$ns at 25.1 "$ftp(36) start"
$ns at 28.0 "$ftp(36) stop"

$ns at 2.1 "$cbr(2) start"
$ns at 6.0 "$cbr(2) stop"
$ns at 11.1 "$cbr(5) start"
$ns at 17.0 "$cbr(5) stop"
$ns at 16.1 "$cbr(15) start"
$ns at 20.0 "$cbr(15) stop"
$ns at 23.1 "$cbr(37) start"
$ns at 26.0 "$cbr(37) stop"
$ns at 27.1 "$cbr(26) start"
$ns at 29.0 "$cbr(26) stop"

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
