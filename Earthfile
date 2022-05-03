VERSION 0.5
FROM niels58/graalvm-ce-clicks:v1
WORKDIR /save

build:
  ENV GROOVY_HOME=/root/.sdkman/candidates/groovy/current
  ENV GROOVY_VERSION=3.0.5
  ENV JAVA_HOME=/opt/graalvm-ce-java11-21.3.1
  RUN curl -s -O /root/.groovy/grapes/org.jsoup/jsoup/jars/jsoup-1.11.3.jar \
      https://repo1.maven.org/maven2/org/jsoup/jsoup/1.11.3/jsoup-1.11.3.jar
  ENV PATH="$GROOVY_HOME/bin:$JAVA_HOME/bin:$PATH"
  ENV CLASSPATH="./out/:$GROOVY_HOME/lib/groovy-$GROOVY_VERSION.jar:/root/.groovy/grapes/org.jsoup/jsoup/jars/jsoup-1.11.3.jar"
  COPY config config
  COPY count.groovy .
  RUN groovyc -d=./out/ --configscript=config/compiler.groovy ./count.groovy
  RUN java -agentlib:native-image-agent=config-output-dir=./out/conf/ \
         -Dgroovy.grape.enable=false \
        -cp ${CLASSPATH} \
        count https://e.printstacktrace.blog >/dev/null
  RUN native-image -Dgroovy.grape.enable=false \
    --no-server \
    -cp "${CLASSPATH}" \
    --allow-incomplete-classpath \
    --no-fallback \
    --report-unsupported-elements-at-runtime \
    --initialize-at-build-time \
    --initialize-at-run-time=org.codehaus.groovy.control.XStreamUtils,groovy.grape.GrapeIvy \
    -H:ConfigurationFileDirectories=./out/conf/ \
    --enable-url-protocols=http,https count
  SAVE ARTIFACT count  dist/count AS LOCAL build/count

docker:
  # FROM alpine:3.15
  # ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
  # ENV PATH="$JAVA_HOME/bin:$PATH"
  FROM container-registry.oracle.com/os/oraclelinux:8-slim
  COPY +build/dist /opt/
  # COPY ./jsoup-1.11.3.jar /opt/lib/jsoup-1.11.3.jar
  # RUN  apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
  ENTRYPOINT ["/opt/count"]
  SAVE IMAGE niels58/graalvm-ce-count-native:v1

all:
  BUILD +build 
  BUILD +docker