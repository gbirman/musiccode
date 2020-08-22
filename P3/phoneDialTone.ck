class phoneDialTone
{
    SinOsc s1 => JCRev r1 => ADSR e1;
    SinOsc s2 => JCRev r2 => ADSR e2;
    
    // 0-9 are their same indices, * is 10 and # is 11
    [1336.0, 1209.0, 1336.0, 1477.0, 1209.0, 1336.0, 1477.0, 1209.0, 1336.0, 1477.0, 1209.0, 1477.0] @=> float phoneHighFreq[]; 
    [941.0, 697.0, 697.0, 697.0, 770.0, 770.0, 770.0, 852.0, 852.0, 852.0, 941.0, 941.0] @=> float phoneLowFreq[];
    r1.mix(0.1);
    r2.mix(0.1);
    s1.gain(0.2);
    s2.gain(0.2);
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

phoneDialTone myPhone;
myPhone.connect(dac);

while(true)
{
    [2, 1, 0, 2, 4, 8, 6, 7, 9, 1] @=> int myNumber[];
    0.2 => float dialDuration;
    myPhone.playSequence(myNumber, dialDuration); 
    myPhone.playDialTone(10, 1.0);
    myPhone.playDialTone(9, 0.5);
    myPhone.playDialTone(8, 0.5);
    myPhone.playDialTone(9, 0.5);
    myPhone.playDialTone(8, 0.5);
}