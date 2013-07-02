#!/bin/env make

all:
	(cd bin; ./build.sh)
	@echo ""
	@echo "============================================================="
	@echo "  Once you have finished testing, please remember to upload"
	@echo "  the gzipped tarball to a publicly accessible site ala:"
	@echo "      www.strongloop.com/downloads/asteroid-oracle/*.tar.gz"
	@echo "============================================================="
	@echo ""
