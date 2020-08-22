import argparse
import random
import time
import sys

from pythonosc import osc_message_builder
from pythonosc import udp_client

from aubio import source, notes, pitch

parser = argparse.ArgumentParser()
parser.add_argument("--ip", default="127.0.0.1", help="The ip of the OSC server")
parser.add_argument("--port", type=int, default=5005, help="The port the OSC server is listening on")
args = parser.parse_args()

client = udp_client.SimpleUDPClient(args.ip, args.port)

for filename in sys.stdin:
  downsample = 1
  samplerate = 44100 // downsample

  win_s = 2048 // downsample # fft size
  hop_s = 512 // downsample # hop size

  s = source(filename.strip(), samplerate, hop_s)
  samplerate = s.samplerate

  tolerance = 0.8

  notes_o = notes("default", win_s, hop_s, samplerate)
  notes_o.set_silence(-40)
  notes_o.set_minioi_ms(200)

  times = []
  pitches = []
  confidences = []

  # total number of frames read
  total_frames = 0
  while True:
    samples, read = s()
    new_note = notes_o(samples)
    if (new_note[0] != 0):
      note_str = ' '.join(["%.2f" % i for i in new_note])
      onset = total_frames/float(samplerate)
      # print("%.6f" % onset, new_note)
      times += [onset]
      pitches += [new_note[0]]
    total_frames += read
    if read < hop_s: break

  client.send_message("/onoff", 1)
  for i in range(len(pitches)-1):
    t = times[i+1] - times[i]
    p = pitches[i]
    client.send_message("/note", str(p) + " " + str(t))
    time.sleep(t)

  client.send_message("/onoff", 0)
  time.sleep(1)
  client.send_message("/inc", 0)
  