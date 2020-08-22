**Programming Assignment \#1**

Due 9/19 (actually due the night before at 11:59pm)

Work alone for this assignment!

Read the MiniAudicle tutorial (about a page long) at

http://audicle.cs.princeton.edu/mini/mac/doc/\#tutorial. Run the code
examples from the tutorial and verify that they make sound (don’t do the
MAUI examples).

Some useful documentation you should take a look at:

Types, values, and variables

http://chuck.cs.princeton.edu/doc/language/type.html

Unit Generators in ChucK

http://chuck.cs.princeton.edu/doc/language/ugen.html

Operators

http://chuck.cs.princeton.edu/doc/language/oper.html

Manipulating Time in ChucK

<http://chuck.cs.princeton.edu/doc/language/time.html>

**1) Create a ChucK patch to play the tune "Frere Jacques". (4 points)**

There is a chuck patch skeleton to get you started, posted on piazza for
this assignment

//Midi Note numbers peg middle C at 60, C\# at 61, D at 62, etc

Std.mtof(60)=&gt;myOsc.freq; //play middle C

500::ms=&gt;now;

Std.mtof(62)=&gt;myOsc.freq; //play D above middle C

500::ms=&gt;now;

//and so on...

Turning notes on and off can be done many ways, for now we**ʼ**ll do the
most basic way of turning the gain (volume) of the oscillator on and off

.2=&gt;myOsc.gain;// make oscillator output at 20% volume

500::ms=&gt;now; //make time pass

0=&gt;myOsc.gain;

//make it quiet

Think about how you will rearticulate repeated notes, and if you insert
a space between notes, that you don’t get out of tempo!

**2) Once you have that, great. Then**, replace all of the "hard-coded"
time durations, with a variable of type "dur" defined at the top of the
patch. And replace all the “hard-coded” pitch values (60,62, etc) with a
variable holding the starting pitch. And replace the “.2” gain value
with a variable of type float. So put these at the top (and chuck some
value to them). (4 points)

dur quarterNote;

float playVolume;

int startMIDIPitch;

Then you can do basic operations on them to define time and pitch e.g.:

Std.mtof(startMIDIPitch+7)=&gt; myOsc.freq; //play 7 half

//steps above the starting pitch

quarterNote/2=&gt;now; //allow half of a quarter note, i.e. an

//eighth note, to progress in time

Play around with these variable values and make sure they work!

**3. Make it into a true round!** (4 points)

http://en.wikipedia.org/wiki/Round\_(music)

Take your Frere Jaques patch (maybe make a backup!), and encapsulate the
code for playing the melody into a function. It will look like:

function void playMelody()

{

> SinOsc myOsc =&gt; dac;
>
> .2 =&gt; myOsc.gain;
>
> Std.mtof(startMIDIPitch)=&gt;myOsc.freq;
>
> quarterNote=&gt;now;
>
> Std.mtof(startMIDIPitch+2)=&gt;myOsc.freq;
>
> quarterNote=&gt;now; //etc, etc,

}

//main program code goes anywhere else in the patch

Then, with the bulk of the code in that function, the program code will
be quite short. In it:

1)launch the melody with spork\~ playMelody();

2)wait a set amount of time until you want the second voice to come in

3)launch the melody again

4)Remember that you have to keep the time progressing in the top-level
thread,

or the patch will exit

This is enough to satisfy the assignment. If you want to get fancy with
it, add Envelopes to get rid of the clicks when the notes start and stop
(http://chuck.cs.princeton.edu/doc/program/ugen\_full.html\#Envelope),
and try to do an unusual or interesting arrangement of the tune beyond
just the simple notes.

**4. Answer the following: (2 points)**

-Tell us a bit about your background – What’s your major? What
instruments do

you play? What kind of music do you like to listen to and play? What
other

programming languages, if any, do you know, and what is your level of

expertise?

-Choose a classmate to be your 314 lab partner for the foreseeable
future, and

tell us his or her name. Or tell us if you don’t know anyone in the
class and want

us to choose someone for you.

WHAT TO TURN IN:

\- your .ck file for question \#1&2&3. Just turn in one file, of the

most advanced state of your patch.

\- your written answers to \#4

HOW TO TURN IT IN

Submit just one file. Put all of your files in single directory and zip
it up (right-click

-&gt; compress of you are on OS X). Go to the Assignments page in
Blackboard, select

Programming\_Assignment\_1 View/Complete. Then attach your .zip file.
Don’t

forget to submit. People have had trouble in the past with Firefox, so
try Chrome or Safari if your file won’t upload. If you run into
problems, write a question on the Piazza site!
