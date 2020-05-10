togglereverser = func(eng) {
	if (getprop("controls/engines/engine["~eng~"]/throttle")<0.1) {
		if (getprop("engines/engine["~eng~"]/reverser")) {
			setprop("fdm/jsbsim/propulsion/engine["~eng~"]/reverser-angle-rad", 3.14);
			setprop("engines/engine["~eng~"]/reverser_pos_morm", 1.00);
		} else {
			setprop("fdm/jsbsim/propulsion/engine["~eng~"]/reverser-angle-rad", 0.00);
			setprop("engines/engine["~eng~"]/reverser_pos_norm", 0.00);
		}
	}
}

setlistener("engines/engine[0]/reverser", func{
	togglereverser(0);
}, 0, 0);

setlistener("engines/engine[1]/reverser", func{
	togglereverser(1);
}, 0, 0);

setlistener("engines/engine[2]/reverser", func{
	togglereverser(2);
}, 0, 0);

setlistener("engines/engine[3]/reverser", func{
	togglereverser(3);
}, 0, 0);

setlistener("engines/engine[4]/reverser", func{
	togglereverser(4);
}, 0, 0);

setlistener("engines/engine[5]/reverser", func{
	togglereverser(5);
}, 0, 0);

setlistener("engines/engine[6]/reverser", func{
	togglereverser(6);
}, 0, 0);

setlistener("engines/engine[7]/reverser", func{
	togglereverser(7);
}, 0, 0);
