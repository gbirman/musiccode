

//////////////// GET SAMPLE ///////////////////////////

// sound file
me.sourceDir() + "foo.wav" => string filename;
if( me.args() ) me.arg(0) => filename;

// the patch 
SndBuf buf;
LiSa lisa => dac;
// load the file
filename => buf.read;

//set lisa buffer size to sample size
buf.samples()::samp => lisa.duration;
buf.samples() => int S;
1/buf.freq() => float fileLength; 
S/fileLength => float sampleRate; 

<<<sampleRate>>>;
<<<S>>>;


//////////////////// USER INPUT ////////////////////////////////

0.2 => float secondsPerBucket; // user input

/////////////////////// GET SAMPLE GRID ////////////////////////

Math.round(secondsPerBucket * sampleRate) $ int => int samplesPerBucket; 
0.1 => float CI; // confidence interval (percentage plus/minus) 
S => int minDiff; 
(Math.ceil(samplesPerBucket*CI)) $ int => int minDist; 
0 => int spb; // samples per bucket final value
0 => int numBuckets; // number of buckets final value 

// get value that (almost) equalizes N(samples)/bucket within CI
// such that first N-1 buckets have same size and last bucket 
// has different size close to that size 
for (Math.floor(samplesPerBucket*(1-CI)) $ int => int x; x <= Math.ceil(samplesPerBucket*(1+CI)) $ int; x++) 
{
    (S $ float)/x => float B0; 
    (Math.round(B0)) $ int => int B;
    S-(B-1)*x => int y; 
    x-y => int diff; 
    Std.abs(x - samplesPerBucket) => int dist;
    // set new best values 
    if ((diff <= minDiff) & (dist < minDist) & (diff>=0)) {
        x => spb; 
        B => numBuckets; 
        diff => minDiff; 
        dist => minDist;    
        
    }
}

// get the samples per bucket as an array
int q[numBuckets];
for (0 => int b; b < numBuckets-1; b++) {
    spb => q[b];
}
S-(numBuckets-1)*spb => q[numBuckets-1]; 


/////////////////////// GET FREQUENCY ///////////////////////

// linear map x in [A, B] to y in [C,D]
fun float linearMap(float x, float a, float b, float c, float d) 
{
    (x-a)/(b-a) * (d-c) + c=> float y;
    return Math.sin(y); 
}

fun float getMin(SndBuf buf, int start, int end) {
    
    end-start => int N;
    1 => float currentMin; 
    
    for (start => int i; i < end; i++) {
        if (buf.valueAt(i) < currentMin) {
            buf.valueAt(i) => currentMin;
        }
    }
    
    return currentMin; 
    
}

fun float getMax(SndBuf buf, int start, int end) {
    
    end-start => int N;
    -1 => float currentMax; 
    
    for (start => int i; i < end; i++) {
        if (buf.valueAt(i) > currentMax) {
            buf.valueAt(i) => currentMax;
        }
    }
    
    return currentMax; 
    
}


//getMin(buf, 0, S) => float bufMin; 
//getMax(buf, 0, S) => float bufMax; 
0.0 => float bufMin; 
0.05 => float bufMax; 
//260 => float freqMin; 
//330 => float freqMax; 
1 => float freqMin; 
2 => float freqMax; 


// get average frequency for buf in [start, end) 
fun float getAvgFreq(SndBuf buf, int start, int end) {

    end-start => int N;
    0 => float sum; 
    
    for (start => int i; i < end; i++) {
        if ((buf.valueAt(i) < bufMin) | (buf.valueAt(i) > bufMax)) {
            1 -=> N;
        } else {
            linearMap(buf.valueAt(i), bufMin, bufMax, freqMin, freqMax)  +=> sum;
        } 
    }
    
    return sum / N; 
}

<<<getAvgFreq(buf, 0, S)>>>;

////////////////////////// PLAYBACK ////////////////////////////

/*
SinOsc s => dac; 
0 => int currentSamplePos;
for (0 => int b; b < numBuckets; b++) {
    
    b*q[b] +=> currentSamplePos;  
    <<<currentSamplePos>>>;  
    getAvgFreq(buf, currentSamplePos, currentSamplePos+q[b]) => float f; 
    <<<f>>>;
    s.freq(f);
    s.gain(0.5);
    (q[b]/sampleRate)::second => dur bucketLength; 
    bucketLength => now; 
}
*/

/*
0 => int currentSamplePos;
for (0 => int b; b < numBuckets; b++) {    
    b*q[b] +=> currentSamplePos;
    for (currentSamplePos => int i; i < currentSamplePos+q[b]; i++) {
        (buf.valueAt(i), i::samp) => lisa.valueAt;
    }
}
*/


//////////////////////// TESTING /////////////////////

//transfer values from SndBuf to LiSa
//works properly for mono; need to skip samples for multichannel
for ( 0 => int i; i < buf.samples(); i++ ) {
    
    (buf.valueAt(i), i::samp) => lisa.valueAt;
}

//use an oscillator to set playback position
//play it back
1   => lisa.play;
0.5 => lisa.gain;


-0.08 => float alpha; // how quickly pitch descends/ascends
100 => int beta; // length of interval for a given playback rate
10 => float gamma; // how slowly pitch oscillates
1 => float k0; // initial pitch speed (0.5 == regular playback) 
0 => int counter; 

k0 => float k; 
while ( true ) { 
    
    //monitor where we're playing back from in the buffer
    lisa.rate(k);
    beta::ms => now; 
    1 +=> counter;
    if ((counter % gamma) == 0) {
        k0 => k;
    }
    alpha +=> k;
    if (k < 0) {
        k0 => k;
        0 => counter;
    }
}



///////////////////////////// RANDOM /////////////////////////////

/*
// time loop
while( true )
{
    0 => buf.pos;
    Math.random2f(.2,.5) => buf.gain;
    Math.random2f(.5,1.5) => buf.rate;
    100::ms => now;
}
*/

/*
/////////////////// RECORD SAMPLE ////////////////////

1::second => dur beatLength; 
[60, 62, 64, 62, 60] @=> int midiFreq[];
5 => float freqOffset; 


SinOsc s => dac; 

for (0 => int i; i < midiFreq.cap(); i++) {
    s.freq(Std.mtof(midiFreq[i])-freqOffset);
    beatLength => now; 
}
*/
