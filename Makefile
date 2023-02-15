.POSIX:
.SUFFIXES:

FC        = gfortran
FFLAGS    = -Wno-unused-function -fmax-errors=1
AR        = ar
ARFLAGS   = rcs
TARGET    = libfortran-dialog.a

.PHONY: all clean examples

$(TARGET):
	$(FC) $(FFLAGS) -c src/dialog.f90
	$(AR) $(ARFLAGS) $(TARGET) dialog.o

all: $(TARGET)

examples: $(TARGET)
	$(FC) $(FFLAGS) -o hamurabi examples/hamurabi.f90 $(TARGET)
	$(FC) $(FFLAGS) -o showcase examples/showcase.f90 $(TARGET)
	$(FC) $(FFLAGS) -o wumpus examples/wumpus.f90 $(TARGET)

clean:
	if [ -e hamurabi ]; then rm hamurabi; fi
	if [ -e showcase ]; then rm showcase; fi
	if [ -e wumpus ]; then rm wumpus; fi
	rm $(TARGET)
	rm *.mod
	rm *.o
