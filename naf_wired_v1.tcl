if 0 {
	argv 0 number of nodes
	argv 1 number of flows # all are random flows
	argv 2 number of packets per seconds
	# I don't need to vary speed of nodes or coverage area as I have wired connection
}

set num_node [lindex $argv 0]
set num_flow [lindex $argv 1]
set cbr_pckt_per_sec [lindex $argv 2]
puts "cbr_pckt_per_sec = $cbr_pckt_per_sec"
set cbr_interval [expr 1.0/$cbr_pckt_per_sec] ;# ?????? 1 for 1 packets per second and 0.1 for 10 
puts "cbr_interval = $cbr_interval "

set tr naf_wired_v1.tr

#Create a simulator object
set ns [new Simulator]

set tracefd [open $tr w]
$ns trace-all $tracefd


#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
	puts "finishing"
        global ns nf tr
        $ns flush-trace
	#Close the trace file
        close $nf
        close $tr
	#Execute nam on the trace file
        exec nam out.nam &
        exit 0
}

#Create node
puts "start node creation"
for {set i 0} {$i < $num_node} {incr i} {
	set node_($i) [$ns node]
}

set j 0
puts "start link creation"
for {set i 1} {$i < $num_node} {incr i} {
	#Create a duplex link between the nodes
	#$node_($i)
	$ns duplex-link $node_($i) $node_($j) 1Mb 10ms DropTail
	incr j
}




puts "creating UDP agents and attaching them to random nodes"
for {set i 0} {$i < $num_flow} {incr i} {
	#create UDP agent
	set udp_($i) [new Agent/UDP]
	puts "UDP agent created"
	
	# select a random source node
	set udp_node [expr int($num_node*rand())] ;# src node
	puts "random src node selected"
	
	# attach UDP agent to source node
	$ns attach-agent $node_($udp_node) $udp_($i)
	puts "attached UDP agent to source node"
	
	# create CBR traffic source	
	set cbr_($i) [new Application/Traffic/CBR]
	#puts "new CBR traffic source created"	
	$cbr_($i) set packetSize_ 500
	#puts "packettSize of CBR traffic agent assigned"
	$cbr_($i) set interval_ $cbr_interval 
	#puts "interval_ of CBR traffic agent is set "
	
	# attaching cbr to UDP agent
	$cbr_($i) attach-agent $udp_($i)
	
	#create a Null agent (a traffic sink)
	set null_($i) [new Agent/Null]		
	#puts "Null agent is created"
	
	# find a destination node randomly which doesn't match with source node
	set null_node $udp_node
	while {$null_node==$udp_node} {
		set null_node [expr int($num_node*rand())] ;# dest node
	}
	#puts "destination node number is assigned"
	
	# attach Null agent to destination node
	$ns attach-agent $node_($null_node) $null_($i)
	#puts "Null agent is attached to destination node"
	
	#Connect the traffic source with the traffic sink
	$ns connect $udp_($i) $null_($i)  
	puts "traffic source is connected with the traffic sink"
	puts ""
	puts ""
	puts ""
}


puts "loop of flow is complete"



#Schedule events for the CBR agent
for {set i 0} {$i < $num_flow} {incr i} {
	$ns at 0.5 "$cbr_($i) start"
	$ns at 4.5 "$cbr_($i) stop"
}
puts "scheduling loop is complete"




#Call the finish procedure after 5 seconds of simulation time
	$ns at 5.0 "finish"	


#Run the simulation
puts "Going to run the simulation"
$ns run
