FROM ghcr.io/graalvm/graalvm-ce:ol8-java11-21.3.1
ENV GROOVY_VERSION 3.0.5
ENV GROOVY_HOME ~/.sdkman/candidates/groovy/$GROOVY_VERSION
RUN microdnf install -y zip unzip
RUN gu install native-image 
RUN curl -s "https://get.sdkman.io" | bash 
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \ 
    echo \"sdkman_auto_answer=true\" > $SDKMAN_DIR/etc/config && \ 
    sdk install groovy $GROOVY_VERSION && \ 
    groovy -version"