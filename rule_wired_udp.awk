BEGIN {

# Initialization. Set two variables. fsDrops: packets drop. numFs: packets sent

	fsDrops = 0;

	numFs = 0;
	max_node = 2000;
	nSentPackets = 0.0 ;		
	nReceivedPackets = 0.0 ;
	rTotalDelay = 0.0 ;
	max_pckt = 10000;

	rTotalDelay = 0.0 ;
	max_pckt = 10000;

	

	idHighestPacket = 0;
	idLowestPacket = 100000;
	rStartTime = 10000.0;
	rEndTime = 0.0;
	nReceivedBytes = 0;
	

	nDropPackets = 0.0;

	

	temp = 0;
	
	
	total_retransmit = 0;
	for (i=0; i<max_pckt; i++) {
		retransmit[i] = 0;		
	}

}

{

	action = $1;

	time = $2;

	from = $3;

	to = $4;

	type = $5;

	pktsize = $6;

	flow_id = $8;

	src = $9;

	dst = $10;

	seq_no = $11;

	packet_id = $12;
	
	if ( action=="s" )
	{
		nSentPackets += 1 ;	rSentTime[ packet_id ] = time ;
	}
	
	if ( action=="r" )
	{
		nReceivedPackets += 1; 
		nReceivedBytes += pktsize;
		
		rReceivedTime[ packet_id ] = time ;
		rDelay[packet_id] = rReceivedTime[ packet_id] - rSentTime[ packet_id ];
#			rTotalDelay += rReceivedTime[ idPacket] - rSentTime[ idPacket ];
		rTotalDelay += rDelay[packet_id]; 
	}
	
	if ( action== "d" )
	{
		nDropPackets += 1;
	}



}
