# generate 1024 random 8-bit numbers
from random import randint

nbit = 8
M = 1024

mema_bit = []
mema = []
memb = []
memb_bit = []

def random8bit():
	ret = ""
	for i in range(nbit):
		ret += str(randint(0, 1))
	return ret

def generate():
	for i in range(M):
		num = random8bit()
		mema_bit.append(num)
		mema.append(binToDec(num))
		memb_bit.append(None)
		memb.append(None)

def binToDec(num):
	if(num[0] == "0"): # positive
		return int(num, 2)
	else:
		# subtract 2^n to the convertion
		return int(num, 2) - (2**nbit)

def decToBin(num):
	if(num > 127):
		# saturate up
		return "0"+"1"*(nbit-1) # 0111111
	if(num < -128):
		# saturate down
		return "1"+"0"*(nbit-1) # 1000000
	if(num >= 0):
		return bin(abs(num))[2:].rjust(nbit, '0') # remove the '0b' at the beginning
	else:
		return bin(num + (2**nbit))[2:].rjust(nbit-1, '1')

def VCS(num):
	if(num > 100):
		return 93
	else:
		return 0

def Round(num):
	if(num > 0):
		return round(num + 0.0001)
	elif(abs(num-int(num)) > 0.5):
		return round(num - 0.0001)
	else:
		return int(num)
	


def calculate_output():
	memb[0] = Round(1.75*mema[0])
	memb_bit[0] = decToBin(memb[0])
	for i in range(1, M):
		memb[i] = Round(1.75*mema[i] + 2*mema[i-1] - VCS(mema[i-1]))
		memb_bit[i] = decToBin(memb[i])
		if len(memb_bit[i]) != nbit:
			print("length error")
			print(memb[i])
			print(memb_bit[i])


calcolati = []


with open("bit_simulation_memB.txt", "r") as f:
	with open("int_simulation_memB.txt", "w") as f2:
		for line in f.readlines():
			f2.write(str(binToDec(line)) + "\n")