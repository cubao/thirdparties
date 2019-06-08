all:
	@echo nothing special

reset_submodules:
	git submodule update --init --recursive

clean:
	rm -rf build dist

S2GEOMETRY_BINARY_DIR := $(abspath dist/s2geometry)
S2GEOMETRY_PATCH_FILE := $(abspath s2geometry.patch)
S2GEOMETRY_SOURCE_DIR := $(abspath s2geometry)

clean_s2geometry:
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git reset --hard HEAD
	rm -rf $(S2GEOMETRY_BINARY_DIR)

build_s2geometry: patch_s2geometry build_s2geometry_impl depatch_s2geometry
patch_s2geometry:
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git apply $(S2GEOMETRY_PATCH_FILE)
depatch_s2geometry:
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git reset --hard HEAD
build_s2geometry_impl:
	mkdir -p $(S2GEOMETRY_BINARY_DIR) && cd $(S2GEOMETRY_BINARY_DIR) && \
		cmake $(S2GEOMETRY_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PATH) \
			-DWITH_GFLAGS=OFF \
			-DBUILD_GLOG=OFF \
			-DBUILD_SHARED_LIBS=ON \
			-DBUILD_EXAMPLES=OFF && \
		make -j4
install_s2geometry: build_s2geometry
	cd $(S2GEOMETRY_BINARY_DIR) && \
		make install
