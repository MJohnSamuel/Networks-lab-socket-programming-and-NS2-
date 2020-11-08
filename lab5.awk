BEGIN{
    TCPSent = 0;
    TCPRecieved = 0;
    TCPLost = 0;
    UDPSent = 0;
    UDPRecieved = 0;
    UDPLost = 0;
    totalSent = 0;
    totalRecieved = 0;
    totalLost = 0;

    m=0.0;
    n=0.0;
    
    curr_pktid = -1;
    curr_delay = 0;
    start_time = 0;
    end_time = 0;
    total_delay = 0;
    total_packets = 0;
    avg_delay = 0.0;
}
{
    packetType = $5
    event = $1
    pktid = $12
    time = $2
    
    
    if(!(pktid in packet_array))
    {
        time_array[pktid,"start"] = time;
        time_array[pktid,"end"] = time;
        packet_array[pktid];
        total_packets++;
    }
    else
    {
        time_array[pktid,"end"] = time;
    }

    if(packetType == "tcp")
    {
        if(event == "+")
        {
            TCPSent++;
        }
        else if(event == "r")
        {
            TCPRecieved++;
        }
        else if(event == "d")
        {
            TCPLost++;
        }
    }
    else if(packetType == "cbr")
    {
        if(event == "+")
        {
            UDPSent++;
        }
        else if(event == "r")
        {
            UDPRecieved++;
        }
        else if(event == "d")
        {
            UDPLost++;
        }
    }
}
END{
# Packet delivery ratio
    totalSent = TCPSent + UDPSent;
    totalLost = TCPLost + UDPLost;
    
    m=(TCPSent/time);
    n=(UDPSent/time)
    printf("Total time taken : %f\n ---------\n",time);
    
    printf("TCP packets sent : %d\n",TCPSent);
    printf("TCP packets recieved : %d\n",TCPRecieved);
    printf("TCP packets dropped: %d\n", TCPLost);
if(TCPSent>0) {
printf("PDR  %d\n", (TCPRecieved/TCPSent)*100);
printf("THROGHPUT %f\n", m); }

    printf("UDP packets sent : %d\n",UDPSent);
    printf("UDP packets recieved : %d\n",UDPRecieved);
    printf("UDP packets dropped: %d\n", UDPLost);
    printf("Total Sent: %d\n",totalSent);
    printf("Total Dropped: %d\n\n",totalLost);
if(UDPSent>0) {
printf("PDR  %d\n", (UDPRecieved/UDPSent)*100);
printf("THROGHPUT %f\n",n);}




# Average delay
    for (i in packet_array)
    {
        curr_delay = time_array[i,"end"] - time_array[i,"start"];
        total_delay += curr_delay;
    }
    avg_delay = total_delay / total_packets;
    printf("Average delay: %f\n",avg_delay);

    

}
