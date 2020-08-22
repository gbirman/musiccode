[25.0/24.0, 9.0/8.0, 6.0/5.0, 5.0/4.0, 4.0/3.0, 45.0/32.0, 3.0/2.0, 8.0/5.0, 5.0/3.0, 9.0/5.0, 15.0/8.0, // just intervals
256.0/243.0, 32.0/27.0, 81.0/64.0, 729.0/512.0, 128.0/81.0, 27.0/16.0, 16.0/9.0, 243.0/128.0, 531441.0/524288.0, //pythagorean intervals
2.0] @=> float intervalPatterns[];

[65.4, 69.3, 73.4, 77.8, 82.4, 87.3, 92.5, 98.0, 103.8, 110.0, 116.5, 123.5] @=> float pitchValues[];

class myIntervals
{
    pitchValues[Std.rand2(0, 11)] => float fundamental;
    <<<fundamental>>>;
    SawOsc s => JCRev r => ADSR e ;
    r.mix(1.2);
    e.set(500::ms, 100::ms, 0.1, 50::ms);
    s.gain(0.02);
    //HPF f;
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
        //oscs[i] => f;
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

103.83 => float f; 

myIntervals intervals;
intervals.connect(dac);
intervals.changeFundamental(f);
spork~ intervals.run(1);
//60::second => now;
5::second => now;
//spork~ intervals.changeFundamental(pitchValues[Std.rand2(0, 11)]);
spork~ intervals.changeFundamental(f*(4.0/5.0));
5::second => now;
spork~ intervals.changeFundamental(f*(4.0/5.0)*(5.0/6.0));
5::second => now;
spork~ intervals.changeFundamental(f*(4.0/5.0)*(5.0/6.0)*(3.0/4.0));
5::second => now;
myIntervals secondFund;
secondFund.connect(dac);
spork~ secondFund.run(1);
30::second => now;