output_file="final_sum.txt"
for_graph_x="for_graph_x.txt"
for_graph_y="for_graph_y.txt"
for_graph_xy="for_graph_xy.txt"

array_num_node=(20 40 60 80 100)
array_flow=(10 20 30 40 50)
array_num_pack_per_sec=(100 200 300 400 500)
array_con_mul=(1 2 3 4 5)
array_var=("${array_num_node[@]}") 

echo "" > $output_file
echo "" > $for_graph_xy

iteration_float=5.0;

start=0
end=4

iteration=$(printf %.0f $iteration_float);

r=$start

while [ $r -le $end ]
do
echo "total iteration: $iteration"
###############################START A ROUND
l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;

i=0
while [ $i -lt $iteration ]
do
#################START AN ITERATION
echo "                             EXECUTING $(($i+1)) th ITERATION"


#                            CHNG PATH		1		######################################################
ns naf_wired_v1.tcl "${array_var[$r]}" 30 300  # $dist_11 $pckt_size $pckt_per_sec $routing $time_sim
echo "SIMULATION COMPLETE. BUILDING STAT......"
#awk -f rule_th_del_enr_tcp.awk 802_11_grid_tcp_with_energy_random_traffic.tr > math_model1.out
#                            CHNG PATH		2		######################################################
awk -f rule_wired_udp.awk naf_wired_v1.tr > awkOut.txt
echo "awk file completed it work......"
ok=1;
while read val
do
#	l=$(($l+$inc))
	l=$(($l+1))


	if [ "$l" == "1" ]; then
		# This if statement was causing error
		#if [ `echo "if($val > 0.0) 1; if($val <= 0.0) 0" | bc` -eq 0 ]; then
			#ok=0;
			#break
			#fi	
		thr=$(echo "scale=5; $thr+$val/$iteration_float" | bc)
#		echo -ne "throughput: $thr "
	elif [ "$l" == "2" ]; then
		del=$(echo "scale=5; $del+$val/$iteration_float" | bc)
#		echo -ne "delay: "
	elif [ "$l" == "9999" ]; then
		s_packet=$(echo "scale=5; $s_packet+$val/$iteration_float" | bc)
#		echo -ne "send packet: "
	elif [ "$l" == "9999" ]; then
		r_packet=$(echo "scale=5; $r_packet+$val/$iteration_float" | bc)
#		echo -ne "received packet: "
	elif [ "$l" == "5" ]; then
		d_packet=$(echo "scale=5; $d_packet+$val/$iteration_float" | bc)
#		echo -ne "drop packet: "
	elif [ "$l" == "3" ]; then
		del_ratio=$(echo "scale=5; $del_ratio+$val/$iteration_float" | bc)
#		echo -ne "delivery ratio: "
	elif [ "$l" == "4" ]; then
		dr_ratio=$(echo "scale=5; $dr_ratio+$val/$iteration_float" | bc)
#		echo -ne "drop ratio: "
	elif [ "$l" == "8" ]; then
		time=$(echo "scale=5; $time+$val/$iteration_float" | bc)
#		echo -ne "time: "
	elif [ "$l" == "9" ]; then
		t_energy=$(echo "scale=5; $t_energy+$val/$iteration_float" | bc)
#		echo -ne "total_energy: "
	elif [ "$l" == "10" ]; then
		energy_bit=$(echo "scale=5; $energy_bit+$val/$iteration_float" | bc)
#		echo -ne "energy_per_bit: "
	elif [ "$l" == "11" ]; then
		energy_byte=$(echo "scale=5; $energy_byte+$val/$iteration_float" | bc)
#		echo -ne "energy_per_byte: "
	elif [ "$l" == "12" ]; then
		energy_packet=$(echo "scale=5; $energy_packet+$val/$iteration_float" | bc)
#		echo -ne "energy_per_packet: "
	elif [ "$l" == "13" ]; then
		total_retransmit=$(echo "scale=5; $total_retransmit+$val/$iteration_float" | bc)
#		echo -ne "total_retrnsmit: "
	elif [ "$l" == "14" ]; then
		energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$iteration_float" | bc)
#		echo -ne "energy_efficiency: "
	fi


	echo "$val"
#                            CHNG PATH		3		######################################################
done < awkOut.txt

if [ "$ok" -eq "0" ]; then
	l=0;
	ok=1;
	continue
	fi
i=$(($i+1))
l=0
#################END AN ITERATION
done

enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

#dir="/home/ubuntu/ns2\ programs/raw_data/"
#tdir="/home/ubuntu/ns2\ programs/multi-radio\ random\ topology/"
#                            CHNG PATH		4		######################################################
dir="/home/ubuntu/ns2_data/multi_radio_random_topology/"
under="_"
#output_file="$dir$output_file_format$under$r$under$r.out"
output_file="final_sum.txt"



#echo "Before comment" >> $output_file

: <<'END'

echo -ne "Throughput:          $thr " >> $output_file
echo -ne "AverageDelay:         $del " >> $output_file
echo -ne "Sent Packets:         $s_packet " >> $output_file
echo -ne "Received Packets:         $r_packet " >> $output_file
echo -ne "Dropped Packets:         $d_packet " >> $output_file
echo -ne "PacketDeliveryRatio:      $del_ratio " >> $output_file
echo -ne "PacketDropRatio:      $dr_ratio " >> $output_file
echo -ne "Total time:  $time " >> $output_file
echo -ne "" >> $output_file
echo -ne "" >> $output_file
echo -ne "Total energy consumption:        $t_energy " >> $output_file
echo -ne "Average Energy per bit:         $energy_bit " >> $output_file
echo -ne "Average Energy per byte:         $energy_byte " >> $output_file
echo -ne "Average energy per packet:         $energy_packet " >> $output_file
echo -ne "total_retransmit:         $total_retransmit " >> $output_file
echo -ne "energy_efficiency(nj/bit):         $enr_nj " >> $output_file
echo "" >> $output_file


END


#echo "After comment" >> $output_file

echo "${array_var[$r]}" >> $output_file


echo "Throughput:          $thr " >> $output_file
echo "AverageDelay:         $del " >> $output_file
echo "PacketDeliveryRatio:      $del_ratio " >> $output_file
echo "PacketDropRatio:      $dr_ratio " >> $output_file
#echo "Total energy consumption:        $t_energy " >> $output_file
echo "" >> $output_file

#Now these echos are for generating graph
echo "${array_var[$r]} $dr_ratio" >> $for_graph_xy


r=$(($r+1))
idx=$(($idx+1))
#######################################END A ROUND
done


xgraph "$for_graph_xy"

