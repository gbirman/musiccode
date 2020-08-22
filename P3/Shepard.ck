
SinOsc a => ADSR e => dac;
SinOsc d => e => dac;

e.set(5::ms, 2::ms, 0.05, 1::ms); 


60 => int aMidi; 
72+12 => int dMidi;
0.0 => float aGain;
1.2 => float dGain;

1 => int counter; 
0.05 => float gainStep;
1 => float freqStep; 
24 => int iterMax; 

0.01::second => dur length; // try setting to 0.05

while(true) {
    
    spork ~ playAscending(); 
    playDescending(); 
    
    counter++;
    if ((counter % (iterMax+1)) == 0) {
        1 => counter; 
    }
    
}

fun void playAscending() {
   //d.gain(0);
   <<< counter >>>;
   a.gain(aGain+(counter-1)*gainStep);
   a.freq(Std.mtof(aMidi+(counter-1)*freqStep));
   e.keyOn();
   length => now; 
   e.keyOff();

}

fun void playDescending() {
    //a.gain(0);
    d.gain(dGain-(counter-1)*gainStep);
    d.freq(Std.mtof(dMidi-(counter-1)*freqStep));
    e.keyOn();
    length => now; 
    e.keyOff();

}