-- Super Mario Bros. script by 4matsy.
-- 2008, September 11th.
--Displays the # of lives for Mario and a HP meter for Bowswer

require("shapedefs");
require("osc.client");

local flag_msg = {'/mario/flag', 'i', 0}
local coin_msg = {'/mario/coin', 'i', 0}
local speed_msg = {'/mario/speed', 'i', 0}
local oscclient = osc.client.new{host = '10.211.55.2', port = 9001} --57120}

local is_flagged = 0
local last_coin = memory.readbyte(0x075e)
local last_speed = memory.readbyte(0x0057)

function text(x,y,str)
	if (x > 0 and x < 255 and y > 0 and y < 240) then
		gui.text(x,y,str);
	end;
end;

while (true) do

	-- print player's lives...I always thought this was a major omission of the status bar :p
	text(63,13,"x"..memory.readbyte(0x075a)+1);
	if (last_coin ~= memory.readbyte(0x075e)) then
		coin_msg[3] = memory.readbyte(0x075e)
		last_coin = memory.readbyte(0x075e)
		oscclient:send(coin_msg);
	end;
	if (memory.readbyte(0x070f) > 0 and is_flagged == 0) then
		flag_msg[3] = memory.readbyte(0x070f)
		is_flagged = 1;
		oscclient:send(flag_msg);
	end;
	if (memory.readbyte(0x070f) == 0 and is_flagged == 1) then
		is_flagged = 0;
	end;
	if (memory.readbyte(0x0057) ~= last_speed) then
		speed_msg[3] = memory.readbyte(0x0057)
		last_speed = memory.readbyte(0x0057)
		oscclient:send(speed_msg)
	end;
	FCEU.frameadvance();
end;
