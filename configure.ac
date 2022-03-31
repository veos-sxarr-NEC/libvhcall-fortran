#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([libvhcall-fortran], [2.11])
AC_LANG([Fortran])
AC_CONFIG_SRCDIR([src/Makefile.am])
AC_CONFIG_AUX_DIR([./build-aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AM_PROG_AR
LT_INIT()
AC_PREFIX_DEFAULT([/opt/nec/ve])
AC_PROG_FC([nfort])

AC_ARG_WITH([release-id], [AS_HELP_STRING([--with-release-id],
	    [Specify release id])],
	    [RELEASE=${with_release_id}],
	    [RELEASE="1"])
AC_SUBST(RELEASE)

AC_CONFIG_FILES([Makefile
		 libvhcall-fortran.spec
		 Doxyfile
		 src/Makefile])
AC_OUTPUT
