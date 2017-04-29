if 0 {
	argv 0 number of nodes
	argv 1 number of flows # all are random flows
	argv 2 number of packets per seconds
	# I don't need to vary speed of nodes as I have static
	argv 3 coverage area (multiple of Tx will be input) (Tx will be hard coded)
}


	
################################################################802.11 in Grid topology with cross folw
set cbr_size 64 ; 
set cbr_rate 200.0kb
set cbr_pckt_per_sec [lindex $argv 2]
set cbr_interval [expr 1.0/$cbr_pckt_per_sec] ;# ?????? 1 for 1 packets per second and 0.1 for 10 packets per second
#set cbr_interval 0.00005 ; #[expr 1/[lindex $argv 2]] ;# ?????? 1 for 1 packets per second and 0.1 for 10 packets per second
set num_row [lindex $argv 0] ;#number of row
set num_col [lindex $argv 0] ;#number of column
set Tx_multiple [lindex $argv 3]
set time_duration 3 ; #[lindex $argv 5] ;#50
set start_time 50 ;#100
set parallel_start_gap 0.0
set cross_start_gap 0.0
set num_node [lindex $argv 0]
set num_total_flow [lindex $argv 1]

#################################
#variable for internal use
set rt 0 ; # This is for agent count
set r 0 ; # This is for connection count

#############################################################ENERGY PARAMETERS
set val(energymodel_11)    EnergyModel     ;
set val(initialenergy_11)  1000            ;# Initial energy in Joules

set val(idlepower_11) 869.4e-3			;#LEAP (802.11g) 
set val(rxpower_11) 1560.6e-3			;#LEAP (802.11g)
set val(txpower_11) 1679.4e-3			;#LEAP (802.11g)
set val(sleeppower_11) 37.8e-3			;#LEAP (802.11g)
set val(transitionpower_11) 176.695e-3		;#LEAP (802.11g)	??????????????????????????????/
set val(transitiontime_11) 2.36			;#LEAP (802.11g)

#set val(idlepower_11) 900e-3			;#Stargate (802.11b) 
#set val(rxpower_11) 925e-3			;#Stargate (802.11b)
#set val(txpower_11) 1425e-3			;#Stargate (802.11b)
#set val(sleeppower_11) 300e-3			;#Stargate (802.11b)
#set val(transitionpower_11) 200e-3		;#Stargate (802.11b)	??????????????????????????????/
#set val(transitiontime_11) 3			;#Stargate (802.11b)

set val(nn) $num_node

############################  Varying nodes giving error
#set val(x) $x_dim
#set val(y) $y_dim
############# Upper two lines was added to avoid error. Suggestion is from internet





#puts "$MAC/802_11.dataRate_"
Mac/802_15_4 set syncFlag_ 1
Mac/802_15_4 set dataRate_ 11Mb
Mac/802_15_4 set dutyCycle_ cbr_interval


########  Lines from Tareq
set dist(5m)  7.69113e-06
set dist(9m)  2.37381e-06
set dist(10m) 1.92278e-06
set dist(11m) 1.58908e-06
set dist(12m) 1.33527e-06
set dist(13m) 1.13774e-06
set dist(14m) 9.81011e-07
set dist(15m) 8.54570e-07
set dist(16m) 7.51087e-07
set dist(20m) 4.80696e-07
set dist(25m) 3.07645e-07
set dist(30m) 2.13643e-07
set dist(35m) 1.56962e-07
set dist(40m) 1.20174e-07
Phy/WirelessPhy/802_15_4 set CSThresh_ $dist(40m)
Phy/WirelessPhy/802_15_4 set RXThresh_ $dist(40m)
Phy/WirelessPhy/802_15_4 set TXThresh_ $dist(40m)

#########  Lines from Tareq ended



set Tx 40
set x_dim [expr $Tx_multiple*$Tx] ; #150 ; #[lindex $argv 1]
set y_dim [expr $Tx_multiple*$Tx] ; # 150 ; #[lindex $argv 1]

set dx [expr $x_dim/$num_node]
set dy [expr $y_dim/$num_node]



#CHNG
set num_parallel_flow 0 ;#[lindex $argv 0]	# along column
set num_cross_flow 0 ;#[lindex $argv 0]		#along row
set num_random_flow $num_total_flow
set num_sink_flow [expr $num_row*$num_col] ;#sink
set sink_node 100 ;#sink id, dummy here; updated next

set grid 0
set extra_time 10 ;#10

#set tcp_src Agent/TCP/Vegas ;# Agent/TCP or Agent/TCP/Reno or Agent/TCP/Newreno or Agent/TCP/FullTcp/Sack or Agent/TCP/Vegas
#set tcp_sink Agent/TCPSink ;# Agent/TCPSink or Agent/TCPSink/Sack1

set tcp_src Agent/UDP
set tcp_sink Agent/Null


# TAHOE:	Agent/TCP		Agent/TCPSink
# RENO:		Agent/TCP/Reno		Agent/TCPSink
# NEWRENO:	Agent/TCP/Newreno	Agent/TCPSink
# SACK: 	Agent/TCP/FullTcp/Sack	Agent/TCPSink/Sack1
# VEGAS:	Agent/TCP/Vegas		Agent/TCPSink
# FACK:		Agent/TCP/Fack		Agent/TCPSink
# LINUX:	Agent/TCP/Linux		Agent/TCPSink

#	http://research.cens.ucla.edu/people/estrin/resources/conferences/2007may-Stathopoulos-Lukac-Dual_Radio.pdf

#set frequency_ 2.461e+9
#Phy/WirelessPhy set Rb_ 11*1e6            ;# Bandwidth
#Phy/WirelessPhy set freq_ $frequency_



set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
#set val(prop) Propagation/FreeSpace ;# radio-propagation model
set val(netif) Phy/WirelessPhy/802_15_4 ;# network interface type
set val(mac) Mac/802_15_4 ;# MAC type
#set val(mac) SMac/802_15_4 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 500 ;# max packet in ifq
set val(rp) DSDV ; #[lindex $argv 4] ;# routing protocol



set nm naf_wireless_802_15_4_static_v1.nam
set tr naf_wireless_802_15_4_static_v1.tr
set topo_file naf_wireless_802_15_4_static_v1.txt

#set topo_file 5.txt
# 
# Initialize ns
#
set ns_ [new Simulator]

set tracefd [open $tr w]
$ns_ trace-all $tracefd

#$ns_ use-newtrace ;# use the new wireless trace file format

set namtrace [open $nm w]
#$ns_ namtrace-all-wireless $namtrace $x_dim $y_dim

#set topofilename "topo_ex3.txt"
set topofile [open $topo_file "w"]

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $x_dim $y_dim
#$topo load_flatgrid 1000 1000


if {$num_sink_flow > 0} { ;#sink
	create-god [expr $num_row * $num_col + 1 ]
} else {
	create-god [expr $num_row * $num_col ]
}

#remove-all-packet-headers
#add-packet-header DSDV AODV ARP LL MAC CBR IP



#set val(prop)		Propagation/TwoRayGround
#set prop	[new $val(prop)]



create-god $val(nn)

$ns_ node-config -adhocRouting $val(rp) -llType $val(ll) \
     -macType $val(mac)  -ifqType $val(ifq) \
     -ifqLen $val(ifqlen) -antType $val(ant) \
     -propType $val(prop) -phyType $val(netif) \
     -channel  [new $val(chan)] -topoInstance $topo \
     -agentTrace ON -routerTrace OFF\
     -macTrace ON \
     -movementTrace OFF \
			 -energyModel $val(energymodel_11) \
			 -idlePower $val(idlepower_11) \
			 -rxPower $val(rxpower_11) \
			 -txPower $val(txpower_11) \
          		 -sleepPower $val(sleeppower_11) \
          		 -transitionPower $val(transitionpower_11) \
			 -transitionTime $val(transitiontime_11) \
			 -initialEnergy $val(initialenergy_11)


#          		 -transitionTime 0.005 \
 

puts "start node creation"
for {set i 0} {$i < $num_node} {incr i} {
	set node_($i) [$ns_ node]
#	$node_($i) random-motion 0
}

puts "start assigning co-ordinates to nodes"
for {set i 0} {$i < $num_node} {incr i} {
	set x_pos [expr int($dx * $i)] ;#random settings
	set y_pos [expr int($dy * $i)] ;#random settings
	
	puts "$i $x_pos $y_pos"
	puts ""
	
	$node_($i) set X_ $x_pos;
	$node_($i) set Y_ $y_pos;
	$node_($i) set Z_ 0.0
}
puts "assigned co-ordinates to nodes"


puts "creating agents.. both source and sink types"
for {set i 0} {$i < [expr $num_parallel_flow + $num_cross_flow + $num_random_flow  + $num_sink_flow]} {incr i} { ;#sink
#    set udp_($i) [new Agent/UDP]
#    set null_($i) [new Agent/Null]

	set udp_($i) [new $tcp_src]
	$udp_($i) set class_ $i
	set null_($i) [new $tcp_sink]
	$udp_($i) set fid_ $i
	if { [expr $i%2] == 0} {
		$ns_ color $i Blue
	} else {
		$ns_ color $i Red
	}

} 
puts "Agent creation complete"


#######################################################################RANDOM FLOW
# in fact this is the only flow in my file
set num_flows_created 0
set rt $num_flows_created
for {set i 0} {$i < $num_random_flow} {incr i} {
	set udp_node [expr int($num_node*rand())] ;# src node
	set null_node $udp_node
	while {$null_node==$udp_node} {
		set null_node [expr int($num_node*rand())] ;# dest node
	}
	puts "$udp_node $null_node"
	puts ""
	$ns_ attach-agent $node_($udp_node) $udp_($rt)
  	$ns_ attach-agent $node_($null_node) $null_($rt)
	puts -nonewline $topofile "RANDOM:  Src: $udp_node Dest: $null_node\n"
	incr rt
}

puts "Agents attached to nodes"

set rt $num_flows_created
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	$ns_ connect $udp_($rt) $null_($rt)
	incr rt
}

puts "source and sink agents connected"


set rt $num_flows_created
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	set cbr_($rt) [new Application/Traffic/CBR]
	$cbr_($rt) set packetSize_ $cbr_size
	$cbr_($rt) set rate_ $cbr_rate
	$cbr_($rt) set interval_ $cbr_interval
	$cbr_($rt) attach-agent $udp_($rt)
	incr rt
} 

puts "created cbr and attached them to source agents"

set rt $num_flows_created
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	$ns_ at [expr $start_time] "$cbr_($rt) start"
	incr rt
}
puts "fixed start time for each cbr"

puts "flow creation complete"

##########################################################################END OF FLOW GENERATION

# Tell nodes when the simulation ends
#
for {set i 0} {$i < $num_node } {incr i} {
    $ns_ at [expr $start_time+$time_duration] "$node_($i) reset";
}
$ns_ at [expr $start_time+$time_duration +$extra_time] "finish"

$ns_ at [expr $start_time+$time_duration +$extra_time] "$ns_ nam-end-wireless [$ns_ now]; puts \"NS Exiting...\"; $ns_ halt"

$ns_ at [expr $start_time+$time_duration/2] "puts \"half of the simulation is finished\""
$ns_ at [expr $start_time+$time_duration] "puts \"end of simulation duration\""

proc finish {} {
	puts "finishing"
	global ns_ tracefd namtrace topofile nm
	#global ns_ topofile
	$ns_ flush-trace
	close $tracefd
	close $namtrace
	close $topofile
#        exec nam $nm &
        exit 0
}


for {set i 0} {$i < $num_node  } { incr i} {
	####  can't understand the use of the following line
	$ns_ initial_node_pos $node_($i) 4
	####  can't understand the use of the preceding line
}

puts "Starting Simulation..."
$ns_ run 
