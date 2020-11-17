import sys
def read_result(filename):
	with open(filename) as nw_result:
		t1,t2,t3=nw_result.readline().split()
		nproc=int(t3)	
		nw_result.readline()
		nw_result.readline()
		t4=nw_result.readline().split()
		energy1=float(t4[2])
		timing1=float(t4[8])
		t4=nw_result.readline().split()
		energy2=float(t4[2])
		timing2=float(t4[8])
		return nproc,energy1,energy2,timing1,timing2

def compare_2float(a,b,tol):
	if abs(a-b) <= tol: return True
	else: return False


if len(sys.argv)!=3:
	print("Usage: python validate.py [calculation result file] [reference result file]")

tol=1e-6
calc_data=read_result(sys.argv[1])
print("Using "+str(calc_data[0])+" MPI ranks")
print("Step 1 uses "+str(calc_data[4]-calc_data[3])+" seconds")
ref_data=read_result(sys.argv[2])
if compare_2float(calc_data[1],ref_data[1],tol) and compare_2float(calc_data[2],ref_data[2],tol):
	print("Validation passed")
else:
	print("Validation failed!!!")



