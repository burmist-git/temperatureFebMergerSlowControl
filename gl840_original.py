#!/usr/bin/env python3

import socket
#import struct

HOST = 'localhost'
PORT = 8023

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    s.sendall(b'*IDN?\n')
    data = s.recv(1024)
    print('Received', repr(data))
    s.sendall(b':MEAS:OUTP:ONE?\n')
    data = s.recv(1024)
#    print('Received', repr(data))
    s.close()
# IntData = struct.unpack('>HH', data[9:12])
for i in range(8,20,2):
    IntData = int.from_bytes(data[i:i+2], byteorder='big', signed=True)
    print('T',repr(IntData/200.),'C')
for i in range(20,28,2):
    IntData = int.from_bytes(data[i:i+2], byteorder='big', signed=True)
    print('U',repr(IntData/2000.),'V')
for i in range(28,40,2):
    IntData = int.from_bytes(data[i:i+2], byteorder='big', signed=True)
    print('T',repr(IntData/200.),'C')
for i in range(40,48,2):
    IntData = int.from_bytes(data[i:i+2], byteorder='big', signed=True)
    print('U',repr(IntData/2000.),'V')
