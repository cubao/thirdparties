CMAKE_INSTALL_PREFIX ?= $(HOME)/.cmake_install
S2GEOMETRY_BINARY_DIR := $(abspath dist/s2geometry)
S2GEOMETRY_SOURCE_DIR := $(abspath s2geometry)
H3_BINARY_DIR := $(abspath dist/h3)
H3_SOURCE_DIR := $(abspath h3)
ABSEIL_BINARY_DIR := $(abspath dist/abseil-cpp)
ABSEIL_SOURCE_DIR := $(abspath abseil-cpp)
FLATBUFFERS_BINARY_DIR := $(abspath dist/flatbuffers)
FLATBUFFERS_SOURCE_DIR := $(abspath flatbuffers)
PROJ4_BINARY_DIR := $(abspath dist/PROJ)
PROJ4_SOURCE_DIR := $(abspath PROJ)
EIGEN_BINARY_DIR := $(abspath dist/eigen)
EIGEN_SOURCE_DIR := $(abspath eigen-git-mirror)

.PHONY: all reset_submodules clean \
	clean_s2geometry \
	build_s2geometry \
	install_s2geometry \
	build_s2geometry \
	install_s2geometry \
	clean_abseil \
	build_abseil \
	install_abseil \
	clean_flatbuffers \
	build_flatbuffers \
	install_flatbuffers \
	clean_proj4 \
	build_proj4 \
	install_proj4 \
	clean_eigen \
	build_eigen \
	install_eigen \

all:
	@echo nothing special

reset_submodules:
	git submodule update --init --recursive

clean:
	rm -rf build dist

build: build_s2geometry build_h3 build_abseil build_flatbuffers build_proj4 build_eigen

install: install_s2geometry install_h3 install_abseil install_flatbuffers install_proj4 install_eigen

clean_s2geometry:
	cd $(S2GEOMETRY_SOURCE_DIR) && \
		git reset --hard HEAD
	rm -rf $(S2GEOMETRY_BINARY_DIR)
build_s2geometry:
	mkdir -p $(S2GEOMETRY_BINARY_DIR) && cd $(S2GEOMETRY_BINARY_DIR) && \
		cmake $(S2GEOMETRY_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) \
			-DWITH_GFLAGS=ON \
			-DWITH_GLOG=ON \
			-DBUILD_SHARED_LIBS=OFF \
			-DBUILD_EXAMPLES=OFF && \
		make -j4
install_s2geometry: build_s2geometry
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

clean_abseil:
	rm -rf $(ABSEIL_BINARY_DIR)
install_abseil: build_abseil
	cd $(ABSEIL_BINARY_DIR) && \
		make install
build_abseil: 
	mkdir -p $(ABSEIL_BINARY_DIR) && cd $(ABSEIL_BINARY_DIR) && \
		cmake $(ABSEIL_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) && \
		make -j4

clean_flatbuffers:
	rm -rf $(FLATBUFFERS_BINARY_DIR)
install_flatbuffers: build_flatbuffers
	cd $(FLATBUFFERS_BINARY_DIR) && \
		make install
build_flatbuffers: 
	mkdir -p $(FLATBUFFERS_BINARY_DIR) && cd $(FLATBUFFERS_BINARY_DIR) && \
		cmake $(FLATBUFFERS_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) && \
		make -j4

clean_proj4:
	rm -rf $(PROJ4_BINARY_DIR)
install_proj4: build_proj4
	cd $(PROJ4_BINARY_DIR) && \
		make install
build_proj4: 
	mkdir -p $(PROJ4_BINARY_DIR) && cd $(PROJ4_BINARY_DIR) && \
		cmake $(PROJ4_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) \
			-DPROJ_TESTS=OFF && \
		make -j4

clean_eigen:
	rm -rf $(EIGEN_BINARY_DIR)
install_eigen: build_eigen
	cd $(EIGEN_BINARY_DIR) && \
		make install
build_eigen: 
	mkdir -p $(EIGEN_BINARY_DIR) && cd $(EIGEN_BINARY_DIR) && \
		cmake $(EIGEN_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX)

DOCKER_BUILD_TAG := cubao/basic-google-suit-bundles
docker_test_build:
	docker run --rm -v `pwd`:/workdir \
		-it $(DOCKER_BUILD_TAG) zsh

DOCKER_RELEASE_TAG := cubao/release
docker_build:
	docker build \
		--tag $(DOCKER_RELEASE_TAG) .
docker_push:
	docker push $(DOCKER_RELEASE_TAG)
docker_test_release:
	docker run --rm -v `pwd`:/workdir -it $(DOCKER_RELEASE_TAG) zsh
