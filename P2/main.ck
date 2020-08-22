// Gabriel Birman and Reid Kairalla
// September 26th, 2018
// Description: plays music

// stdin used for beat length
// recommended: 120 ms 
Std.atoi(me.arg(0)) => float beatLenInMS;

// constants
1 => int key;
beatLenInMS::ms => dur beat;
beat * 100 => dur noiseDur;
beat * 6 => dur bassBeat;
2,147,483,647 => int NaN; 


// Midi Frequencies
62 => int D4;
57 => int A3; 
65 => int F4; 
A3+12 => int A4;
D4+12 => int D5;

// number of triplets in melodic stanza 
14 => int tripletNum;

fun void noiseFromSound(int freq, dur length){
    Noise n => ADSR e2 => BPF f => dac;
    f.freq(Std.mtof(freq));
    Step s => ADSR e => blackhole;
    
    e.set(length, 0::ms, 0, 0::ms);
    e.keyOn();
    e2.set(length/8, 7*length/8, 0, 0::ms);
    e2.keyOn();
    spork~changeBPFInverse(e, f, n);
    length => now;
    n =< dac;
}


fun void soundFromNoise(int freq, dur length){
    Noise n => ADSR e2 => BPF f => dac;
    f.freq(Std.mtof(freq));
    Step s => ADSR e => blackhole;
    f.Q(1);
    e2.set(7*length/8, length/8, 0, 0::ms);
    e.set(length, 0::ms, 0, 0::ms);
    e.keyOn();
    e2.keyOn();
    spork~changeBPF(e, f, n, length);
    length => now;
    n =< dac;
}


fun void makeHeld(int note, dur length){ //make held note (bass drone)
    SawOsc n => NRev rev => Delay d => LPF f => ADSR e => dac;
    n.freq(Std.mtof(note));
    .3 => float g;
    n.gain(g);
    rev.mix(.2); //reverb on bass drone
    d.max(length*2);
    d.delay(length*2); //delay on bass drone
    e.set(length, length*2, .5, length/2);
    Step dummy => ADSR e2 => blackhole; //used to produce slight oscillations in drone filter
    e2.set(length*2, length, .4, length*1.5);   
    spork~ changeOscillations(e2, n, g, f, length*8);
    e.keyOn();
    e2.keyOn(); //keyoff for oscillation
    length*2 => now;
    e2.keyOff();
    length => now;
    e2.keyOn();
    length*4 => now;
    e.keyOff(); //keyoff for drone sound
    e2.keyOff();
    length*2 => now;
    n =< dac;
}


fun void changeBPF(ADSR lowfreq, BPF f, Noise n, dur len){
    len + now => time end;
    while(now < end){
        f.Q(1+(lowfreq.value()*30)); //over time, narrow band pass filter on noise to produce a tone
        n.gain(.5-(lowfreq.value()*5)); //increase gain of noise to make tone audible
        4::samp => now;
    }
}
fun void changeBPFInverse(ADSR lowfreq, BPF f, Noise n){
    while(true){
        f.Q(Math.min((1/(lowfreq.value())), 20)); //over time, widen band pass filter on noise to release tone
        n.gain(Math.min(1/lowfreq.value(), 7)); //decrease gain of noise as band pass filter is widened
        4::samp => now;
    }   
}

fun void changeOscillations(ADSR lowfreq, Osc oscillator, float gain, FilterBasic f, dur len){
    len + now => time end;
    while(now < end){
        f.freq((lowfreq.value() * 200.0)+100.0); //change frequency of filter over time
        oscillator.gain(gain*(lowfreq.value()+.5)); //change volume of oscillator slightly over time
        10::samp => now;
    }   
}




//play the melody
fun void playMelody() {
    
    playMelody(D4, 0);
    
    spork ~playMelody(A3, 2);
    playTriplets(D4, tripletNum);
    
    spork ~ playMelody(A3, 3);
    spork ~ playMelody(D4, 0);
    playTriplets(D4, tripletNum);
    
    spork ~ playMelody(D4, 1);
    spork ~ playMelody(A3, 2);
    spork ~ playTriplets(D4, tripletNum);
    playTriplets(A4, tripletNum);

    spork ~ playMelody(A4, 3);
    spork ~ playMelody(D5, 0);
    spork~ playTriplets(D4, tripletNum);
    spork~ playTriplets(A4, tripletNum); 
    
    Note sustainedD5;
    sustainedD5.setFreq(D5);
    sustainedD5.setEmphasis(1);
    sustainedD5.setDur(beat*3*tripletNum);
    sustainedD5.play();
}

// play Triplet with trill
fun void playTriplet(int mNotes[], int length[], int emphasis[], int trill[]) {
    
    Note n;
    for (0 => int i; i < 3; i++) { 
        n.setFreq(mNotes[i]);
        n.setLength(length[i]);
        n.setEmphasis(emphasis[i]);
        n.setTrill(trill[i]);
        n.setDur(beat); 
        n.play();
    }

}

// play Triplet without trill
fun void playTriplet(int mNotes[], int length[], int emphasis[]) {
    
    Note n;
    for (0 => int i; i < 3; i++) { 
        n.setFreq(mNotes[i]);
        n.setLength(length[i]);
        n.setEmphasis(emphasis[i]);
        //n.setTrill(NaN);
        n.setDur(beat); 
        n.play();
    }
    
    n.remove();
    
}
 
 // play a 6/8 triplet at midi frequency p 
 fun void playTriplets(int p, int num) { 
     for (0 => int i; i < num; i++) {
         playTriplet([p,p,p],[0,0,0],[1,0,0]);
     }
 }
 
 // play melody with starting midi frequency p
 fun void playMelody(int p, int ending) {
     
     spork ~ makeHeld(p, bassBeat);
     
     playTriplet([p,p,p],[0,0,0],[0,0,0],[NaN,2,NaN]);
     playTriplet([p-2,p,p+2],[0,0,0],[0,0,0]); 
     playTriplet([p+3,p+2,p],[1,0,0],[1,0,0]);
     playTriplet([p+2,p,p-2],[1,0,0],[1,0,0]);   
     
     spork ~ makeHeld(p, bassBeat);

     playTriplet([p,p,p],[0,0,0],[0,0,0],[NaN,2,NaN]); 
     playTriplet([p-2,p,p+2],[0,0,0],[0,0,0]); 
     playTriplet([p+3,p+2,p],[1,0,0],[1,0,0]);
     playTriplet([p+5,p+3,p+2],[1,0,0],[1,0,0]);
     
     playTriplet([p,p,p],[0,0,0],[0,0,0],[NaN,2,NaN]); 
     playTriplet([p-2,p,p+2],[0,0,0],[0,0,0]); 
     playTriplet([p+3,p+2,p],[1,0,0],[1,0,0]);
     playTriplet([p+2,p,p-2],[1,0,0],[1,0,0]);  
     

    if (ending == 0) { // D first 
        playTriplet([p,p-2,p-3],[1,0,0],[1,0,0]);
        playTriplet([p-2,p-3,p-5],[1,0,0],[1,0,0]);
    } else if (ending == 1) { // D second
        playTriplet([p-2,p,p+2],[1,0,0],[1,0,0]);
        playTriplet([p,p+2,p+3],[1,0,0],[1,0,0]);  
    } else if (ending == 2) { // A first
        playTriplet([p,p+2,p+3],[1,0,0],[1,0,0]); 
        playTriplet([p+2,p+3,p+5],[1,0,0],[1,0,0]);
    } else if (ending == 3) { // A second
        playTriplet([p-2,p,p-2],[1,0,0],[1,0,0]); 
        playTriplet([p,p-2,p-4],[1,0,0],[1,0,0]);
    }

}


// Note object that can be played
class Note { 
    
    // instance fields with default numbers 
    69 => int freq; // midi frequency  
    1 => int length; // boolean: 1 for slurred, 0 for staccato
    0 => int emphasis; // boolean: 1 for accent, 0 for no accent  
    0.5::second => dur duration; // duration of note to be played
    NaN => int trill; // the trill interval
    
    // sound qualities
    SawOsc s => BPF f => ADSR e => dac;
    f.set(1300,0.5);
    
    // trill length 
    1.9 => float trillDiv;

    // function that returns frequency
    fun int getFreq() { return freq; }
    
    // function to set the value of frequency
    fun void setFreq( int value ) { value => freq; }
    
    // function that returns length
    fun int getLength() { return length; }
    
    // function to set the value of length
    fun void setLength( int value ) { value => length; }
    
    // function that returns emphasis
    fun int getEmphasis() { return emphasis; }
    
    // function to set the value of emphasis
    fun void setEmphasis( int value ) { value => emphasis; }
    
    // function that returns duration
    fun dur getDur() { return duration; }
    
    // function to set the value of duration
    fun void setDur( dur value ) { value => duration; }
    
    // function that returns trill
    fun int getTrill() { return trill; }
    
    // function to set the value of trill
    fun void setTrill( int value ) { value => trill; } 
    
    fun void remove () {
        s =< dac;
    }
    // plays note either legato or staccato 
    fun void setEnvelope(int length) {
        if (length == 0) { // legato
            e.set(2::ms, 100::ms, 0.01, 0::ms);
        } else if (length == 1) { // slurred
            e.set(2::ms, 100::ms, 0.3, 0::ms);
        }
    }
    
    // determines whether to place emphasis on note
    fun void setGain(int emphasis) {
        if (emphasis == 0) { // softer
            s.gain(0.05);
        } else if (emphasis == 1) { // louder
            s.gain(0.1);
        }
    }
    
    // plays the Note object without a trill
    fun void playNote() {
        setGain(emphasis); 
        s.freq(Std.mtof(freq));
        setEnvelope(length);
        e.keyOn();
        duration => now;
        e.keyOff();
    }
    
    // subdivides the note into a simple mordent
    fun void playTrill() {
        setLength(0); 
        setEmphasis(1);
        setDur(duration/trillDiv);
        playNote();
        
        setFreq(freq+trill);
        setLength(0); 
        setEmphasis(0); 
        setDur(duration*(trillDiv/2)); 
        playNote();
        
    }
    
    // play the Note object
    fun void play() {
        
        if (trill != NaN) 
        {
            playTrill(); 
            
        } else {
            playNote();
        }
    }
 
}

//main here

spork ~ soundFromNoise(D4, noiseDur);
noiseDur - beat*6 => now;
playMelody();

noiseFromSound(D5, noiseDur);
