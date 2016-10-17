/*

telephones and birds

only supports mono sound files
put all sound files in a directory, update path of ~buffers

to add -> random position thing

*/


///////// SETUP /////////

s.options.memSize = 1048576;
s.boot;

(
a = currentEnvironment;
w = Window.new("telephones and birds", Rect(200,200,940,420));

// make the buffers
~buffers = "/Users/mdp/Desktop/telephones_birds/*".pathMatch.collect{ | file | Buffer.read( s, file ); };
)


///////// SYNTH /////////

(
SynthDef(\play, {| out = 0, buffer, amp = 0.0, trig = 0, pos = 0 |
	var env, play;

	env = EnvGen.kr( Env.asr( 0.01, amp, 0.01 ), trig, doneAction:0 );
	play = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer), startPos: pos, loop: 1);
	Out.ar([0,1], play * env * amp );
}).add;
)


///////// MAKE ALL THE THINGS /////////

(
var len = ((~buffers.size)-1);
var t_buttonH = 10;
var b_buttonH = 10;
var t_sliderH = 65;
var b_sliderH = 65;
var spacing = 115;
var vertical = 10;
var sliders;
var row = 0;

sliders = Array.newClear(~buffers.size);

for( 0, len, { arg i;

	//make the busses and the synths

	a[("vol"++i).asSymbol] = Bus.control(s,1).set(0.5);
	a[("trig"++i).asSymbol] = Bus.control(s,1).set(0);
	Synth(\play, [\buffer, ~buffers[i], \amp, a[("vol"++i).asSymbol].asMap, \trig, a[("trig"++i).asSymbol].asMap]);


	// make the gui

	if( row == 0, {

		b = Button(w, Rect( t_buttonH, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		sliders[i] = Slider.new(w, Rect(t_sliderH, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		t_buttonH = t_buttonH + spacing;
		t_sliderH = t_sliderH + spacing;

		// this switches from top to bottom
		if( i > 6, {
			row = 1;
			vertical = 220;
		});
	},{

		b = Button(w, Rect( b_buttonH, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		sliders[i] = Slider.new(w, Rect(b_sliderH, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		b_buttonH = b_buttonH + spacing;
		b_sliderH = b_sliderH + spacing;

	});
});

w.front;

)

// trouble shooting

a.clear;