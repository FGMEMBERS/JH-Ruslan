var SettingsDialog = {


	buttons: [
			 [nil, nil, nil, nil, nil, nil],
			 [nil, nil, nil, nil, nil, nil],
			 [nil, nil, nil, nil, nil, nil],
			 [nil, nil, nil, nil, nil, nil],
			 [nil, nil, nil, nil, nil, nil],
			 [nil, nil, nil, nil, nil, nil]
		],

	srow: -1,
	scol: -1,

	new: func(width=440,height=160) {
		var m = {
			parents: [SettingsDialog],
			_dlg: canvas.Window.new([width, height], "dialog")
		};

		m._dlg.getCanvas(1).set("background", canvas.style.getColor("bg_color"));
		m._root = m._dlg.getCanvas().createGroup();
 
		var vbox = canvas.VBoxLayout.new();
		m._dlg.setLayout(vbox);

		var settings_base = props.globals.getNode("/voodoomaster/settings");
		if (settings_base != nil) {
			var settings = settings_base.getChildren("setting");
		} else {
			var settings = [];
		}

		for (var i=0; i<size(settings); i+=1) {
			var s = settings[i];

			var options=props.getNode("/voodoomaster/settings/setting["~i~"]/options").getChildren("opt");
			var sname = s.getNode("name", 1).getValue();
			var hbox=canvas.HBoxLayout.new();
			vbox.addItem(hbox);
			var line=canvas.gui.widgets.Label.new(m._root, canvas.style, {});
			line.setText(sname);
			hbox.addItem(line);
			var scurrent = s.getNode("current", 1).getValue();
			for (var j=0; j<size(options); j+=1) {
				var o=options[j];
				var action=o.getNode("name", 1).getValue();
				me.buttons[i][j]=canvas.gui.widgets.Button.new(m._root, canvas.style, {}).setText(o.getNode("name", 1).getValue());
				me.buttons[i][j].setCheckable(1);
				if (j==scurrent) {
					me.buttons[i][j].setChecked(1);
				} else {
					me.buttons[i][j].setChecked(0);
				}

				#### up to 6 options per selection ####
				if (i==0) {
					if (j==0) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(0, 0);
						});
					}
				}
				if (i==0) {
					if (j==1) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(0, 1);
						});
					}
				}
				if (i==0) {
					if (j==2) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(0, 2);
						});
					}
				}
				if (i==0) {
					if (j==3) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(0, 3);
						});
					}
				}
				if (i==0) {
					if (j==4) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(0, 4);
						});
					}
				}
				if (i==0) {
					if (j==6) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(0, 5);
						});
					}
				}

				#### up to 6 options per selection ####
				if (i==1) {
					if (j==0) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(1, 0);
						});
					}
				}
				if (i==1) {
					if (j==1) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(1, 1);
						});
					}
				}
				if (i==1) {
					if (j==2) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(1, 2);
						});
					}
				}
				if (i==1) {
					if (j==3) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(1, 3);
						});
					}
				}
				if (i==1) {
					if (j==4) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(1, 4);
						});
					}
				}
				if (i==1) {
					if (j==6) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(1, 5);
						});
					}
				}

				#### up to 6 options per selection ####
				if (i==2) {
					if (j==0) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(2, 0);
						});
					}
				}
				if (i==2) {
					if (j==1) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(2, 1);
						});
					}
				}
				if (i==2) {
					if (j==2) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(2, 2);
						});
					}
				}
				if (i==2) {
					if (j==3) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(2, 3);
						});
					}
				}
				if (i==2) {
					if (j==4) {
						me.button.listen("clicked", func{
							me.switch(2, 4);
						});
					}
				}
				if (i==2) {
					if (j==6) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(2, 5);
						});
					}
				}

				#### up to 6 options per selection ####
				if (i==3) {
					if (j==0) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(3, 0);
						});
					}
				}
				if (i==3) {
					if (j==1) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(3, 1);
						});
					}
				}
				if (i==3) {
					if (j==2) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(3, 2);
						});
					}
				}
				if (i==3) {
					if (j==3) {
						me.button.listen("clicked", func{
							me.switch(3, 3);
						});
					}
				}
				if (i==3) {
					if (j==4) {
						ne.buttons[i][j].listen("clicked", func{
							me.switch(3, 4);
						});
					}
				}
				if (i==3) {
					if (j==6) {
						me.button.listen("clicked", func{
							me.switch(3, 5);
						});
					}
				}

				#### up to 6 options per selection ####
				if (i==4) {
					if (j==0) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(4, 0);
						});
					}
				}
				if (i==4) {
					if (j==1) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(4, 1);
						});
					}
				}
				if (i==4) {
					if (j==2) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(4, 2);
						});
					}
				}
				if (i==4) {
					if (j==3) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(4, 3);
						});
					}
				}
				if (i==4) {
					if (j==4) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(4, 4);
						});
					}
				}
				if (i==4) {
					if (j==6) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(4, 5);
						});
					}
				}

				#### up to 6 options per selection ####
				if (i==5) {
					if (j==0) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(5, 0);
						});
					}
				}
				if (i==5) {
					if (j==1) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(5, 1);
						});
					}
				}
				if (i==5) {
					if (j==2) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(5, 2);
						});
					}
				}
				if (i==5) {
					if (j==3) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(5, 3);
						});
					}
				}
				if (i==5) {
					if (j==4) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(5, 4);
						});
					}
				}
				if (i==5) {
					if (j==6) {
						me.buttons[i][j].listen("clicked", func{
							me.switch(5, 5);
						});
					}
				}
				hbox.addItem(me.buttons[i][j]);
			}
		}

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

		return m;
	}, 

	switch: func (row, col) {
		if ((me.srow<0)) {
			if ((me.scol<0)) {
				me.srow=row;
				me.scol=col;
			}
		}
		for (var c=0; c<6; c+=1) {
			if (me.buttons[row][c]!=nil) {
				if (c!=col) {
					me.buttons[row][c].setChecked(0);
				} else {
					if (me.srow==row) {
						if (me.scol==col) {
							setprop("/voodoomaster/settings/setting["~row~"]/current", c);
							var prop=getprop("/voodoomaster/settings/setting["~row~"]/options/opt["~c~"]/pkey");
							var val=getprop("/voodoomaster/settings/setting["~row~"]/options/opt["~c~"]/value");
							setprop(prop, val);
						}
					}
				}
			}
		}
		if (me.srow==row) {
			if (me.scol==col) {
				me.srow=-1;
				me.scol=-1;
			}
		}
	}

};


