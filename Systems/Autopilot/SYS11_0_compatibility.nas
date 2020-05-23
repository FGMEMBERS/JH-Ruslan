#### AP buttons in cockpit ####

####################################################################
#                                                                  #
# Some general functions to convert units                          #
#                                                                  #
####################################################################

var initialize=func() {
	#### some things can't be initialized clean from the xml, for example empty strings
	setprop("autopilot/locks/altitude", "");
}

var sync_units_ft=func() {
	var valuetarget=getprop("autopilot/settings/target-altitude-ft");
	if (valuetarget!=nil) {
		setprop("autopilot/settings/target-altitude-m", valuetarget*0.3048);
	}

	var valuemin=getprop("autopilot/internal/min-alt-ft");
	if (valuemin!=nil) {
		setprop("autopilot/internal/min-alt-m", valuemin*0.3048);
	}
}

var sync_units_buffered_ft=func() {
	var valuebuffered=getprop("autopilot/settings/buffered-altitude-ft");
	if (valuebuffered!=nil) {
		setprop("autopilot/settings/buffered-altitude-m", valuebuffered*0.3048);
	}
}

var sync_units_m=func() {
	var valuetarget=getprop("autopilot/settings/target-altitude-m");
	if (valuetarget!=nil) {
		setprop("autopilot/settings/target-altitude-ft", valuetarget/0.3048);
	}

	var valuemin=getprop("autopilot/internal/min-alt-m");
	if (valuemin!=nil) {
		setprop("autopilot/internal/min-alt-ft", valuemin/0.3048);
	}
}

var sync_units_buffered_m=func() {
	var valuebuffered=getprop("autopilot/settings/buffered-altitude-m");
	if (valuebuffered!=nil) {
		setprop("autopilot/settings/buffered-altitude-ft", valuebuffered/0.3048);
	}
}

####################################################################
#                                                                  #
# Switches                                                         #
#                                                                  #
####################################################################

var switchAlt=func() {
	var oldprop=getprop("autopilot/locks/altitude");
	var sysprop=0;
	var newprop="";

	if (oldprop=="altitude-hold") {
		newprop="";
		sysprop=0;
	} else {
		newprop="altitude-hold";
		sysprop=1;
	}

	setprop("autopilot/locks/altitude", newprop);
	setprop("sim/gui/dialogs/autopilot/altitude-active", sysprop);
}

var switchFLCH=func() {
	var oldprop=getprop("autopilot/locks/altitude");
	var sysprop=0;
	var newprop="";

	if (oldprop=="flightlevel-change") {
		newprop="";
		sysprop=0;
	} else {
		newprop="flightlevel-change";
		setprop("autopilot/settings/target-altitude-ft", getprop("autopilot/settings/buffered-altitude-ft"));
		setprop("autopilot/settings/target-altitude-m", getprop("autopilot/settings/buffered-altitude-m"));
		sysprop=1;
	}

	setprop("autopilot/locks/altitude", newprop);
	setprop("sim/gui/dialogs/autopilot/altitude-active", sysprop);
}

var switchFPA=func() {
	var oldprop=getprop("autopilot/locks/altitude");
	var sysprop=0;
	var newprop="";

	if (oldprop=="fpa-hold") {
		newprop="";
		sysprop=0;
	} else {
		newprop="fpa-hold";
		sysprop=1;
	}

	setprop("autopilot/locks/altitude", newprop);
	setprop("sim/gui/dialogs/autopilot/altitude-active", sysprop);
}

var switchVS=func() {
	var oldprop=getprop("autopilot/locks/altitude");
	var sysprop=0;
	var newprop="";

	if (oldprop=="vertical-speed-hold") {
		newprop="";
		sysprop=0;
	} else {
		newprop="vertical-speed-hold";
		sysprop=1;
	}

	setprop("autopilot/locks/altitude", newprop);
	setprop("sim/gui/dialogs/autopilot/altitude-active", sysprop);
}

var switchVNAV=func() {
	var oldprop=getprop("autopilot/locks/altitude");
	var sysprop=0;
	var newprop="";

	if (oldprop=="vertical-nav") {
		newprop="";
		sysprop=0;
	} else {
		newprop="vertical-nav";
		sysprop=1;
	}

	setprop("autopilot/locks/altitude", newprop);
	setprop("sim/gui/dialogs/autopilot/altitude-active", sysprop);
}

var CRS_dir_nav0 = func () {
    setprop("instrumentation/nav[0]/radials/selected-deg",getprop("instrumentation/nav[0]/heading-deg"));
}

var CRS_dir_nav1 = func () {
    setprop("instrumentation/nav[1]/radials/selected-deg",getprop("instrumentation/nav[1]/heading-deg"));
}

var HDG_Sync = func () {
    setprop("autopilot/settings/heading-bug-deg",getprop("orientation/heading-magnetic-deg"));
}

var pitchLimit = func (pitch, low=-9.9, high=9.9) {
    if (pitch < low) { pitch = low;}
    if (pitch > high) { pitch = high;}
    return (pitch);
}

var FPA_Sync = func () {
    var current_pitch = getprop("orientation/pitch-deg");

    #hard Limits for Pitch Sync
    current_pitch = pitchLimit(current_pitch);

    setprop("autopilot/settings/target-pitch-deg",current_pitch);
}

var VSLimit = func (vs, low=-5500, high=5500) {
    if (vs < low) { vs = low;}
    if (vs > high) { vs = high;}
    return (vs);
}

var VS_Sync = func () {
    var current_vs = getprop("velocities/vertical-speed-fps");

    #hard Limits for Pitch Sync
    current_vs = VSLimit(current_vs);

    setprop("autopilot/settings/vertical-speed-fpm",current_vs);
}

####################################################################
#                                                                  #
# ALT functions                                                    #
#                                                                  #
####################################################################

var ALT_min = func (min_agl=1000){

	#### updating minimum altitude
	var current_elev =  getprop("/position/ground-elev-ft");
	if (current_elev == nil) { current_elev = 0;}
	var min_alt_ft = min_agl + current_elev;
	setprop("autopilot/internal/min-alt-ft", min_alt_ft);

	#### control predicted altitude for change from flightlevel-change to altitude-hold
	var mode=getprop("autopilot/locks/altitude");
	var difference=0.00;
	if (mode=="flightlevel-change") {
		difference=abs(getprop("autopilot/settings/target-altitude-ft")-getprop("autopilot/internal/altitude-60-sec-ahead"));
		if (difference<100) {
			#### when near enough to the target altitude, chenge from flightlevel-change to altitude-hold
			setprop("autopilot/locks/altitude", "altitude-hold");
		}
	}
	#### making sure, this is called in 5 seconds again
	settimer (ALT_min, 5);
}

var ALTLimit=func(alt=0) {
	var unit = getprop("autopilot/settings/altitude-unit");
	var min_alt = 1000;
	if (unit=="ft") {
		min_alt=getprop("autopilot/internal/min-alt-ft");
	} else {
		min_alt=getprop("autopilot/internal/min-alt-m");
	}
	if (alt < min_alt) {
		alt = min_alt;
	}
	return(alt);
}

var ALT_Sync = func (alt_set=nil) {
	var unit = getprop("autopilot/settings/altitude-unit");
	if (alt_set==nil) {
		var alt_set = 0;
		if (unit=="ft") {
			alt_set=getprop("position/altitude-ft");
		} else {
			alt_set=getprop("position/altitude-m");
		}
	}
	alt_set = ALTLimit(alt_set);
	if (unit=="ft") {
		setprop("autopilot/settings/buffered-altitude-ft", alt_set);
	} else {
		setprop("autopilot/settings/buffered-altitude-m", alt_set);
	}
}


####################################################################
#                                                                  #
# Speed functions                                                  #
#                                                                  #
####################################################################

var KIASLimit = func (KIAS, low=130, high=320) {
	if (KIAS < low) { KIAS = low;}
	if (KIAS > high) { KIAS = high;}
	return(KIAS);
}

var MachLimit = func (mach, low=0.35, high=0.82) {
	if (mach < low) { mach = low;}
	if (mach > high) { mach = high;}
	return(mach);
}

var SPD_Sync = func () {
	var current_KIAS = getprop("velocities/airspeed-kt");
	var current_MACH = getprop("velocities/mach");
	var current_KIAS_target=getprop("autopilot/settings/target-speed-kt");
	var current_MACH_target=getprop("autopilot/settings/target-speed-mach");

	#LIMIT Speed Set by AP
	current_KIAS = KIASLimit(current_KIAS);
	current_MACH = MachLimit(current_MACH);

	#### this is kind of clumsy, but I need a way to prevent an already set kias value from being overwritten by the current actual speed
	if (current_KIAS_target==nil) {
		setprop("autopilot/settings/target-speed-kt", current_KIAS);
	} else {
		if (current_KIAS>current_KIAS_target) {
			setprop("autopilot/settings/target-speed-kt", current_KIAS);
		}
	}
	if (current_MACH_target==nil) {
		setprop("autopilot/settings/target-speed-mach", current_MACH);
	} else {
		if (current_MACH>current_MACH_target) {
			setprop("autopilot/settings/target-speed-mach", current_MACH);
		}
	}
}

var Speed_Enabled = func (prop="sim/gui/dialogs/autopilot/dialog", path="Dialogs/autopilot9.xml") {
    var ap = gui.Dialog.new (prop, path);
    ap.open();
    ap.close();
}

var AP_Toggle = func () {
	var result="";
	if (getprop("autopilot/settings/ap-armed")){
		#When AP is engaged; then disengage
		setprop("autopilot/settings/ap-armed", "false");
		result="AP off";
	} else {

		#When AP is not engaged; first sync to current condition
		HDG_Sync();
		FPA_Sync();
		VS_Sync();
		ALT_Sync();
		SPD_Sync();
    
		#then engage HDG or FPA by default if no option pre-selected
		#### checking for "" instead of nil because old-school programmers like me make sure things are initialized whenever 			possible
		if (getprop("autopilot/locks/heading")=="") {
			setprop("autopilot/locks/heading","dg-heading-hold");      
		}
		if (getprop("autopilot/locks/altitude")=="") {
			setprop("autopilot/locks/altitude","pitch-hold");
		}

		#Finally engage autopilot
		setprop("autopilot/settings/ap-armed","true");
		result="AP on";
	}
	#### Always go for the defined in and out, never just return away from an if-branch because the 
	#### NASAL interpreter can leave bytes in the internal stack and that can later lead to ominous segment fault errors
	return(result);
}


####################################################################
#                                                                  #
# helpers for the AP since <expressions> are broken                #
#                                                                  #
####################################################################

var target_turn_comp=func() {
	var flaps= getprop("/controls/flight/flaps");
	var turnMin= getprop("/autopilot/settings/turn_gain_min");
	var turnMax=getprop("/autopilot/settings/turn_gain_max");
	var turnCurr=1.00;
	var machSpeed=getprop("/velocities/mach");
	if (flaps>0.01) {
		turnCurr=turnMin;
	} else {
		if (machSpeed<0.5) {
			turnCurr=(turnMax-turnMin)*machSpeed+turnMin;
		} else {
			turnCurr=turnMax;
		}
	}	
	setprop("/autopilot/internal/turn_gain", turnCurr);
	settimer (target_turn_comp, 1);
}

initialize();
#### put all the settimers and setlisteners to the end, makes it easier to find ####
settimer (ALT_min, 5);
settimer (target_turn_comp, 1);
#### those call conversion functions on top of the file
var listener_target_alt_ft = setlistener("autopilot/settings/target-altitude-ft", sync_units_ft, 0, 0);
var listener_target_alt_m = setlistener("autopilot/settings/target-altitude-m", sync_units_m, 0, 0);
var listener_buffered_alt_ft = setlistener("autopilot/settings/buffered-altitude-ft", sync_units_buffered_ft, 0, 0);
var listener_buffered_alt_m = setlistener("autopilot/settings/buffered-altitude-m", sync_units_buffered_m, 0, 0);

