# ***************************************************** -*- Makefile -*-
#
# AUTHOR(S): Andreas Huggel (ahu)
#
# RCS information
#  $Name:  $
#  $Revision: 1.4 $
#
# Description:
#  This makefile mainly forwards to makefiles in subdirectories.
#
# Restrictions:
#  Requires GNU make.
#

.PHONY: all clean maintainer-clean doc

all %:
	cd src && $(MAKE) $(MAKECMDGOALS)

doc:
	cd doc && $(MAKE) $(MAKECMDGOALS)

clean:
	cd src && $(MAKE) $(MAKECMDGOALS)
#	cd doc && $(MAKE) $(MAKECMDGOALS)
	rm -f config.h config.mk config.log config.status
	rm -rf autom4te.cache/

maintainer-clean: clean
	cd src && $(MAKE) $(MAKECMDGOALS)
	cd doc && $(MAKE) $(MAKECMDGOALS)
	rm -f configure
	rm -f *~ *.bak *#
