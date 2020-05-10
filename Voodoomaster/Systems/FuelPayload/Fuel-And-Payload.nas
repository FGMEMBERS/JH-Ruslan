# Overwrite the original menu
gui.menuBind("fuel-and-payload", "voodoomaster.WeightFuelDialog()");

var showDialog = func(name) {
    fgcommand("dialog-show", props.Node.new({ "dialog-name" : name }));
}

#***********************************************************************************************
#* General Conversion Timer Routine                                                            *
#***********************************************************************************************

var generalConversions = func() {

	var total_supply_caplbs=0.00;
	var total_supply_lbs=0.00;
	var total_refuel_caplbs=0.00;
	var total_refuel_lbs=0.00;
	var total_crew_lbs=0.00;
	var total_crew_caplbs=0.00;
	var total_passengers_lbs=0.00;
	var total_passengers_caplbs=0.00;
	var total_passengers_count=0.00;
	var total_passengers_capcount=0.00;
	var total_luggage_lbs=0.00;
	var total_luggage_caplbs=0.00;
	var total_cargo_lbs=0.00;
	var total_cargo_caplbs=0.00;
	var total_payload_lbs=0.00;
	var total_payload_caplbs=0.00;

	var tanks = props.globals.getNode("/fdm/jsbsim/propulsion").getChildren("tank");

	for (var ti=0; ti<size(tanks); ti+=1) {
		var t = tanks[ti];
		var lbs=t.getValue("contents-lbs");
		var cap=getprop("/consumables/fuel/tank["~ti~"]/capacity-lbs");
		if (getprop("/consumables/fuel/tank["~ti~"]/tank-type")=="supply") {
			total_supply_caplbs=total_supply_caplbs+cap;
			total_supply_lbs=total_supply_lbs+lbs;
		}
		if (getprop("/consumables/fuel/tank["~ti~"]/tank-type")=="refuel") {
			total_refuel_caplbs=total_refuel_caplbs+cap;
			total_refuel_lbs=total_refuel_lbs+lbs;
		}
		t.setValue("contents-kg", lbs*0.453592);
	}

	var weights = props.globals.getNode("/payload").getChildren("weight");

	for (var wi=0; wi<size(weights); wi+=1) {
		var w=weights[wi];
		var lbs=w.getValue("weight-lb");
		var cap=w.getValue("max-lb");
		if (lbs==nil) { lbs=0; }
		if (cap==nil) { cap=0; }
		if (getprop("/payload/weight["~wi~"]/weight-type")=="crew") {
			total_crew_caplbs=total_crew_caplbs+cap;
			total_crew_lbs=total_crew_lbs+lbs;
		}
		if (getprop("/payload/weight["~wi~"]/weight-type")=="passengers") {
			total_passengers_caplbs=total_passengers_caplbs+cap;
			total_passengers_lbs=total_passengers_lbs+lbs;
		}
		if (getprop("/payload/weight["~wi~"]/weight-type")=="luggage") {
			total_luggage_caplbs=total_luggage_caplbs+cap;
			total_luggage_lbs=total_luggage_lbs+lbs;
		}
		if (getprop("/payload/weight["~wi~"]/weight-type")=="cargo") {
			total_cargo_caplbs=total_cargo_caplbs+cap;
			total_cargo_lbs=total_cargo_lbs+lbs;
		}
	}

	if (total_supply_caplbs!=0) {
		setprop("/consumables/fuel/supply-fuel-perc", total_supply_lbs/(total_supply_caplbs/100));
		setprop("/consumables/fuel/supply-fuel-lbs", total_supply_lbs);
		setprop("/consumables/fuel/supply-fuel-kg", total_supply_lbs*0.453592);
	} else {
		setprop("/consumables/fuel/supply-fuel-perc", 0.00);
		setprop("/consumables/fuel/supply-fuel-lbs", 0.00);
		setprop("/consumables/fuel/supply-fuel-kg", 0.00);
	}

	if (total_refuel_caplbs!=0) {
		setprop("/consumables/fuel/refuel-fuel-perc", total_refuel_lbs/(total_refuel_caplbs/100));
		setprop("/consumables/fuel/refuel-fuel-lbs", total_refuel_lbs);
		setprop("/consumables/fuel/refuel-fuel-kg", total_refuel_lbs*0.453592);
	} else {
		setprop("/consumables/fuel/refuel-fuel-perc", 0.00);
		setprop("/consumables/fuel/refuel-fuel-lbs", 0.00);
		setprop("/consumables/fuel/refuel-fuel-kg", 0.00);
	}

	if (total_crew_caplbs!=0) {
		setprop("/payload/crew-perc", total_crew_lbs/(total_crew_caplbs/100));
		setprop("/payload/crew-lbs", total_crew_lbs);
		setprop("/payload/crew-kg", total_crew_lbs*0.453592);
	} else {
		setprop("/payload/crew-perc", 0.00);
		setprop("/payload/crew-lbs", 0.00);
		setprop("/payload/crew-kg", 0.00);
	}

	if (total_passengers_caplbs!=0) {
		setprop("/payload/passengers-perc", total_passengers_lbs/(total_passengers_caplbs/100));
		setprop("/payload/passengers-lbs", total_passengers_lbs);
		setprop("/payload/passengers-kg", total_passengers_lbs*0.453592);
	} else {
		setprop("/payload/passengers-perc", 0.00);
		setprop("/payload/passengers-lbs", 0.00);
		setprop("/payload/passengers-kg", 0.00);
	}

	setprop("/payload/passengers-count", (total_passengers_lbs+total_crew_lbs)/180);
	setprop("/payload/passengers-capcount", (total_passengers_caplbs+total_crew_caplbs)/180);

	if (total_luggage_caplbs!=0) {
		setprop("/payload/luggage-perc", total_luggage_lbs/(total_luggage_caplbs/100));
		setprop("/payload/luggage-lbs", total_luggage_lbs);
		setprop("/payload/luggage-kg", total_luggage_lbs*0.453592);
	} else {
		setprop("/payload/luggage-perc", 0.00);
		setprop("/payload/luggage-lbs", 0.00);
		setprop("/payload/luggage-kg", 0.00);
	}

	if (total_cargo_caplbs!=0) {
		setprop("/payload/cargo-perc", total_cargo_lbs/(total_cargo_caplbs/100));
		setprop("/payload/cargo-lbs", total_cargo_lbs);
		setprop("/payload/cargo-kg", total_cargo_lbs*0.453592);
	} else {
		setprop("/payload/cargo-perc", 0.00);
		setprop("/payload/cargo-lbs", 0.00);
		setprop("/payload/cargo-kg", 0.00);
	}

	total_payload_lbs=total_refuel_lbs+total_crew_lbs+total_passengers_lbs+total_luggage_lbs+total_cargo_lbs;
	total_payload_caplbs=total_refuel_caplbs+total_crew_caplbs+total_passengers_caplbs+total_luggage_caplbs+total_cargo_caplbs;

	if (total_payload_caplbs!=0) {
		setprop("/payload/payload-perc", total_payload_lbs/(total_payload_caplbs/100));
		setprop("/payload/payload-lbs", total_payload_lbs);
		setprop("/payload/payload-kg", total_payload_lbs*0.453592);
	} else {
		setprop("/payload/payload-perc", 0.00);
		setprop("/payload/payload-lbs", 0.00);
		setprop("/payload/payload-kg", 0.00);
	}

	if (getprop("/engines/engine-set")=="DT18T") {
		setprop("/limits/mass-and-balance/maximum-landing-mass-lbs", 840000);
		setprop("/limits/mass-and-balance/maximum-ramp-mass-lbs", 875000);
		setprop("/limits/mass-and-balance/maximum-takeoff-mass-lbs", 840000);
		setprop("/limits/mass-and-balance/maximum-zero-fuel-mass-lbs", 665000);
	}
	if (getprop("/engines/engine-set")=="GP7277") {
		setprop("/limits/mass-and-balance/maximum-landing-mass-lbs", 920000);
		setprop("/limits/mass-and-balance/maximum-ramp-mass-lbs", 1250000);
		setprop("/limits/mass-and-balance/maximum-takeoff-mass-lbs", 1250000);
		setprop("/limits/mass-and-balance/maximum-zero-fuel-mass-lbs", 740000);
	}

	settimer(generalConversions, 1.0);
}

########################################################################
# Widgets & Layout Management
########################################################################

##
# A "widget" class that wraps a property node.  It provides useful
# helper methods that are difficult or tedious with the raw property
# API.  Note especially the slightly tricky addChild() method.
#

var Widget = {
	set : func { 
		me.node.getNode(arg[0], 1).setValue(arg[1]); 
	},

	prop : func { 
		return me.node; 
	},

	new : func { 
		return { 
			parents : [Widget], node : props.Node.new() 
		} 
	},

	addChild : func {
	        var type = arg[0];
	        var idx = size(me.node.getChildren(type));
	        var name = type ~ "[" ~ idx ~ "]";
	        var newnode = me.node.getNode(name, 1);
	        return { 
			parents : [Widget], node : newnode 
		};
	},

	setColor : func(r, g, b, a = 1) {
		me.node.setValues({ 
			color : { 
				red:r, green:g, blue:b, alpha:a 
			} 
		});
	},

	setFont : func(n, s = 13, t = 0) {
		me.node.setValues({ 
			font : { 
				name:n, "size":s, slant:t 
			} 
		});
	},

	setBinding : func(cmd, carg = nil) {
		var idx = size(me.node.getChildren("binding"));
		var node = me.node.getChild("binding", idx, 1);
		node.getNode("command", 1).setValue(cmd);
		if (cmd == "nasal") {
			node.getNode("script", 1).setValue(carg);
		} elsif (carg != nil and (cmd == "dialog-apply" or cmd == "dialog-update")) {
			node.getNode("object-name", 1).setValue(carg);
		}
	},

};

########################################################################
# Dialog Boxes
########################################################################

var dialog = {};

var setWeight = func(wgt, opt) {
	var lbs = opt.getNode("lbs", 1).getValue();
	wgt.getNode("weight-lb", 1).setValue(lbs);

	# Weights can have "tank" indices which set the capacity of the
	# corresponding tank.  This code should probably be moved to
	# something like fuel.setTankCap(tank, gals)...
	if (wgt.getNode("tank",0) == nil) { 
		return 0; 
	}
	var ti = wgt.getNode("tank").getValue();
	var gn = opt.getNode("gals");
	var gals = gn == nil ? 0 : gn.getValue();
	var tn = props.globals.getNode("consumables/fuel/tank["~ti~"]", 1);
	var ppg = tn.getNode("density-ppg", 1).getValue();
	var lbs = gals * ppg;
	var curr = tn.getNode("level-gal_us", 1).getValue();
	curr = curr > gals ? gals : curr;
	tn.getNode("capacity-gal_us", 1).setValue(gals);
	tn.getNode("level-gal_us", 1).setValue(curr);
	tn.getNode("level-lbs", 1).setValue(curr * ppg);
	return 1;
}

##
# Dynamically generates a weight & fuel configuration dialog specific to
# the aircraft.
#
var WeightFuelDialog = func {
	var name = "WeightAndFuel";
	var title = getprop("/voodoomaster/dialogs/fuel-and-payload");

	#
	# General Dialog Structure
	#

	var hasCrew=0;
	var hasPassengers=0;
	var hasLuggage=0;
	var hasRefuel=0;
	var hasCargo=0;

	dialog[name] = Widget.new();
	dialog[name].set("name", name);
	dialog[name].set("layout", "vbox");

	var header = dialog[name].addChild("group");
	header.set("layout", "hbox");
	header.addChild("empty").set("stretch", "1");
	header.addChild("text").set("label", title);
	header.addChild("empty").set("stretch", "1");
	var w = header.addChild("button");
	w.set("pref-width", 16);
	w.set("pref-height", 16);
	w.set("legend", "");
	w.set("default", 1);
	w.set("key", "esc");
	w.setBinding("nasal", "delete(voodoomaster.dialog, \"" ~ name ~ "\")");
	w.setBinding("dialog-close");

	dialog[name].addChild("hrule");

	var fdmdata = {
		grosswgt : "/fdm/jsbsim/inertia/weight-lbs",
		payload  : "/payload",
		cg       : "/fdm/jsbsim/inertia/cg-x-in",
	};

	var contentArea = dialog[name].addChild("group");
	contentArea.set("layout", "hbox");
	contentArea.set("default-padding", 10);

	dialog[name].addChild("empty");

	var limits = dialog[name].addChild("group");
	limits.set("layout", "table");
	limits.set("halign", "center");
	var row = 0;

	var massLimits = props.globals.getNode("/limits/mass-and-balance");

	var tablerow = func(name, node, format ) {

	        var n = isa( node, props.Node ) ? node : massLimits.getNode( node );
	        if ( n == nil ) return;

        	var label = limits.addChild("text");
        	label.set("row", row);
        	label.set("col", 0);
        	label.set("halign", "right");
        	label.set("label", name ~ ":");

        	var val = limits.addChild("text");
        	val.set("row", row);
        	val.set("col", 1);
        	val.set("halign", "left");
        	val.set("label", "0123457890123456789");
        	val.set("format", format);
        	val.set("property", n.getPath());
        	val.set("live", 1);
          
        	row += 1;
	}

	var grossWgt = props.globals.getNode(fdmdata.grosswgt);
	var grosskg = props.globals.getNode("/voodoomaster/weight-kg");
	if (grossWgt != nil) {
	        tablerow("Gross Weight", grossWgt, "%.0f lbs");
	}

	if (massLimits != nil ) {
		tablerow("Max. Ramp Weight", "maximum-ramp-mass-lbs", "%.0f lbs" );
		tablerow("Max. Takeoff", "maximum-takeoff-mass-lbs", "%.0f lbs" );
		tablerow("Max. Landing", "maximum-landing-mass-lbs", "%.0f lbs" );
		tablerow("Max. Arrested Landing  Weight", "maximum-arrested-landing-mass-lbs", "%.0f lbs" );
		tablerow("Max. Zero Fuel Weight", "maximum-zero-fuel-mass-lbs", "%.0f lb" );
	}

	#if( fdmdata.cg != nil ) { 
	#    var n = props.globals.getNode("/limits/mass-and-balance/cg/dimension");
	#    tablerow("Center of Gravity", props.globals.getNode(fdmdata.cg), "%.1f " ~ (n == nil ? "in" : n.getValue()));
	#}

	dialog[name].addChild("hrule");

	var buttonBar = dialog[name].addChild("group");
	buttonBar.set("layout", "hbox");
	buttonBar.set("default-padding", 10);

	var close = buttonBar.addChild("button");
	close.set("legend", "Close");
	close.set("default", "true");
	close.set("key", "Enter");
	close.setBinding("dialog-close");

	# Temporary helper function
	var tcell = func(parent, type, row, col) {
		var cell = parent.addChild(type);
		cell.set("row", row);
		cell.set("col", col);
		return cell;
	}

	#
	# Fill in the content area
	#

	var fuelArea = contentArea.addChild("group");
	fuelArea.set("layout", "vbox");
	fuelArea.addChild("text").set("label", "Fuel Tanks");

	var fuelTable = fuelArea.addChild("group");
	fuelTable.set("layout", "table");

	fuelArea.addChild("empty").set("stretch", 1);

	tcell(fuelTable, "text", 0, 0).set("label", "Tank"); 
	var lbs = tcell(fuelTable, "text", 0, 3);
	lbs.set("label", "lbs");
	lbs.set("halign", "left");
    
	var kg = tcell(fuelTable, "text", 0, 4);
	kg.set("label", "kg");
	kg.set("halign", "left");

	var tanks = props.globals.getNode("/consumables/fuel").getChildren("tank");

	for (var ti=0; ti<size(tanks); ti+=1) {
		var t = tanks[ti];
		var tname = "";
		var ttype = "";
		var tcap = 0.00;

		tname=t.getValue("name");
		ttype=t.getValue("tank-type");
		tcap=t.getValue("capacity-lbs");

		# count only supply tanks, all others are counted as payload, but mark here if refuel tanks are found
		if (ttype == "refuel") {
			hasRefuel=1;
		}

		if (ttype != "supply") {
			continue;
		}

		var tankprop = "/consumables/fuel/tank["~ti~"]";

		var title = tcell(fuelTable, "text", ti+1, 0);
		title.set("label", tname);
		title.set("halign", "left");

		var selected = props.globals.initNode(tankprop ~ "/selected", 1, "BOOL");
		if (selected.getAttribute("writable")) {
			var sel = tcell(fuelTable, "checkbox", ti+1, 1);
			sel.set("property", tankprop ~ "/selected");
			sel.set("live", 1);
			sel.setBinding("dialog-apply");
		}

		var slider = tcell(fuelTable, "slider", ti+1, 2);
		slider.set("property", "/fdm/jsbsim/propulsion/tank["~ti~"]/contents-lbs");
		slider.set("live", 1);
		slider.set("min", 0);
		slider.set("max", tcap);
		slider.setBinding("dialog-apply");

		var lbs = tcell(fuelTable, "text", ti+1, 3);
		lbs.set("property", "/fdm/jsbsim/propulsion/tank["~ti~"]/contents-lbs");
		lbs.set("label", "0123456");
		lbs.set("format", "%.1f" );
		lbs.set("halign", "right");
		lbs.set("live", 1);

		var kg = tcell(fuelTable, "text", ti+1, 4);
		kg.set("property", "/fdm/jsbsim/propulsion/tank["~ti~"]/contents-kg");
		kg.set("label", "0123456");
		kg.set("format", "%.1f" );
		kg.set("halign", "right");
		kg.set("live", 1);
	}

	var bar = tcell(fuelTable, "hrule", size(tanks)+1, 0);
	bar.set("colspan", 5);

	var total_label = tcell(fuelTable, "text", size(tanks)+2, 0);
	total_label.set("label", "Total");
	total_label.set("halign", "left");
    
	# show percentage only over the supply tanks
	var perc = tcell(fuelTable, "text", size(tanks)+2, 2);  
	perc.set("property", "/consumables/fuel/supply-fuel-perc");
	perc.set("label", "0123456");
	perc.set("format", "%.2f" );
	perc.set("halign", "right");
	perc.set("live", 1);

	var lbs = tcell(fuelTable, "text", size(tanks)+2, 3);
	lbs.set("property", "/consumables/fuel/supply-fuel-lbs");
	lbs.set("label", "0123456");
	lbs.set("format", "%.1f" );
	lbs.set("halign", "right");
	lbs.set("live", 1);

	var kg = tcell(fuelTable, "text", size(tanks)+2, 4);
	kg.set("property", "/consumables/fuel/supply-fuel-kg");
	kg.set("label", "0123456");
	kg.set("format", "%.1f" );
	kg.set("halign", "right");
	kg.set("live", 1);

	#***********************************************************************************************
	#* Weight list                                                                                 *
	#***********************************************************************************************

	var weightArea = contentArea.addChild("group");
	weightArea.set("layout", "vbox");
	weightArea.addChild("text").set("label", "Payload");

	var weightTable = weightArea.addChild("group");
	weightTable.set("layout", "table");

	weightArea.addChild("empty").set("stretch", 1);

	tcell(weightTable, "text", 0, 0).set("label", "Location");
	var lbs = tcell(weightTable, "text", 0, 2);
	lbs.set("label", "lbs");
	lbs.set("halign", "left");

	var kg = tcell(weightTable, "text", 0, 3);
	kg.set("label", "kg");
	kg.set("halign", "left");
    
	if (getprop("/aircraft-variant/aircraft-type")=="passenger") {
		var pers = tcell(weightTable, "text", 0, 4);
		pers.set("label", "Pers.");
		pers.set("halign", "left");
	}
		
	var payload_base = props.globals.getNode(fdmdata.payload);
	if (payload_base != nil) {
	        var wgts = payload_base.getChildren("weight");
	} else {
		var wgts = [];
	}

	var lines=0;

	for (var i=0; i<size(wgts); i+=1) {
		var w = wgts[i];
		var wname = w.getNode("name", 1).getValue();
		var wprop = fdmdata.payload ~ "/weight[" ~ i ~ "]";
		var wtype = w.getValue("weight-type");

		if (wtype == "passengers") {
			hasPassengers=1;
		}
		if (wtype == "luggage") {
			hasLuggage=1;
		}
		if (wtype == "cargo") {
			hasCargo=1;
		}

		if (wtype != "crew") {
			continue;
		}

		lines=lines+1;

		var title = tcell(weightTable, "text", i+1, 0);
		title.set("label", wname);
		title.set("halign", "left");

		var slider = tcell(weightTable, "slider", lines, 1);
		slider.set("property", wprop ~ "/weight-lb");
		var min = w.getNode("min-lb", 1).getValue();
		var max = w.getNode("max-lb", 1).getValue();
		slider.set("min", min != nil ? min : 0);
		slider.set("max", max != nil ? max : 100);
		slider.set("live", 1);
		slider.setBinding("dialog-apply");

		var lbs = tcell(weightTable, "text", lines, 2);
		lbs.set("property", wprop ~ "/weight-lb");
		lbs.set("label", "0123456");
		lbs.set("format", "%.0f");
		lbs.set("halign", "right");
		lbs.set("live", 1);
        
		var kg = tcell(weightTable, "text", lines, 3);
		kg.set("property", "voodoomaster/passengers/weight-kg["~i~"]");
		kg.set("label", "0123456");
		kg.set("format", "%.0f");
		kg.set("halign", "right");
		kg.set("live", 1);
        
		var pas = tcell(weightTable, "text", lines, 4);
		pas.set("property", "voodoomaster/passengers/count["~i~"]");
		pas.set("label", "0123456");
		pas.set("format", "%.0f");
		pas.set("halign", "right");
		pas.set("live", 1);

	}

	lines=lines+1;    

	var bar = tcell(weightTable, "hrule", lines, 0);
	bar.set("colspan", 5);

	lines=lines+1;

	if (hasPassengers==1) {

		for (var i=0; i<size(wgts); i+=1) {
			var w = wgts[i];
			var wname = w.getNode("name", 1).getValue();
			var wprop = fdmdata.payload ~ "/weight[" ~ i ~ "]";
			var wtype = w.getValue("weight-type");

			if (wtype != "passengers") {
				continue;
			}

			lines=lines+1;

			var title = tcell(weightTable, "text", lines, 0);
			title.set("label", wname);
			title.set("halign", "left");

			var slider = tcell(weightTable, "slider", lines, 1);
			slider.set("property", wprop ~ "/weight-lb");
			var min = w.getNode("min-lb", 1).getValue();
			var max = w.getNode("max-lb", 1).getValue();
			slider.set("min", min != nil ? min : 0);
			slider.set("max", max != nil ? max : 100);
			slider.set("live", 1);
			slider.setBinding("dialog-apply");

			var lbs = tcell(weightTable, "text", lines, 2);
			lbs.set("property", wprop ~ "/weight-lb");
			lbs.set("label", "0123456");
			lbs.set("format", "%.0f");
			lbs.set("halign", "right");
			lbs.set("live", 1);
        	
			var kg = tcell(weightTable, "text", lines, 3);
			kg.set("property", "voodoomaster/passengers/weight-kg["~i~"]");
			kg.set("label", "0123456");
			kg.set("format", "%.0f");
			kg.set("halign", "right");
			kg.set("live", 1);
        
			var pas = tcell(weightTable, "text", lines, 4);
			pas.set("property", "voodoomaster/passengers/count["~i~"]");
			pas.set("label", "0123456");
			pas.set("format", "%.0f");
			pas.set("halign", "right");
			pas.set("live", 1);

		}

		lines=lines+1;    

		var bar = tcell(weightTable, "hrule", lines, 0);
		bar.set("colspan", 5);

		lines=lines+1;
	}

	if (hasLuggage==1) {

		for (var i=0; i<size(wgts); i+=1) {
			var w = wgts[i];
			var wname = w.getNode("name", 1).getValue();
			var wprop = fdmdata.payload ~ "/weight[" ~ i ~ "]";
			var wtype = w.getValue("weight-type");
			if (wtype != "luggage") {
				continue;
			}

			lines=lines+1;

			var title = tcell(weightTable, "text", lines, 0);
			title.set("label", wname);
			title.set("halign", "left");

			var slider = tcell(weightTable, "slider", lines, 1);
			slider.set("property", wprop ~ "/weight-lb");
			var min = w.getNode("min-lb", 1).getValue();
			var max = w.getNode("max-lb", 1).getValue();
			slider.set("min", min != nil ? min : 0);
			slider.set("max", max != nil ? max : 100);
			slider.set("live", 1);
			slider.setBinding("dialog-apply");

			var lbs = tcell(weightTable, "text", lines, 2);
			lbs.set("property", wprop ~ "/weight-lb");
			lbs.set("label", "0123456");
			lbs.set("format", "%.0f");
			lbs.set("halign", "right");
			lbs.set("live", 1);
        	
			var kg = tcell(weightTable, "text", lines, 3);
			kg.set("property", "voodoomaster/passengers/weight-kg["~i~"]");
			kg.set("label", "0123456");
			kg.set("format", "%.0f");
			kg.set("halign", "right");
			kg.set("live", 1);
        
			var pas = tcell(weightTable, "text", lines, 4);
			pas.set("property", "voodoomaster/passengers/count["~i~"]");
			pas.set("label", "0123456");
			pas.set("format", "%.0f");
			pas.set("halign", "right");
			pas.set("live", 1);

		}

		lines=lines+1;    

		var bar = tcell(weightTable, "hrule", lines, 0);
		bar.set("colspan", 5);

		lines=lines+1;
	}

	if (hasCargo==1) {

		for (var i=0; i<size(wgts); i+=1) {
			var w = wgts[i];
			var wname = w.getNode("name", 1).getValue();
			var wprop = fdmdata.payload ~ "/weight[" ~ i ~ "]";
			var wtype = w.getValue("weight-type");

			if (wtype != "cargo") {
				continue;
			}

			lines=lines+1;

			var title = tcell(weightTable, "text", lines, 0);
			title.set("label", wname);
			title.set("halign", "left");

			var slider = tcell(weightTable, "slider", lines, 1);
			slider.set("property", wprop ~ "/weight-lb");
			var min = w.getNode("min-lb", 1).getValue();
			var max = w.getNode("max-lb", 1).getValue();
			slider.set("min", min != nil ? min : 0);
			slider.set("max", max != nil ? max : 100);
			slider.set("live", 1);
			slider.setBinding("dialog-apply");

			var lbs = tcell(weightTable, "text", lines, 2);
			lbs.set("property", wprop ~ "/weight-lb");
			lbs.set("label", "0123456");
			lbs.set("format", "%.0f");
			lbs.set("halign", "right");
			lbs.set("live", 1);
        	
			var kg = tcell(weightTable, "text", lines, 3);
			kg.set("property", "voodoomaster/passengers/weight-kg["~i~"]");
			kg.set("label", "0123456");
			kg.set("format", "%.0f");
			kg.set("halign", "right");
			kg.set("live", 1);
        
			var pas = tcell(weightTable, "text", lines, 4);
			pas.set("property", "voodoomaster/passengers/count["~i~"]");
			pas.set("label", "0123456");
			pas.set("format", "%.0f");
			pas.set("halign", "right");
			pas.set("live", 1);

		}

		lines=lines+1;    

		var bar = tcell(weightTable, "hrule", lines, 0);
		bar.set("colspan", 5);

		lines=lines+1;
	}

	if (hasRefuel==1) {

		tanks = props.globals.getNode("/consumables/fuel").getChildren("tank");

		for (var ti=0; ti<size(tanks); ti+=1) {
			var t = tanks[ti];
			var tname = "";
			var ttype = "";
			var tcap = 0.00;
	
			tname=t.getValue("name");
			ttype=t.getValue("tank-type");
			tcap=t.getValue("capacity-lbs");

			if (ttype != "refuel") {
				continue;
			}

			lines=lines+1;

			var title = tcell(weightTable, "text", lines, 0);
			title.set("label", tname);
			title.set("halign", "left");

			var slider = tcell(weightTable, "slider", lines, 1);
			slider.set("property", "/fdm/jsbsim/propulsion/tank["~ti~"]/contents-lbs");
			var min = w.getNode("min-lb", 1).getValue();
			var max = tcap;
			slider.set("min", 0);
			slider.set("max", max != nil ? max : 100);
			slider.set("live", 1);
			slider.setBinding("dialog-apply");

			var lbs = tcell(weightTable, "text", lines, 2);
			lbs.set("property", "/fdm/jsbsim/propulsion/tank["~ti~"]/contents-lbs");
			lbs.set("label", "0123456");
			lbs.set("format", "%.0f");
			lbs.set("halign", "right");
			lbs.set("live", 1);
       
			var kg = tcell(weightTable, "text", lines, 3);
			kg.set("property", "/fdm/jsbsim/propulsion/tank["~ti~"]/contents-kg");
			kg.set("label", "0123456");
			kg.set("format", "%.0f");
			kg.set("halign", "right");
			kg.set("live", 1);
        
			var pas = tcell(weightTable, "text", lines, 4);
			pas.set("label", "-------");
			pas.set("format", "%.0f");
			pas.set("halign", "right");
		}

		lines=lines+1;

		var bar = tcell(weightTable, "hrule", lines, 0);
		bar.set("colspan", 5);

		lines=lines+1;    
	}

	var total_label = tcell(weightTable, "text", lines, 0);
	total_label.set("label", "Total Load");
	total_label.set("halign", "left");		

	var perclbs = tcell(weightTable, "text", lines, 1);
	perclbs.set("property", "/payload/payload-perc");
	perclbs.set("label", "0123456");
	perclbs.set("format", "%.2f" );
	perclbs.set("halign", "right");
	perclbs.set("live", 1);
    
	var lbs = tcell(weightTable, "text", lines, 2);
	lbs.set("property", "/payload/payload-lbs");
	lbs.set("label", "0123456");
	lbs.set("format", "%.0f" );
	lbs.set("halign", "right");
	lbs.set("live", 1);

	var kg = tcell(weightTable, "text", lines, 3);
	kg.set("property", "/payload/payload-kg");
	kg.set("label", "0123456");
	kg.set("format", "%.0f" );
	kg.set("halign", "right");
	kg.set("live", 1);

	var ps = tcell(weightTable, "text", lines, 4);
	ps.set("property", "/payload/passengers-count");
	ps.set("label", "0123456");
	ps.set("format", "%.0f" );
	ps.set("halign", "right");
	ps.set("live", 1);

	# All done: pop it up
	fgcommand("dialog-new", dialog[name].prop());
	showDialog(name);
}

########################################### Helper #################################
var count_all = func {
	var tanks_refuel=0.00;
	var payload_passengers=0.00;
	var payload_luggage=0.00;
	var payload_cargo=0.00;
	foreach (var c; props.globals.getNode("/consumables/fuel").getChildren("tank")) {
		var name = c.getNode("name").getValue() or "";
		var type = c.getNode("tank-type").getValue() or "";
		if (type=="refuel") {
			var tanknum=c.getNode("tank-num").getValue();
			tanks_refuel=tanks_refuel+getprop("/fdm/jsbsim/propulsion/tank["~tanknum~"]/contents-lbs");
		}
	}
	var total_load=tanks_refuel+payload_passengers+payload_luggage+payload_cargo;
	setprop("voodoomaster/fuel-payload/weights/total_total", total_load);
	setprop("voodoomaster/fuel-payload/weights/tanks_refuel", tanks_refuel);
	setprop("voodoomaster/fuel-payload/weights/payload_passengers", payload_passengers);
	setprop("voodoomaster/fuel-payload/weights/payload_luggage", payload_luggage);
	setprop("voodoomaster/fuel-payload/weights/payload_cargo", payload_cargo);
	setprop("voodoomaster/fuel-payload/weights/load-weight-kg", total_load*0.45359237);
}

#Linie 328
var calc_fuel = func {
	# how many fuel is inside the tanks
	var cfuel  = 0;
	var cfuel += tfR4.getValue() or 0;
	var cfuel += tfM4.getValue() or 0;
	var cfuel += tfM3.getValue() or 0;
	var cfuel += tfC.getValue() or 0;
	var cfuel += tfM2.getValue() or 0;
	var cfuel += tfM1.getValue() or 0;
	var cfuel += tfR1.getValue() or 0;
  
	# refill the tanks as her percent level
	tfR4.setValue(cfuel * 0.0184);
	tfM4.setValue(cfuel * 0.0974); 
	tfM3.setValue(cfuel * 0.1705); 
	tfC.setValue(cfuel * 0.4274); 
	tfM2.setValue(cfuel * 0.1705); 
	tfM1.setValue(cfuel * 0.0974); 
	tfR1.setValue(cfuel * 0.0184);  
}

var standard_load = func {
	var st = getprop("/voodoomaster/standard-load") or 0;
	if (!st) {
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]", 1068.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 3429.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 6713.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 11529.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 2805.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 6104.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 7532.0);
		setprop("/voodoomaster/standard-load", 1);
		settimer(calc_fuel, 0.2);
	} else {
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]", 540.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 0.0);
		setprop("/voodoomaster/standard-load", 0);	
	}
}
###################################################################################################

#setlistener("/voodoomaster/oil/oil-test", func(pos){
#	var pos = pos.getValue();
#	var pwr = getprop("/voodoomaster/ess-bus") or 0;
#	if(pos and pwr > 24) {
#		interpolate("/voodoomaster/oil/quantity[0]", 0, 1);
#		interpolate("/voodoomaster/oil/quantity[1]", 0, 1);
#		interpolate("/voodoomaster/oil/quantity[2]", 0, 1);
#		interpolate("/voodoomaster/oil/quantity[3]", 0, 1);
#	} else {
#		interpolate("/voodoomaster/oil/quantity[0]", 6400, 1);
#		interpolate("/voodoomaster/oil/quantity[1]", 6400, 1);
#		interpolate("/voodoomaster/oil/quantity[2]", 6400, 1);
#		interpolate("/voodoomaster/oil/quantity[3]", 6400, 1);	
#	}
#},1,0);

################################ FUEL DUMP ANIMATION ####################################

#setlistener("/voodoomaster/fuel/valves/dump-retract[0]", func(pos) {
#	var pos = pos.getValue();
#	var pwr = getprop("/voodoomaster/ess-bus") or 0;
#	if (pos and pwr > 24) dump_loop_l();
#},1,0);

#setlistener("/voodoomaster/fuel/valves/dump-retract[1]", func(pos) {
#	var pos = pos.getValue();
#	var pwr = getprop("/voodoomaster/ess-bus") or 0;
#	if(pos and pwr > 24) dump_loop_r();
#},1,0);

#var dump_loop_l = func {
#	var is  = getprop("sim/multiplay/generic/int[15]") or 0; # the int[15] is the fuel dust on wings
#	var pwr = getprop("/voodoomaster/ess-bus") or 0;
#	
#	if (v0.getBoolValue() or v1.getBoolValue() or v2.getBoolValue()) {
#		screen.log.write("Close crossfeed valves Res1, Main 1 and Main 2 before dumping!", 1, 0, 0);
#		drL.setValue(0);
#	}
#	
#	if (drL.getValue() and (!v0.getBoolValue() and !v1.getBoolValue() and !v2.getBoolValue()) and ((dv0.getBoolValue() and dvp0.getBoolValue()) or (dv2.getBoolValue() and dvp2.getBoolValue()) or 	#		(dv3.getBoolValue() and dvp3.getBoolValue()))) {
#						 
#		if (is == 0) setprop("sim/multiplay/generic/int[15]", 1); 
#		if (is == 2) setprop("sim/multiplay/generic/int[15]", 3);
#				
#		if (is == 1) { # only this side is on
#			var tfCNeu = (tfC.getValue() > 1700 ) ? tfC.getValue() - 100 : tfC.getValue();
#		} else {
#			var tfCNeu = (tfC.getValue() > 1800 ) ? tfC.getValue() - 200 : tfC.getValue();			
#		}		
#						
#		var tfM2Neu = (tfM2.getValue() > 4100 ) ? tfM2.getValue() - 100 : tfM2.getValue();				
#		var tfM1Neu = (tfM1.getValue() > 4100 ) ? tfM1.getValue() - 100 : tfM1.getValue();				
#		var tfR1Neu = (tfR1.getValue() > 0 ) ? tfR1.getValue() - 100 : 0;
#		if (dv0.getBoolValue() and dvp0.getBoolValue()) interpolate("/consumables/fuel/tank[3]/level-lbs", tfCNeu, 2.1); # Center
#		if (dv3.getBoolValue() and dvp3.getBoolValue())	interpolate("/consumables/fuel/tank[4]/level-lbs", tfM2Neu, 2.1); # Main 2
#		if (dv2.getBoolValue() and dvp2.getBoolValue()) interpolate("/consumables/fuel/tank[5]/level-lbs", tfM1Neu, 2.1); # Main 1
#		interpolate("/consumables/fuel/tank[6]/level-lbs", tfR1Neu, 2.1); # Reserve 1
#	} else {
#		if (is == 1) setprop("sim/multiplay/generic/int[15]", 0);
#		if (is == 3) setprop("sim/multiplay/generic/int[15]", 2);	
#	}
#	if (pwr > 24 and drL.getValue() and (tfC.getValue() > 1600 or tfM2.getValue() > 4000 or tfM1.getValue() > 4000) and (!v3.getBoolValue() and !v4.getBoolValue() and !v5.getBoolValue())) {
#		settimer(dump_loop_l, 2.1);
#	} else {
#		setprop("sim/multiplay/generic/int[15]", 0);
#	}	
#	if (dv0.getBoolValue() and tfC.getValue() <= 1750) {
#		dv0.setValue(0);
#		screen.log.write("Dumping terminated - minimum reached for L Center Tank!", 1, 0, 0);
#	}
#	if (dv2.getBoolValue() and tfM1.getValue() <= 4150) {
#		dv2.setValue(0);
#		screen.log.write("Dumping terminated - minimum reached for Main Tank 1!", 1, 0, 0);
#	} 
#	if (dv3.getBoolValue() and tfM2.getValue() <= 4150) {
#		dv3.setValue(0);
#		screen.log.write("Dumping terminated - minimum reached for Main Tank 2!", 1, 0, 0);
#	}
#}

#var dump_loop_r = func {
#	var is  = getprop("sim/multiplay/generic/int[15]") or 0;
#	var pwr = getprop("/voodoomaster/ess-bus") or 0;
#	
#	if (v3.getBoolValue() or v4.getBoolValue() or v5.getBoolValue()) {
#		screen.log.write("Close crossfeed valves Main 3 and Main 4 and Res4 before dumping!", 1, 0, 0);
#		drR.setValue(0);
#	}
#	
#	if (drR.getValue() and (!v3.getBoolValue() and !v4.getBoolValue() and !v5.getBoolValue()) and ((dv1.getBoolValue() and dvp1.getBoolValue()) or 
#						 						 (dv4.getBoolValue() and dvp4.getBoolValue()) or
#						 						 (dv5.getBoolValue() and dvp5.getBoolValue()))) {	
#						 						 
#		var tfCNeu  = 0; 
#									 
#		if (is == 0) setprop("sim/multiplay/generic/int[15]", 2);
#		if (is == 1) setprop("sim/multiplay/generic/int[15]", 3);
#				
#		if (is == 2) { # only this side is on
#			tfCNeu = (tfC.getValue() > 1700 ) ? tfC.getValue() - 100 : tfC.getValue();
#		}		
#						
#		var tfM4Neu = (tfM4.getValue() > 4100 ) ? tfM4.getValue() - 100 : tfM4.getValue();				
#		var tfM3Neu = (tfM3.getValue() > 4100 ) ? tfM3.getValue() - 100 : tfM3.getValue();				
#		var tfR4Neu = (tfR4.getValue() > 0 ) ? tfR4.getValue() - 100 : 0;
#		if (dv1.getBoolValue() and dvp1.getBoolValue() and tfCNeu) interpolate("/consumables/fuel/tank[3]/level-lbs", tfCNeu, 2.1); # Center
#		if (dv4.getBoolValue() and dvp4.getBoolValue()) interpolate("/consumables/fuel/tank[2]/level-lbs", tfM3Neu, 2.1); # Main 3
#		if (dv5.getBoolValue() and dvp5.getBoolValue()) interpolate("/consumables/fuel/tank[1]/level-lbs", tfM4Neu, 2.1); # Main 4
#		interpolate("/consumables/fuel/tank[0]/level-lbs", tfR4Neu, 2.1); # Reserve 1						 						 
#	  						 
#	} else {
#		if (is == 2) setprop("sim/multiplay/generic/int[15]", 0);
#		if (is == 3) setprop("sim/multiplay/generic/int[15]", 1);
#	}
#	if (pwr > 24 and drR.getValue() and (tfC.getValue() > 1600 or tfM4.getValue() > 4000 or tfM3.getValue() > 4000) and (!v3.getBoolValue() and !v4.getBoolValue() and !v5.getBoolValue())) {
#		settimer(dump_loop_r, 2.1);
#	} else {
#		setprop("sim/multiplay/generic/int[15]", 0);
#	}	
#	
#	if (dv1.getBoolValue() and tfC.getValue() <= 1750) {
#		dv1.setValue(0);
#		screen.log.write("Dumping terminated - minimum reached for R Center Tank!", 1, 0, 0);
#	}	
#	if (dv4.getBoolValue() and tfM3.getValue() <= 4150) {
#		dv4.setValue(0);
#		screen.log.write("Dumping terminated - minimum reached for Main Tank 3!", 1, 0, 0);
#	}
#	if (dv5.getBoolValue() and tfM4.getValue() <= 4150) {
#		dv5.setValue(0);
#		screen.log.write("Dumping terminated - minimum reached for Main Tank 4!", 1, 0, 0);
#	}
#}


############  Start up the loops ################
# settimer( func { engines_alive(); } , 6);
# settimer( func { crossfeed_action(); } , 4);

############################################# external fuel service action ###########################################
var fuel_truck = props.globals.getNode("voodoomaster/ground-service/fuel-truck/truck[0]/state");
var fuel_truck_enable = props.globals.getNode("voodoomaster/ground-service/fuel-truck/truck[0]/enable");
var fuel_truck_connect = props.globals.getNode("voodoomaster/ground-service/fuel-truck/truck[0]/connect");
var fuel_truck_transfer = props.globals.getNode("voodoomaster/ground-service/fuel-truck/truck[0]/transfer");
var fuel_truck_clean = props.globals.getNode("voodoomaster/ground-service/fuel-truck/truck[0]/clean");

var loop_id = 0;

var clean_or_refuel = func {
	
	#print("ID:"~loop_id);
	loop_id += 1;
	
	# Fuel Truck Controls
	var request_kg = getprop("/voodoomaster/ground-service/fuel-truck/truck[0]/request-kg") or 0;
	var total_fuel = getprop("consumables/fuel/total-fuel-kg") or 0; 

	if (fuel_truck_enable.getBoolValue()) {

		if (!getprop("engines/engine[0]/running") and !getprop("engines/engine[1]/running") and !getprop("engines/engine[2]/running") and !getprop("engines/engine[3]/running")) {
			fuel_truck.setValue(1.0);
		} else {
			screen.log.write("Please shutdown engines before Re-fueling Service call!", 1, 0, 0);
			setprop("/voodoomaster/ground-service/fuel-truck/truck[0]/enable", 0);
			setprop("/voodoomaster/ground-service/fuel-truck/truck[0]/connect", 0);
			setprop("/voodoomaster/ground-service/fuel-truck/truck[0]/transfer", 0);
			setprop("/voodoomaster/ground-service/fuel-truck/truck[0]/clean", 0);
			setprop("/voodoomaster/ground-service/fuel-truck/truck[0]/state", 0);
		}

		if (fuel_truck_connect.getBoolValue()) {

			fuel_truck.setValue(1.1);

			if (fuel_truck_transfer.getBoolValue()) {
			
				if (!getprop("/voodoomaster/fuel/valves/valve[0]") and
					!getprop("/voodoomaster/fuel/valves/valve[1]") and !getprop("/voodoomaster/fuel/valves/valve[2]") and
					!getprop("/voodoomaster/fuel/valves/valve[3]") and !getprop("/voodoomaster/fuel/valves/valve[4]") and
					!getprop("/voodoomaster/fuel/valves/valve[5]")) {

					if (total_fuel < request_kg and total_fuel < 72485.0) {
						setprop("/consumables/fuel/tank[0]/level-kg", getprop("/consumables/fuel/tank[0]/level-kg") + 0.5);
						setprop("/consumables/fuel/tank[1]/level-kg", getprop("/consumables/fuel/tank[1]/level-kg") + 3);
						setprop("/consumables/fuel/tank[2]/level-kg", getprop("/consumables/fuel/tank[2]/level-kg") + 3);
						setprop("/consumables/fuel/tank[3]/level-kg", getprop("/consumables/fuel/tank[3]/level-kg") + 6);
						setprop("/consumables/fuel/tank[4]/level-kg", getprop("/consumables/fuel/tank[4]/level-kg") + 3);
						setprop("/consumables/fuel/tank[5]/level-kg", getprop("/consumables/fuel/tank[5]/level-kg") + 3);
						setprop("/consumables/fuel/tank[6]/level-kg", getprop("/consumables/fuel/tank[6]/level-kg") + 0.5);

						if(loop_id > 3) fuel_truck.setValue(1.2); 

					} else {
						setprop("/voodoomaster/ground-service/fuel-truck/transfer", 0);
						screen.log.write("Re-fueling complete! Have a nice flight... :)", 1, 1, 1);
					}				

				} else {
					setprop("/voodoomaster/ground-service/fuel-truck/transfer", 0);
					screen.log.write("ABORT! Please CLOSE your crossfeed valves before Re-fueling!", 1, 0, 0);
				}

			}

			if (fuel_truck_clean.getBoolValue()) {

				if (getprop("/voodoomaster/fuel/valves/valve[0]") and
					getprop("/voodoomaster/fuel/valves/valve[1]") and getprop("/voodoomaster/fuel/valves/valve[2]") and
					getprop("/voodoomaster/fuel/valves/valve[3]") and getprop("/voodoomaster/fuel/valves/valve[4]") and
					getprop("/voodoomaster/fuel/valves/valve[5]")) {

					if (getprop("consumables/fuel/total-fuel-kg")) {

						setprop("/consumables/fuel/tank[0]/level-kg", getprop("/consumables/fuel/tank[0]/level-kg") - 0.5);
						setprop("/consumables/fuel/tank[1]/level-kg", getprop("/consumables/fuel/tank[1]/level-kg") - 3);
						setprop("/consumables/fuel/tank[2]/level-kg", getprop("/consumables/fuel/tank[2]/level-kg") - 3);
						setprop("/consumables/fuel/tank[3]/level-kg", getprop("/consumables/fuel/tank[3]/level-kg") - 6);
						setprop("/consumables/fuel/tank[4]/level-kg", getprop("/consumables/fuel/tank[4]/level-kg") - 3);
						setprop("/consumables/fuel/tank[5]/level-kg", getprop("/consumables/fuel/tank[5]/level-kg") - 3);
						setprop("/consumables/fuel/tank[6]/level-kg", getprop("/consumables/fuel/tank[6]/level-kg") - 0.5);

						if(loop_id > 3) fuel_truck.setValue(1.2);

					} else {
						setprop("/voodoomaster/ground-service/fuel-truck/clean", 0);
						screen.log.write("Finished draining the fuel tanks...", 1, 1, 1);
					}
				} else {
					setprop("/voodoomaster/ground-service/fuel-truck/clean", 0);
					screen.log.write("ABORT! Please OPEN your crossfeed valves before draining!", 1, 0, 0);
				}
			}

		}

		if (loop_id > 6) {
			loop_id = 0;
		}
		settimer(clean_or_refuel, 0.12);
	} else {
		setprop("/voodoomaster/ground-service/fuel-truck/transfer", 0);
		setprop("/voodoomaster/ground-service/fuel-truck/connect", 0);
		setprop("/voodoomaster/ground-service/fuel-truck/clean", 0);
		setprop("/voodoomaster/ground-service/fuel-truck/state", 0);
	}
};

#setlistener("/voodoomaster/ground-service/fuel-truck/enable", func{
#	clean_or_refuel();
#},1,0);

var weights = props.globals.getNode("/payload").getChildren("weight");

if (size(weights)>0) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[0]") or 0;
		var wt=props.globals.getNode("/payload/weight[0]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[0]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[0]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>1) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[1]") or 0;
		var wt=props.globals.getNode("/payload/weight[1]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[1]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[1]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>2) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[2]") or 0;
		var wt=props.globals.getNode("/payload/weight[2]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[2]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[2]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>3) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[3]") or 0;
		var wt=props.globals.getNode("/payload/weight[3]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[3]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[3]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>4) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[4]") or 0;
		var wt=props.globals.getNode("/payload/weight[4]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[4]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[4]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>5) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[5]") or 0;
		var wt=props.globals.getNode("/payload/weight[5]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[5]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[5]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>6) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[6]") or 0;
		var wt=props.globals.getNode("/payload/weight[6]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[6]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[6]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>7) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[7]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[7]") or 0;
		var wt=props.globals.getNode("/payload/weight[7]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[7]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[7]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>8) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[8]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[8]") or 0;
		var wt=props.globals.getNode("/payload/weight[8]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[8]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[8]", lbs);  
			count_all();
		}
	},1,0);
}	

if (size(weights)>9) {
	setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[9]", func() {
		var lbs = props.globals.getNode("/fdm/jsbsim/inertia").getValue("pointmass-weight-lbs[9]") or 0;
		var wt=props.globals.getNode("/payload/weight[9]").getValue("weight-type");
		setprop("voodoomaster/passengers/weight-kg[9]", lbs*0.45359237);
		if (wt=="crew" or wt=="passengers") {
			lbs = (lbs > 0) ? lbs/180 : 0;  # 180lbs per crew member or passenger
			setprop("voodoomaster/passengers/count[9]", lbs);  
			count_all();
		}
	},1,0);
}	

settimer(generalConversions, 1.0);

