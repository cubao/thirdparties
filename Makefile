CMAKE_INSTALL_PREFIX ?= $(HOME)/.cmake_install
S2GEOMETRY_BINARY_DIR := $(abspath dist/s2geometry)
S2GEOMETRY_PATCH_FILE := $(abspath s2geometry.patch)
S2GEOMETRY_SOURCE_DIR := $(abspath s2geometry)
H3_BINARY_DIR := $(abspath dist/h3)
H3_SOURCE_DIR := $(abspath h3)

.PHONY: all reset_submodules clean \
	clean_s2geometry \
	build_s2geometry \
	install_s2geometry \
	install_s2geometry_impl \
	patch_s2geometry \
	build_s2geometry_impl \
	depatch_s2geometry \

all:
	@echo nothing special

reset_submodules:
	git submodule update --init --recursive

clean:
	rm -rf build dist

install: install_s2geometry install_h3

clean_s2geometry:
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git reset --hard HEAD
	rm -rf $(S2GEOMETRY_BINARY_DIR)
install_s2geometry: 
	$(MAKE) patch_s2geometry && \
		$(MAKE) build_s2geometry_impl && \
		$(MAKE) install_s2geometry_impl && \
		$(MAKE) depatch_s2geometry
build_s2geometry: 
	$(MAKE) patch_s2geometry 
	$(MAKE) build_s2geometry_impl
	$(MAKE) depatch_s2geometry
patch_s2geometry: depatch_s2geometry
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git apply $(S2GEOMETRY_PATCH_FILE)
depatch_s2geometry:
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git reset --hard HEAD
build_s2geometry_impl:
	mkdir -p $(S2GEOMETRY_BINARY_DIR) && cd $(S2GEOMETRY_BINARY_DIR) && \
		cmake $(S2GEOMETRY_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) \
			-DWITH_GFLAGS=OFF \
			-DWITH_GLOG=OFF \
			-DBUILD_SHARED_LIBS=ON \
			-DBUILD_EXAMPLES=OFF && \
		make -j4
install_s2geometry_impl:
	cd $(S2GEOMETRY_BINARY_DIR) && \
		make install

clean_h3:
	rm -rf $(H3_BINARY_DIR)
install_h3: build_h3
	cd $(H3_BINARY_DIR) && \
		make install
build_h3: 
	mkdir -p $(H3_BINARY_DIR) && cd $(H3_BINARY_DIR) && \
		cmake $(H3_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) \
			-DBUILD_TESTING=OFF \
			-DENABLE_COVERAGE=OFF \
			-DENABLE_DOCS=OFF \
			-DENABLE_FORMAT=OFF \
			-DENABLE_LINTING=OFF && \
		make -j4
