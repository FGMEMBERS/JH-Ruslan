var AutostartDialog = {

	status: "",

	statuslabel: nil,
	line: nil,

	new: func(width=450,height=160) {
		var m = {
			parents: [SettingsDialog],
			_dlg: canvas.Window.new([width, height], "mxTitle")
		};

		m._dlg.getCanvas(1)
		.set("background", canvas.style.getColor("bg_color"));
		m._root = m._dlg.getCanvas().createGroup();
 
		var vbox = canvas.VBoxLayout.new();
		m._dlg.setLayout(vbox);

		var sname = "...";
		var hbox=canvas.HBoxLayout.new();
		vbox.addItem(hbox);
		me.line=canvas.gui.widgets.Label.new(m._root, canvas.style, {});
		me.line.setText(sname);
		hbox.addItem(me.line);
		me.statuslabel=canvas.gui.widgets.Label.new(m._root, canvas.style, {});
		me.statuslabel.setText("...");
		hbox.addItem(me.statuslabel);

		var hbox2=canvas.HBoxLayout.new();
		vbox.addItem(hbox2);
		btnClose=canvas.gui.widgets.Button.new( m._root, canvas.style, {}).setText("Close Window");
		btnClose.listen("clicked", func{
			m._dlg.del();
		});

		hbox2.addItem(btnClose);
		var hint = vbox.sizeHint();
		hint[0] = math.max(width, hint[0]);
		m._dlg.setSize(hint);

		setlistener("/sim/model/start-idling", func(idle) {
			var run= idle.getBoolValue();
			if (run) {
				me.startup();
			} else {
				me.shutdown();
			}
		});

		setlistener("/voodoomaster/internal/message-switcher", func() {
			var msg=getprop("voodoomaster/internal/message-switcher");
			me.statuslabel.setText(msg);
		});

		setlistener("/voodoomaster/internal/message-switcher", func() {
			var msg=getprop("voodoomaster/internal/message-header");
			me.line.setText(msg);
		});

		return m;
	}, 

	startup: func {
		setprop("voodoomaster/internal/message-header", "Automatic Start Sequence:");
		var seconds=1;

		settimer(me.batstart, 1);

		if (getprop("/voodoomaster/systems/electrical/number-apus")>0) {
			settimer(me.apustart0, 6);
			seconds=6;
		}
		if (getprop("/voodoomaster/systems/electrical/number-apus")>1) {
			settimer(me.apustart1, 8);
			seconds=8;
		}
		if (getprop("/voodoomaster/systems/electrical/number-apus")>2) {
			settimer(me.apustart2, 10);
			seconds=10;
		}
		if (getprop("/voodoomaster/systems/electrical/number-apus")>3) {
			settimer(me.apustart3, 12);
			seconds=12;
		}

		if (getprop("/voodoomaster/systems/fuel/number-pumps")>0) {
			seconds=seconds+2;
			settimer(me.pumpstart0, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>1) {
			seconds=seconds+2;
			settimer(me.pumpstart1, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>2) {
			seconds=seconds+2;
			settimer(me.pumpstart2, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>3) {
			seconds=seconds+2;
			settimer(me.pumpstart3, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>4) {
			seconds=seconds+2;
			settimer(me.pumpstart4, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>5) {
			seconds=seconds+2;
			settimer(me.pumpstart5, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>6) {
			seconds=seconds+2;
			settimer(me.pumpstart6, seconds);
		}
		if (getprop("/voodoomaster/systems/fuel/number-pumps")>7) {
			seconds=seconds+2;
			settimer(me.pumpstart7, seconds);
		}

		var engines_base = props.globals.getNode("/voodoomaster/systems/engines");
		if (engines_base != nil) {
			var sets = engines_base.getChildren("set");
		} else {
			var sets = [];
		}
		
		var engoffset=0;

		seconds=seconds+2;
		for (var i=0; i<size(sets); i+=1) {
			var s = sets[i];
			var ename = s.getNode("name", 1).getValue();
			if (ename==getprop("engines/engine-set")) {
				for (var j=0; j<s.getNode("number",1).getValue(); j+=1) {
					if ((engoffset+j)==0) {
						settimer(me.engstart0, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==1) {
						settimer(me.engstart1, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==2) {
						settimer(me.engstart2, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==3) {
						settimer(me.engstart3, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==4) {
						settimer(me.engstart4, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==5) {
						settimer(me.engstart5, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==6) {
						settimer(me.engstart6, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==7) {
						settimer(me.engstart7, seconds);
						seconds=seconds+2;
					}
				}
			} else {
				engoffset=engoffset+s.getNode("number",1).getValue();
			}
		}
		
		engoffset=0;

		seconds=seconds+5;
		for (var i=0; i<size(sets); i+=1) {
			var s = sets[i];
			var ename = s.getNode("name", 1).getValue();
			if (ename==getprop("engines/engine-set")) {
				for (var j=0; j<s.getNode("number",1).getValue(); j+=1) {
					if ((engoffset+j)==0) {
						settimer(me.engnorm0, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==1) {
						settimer(me.engnorm1, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==2) {
						settimer(me.engnorm2, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==3) {
						settimer(me.engnorm3, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==4) {
						settimer(me.engnorm4, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==5) {
						settimer(me.engnorm5, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==6) {
						settimer(me.engnorm6, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==7) {
						settimer(me.engnorm7, seconds);
						seconds=seconds+5;
					}
				}
			} else {
				engoffset=engoffset+s.getNode("number",1).getValue();
			}
		}
		
		engoffset=0;

		seconds=seconds+5;
		for (var i=0; i<size(sets); i+=1) {
			var s = sets[i];
			var ename = s.getNode("name", 1).getValue();
			if (ename==getprop("engines/engine-set")) {
				for (var j=0; j<s.getNode("number",1).getValue(); j+=1) {
					if ((engoffset+j)==0) {
						settimer(me.engwatch0, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==1) {
						settimer(me.engwatch1, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==2) {
						settimer(me.engwatch2, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==3) {
						settimer(me.engwatch3, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==4) {
						settimer(me.engwatch4, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==5) {
						settimer(me.engwatch5, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==6) {
						settimer(me.engwatch6, seconds);
						seconds=seconds+5;
					}
					if ((engoffset+j)==7) {
						settimer(me.engwatch7, seconds);
						seconds=seconds+5;
					}
				}
			} else {
				engoffset=engoffset+s.getNode("number",1).getValue();
			}
		}
	},

	shutdown: func {
		setprop("voodoomaster/internal/message-header", "Automatic Shutdown Sequence:");
		var seconds=1;
	
		var engines_base = props.globals.getNode("/voodoomaster/systems/engines");
		if (engines_base != nil) {
			var sets = engines_base.getChildren("set");
		} else {
			var sets = [];
		}
	
		var engoffset=0;

		seconds=seconds+2;
		for (var i=0; i<size(sets); i+=1) {
			var s = sets[i];
			var ename = s.getNode("name", 1).getValue();
			if (ename==getprop("engines/engine-set")) {
				for (var j=0; j<s.getNode("number",1).getValue(); j+=1) {
					if ((engoffset+j)==0) {
						settimer(me.engstop0, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==1) {
						settimer(me.engstop1, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==2) {
						settimer(me.engstop2, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==3) {
						settimer(me.engstop3, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==4) {
						settimer(me.engstop4, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==5) {
						settimer(me.engstop5, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==6) {
						settimer(me.engstop6, seconds);
						seconds=seconds+2;
					}
					if ((engoffset+j)==7) {
						settimer(me.engstop7, seconds);
						seconds=seconds+2;
					}
				}
			} else {
				engoffset=engoffset+s.getNode("number",1).getValue();
			}
		}



#		settimer(batstart, 1);
#		settimer(apustart, 6);
#		settimer(pump0start, 8);
#		settimer(pump1start, 12);

#		if (getprop("engines/engine-set")=="DT18T") {
#			settimer(eng1start, 16);
#			settimer(eng4start, 18);
#			settimer(eng2start, 20);
#			settimer(eng3start, 22);
#		} 
#		if (getprop("engines/engine-set")=="GP7277") {
#			settimer(eng5start, 16);
#			settimer(eng8start, 18);
#			settimer(eng6start, 20);
#			settimer(eng7start, 22);
#		}
#
#		if (getprop("engines/engine-set")=="DT18T") {
#			settimer(eng1norm, 24);
#			settimer(eng4norm, 26);
#			settimer(eng2norm, 28);
#			settimer(eng3norm, 30);
#		}
#		if (getprop("engines/engine-set")=="GP7277") {
#			settimer(eng5norm, 24);
#			settimer(eng8norm, 26);
#			settimer(eng6norm, 28);
#			settimer(eng7norm, 30);
#		}
#
#		if (getprop("engines/engine-set")=="DT18T") {
#			settimer(eng1watch, 32);
#			settimer(eng4watch, 34);
#			settimer(eng2watch, 36);
#			settimer(eng3watch, 38);
#		}
#		if (getprop("engines/engine-set")=="GP7277") {
#			settimer(eng5watch, 32);
#			settimer(eng8watch, 34);
#			settimer(eng6watch, 36);
#			settimer(eng7watch, 38);
#		}
	},

	batstart: func {
		setprop("controls/electric/battery-switch",1);
		setprop("voodoomaster/internal/message-switcher", "System on battery, starting APU!");
	},

	apustart0: func {
		setprop("controls/APU/off-start-run", 1);
		setprop("controls/electric/APU-generator", 1);
		setprop("voodoomaster/internal/message-switcher", "APU1 starting!");
	},

	apustart1: func {
		setprop("controls/APU/off-start-run", 1);
		setprop("controls/electric/APU-generator", 1);
		setprop("voodoomaster/internal/message-switcher", "APU2 starting!");
	},

	apustart2: func {
		setprop("controls/APU/off-start-run", 1);
		setprop("controls/electric/APU-generator", 1);
		setprop("voodoomaster/internal/message-switcher", "APU3 starting!");
	},

	apustart3: func {
		setprop("controls/APU/off-start-run", 1);
		setprop("controls/electric/APU-generator", 1);
		setprop("voodoomaster/internal/message-switcher", "APU4 starting!");
	},

	pumpstart0: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump0"));
	},

	pumpstart1: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump1"));
	},

	pumpstart2: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump2"));
	},

	pumpstart3: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump3"));
	},

	pumpstart4: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump4"));
	},

	pumpstart5: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump5"));
	},

	pumpstart6: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump6"));
	},

	pumpstart7: func {
		setprop("controls/fuel/tank[0]/boost-pump[0]", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_pump7"));
	},

	engstart0: func {
		setprop("controls/electric/engine[0]/bus-tie",1);
		setprop("controls/electric/engine[0]/generator",1);
		setprop("controls/engines/engine[0]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[0]/fuel-pump", 1);
		setprop("controls/engines/engine[0]/ignition", 1);
		setprop("controls/engines/engine[0]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine0"));
	},

	engstart1: func {
		setprop("controls/electric/engine[1]/bus-tie",1);
		setprop("controls/electric/engine[1]/generator",1);
		setprop("controls/engines/engine[1]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[1]/fuel-pump", 1);
		setprop("controls/engines/engine[1]/ignition", 1);
		setprop("controls/engines/engine[1]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine1"));
	},

	engstart2: func {
		setprop("controls/electric/engine[2]/bus-tie",1);
		setprop("controls/electric/engine[2]/generator",1);
		setprop("controls/engines/engine[2]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[2]/fuel-pump", 1);
		setprop("controls/engines/engine[2]/ignition", 1);
		setprop("controls/engines/engine[2]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine2"));
	},

	engstart3: func {
		setprop("controls/electric/engine[3]/bus-tie",1);
		setprop("controls/electric/engine[3]/generator",1);
		setprop("controls/engines/engine[3]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[3]/fuel-pump", 1);
		setprop("controls/engines/engine[3]/ignition", 1);
		setprop("controls/engines/engine[3]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine3"));
	},

	engstart4: func {
		setprop("controls/electric/engine[4]/bus-tie",1);
		setprop("controls/electric/engine[4]/generator",1);
		setprop("controls/engines/engine[4]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[4]/fuel-pump", 1);
		setprop("controls/engines/engine[4]/ignition", 1);
		setprop("controls/engines/engine[4]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine4"));
	},

	engstart5: func {
		setprop("controls/electric/engine[5]/bus-tie",1);
		setprop("controls/electric/engine[5]/generator",1);
		setprop("controls/engines/engine[5]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[5]/fuel-pump", 1);
		setprop("controls/engines/engine[5]/ignition", 1);
		setprop("controls/engines/engine[5]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine5"));
	},

	engstart6: func {
		setprop("controls/electric/engine[6]/bus-tie",1);
		setprop("controls/electric/engine[6]/generator",1);
		setprop("controls/engines/engine[6]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[6]/fuel-pump", 1);
		setprop("controls/engines/engine[6]/ignition", 1);
		setprop("controls/engines/engine[6]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine6"));
	},

	engstart7: func {
		setprop("controls/electric/engine[7]/bus-tie",1);
		setprop("controls/electric/engine[7]/generator",1);
		setprop("controls/engines/engine[7]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[7]/fuel-pump", 1);
		setprop("controls/engines/engine[7]/ignition", 1);
		setprop("controls/engines/engine[7]/starter", 1);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine7"));
	},

	engnorm0: func {
		setprop("controls/engines/engine[0]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin0"));
	},

	engnorm1: func {
		setprop("controls/engines/engine[1]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin1"));
	},

	engnorm2: func {
		setprop("controls/engines/engine[2]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin2"));
	},

	engnorm3: func {
		setprop("controls/engines/engine[3]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin3"));
	},

	engnorm4: func {
		setprop("controls/engines/engine[4]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin4"));
	},

	engnorm5: func {
		setprop("controls/engines/engine[5]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin5"));
	},

	engnorm6: func {
		setprop("controls/engines/engine[6]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin6"));
	},

	engnorm7: func {
		setprop("controls/engines/engine[7]/cutoff", 0);	# now cutoff to false to make her run on her own
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engspin7"));
	},

	engwatch0: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[0]/n2");
		if (n2<49) {
			settimer(me.engwatch0, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[0]/cutoff", 1);
				setprop("controls/engines/engine[0]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch0"));
		}
	},

	engwatch1: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[1]/n2");
		if (n2<49) {
			settimer(me.engwatch1, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[1]/cutoff", 1);
				setprop("controls/engines/engine[1]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch1"));
		}
	},

	engwatch2: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[2]/n2");
		if (n2<49) {
			settimer(me.engwatch2, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[2]/cutoff", 1);
				setprop("controls/engines/engine[2]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch2"));
		}
	},

	engwatch3: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[3]/n2");
		if (n2<49) {
			settimer(me.engwatch3, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[3]/cutoff", 1);
				setprop("controls/engines/engine[3]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch3"));
		}
	},

	engwatch4: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[4]/n2");
		if (n2<49) {
			settimer(me.engwatch4, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[4]/cutoff", 1);
				setprop("controls/engines/engine[4]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch4"));
		}
	},

	engwatch5: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[5]/n2");
		if (n2<49) {
			settimer(me.engwatch5, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[5]/cutoff", 1);
				setprop("controls/engines/engine[5]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch5"));
		}
	},

	engwatch6: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[6]/n2");
		if (n2<49) {
			settimer(me.engwatch6, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[6]/cutoff", 1);
				setprop("controls/engines/engine[6]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch6"));
		}
	},

	engwatch7: func {
		var n2=getprop("fdm/jsbsim/propulsion/engine[7]/n2");
		if (n2<49) {
			settimer(me.engwatch7, 5);
			if (n2<1) {
				# re-trigger jsbsim to spin this engine up
				setprop("controls/engines/engine[7]/cutoff", 1);
				setprop("controls/engines/engine[7]/cutoff", 0);
			}
		} else {
			setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engwatch7"));
		}
	},

	engstop0: func {
		setprop("controls/electric/engine[0]/bus-tie",0);
		setprop("controls/electric/engine[0]/generator",0);
		setprop("controls/engines/engine[0]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[0]/fuel-pump", 0);
		setprop("controls/engines/engine[0]/ignition", 0);
		setprop("controls/engines/engine[0]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine0_stop"));
	},

	engstop1: func {
		setprop("controls/electric/engine[1]/bus-tie",0);
		setprop("controls/electric/engine[1]/generator",0);
		setprop("controls/engines/engine[1]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[1]/fuel-pump", 0);
		setprop("controls/engines/engine[1]/ignition", 0);
		setprop("controls/engines/engine[1]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine1_stop"));
	},

	engstop2: func {
		setprop("controls/electric/engine[2]/bus-tie",0);
		setprop("controls/electric/engine[2]/generator",0);
		setprop("controls/engines/engine[2]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[2]/fuel-pump", 0);
		setprop("controls/engines/engine[2]/ignition", 0);
		setprop("controls/engines/engine[2]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine2_stop"));
	},

	engstop3: func {
		setprop("controls/electric/engine[3]/bus-tie",0);
		setprop("controls/electric/engine[3]/generator",0);
		setprop("controls/engines/engine[3]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[3]/fuel-pump", 0);
		setprop("controls/engines/engine[3]/ignition", 0);
		setprop("controls/engines/engine[3]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine3_stop"));
	},

	engstop4: func {
		setprop("controls/electric/engine[4]/bus-tie",0);
		setprop("controls/electric/engine[4]/generator",0);
		setprop("controls/engines/engine[4]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[4]/fuel-pump", 0);
		setprop("controls/engines/engine[4]/ignition", 0);
		setprop("controls/engines/engine[4]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine4_stop"));
	},

	engstop5: func {
		setprop("controls/electric/engine[5]/bus-tie",0);
		setprop("controls/electric/engine[5]/generator",0);
		setprop("controls/engines/engine[5]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[5]/fuel-pump", 0);
		setprop("controls/engines/engine[5]/ignition", 0);
		setprop("controls/engines/engine[5]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine5_stop"));
	},

	engstop6: func {
		setprop("controls/electric/engine[6]/bus-tie",0);
		setprop("controls/electric/engine[6]/generator",0);
		setprop("controls/engines/engine[6]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[6]/fuel-pump", 0);
		setprop("controls/engines/engine[6]/ignition", 0);
		setprop("controls/engines/engine[6]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine6_stop"));
	},

	engstop7: func {
		setprop("controls/electric/engine[7]/bus-tie",0);
		setprop("controls/electric/engine[7]/generator",0);
		setprop("controls/engines/engine[7]/cutoff", 1);	# needs to be true for JSB to spin up with starter
		setprop("controls/engines/engine[7]/fuel-pump", 0);
		setprop("controls/engines/engine[7]/ignition", 0);
		setprop("controls/engines/engine[7]/starter", 0);
		setprop("voodoomaster/internal/message-switcher", getprop("/voodoomaster/internal/msg_engine7_stop"));
	},

};


