CFLAGS = -O2 -fopenmp -mcmodel=medium

# -cpp permits scripting of larger array size build.
#  -fdefault-integer-8 required to handle associated array sizes for 60% memory.
FFLAGS = -O2 -fopenmp -cpp -fdefault-integer-8

all: stream_f.exe stream_c.exe

stream_f.exe: stream.f mysecond.o
	$(CC) $(CFLAGS) $(CPPFLAGS) -c mysecond.c
	$(FC) $(FFLAGS) $(CPPFLAGS) -c stream.f
	$(FC) $(FFLAGS) stream.o mysecond.o -o stream_f.$(FC).exe

stream_c.exe: stream.c
	$(CC) $(CFLAGS) $(CPPFLAGS) stream.c -o stream_c.$(CC).exe

clean:
	rm -f  *.exe  *.o

# an example of a more complex build line for the Intel icc compiler
stream.icc: stream.c
	icc -O3 -xCORE-AVX2 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20 stream.c -o stream.omp.AVX2.80M.20x.icc
