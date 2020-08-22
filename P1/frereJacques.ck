
0.5::second => dur originalQuarter; 

// Voice 1
spork ~ playMelody(originalQuarter);
8::originalQuarter => now;

// Voice 2
spork ~ playMelody(1*originalQuarter);
8::originalQuarter => now;

// Voice 3
spork ~ playMelody(1*originalQuarter);
8::originalQuarter => now;

// Voice 4
spork ~ playMelody(0.5*originalQuarter);
8::originalQuarter => now;

function void playMelody(dur d)
{
    
SinOsc myOsc => Envelope e => dac;
20::ms => dur t => e.duration;

// constants 
d => dur quarter;
2::quarter => dur half;
0.5::quarter => dur eighth;
0.1::quarter => dur x; // articulation time 
0.2 => float playVolume;
60 => int startMIDIPitch;

// Measure 1    

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play middle C 
e.keyOn();
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+2)=>myOsc.freq; //play D above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+4)=>myOsc.freq; //play E above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 2

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+2)=>myOsc.freq; //play D above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+4)=>myOsc.freq; //play E above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 3    

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+4)=>myOsc.freq; //play E above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+5)=>myOsc.freq; //play F above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+7)=>myOsc.freq; //play G above middle C 
e.keyOn(); half-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 4 

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+4)=>myOsc.freq; //play E above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+5)=>myOsc.freq; //play F above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+7)=>myOsc.freq; //play G above middle C 
e.keyOn(); half-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 5    

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+7)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+9)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+7)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+5)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+4)=>myOsc.freq; //play F above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play G above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 6    

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+7)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+9)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+7)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+5)=>myOsc.freq; //play G above middle C 
e.keyOn(); eighth-x/2=>now;
e.keyOff();
x/2=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch+4)=>myOsc.freq; //play F above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play G above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 7   

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play G above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch-5)=>myOsc.freq; //play F above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play G above middle C 
e.keyOn(); half-x=>now;
e.keyOff();
x=>now; //make time pass

// Measure 8    

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play G above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch-5)=>myOsc.freq; //play F above middle C 
e.keyOn(); quarter-x=>now;
e.keyOff();
x=>now; //make time pass

playVolume=>myOsc.gain;
Std.mtof(startMIDIPitch)=>myOsc.freq; //play G above middle C 
e.keyOn(); half-x=>now;
e.keyOff();
x=>now; //make time pass
}
