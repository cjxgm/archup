FLAGS =
PACKAGING_DEPS := make pacman grep binutils file fakeroot
PACKAGING_DEP_FLAGS := $(foreach D,$(PACKAGING_DEPS),-i $D)

.PHONY: package
package: | build/
	./archup -NL $(FLAGS) $(PACKAGING_DEP_FLAGS) \
		-b .:/source \
		-b +build:/build \
		make -C /source _package_in_archup

_package_in_archup:
	cp -r package /tmp
	cd /tmp/package && makepkg -d
	cp /tmp/package/*.pkg.* /build

.PHONY: clean
clean:
	rm -rf build/

.PRECIOUS: %/
%/:
	mkdir $@

