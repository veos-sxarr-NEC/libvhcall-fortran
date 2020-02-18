lib_LTLIBRARIES = libvhcall_fortran.la
libvhcall_fortran_la_SOURCES = vhcall_fortran_lowlevel.F03 vhcall_fortran.F03
libvhcall_fortran_la_CFLAGS = -g
libvhcall_fortran_la_LDFLAGS = -version-info 1:0:0 -Wl,--build-id=sha1 -Wl,-z,max-page-size=0x200000 -g
nodist_include_HEADERS = vhcall_fortran_lowlevel.mod vhcall_fortran.mod
CLEANFILES = vhcall_fortran_lowlevel.mod vhcall_fortran.mod
