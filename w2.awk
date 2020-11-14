BEGIN{
	highest_packet_id=0;
	currentTime=previousTime=0
	timetic=0.1
	current_pkid=0
}
{
	event=$1
	time=$3
	packet_id=$41
	if(previousTime==0)
		previousTime=time
	if(event=="s")
	{
		if(packet_id>highest_packet_id)
			highest_packet_id=packet_id;
		if(start_time[packet_id]==0)
			start_time[packet_id]=time;
	}
	else if(event=="r")
	{
		end_time[packet_id]=time;
		currentTime=time-previousTime
		if(currentTime>=timetic)
		{								
		for(packet_id=current_pkid;packet_id<=highest_packet_id;packet_id++)
			{
				start=start_time[packet_id];
				end=end_time[packet_id];
				packet_duration=end-start;
				if(start<end)
					delay+=packet_duration;
			}
			printf("%f %f\n",time,delay);
			currentTime=0
			previousTime=time
			current_pkid=highest_packet_id+1;
			delay=0
		}
	}
	else if(event=="d")
	{
		end_time[packet_id]=-1;
	}
	if($19=="AGT"&&event=="s")
		start_time[packet_id]=$3;
	else if(event=="r")
		end_time[packet_id]=$3;
	else if(event=="d")
		end_time[packet_id]=-1;
}
END{
	printf("\n");
}
