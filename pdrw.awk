BEGIN {
	sendPkt =0
	recvPkt=0
	forwardPkt=0
	dropPkt=0
	currentTime = previousTime = 0
	timetic=0.1
}

{
packet=$19
event = $1
time=$3
if(previousTime == 0)
	previousTime = time
if(event =="s") {
	sendPkt++;
}

if(event =="r") {
	recvPkt++;
	currentTime = currentTime + (time-previousTime)
	if (currentTime >= timetic) 
	{
		printf ("%f %f \n", time,(sendPkt-dropPkt)*1.0/sendPkt*1.0)
		recvPkt=0
		sendPkt=0
		dropPkt=0
		currentTime=0
	}
	previousTime=time
}

if(event =="f") {
	forwardPkt++;
}
if(event =="d") {
	dropPkt++;
}
}
