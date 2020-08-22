// Authors: Seho Young, Gabriel Birman, and Katherine Wang
// 10/23/2018
// Vocal Transformer

//////// SETUP ////////

// create our OSC receiver
OscRecv OSCin;
// use port 1235 (why not?? just has to match the port of the sender (set in the Max patch))
1235 => OSCin.port;
//start listening to OSC messages
OSCin.listen();

// here are the addresses we're listing to.
OSCin.event("/bang,i") @=> OscEvent bang_event;
OSCin.event("/alpha,f") @=> OscEvent alpha_event;
OSCin.event("/beta,i") @=> OscEvent beta_event;
OSCin.event("/gamma,f") @=> OscEvent gamma_event;
OSCin.event("/k0,f") @=> OscEvent k0_event;
OSCin.event("/rev,f") @=> OscEvent rev_event;
OSCin.event("/lpf,f") @=> OscEvent lpf_event;
OSCin.event("/hpf,f") @=> OscEvent hpf_event;
OSCin.event("/filename,s") @=> OscEvent filename_event;

"record.wav" => string playback_filename;
0 => int r;
0 => int q;
0.0 => float alpha; // how quickly pitch descends/ascends
100 => int beta; // length of interval for a given playback rate
10.0 => float gamma; // how slowly pitch oscillates
1.0 => float k0; // initial pitch speed (0.5 == regular playback) 

// patches 
SndBuf buf;
LiSa lisa => LPF lpf => HPF hpf => NRev rev => dac;
rev.mix(0);
lpf.freq(20000);
hpf.freq(200);

//////// EVENT LISTENER FUNCTIONS ////////

fun void receiveBang() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        bang_event => now;        
        // grab the next message from the queue. 
        while ( bang_event.nextMsg() != 0 )
        {
            bang_event.getInt() => r;
        }
    }
}

fun void receiveAlpha() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        alpha_event => now;        
        // grab the next message from the queue. 
        while ( alpha_event.nextMsg() != 0 )
        {
            alpha_event.getFloat() => alpha;
        }
    }
}

fun void receiveBeta() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        beta_event => now;        
        // grab the next message from the queue. 
        while ( beta_event.nextMsg() != 0 )
        {
            beta_event.getInt() => beta;
        }
    }
}

fun void receiveGamma() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        gamma_event => now;        
        // grab the next message from the queue. 
        while ( gamma_event.nextMsg() != 0 )
        {
            gamma_event.getFloat() => gamma;
        }
    }
}

fun void receiveK0() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        k0_event => now;        
        // grab the next message from the queue. 
        while ( k0_event.nextMsg() != 0 )
        {
            k0_event.getFloat() => k0;
        }
    }
}

fun void receiveRev() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        rev_event => now;        
        // grab the next message from the queue. 
        while ( rev_event.nextMsg() != 0 )
        {
            rev.mix(rev_event.getFloat());
        }
    }
}

fun void receiveLPF() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        lpf_event => now;        
        // grab the next message from the queue. 
        while ( lpf_event.nextMsg() != 0 )
        {
            lpf.freq(lpf_event.getFloat());
        }
    }
}

fun void receiveHPF() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        hpf_event => now;        
        // grab the next message from the queue. 
        while ( hpf_event.nextMsg() != 0 )
        {
            hpf.freq(hpf_event.getFloat());
        }
    }
}

fun void receiveFilename() {
    // infinite event loop
    while ( true )
    {
        // wait for event to arrive
        filename_event => now;        
        // grab the next message from the queue. 
        while ( filename_event.nextMsg() != 0 )
        {
            filename_event.getString() => playback_filename;
            0 => r;
            1 => q;
        }
    }
}

//////// SHREDS ////////

fun void record() {
    
    // get name
    me.sourceDir() + "record.wav" => string filename;
    
    // pull samples from the dac
    adc => Gain g => WvOut w => blackhole;
    // this is the output file name
    filename => w.wavFilename;
    <<<"writing to file:", "'" + w.filename() + "'">>>;
    // any gain you want for the output
    1 => g.gain;
    
    // temporary workaround to automatically close file on remove-shred
    null @=> w;
    
    while ( r == 1 ) {
        10::ms => now;
    }
    "record.wav" => playback_filename;
}



fun void playback() {
    
    // sound file
    me.sourceDir() + playback_filename => string filename;
    
    // load the file
    filename => buf.read;
    
    //set lisa buffer size to sample size
    buf.samples()::samp => lisa.duration;
    
    //transfer values from SndBuf to LiSa
    //works properly for mono; need to skip samples for multichannel
    for ( 0 => int i; i < buf.samples(); i++ ) {
        
        (buf.valueAt(i), i::samp) => lisa.valueAt;
    }
    
    //use an oscillator to set playback position
    //play it back
    1   => lisa.play;
    0.5 => lisa.gain;
    
    0 => int counter; 
    k0 => float k; 
    while ( r == 0 ) { 
        
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
        if (r == 1) 0 => lisa.play;
    }
}

//////// MAIN PATCH ////////

spork~ receiveBang();
spork~ receiveAlpha();
spork~ receiveBeta();
spork~ receiveGamma();
spork~ receiveK0();
spork~ receiveRev();
spork~ receiveLPF();
spork~ receiveHPF();
spork~ receiveFilename();

while (true) {
    if (r == 1 && q == 0) spork~ record();
    if (r == 0 && q == 1) {
        10::ms => now;
        spork~ playback();
    }
    r => q;
    10::ms => now;
}