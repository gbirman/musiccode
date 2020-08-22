
[0,0,0,0,1,0,0,1,0,0,1,0,1,0,0,0]  @=> int snarePattern[];
[1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,0]  @=> int kickPattern[];
[0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0]  @=> int HHPattern[];

[1,0,0,1,1,0,1,0,0,1,1,0,1,0,0,0]  @=> int snare2Pattern[];
[0,1,1,0,0,1,0,1,1,0,0,1,0,1,1,1]  @=> int kick2Pattern[];

[1,0,0,1,0,0,1,0,0,0,1,0,1,0,0,0]  @=> int snare3Pattern[];

0 => int counter;
.25::second => dur beat;

while(true) 
{
    if (kickPattern[counter % kickPattern.size()]) {
        spork~ playKick();
    }
    
    if (snarePattern[counter % snarePattern.size()]) {
        spork~ playSnare();
    }
    
    if (HHPattern[counter % HHPattern.size()]) {
        spork~ playHH();
    }
    
    //if (kick2Pattern[counter % kickPattern.size()]) {
    //    spork~ playHH();
    //}
    
    //if (snare2Pattern[counter % snarePattern.size()]) {
    //    spork~ playSnare();
    //}
    
    //if (snare3Pattern[counter % snarePattern.size()]) {
    //    spork~ playSnare();
    //}
    
    counter++; 
    beat/2 => now; 
}

fun void playHH() 
{
    Noise n => HPF f => ADSR e => dac; 
    f.freq(8000); 
    f.gain(0.4);
    e.set(2::ms, 50::ms, 0, 100::ms); 
    e.keyOn();
    1::second => now; 
}

fun void playSnare() 
{
    Noise n => BPF f => ADSR e => dac; 
    TriOsc t => ADSR te => dac;
    TriOsc t2 => ADSR te2 => dac;
    
    t.freq(140);
    t.gain(0.02);
    te.set(2::ms, 100::ms, 0, 100::ms); 
    
    t2.freq(220);
    t2.gain(0.02);
    te2.set(2::ms, 100::ms, 0, 100::ms); 
    
    n.gain(0.3);
    f.freq(1000);
    f.Q(0.4);
    e.set(2::ms, 100::ms, 0, 100::ms); 
    
    e.keyOn();
    te.keyOn();
    te2.keyOn();
    
    1::second => now; 
}

fun void playKick() 
{
    Noise n => LPF f => ADSR ne => dac; 
    TriOsc s => ADSR e => dac; 
    
    f.freq(450.0);
    ne.set(1::ms, 100::ms, 0.0, 100::ms);
    s.freq(60); 
    e.set(2::ms, 100::ms, 0, 10::ms); 
    e.keyOn();
    ne.keyOn();
    1::second => now; 
}
