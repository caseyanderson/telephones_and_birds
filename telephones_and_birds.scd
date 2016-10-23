/*

telephones and birds, john cage
sample player for southland ensemble, casey anderson

supports mono sound files
put all sound files in a directory, update path to directory at ~buffers

*/


///////// SETUP /////////

s.options.memSize = 2097152;
s.boot;

(
a = currentEnvironment;
w = Window.new("telephones and birds", Rect(100,0,1275,640));

// make the buffers

~buffers = "/Users/mdp/Desktop/telephones_birds/*".pathMatch.collect{ | file | Buffer.read( s, file ); };
)


///////// SYNTH /////////

(
SynthDef(\play, {| out = 0, buffer, amp = 0.0, trig = 0, pos = 0 |
	var env, play;

	env = EnvGen.kr( Env.asr( 0.01, amp, 0.01 ), trig, doneAction:0 );
	play = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer), loop: 1);
	Out.ar([0,1], play * env * amp );
}).add;
)


///////// MAKE ALL THE THINGS /////////

(
var len = ((~buffers.size)-1);
var buttonH1 = 10;
var buttonH2 = 10;
var buttonH3 = 10;

var sliderH1 = 65;
var sliderH2 = 65;
var sliderH3 = 65;

var spacing = 115;
var vertical = 10;
var sliders;
var row = 0;

sliders = Array.newClear(~buffers.size);


for( 0, len, { arg i;

	// make the busses and the synths

	a[("vol"++i).asSymbol] = Bus.control(s,1).set(0.0);
	a[("trig"++i).asSymbol] = Bus.control(s,1).set(0);
	Synth(\play, [\buffer, ~buffers[i], \amp, a[("vol"++i).asSymbol].asMap, \trig, a[("trig"++i).asSymbol].asMap]);


	// check for step (i), set row number (row)

	if( (i >= 0) && (i <= 10), {
		row = 0;
	});

	if( (i > 10) && (i <= 21), {
		row = 1;
	});

	if( (i > 21) && (i <32), {
		row = 2;
	});


	// set the row, make the gui

	switch( row,

	0, {

		b = Button(w, Rect( buttonH1, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		h = NumberBox(w, Rect(buttonH1, vertical + 60, 50, 50));
			h.align = \center;
			h.value = (i + 1);

		sliders[i] = Slider.new(w, Rect(sliderH1, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		buttonH1 = buttonH1 + spacing;
		sliderH1 = sliderH1 + spacing;

	},

	1, {

		vertical = 220;

		b = Button(w, Rect( buttonH2, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		h = NumberBox(w, Rect(buttonH2, vertical + 60, 50, 50));
			h.align = \center;
			h.value = (i + 1);

		sliders[i] = Slider.new(w, Rect(sliderH2, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		buttonH2 = buttonH2 + spacing;
		sliderH2 = sliderH2 + spacing;

	},

	2, {

		vertical = 430;

		b = Button(w, Rect( buttonH3, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		h = NumberBox(w, Rect(buttonH3, vertical + 60, 50, 50));
			h.align = \center;
			h.value = (i + 1);

		sliders[i] = Slider.new(w, Rect(sliderH3, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		buttonH3 = buttonH3 + spacing;
		sliderH3 = sliderH3 + spacing;

		});

});

w.front;

)