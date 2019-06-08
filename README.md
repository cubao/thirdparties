# Thirdparties

## Install all libs

```bash
make install

# default to install headers & libs to ${HOME}/.cmake_install
# can be overrided via
CMAKE_PREFIX_INSTALL=/tmp/other/dir make install
```

## Libs

-   s2geometry: Computational geometry and spatial indexing on the sphere
    ```bash
    make install_s2geometry
    ```
-   h3: Hexagonal hierarchical geospatial indexing system
    ```bash
    make install_h3
    ```
