# Liveries
aircraft.livery.init("Aircraft/Ruslan-JSB/Models/Liveries");

# Listener for nose wheel steering
setlistener("controls/gear/nosegear-steering-enabled", func() {
	if (getprop("controls/gear/nosegear-steering-enabled")) {
		setprop("controls/gear/nosegear-angle", 45.0);
		setprop("controls/gear/maingear-angle", 22.5);
	} else {
		setprop("controls/gear/nosegear-angle", 8.0);
		setprop("controls/gear/maingear-angle", 0.0);
	}
},0,0);

var weathercontrol=func{
	var heading=getprop("/orientation/heading-deg");
	var wind=getprop("/environment/wind-from-heading-deg");
	var result=(wind-heading);
	if (result<0) {
		result=360+result;
	}
	if (result>360) {
		result=result-360;
	}
	setprop("/voodoomaster/weather/relative-wind", result);
	settimer(weathercontrol, 2);
}

var enginecontrol=func{
	var eng0ff=getprop("/fdm/jsbsim/propulsion/engine[0]/fuel-flow-rate-pps");
	var eng1ff=getprop("/fdm/jsbsim/propulsion/engine[1]/fuel-flow-rate-pps");
	var eng2ff=getprop("/fdm/jsbsim/propulsion/engine[2]/fuel-flow-rate-pps");
	var eng3ff=getprop("/fdm/jsbsim/propulsion/engine[3]/fuel-flow-rate-pps");
	var eng4ff=getprop("/fdm/jsbsim/propulsion/engine[4]/fuel-flow-rate-pps");
	var eng5ff=getprop("/fdm/jsbsim/propulsion/engine[5]/fuel-flow-rate-pps");
	var eng6ff=getprop("/fdm/jsbsim/propulsion/engine[6]/fuel-flow-rate-pps");
	var eng7ff=getprop("/fdm/jsbsim/propulsion/engine[7]/fuel-flow-rate-pps");

	var fftotal=eng0ff+eng1ff+eng2ff+eng3ff+eng4ff+eng5ff+eng6ff+eng7ff;
	if (fftotal>0.00) {
		var seconds=getprop("/fdm/jsbsim/propulsion/total-fuel-lbs")/fftotal;
		var hours=seconds/3600;
		var range=hours*getprop("/instrumentation/gps/indicated-ground-speed-kt");
		setprop("/voodoomaster/engines/fuel_flow_total_pps", fftotal);
		setprop("/voodoomaster/engines/airtime", hours);
		setprop("/voodoomaster/engines/range_nm", range);
	}
	settimer(enginecontrol, 2);
}

var routecontrol=func{
	if (getprop("/autopilot/route-manager/active")) {
		# we have an active route, rebuild display
		var i=0;
		var o=getprop("/autopilot/route-manager/current-wp")-5;
		for (i=0; i<11; i=i+1) {
			if (((i+o)<getprop("/autopilot/route-manager/route/num")) and ((i+o)>=0)) {
				if ((i+o)==getprop("/autopilot/route-manager/current-wp")) {
					setprop("/voodoomaster/route/marker["~i~"]", ">");
				} else {
					setprop("/voodoomaster/route/marker["~i~"]", " ");
				}
				setprop("/voodoomaster/route/number["~i~"]", (i+o));
				setprop("/voodoomaster/route/code["~i~"]", getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"));

				var name=getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id");
				var fixes = findFixesByID(getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"));
				foreach(var fix; fixes){
					name=fix.id;
				}

				var navaids = findNavaidsByID(getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"));
				foreach(var fix; navaids){
					name=fix.name;
				}

				if (substr(getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"), 4, 1)=="-") {
					var airports = findAirportsByICAO(substr(getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"), 0, 4));
					print("searching for "~getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"));
					foreach(var fix; airports){
						name=fix.name~" ("~substr(getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/id"), 5)~")";
					}
				}
				setprop("/voodoomaster/route/title["~i~"]", name);
				setprop("/voodoomaster/route/bearing["~i~"]", getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/leg-bearing-true-deg"));
				setprop("/voodoomaster/route/distance["~i~"]", getprop("/autopilot/route-manager/route/wp["~(i+o)~"]/leg-distance-nm"));
			} else {
				setprop("/voodoomaster/route/marker["~i~"]", "INVALID");
				setprop("/voodoomaster/route/number["~i~"]", 0);
				setprop("/voodoomaster/route/code["~i~"]", "");
				setprop("/voodoomaster/route/title["~i~"]", "");
				setprop("/voodoomaster/route/bearing["~i~"]", 0.0);
				setprop("/voodoomaster/route/distance["~i~"]", 0.0);
			}
		}
	} else {
		# we have no active route, clear display
		var i=0;
		for (i=0; i<11; i=i+1) {
			setprop("/voodoomaster/route/marker["~i~"]", "INVALID");
			setprop("/voodoomaster/route/number["~i~"]", 0);
			setprop("/voodoomaster/route/code["~i~"]", "");
			setprop("/voodoomaster/route/title["~i~"]", "");
			setprop("/voodoomaster/route/bearing["~i~"]", 0.0);
			setprop("/voodoomaster/route/distance["~i~"]", 0.0);
		}
	}
}

settimer(weathercontrol, 2);
settimer(enginecontrol, 2);
setlistener("/autopilot/route-manager/active", routecontrol);
setlistener("/autopilot/route-manager/current-wp", routecontrol);
setlistener("/autopilot/route-manager/route/num", routecontrol);


