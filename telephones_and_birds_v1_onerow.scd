/*

telephones and birds

todo:
number of samples in directory controls how many synth instances

control panel (per synth instance)
volume
play

always loop

*/

///////// SETUP /////////

s.options.memSize = 1048576;
s.boot;

(
a = currentEnvironment;
w = Window.new("telephones and birds", Rect(200,200,1300,250));

// make the buffers
~buffers = "/Users/mdp/Desktop/telephones_birds/*".pathMatch.collect{ | file | Buffer.read( s, file ); };
)

///////// SYNTH /////////
(
SynthDef(\play, {| out = 0, buffer, amp = 0.0, trig = 0 |
	var env, play;

	env = EnvGen.kr( Env.asr( 0.01, amp, 0.01 ), trig, doneAction:0 );
	play = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer), loop: 1);
	Out.ar([0,1], play * env * amp );
}).add;
)

(
var len = ((~buffers.size)-1);
var button_h = 10;
var slider_h = 65;
var spacing = 115;
var vertical = 10;
var sliders;
var row = 0;

sliders = Array.newClear(~buffers.size);

for( 0, len, { arg i;

	//make the busses and the synths

	a[("vol"++i).asSymbol] = Bus.control(s, 1).set(0.5);
	a[("trig"++i).asSymbol] = Bus.control(s,1).set(0);
	Synth(\play, [\buffer, ~buffers[i], \amp, a[("vol"++i).asSymbol].asMap, \trig, a[("trig"++i).asSymbol].asMap]);


	// make the gui
	// toggle on/off

		b = Button(w, Rect( button_h, vertical, 50, 50))
		.states_([
			["OFF", Color.white, Color.black],
			["ON", Color.white, Color.red]
		])
		.action_({ arg butt;
			a[("trig"++i).asSymbol].set( butt.value );
		});

		sliders[i] = Slider.new(w, Rect(slider_h, vertical, 50, 200))
		.action_({
			a[("vol"++i).asSymbol].set(sliders[i].value);
		});

		button_h = button_h + spacing;
		slider_h = slider_h + spacing;

});

w.front;

)

// trouble shooting

a.clear;