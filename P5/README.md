**MUS/COS 314 - Assignment 5**

Due 12/2 (11:59PM)

Work in your assigned groups (4 or 5 people).

**1) Perform a piece, composed or improvised, with your full group,
where control is happening over the network, and each of your computers
makes sound. We will provide individual speakers for each computer when
you perform.**

**2) Each group member makes his or her own patch, in either Max or
ChucK, and the group must agree on what messages can be sent over the
network using OSC, and how the computers will respond to these
messages.**

**3) If you create your patch in ChucK, you should create a Max GUI
(graphical user interface) for it, and send messages to your ChucK patch
via OSC over localhost.**

Do not test this stuff using PUWireless. Your computer’s IP address will
get shut down by OIT, and you will have to call them to get it
reinstated. Sending messages on the broadcast address is considered SPAM
by OIT. Instead, use a router or ad hoc network to create your own LAN
(Local Area Network)

You can borrow a network WiFi router from us, or use one of your own. A
hardware WiFi router will allow you to use the 255.255.255.255
(broadcast) host to communicate with any computer on the network.

Mac computers can use “Create Network” to make their own WiFi hub, but
be aware that these ad hoc networks do not allow the full
255.255.255.255 “broadcast” host. You must check the computers’ IP
addresses, and just overlay the broadcast masks (255.255) for the last
two parts of the four-part IP address (for instance, 192.168.255.255).

WHAT TO TURN IN:

\- each member’s Max or ChucK patch, with any associated files that are
necessary to run the patch, and a clear documentation of who made each
patch.

HOW TO TURN IT IN

A zip file of everything needed to run the patches.
