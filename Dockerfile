FROM cubao/basic-google-suit-bundles as build
ADD . /tmp/code
RUN sudo apt-get update && sudo apt-get install -y sqlite3 \
&& sudo rm -rf /var/lib/apt/lists/*
RUN cd /tmp/code && \
    sudo make clean && \
    sudo make install

FROM cubao/basic-google-suit-bundles
ENV USER=conan
COPY --from=build /home/$USER/.cmake_install /home/$USER/.cmake_install 
RUN sudo chown $USER -Rf /home/$USER/.cmake_install
RUN sudo apt-get update && sudo apt-get install -y sqlite3 \
&& sudo rm -rf /var/lib/apt/lists/*
