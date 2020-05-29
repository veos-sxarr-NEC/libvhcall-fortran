FC = /opt/nec/ve/bin/nfort
GFORT = gfortran

ALL = sample libvhcall.so

all: $(ALL)

sample: sample.f
	$(FC) -o $@ $^ -lvhcall_fortran

libvhcall.so: libvhcall.f
	$(GFORT) -o $@ $^ -fpic -shared

clean:
	rm -f $(ALL) *.o *.mod
