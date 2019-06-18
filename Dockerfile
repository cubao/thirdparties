FROM cubao/basic-google-suit-bundles as build
ADD . /tmp/code
RUN cd /tmp/code && \
    sudo make clean && \
    sudo chown conan -Rf ~/.cmake_install && \
    sudo make install

FROM cubao/basic-google-suit-bundles
ENV USER=conan
COPY --from=build /home/$USER/.cmake_install /home/$USER/.cmake_install 
RUN sudo chown $USER -Rf /home/$USER/.cmake_install
