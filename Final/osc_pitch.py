"""Small example OSC client

This program sends 10 random values between 0.0 and 1.0 to the /filter address,
waiting for 1 seconds between each value.
"""
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

  win_s = 4096 // downsample
  hop_s = 512 // downsample

  s = source(filename.strip(), samplerate, hop_s)
  samplerate = s.samplerate

  tolerance = 0.8

  pitch_o = pitch("yin", win_s, hop_s, samplerate)
  pitch_o.set_unit("midi")
  pitch_o.set_tolerance(tolerance)

  times = []
  pitches = []
  confidences = []

  # total number of frames read
  total_frames = 0
  while True:
    samples, read = s()
    pitch = pitch_o(samples)[0]
    #pitch = int(round(pitch))
    confidence = pitch_o.get_confidence()
    # if confidence < 0.8: pitch = 0.
    print("%f %f %f" % (total_frames / float(samplerate), pitch, confidence))
    times += [total_frames / float(samplerate)]
    pitches += [pitch]
    confidences += [confidence]
    total_frames += read
    if read < hop_s: break
  for i in range(len(pitches)-1):
    t = times[i+1] - times[i]
    p = pitches[i]
    client.send_message("/note", str(p))
    time.sleep(t)

