/*

telephones and birds

only supports mono sound files
put all sound files in a directory, update path of ~buffers

*/


///////// SETUP /////////

s.options.memSize = 2097152;
s.boot;

(
a = currentEnvironment;
w = Window.new("telephones and birds", Rect(200,200,1265,640));

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

	//make the busses and the synths

	a[("vol"++i).asSymbol] = Bus.control(s,1).set(0.0);
	a[("trig"++i).asSymbol] = Bus.control(s,1).set(0);
	Synth(\play, [\buffer, ~buffers[i], \amp, a[("vol"++i).asSymbol].asMap, \trig, a[("trig"++i).asSymbol].asMap]);


	// changes row based on step (i)

	if( (i >= 0) && (i <= 10), {
		postln( "i is " + i );
		"gui row 1".postln;
		row = 0;
	});

	if( (i > 10) && (i <= 21), {
		postln( "i is " + i );
		"gui row 2".postln;
		row = 1;
	});

	if( (i > 21) && (i <32), {
		postln( "i is " + i );
		"gui row 3".postln;
		row = 2;
	});

	// change which row we are on

	switch( row,
		0, {
		"we are on row1".postln;

		b = Button(w, Rect( buttonH1, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		sliders[i] = Slider.new(w, Rect(sliderH1, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		buttonH1 = buttonH1 + spacing;
		sliderH1 = sliderH1 + spacing;

	},
	1, {
		"we are on row2".postln;

		vertical = 220;

		b = Button(w, Rect( buttonH2, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		sliders[i] = Slider.new(w, Rect(sliderH2, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		buttonH2 = buttonH2 + spacing;
		sliderH2 = sliderH2 + spacing;

	},

	2, {

		"we are on row3".postln;

		vertical = 430;

		b = Button(w, Rect( buttonH3, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

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

// trouble shooting

a.clear;