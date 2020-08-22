// Theo Trevisan, Gabriel Birman, and Ruben Dicker
//
// 10-10-18
//
// Mimicking of Ryoji Ikeda's music using pseudorandom patterns and 
// unique sounds like phone dial tones and bouncy shepard tones
// played alongside a humming background created using just
// intonations and pythagorean scales
//
// Argument is a phone number that plays the dial tone towards
// end of piece in specified frequency range 


// humming-sounding intervals using just intonations
class myIntervals
{
    [25.0/24.0, 9.0/8.0, 6.0/5.0, 5.0/4.0, 4.0/3.0, 45.0/32.0, 3.0/2.0, 8.0/5.0, 5.0/3.0, 9.0/5.0, 15.0/8.0, // just intervals
256.0/243.0, 32.0/27.0, 81.0/64.0, 729.0/512.0, 128.0/81.0, 27.0/16.0, 16.0/9.0, 243.0/128.0, 531441.0/524288.0, //pythagorean intervals
2.0] @=> float intervalPatterns[];
    [65.4, 69.3, 73.4, 77.8, 82.4, 87.3, 92.5, 98.0, 103.8, 110.0, 116.5, 123.5] @=> float pitchValues[];
    
    pitchValues[Std.rand2(0, 11)] => float fundamental;
    <<<fundamental>>>;
    SawOsc s => JCRev r => ADSR e ;
    r.mix(1.0);
    e.set(500::ms, 100::ms, 0.1, 50::ms);
    s.gain(0.02);
    s.freq(fundamental);
    Std.rand2(3, 8) => int numHiNotes;
    float val[numHiNotes];
    TriOsc oscs[numHiNotes];
    ADSR adsrs[numHiNotes];
    int times[numHiNotes];
    for (0 => int i; i < numHiNotes; i++)
    {
        fundamental * intervalPatterns[Std.rand2(0, intervalPatterns.size() - 1)] * Math.pow(2, Std.rand2(0, 2)) => val[i]; // assigns an interval in a random octave
        Std.rand2(0, 10) => times[i];
        oscs[i].freq(intervalPatterns[i]);
        oscs[i].gain(0.1);
        adsrs[i].set(100::ms, 500::ms, Std.rand2f(0.1, 0.3), 50::ms);
        oscs[i] => adsrs[i];
        1::ms => now;
    }
    
    fun void connect(UGen ug)
    {
        r => ug;
        for (0 => int i; i < numHiNotes; i++)
        {
            adsrs[i] => ug;
        }
    }
    
    fun void changeFundamental(float newFund)
    {
        newFund => fundamental;
        s.freq(fundamental);
    }
    
    fun void run(int start) // 1 is start, 0 is stop
    {
        if (start == 1)
        {
            for (0 => int i; i < numHiNotes; i++)
            {
                adsrs[i].keyOn();
            }
            while (true)
            {
                for (0 => int i; i < numHiNotes; i++)
                {
                    if (times[i] == 0) // if the time for a pitch has run out, a new one is randomly chosen
                    {
                        adsrs[i].keyOff();
                        oscs[i].freq(fundamental * intervalPatterns[Std.rand2(0, intervalPatterns.size() - 1)] * Math.pow(2, Std.rand2(2, 3)));
                        Std.rand2(0, 5) => times[i];
                        adsrs[i].keyOn();
                    }
                    times[i]--;
                    1::second => now;
                }
            }
        }
        else
        {
            r.gain(0);
            for (0 => int i; i < numHiNotes; i++)
            {
                adsrs[i].keyOff();
            }
        }
    }
}

// bouncy paradoxic sound created by playing an ascending tone
// along the same interval over and over
class myShepardTone
{
    SinOsc a => ADSR e;
    SinOsc d => e;
    
    e.set(5::ms, 2::ms, 0.05, 1::ms); 
    
    1.0667 => float semitoneRatio;
    
    1046.502261 => float dFreq;
    261.625565 => float aFreq;
    
    0.0 => float aGain;
    0.24 => float dGain;
    
    1 => int counter; 
    0.01 => float gainStep;
    1 => float freqStep; 
    24 => int iterMax; 
    
    0.01::second => dur length; // try setting to 0.05
    
    fun void connect(UGen ug)
    {
        e => ug;
    }
    
    fun void loop(float duration)
    {
        while(duration > 0.000)
        {
            playTune();
            duration - 0.01 => duration;
        }
    }
    
    fun void playTune()
    {
        spork ~ playAscending(); 
        playDescending(); 
        
        counter++;
        if ((counter % (iterMax+1)) == 0) {
            1 => counter; 
        }
    }
    
    fun void playAscending() {
        a.gain(aGain+(counter-1)*gainStep * .05);
        a.freq(aFreq * (Math.pow(semitoneRatio, counter - 1)));
        e.keyOn();
        length => now; 
        e.keyOff();
    }
    
    fun void playDescending() {
        d.gain(dGain-(counter-1)*gainStep * .05);
        d.freq(dFreq * (Math.pow(semitoneRatio, counter - 1)));
        e.keyOn();
        length => now; 
        e.keyOff();
    }
}

// imitates the virtual sounds of dial tones on a cell phone
class myPhoneDialTone
{
    SinOsc s1 => JCRev r1 => ADSR e1;
    SinOsc s2 => JCRev r2 => ADSR e2;
    
    // 0-9 are their same indices, * is 10 and # is 11
    [1336.0, 1209.0, 1336.0, 1477.0, 1209.0, 1336.0, 1477.0, 1209.0, 1336.0, 1477.0, 1209.0, 1477.0] @=> float phoneHighFreq[]; 
    [941.0, 697.0, 697.0, 697.0, 770.0, 770.0, 770.0, 852.0, 852.0, 852.0, 941.0, 941.0] @=> float phoneLowFreq[];
    r1.mix(0.1);
    r2.mix(0.1);
    s1.gain(0.01);
    s2.gain(0.01);
    e1.set(10::ms, 100::ms, 5.0, 10::ms);
    e2.set(10::ms, 100::ms, 5.0, 10::ms);
    
    fun void connect(UGen ug)
    {
        e1 => ug;
        e2 => ug;
    }
    
    // play a dial tone (0-9, '*' as 10, or '#' as 11) for dialDur seconds
    fun void playDialTone(int number, float dialDur)
    {
        s1.freq(phoneHighFreq[number]);
        s2.freq(phoneLowFreq[number]);
        e1.keyOn();
        e2.keyOn();
        dialDur::second => now;
        e1.keyOff();
        e2.keyOff();
    }
    
    // play sequence of dial tones (0-9, '*' as 10, or '#' as 11)
    // one after another each for dialDur seconds 
    fun void playSequence(int numbers[], float dialDur)
    {
        for(0 => int i; i < numbers.size(); i++)
        {
            playDialTone(numbers[i], dialDur);
        }
    }
}

// get command line arguments
int myPhoneNumber[10];
// loop over the entire array
for( 0 => int i; i < 10; i++ )
{
    // do something (debug print)
    Std.atoi(me.arg(i)) => myPhoneNumber[i];
}


// global values
103.83 => float f;
10 => int interruption; 

0.2 => float dialDuration;
    
// preparing dac
myIntervals intervals;
intervals.connect(dac);
myIntervals secondFund;
secondFund.connect(dac);
myShepardTone shepardTone;
shepardTone.connect(dac);
myPhoneDialTone phone;
phone.connect(dac);



/* 
spork~ shepardTone.loop(interruption); 
*/
/*
spork~ phone.playSequence(myPhoneNumber, dialDuration);
*/

// quiet humming part 
intervals.changeFundamental(f);
secondFund.changeFundamental(f*(6.0/5.0));
spork~ intervals.run(1);
//60::second => now;
5::second => now;
//spork~ intervals.changeFundamental(pitchValues[Std.rand2(0, 11)]);
spork~ intervals.changeFundamental(f*(4.0/5.0));
5::second => now;
spork~ intervals.changeFundamental(f*(4.0/5.0)*(5.0/6.0));
secondFund.changeFundamental(f);
5::second => now;
spork~ intervals.changeFundamental(f*(4.0/5.0)*(5.0/6.0)*(3.0/4.0));
5::second => now;
spork~ secondFund.run(1);
30::second => now;

spork~ shepardTone.loop(interruption); 
phone.playSequence(myPhoneNumber, dialDuration);
15::second => now;
