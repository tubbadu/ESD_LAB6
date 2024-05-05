from random import randint

M = 1024

mema_bit = []
mema = []
memb = []
memb_bit = []
memb_real = []

def randomBits(nbit=8):
	ret = ""
	for i in range(nbit):
		ret += str(randint(0, 1))
	return ret

def generate():
	for i in range(M):
		num = randomBits()
		mema_bit.append(num)
		mema.append(binToDec(num))
		memb_real.append(None)
		#memb_bit.append(None)
		#memb.append(None)

def binToDec(num, nbit=8):
	nbit = len(num)
	if(num[0] == "0"): # positive
		return saturate(int(num, 2))
	else:
		# subtract 2^n to the convertion
		return saturate(int(num, 2) - (2**nbit))

def decToBin(num, nbit=8):
	if(num >= 0):
		return bin(abs(num))[2:].rjust(nbit, '0') # remove the '0b' at the beginning
	else:
		return bin(num + (2**nbit))[2:].rjust(nbit-1, '1')

def saturate(num):
	if(num > 127):
		return 127.0
	elif(num < -128):
		return -128.0
	else:
		return num


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
	memb_real[0] = saturate(1.75*mema[0])
	#memb[0] = Round(memb_real[0])
	#memb_bit[0] = decToBin(memb[0])
	for i in range(1, M):
		memb_real[i] = saturate(1.75*mema[i] + 2*mema[i-1] - VCS(mema[i-1]))
		#memb[i] = Round(memb_real[i])
		#memb_bit[i] = decToBin(memb[i])
		#if len(memb_bit[i]) != nbit:
		#	print("length error")
		#	print(memb[i])
		#	print(memb_bit[i])


generate()
calculate_output()

with open("bit_input.txt", "w") as f:
	for line in mema_bit:
		f.write(line + "\n")

with open("int_input.txt", "w") as f:
	for line in mema:
		f.write(str(line) + "\n")

print("input files generated. Start now the simulation, then type 'ok' to go on")
while(input() != "ok"):
	print("type 'ok' to go on")

with open("bit_simulation_memB.txt", "r") as f:
	with open("int_simulation_memB.txt", "w") as f2:
		for line in f.readlines():
			line = line.strip()
			memb_bit.append(line)
			memb.append(binToDec(line))
			f2.write(str(binToDec(line)) + "\n")

# generate now a global file with the following values:
#	py input int		---		py input bit	---		true values		--		simulated bit		--		simulated int		--		simulation error
lbit, lnum = 20, 15
line = "in int".rjust(lnum)
line += "in bit".rjust(lbit)
line += "out real".rjust(lnum)
line += "out sim int".rjust(lnum)
line += "out sim bit".rjust(lbit)
line += "error".rjust(lnum)
line += "\n"
res = line
for i in range(1023):
	line = str(mema[i]).rjust(lnum)
	line += mema_bit[i].rjust(lbit)
	line += str(memb_real[i]).rjust(lnum)
	line += str(memb[i]).rjust(lnum)
	line += memb_bit[i].rjust(lbit)
	line += str(memb_real[i]-memb[i]).rjust(lnum)
	line += "\n"
	res += line

with open("results.txt", "w") as f:
	f.write(res)
print("done")