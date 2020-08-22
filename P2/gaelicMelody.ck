
// constants
0.12::second => dur beat;
2,147,483,647 => int NaN; 

// Midi Frequencies
62 => int D4;
57 => int A3; 
65 => int F4; 
A3+12 => int A4;
D4+12 => int D5;

// number of triplets in melodic stanza 
14 => int tripletNum;

playMelody();

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
    
}
 
 // play a 6/8 triplet at midi frequency p 
 fun void playTriplets(int p, int num) { 
     for (0 => int i; i < num; i++) {
         playTriplet([p,p,p],[0,0,0],[1,0,0]);
     }
 }
 
 // play melody with starting midi frequency p
 fun void playMelody(int p, int ending) {
     
     playTriplet([p,p,p],[0,0,0],[0,0,0],[NaN,2,NaN]);
     playTriplet([p-2,p,p+2],[0,0,0],[0,0,0]); 
     playTriplet([p+3,p+2,p],[1,0,0],[1,0,0]);
     playTriplet([p+2,p,p-2],[1,0,0],[1,0,0]);   

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
        setDur(duration*(trillDiv/2)); //duration*(trillDiv/2)
        playNote();
        
        //setDur(duration*2);
        
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

class Sound {
    
    // UGens
    SinOsc u1;
    SqrOsc u2;
    SawOsc u3;
    TriOsc u4;
    Noise u5; 

    // function to set the SinOsc to u 
    fun void setSinOsc(SinOsc u) { u => u1; }
    
    // function to set the SqrOsc to u 
    fun void setSinOsc(SqrOsc u) { u => u2; }
    
    // function to set the SinOsc to u 
    fun void setSinOsc(SawOsc u) { u => u3; }
    
    // function to set the SqrOsc to u 
    fun void setTriOsc(TriOsc u) { u => u4; }
    
    // function to set the Noise to u 
    fun void setNoise(Noise u) { u => u5; }
        
}
