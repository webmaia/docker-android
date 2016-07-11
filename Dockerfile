FROM ubuntu:14.04
MAINTAINER nekocode <nekocode.cn@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Dependencies to execute Android builds
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget && \
    apt-get install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 && \
    apt-get clean

# Download JDK 7
RUN wget -q --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz -O Jdk7.tar.gz && \
    tar -xzf Jdk7.tar.gz -C /usr/local && \
    rm Jdk7.tar.gz

# Download JDK 8
RUN wget -q --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz -O Jdk8.tar.gz && \
    tar -xzf Jdk8.tar.gz -C /usr/local && \
    rm Jdk8.tar.gz

# Configure Java Environment
ENV JAVA7_HOME /usr/local/jdk1.7.0_79
ENV JAVA8_HOME /usr/local/jdk1.8.0_77
ENV JAVA_HOME /usr/local/jdk1.7.0_79
ENV PATH $PATH:$JAVA_HOME/bin

# Download Android SDK tools
RUN wget -q "http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" -O android-sdk.tgz && \
    tar -xzf android-sdk.tgz -C /usr/local && \
    rm android-sdk.tgz

# Configure Android SDK Environment
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/build-tools/23.0.3

# Install Android SDK components
RUN echo y | android update sdk --no-ui --all \
    --proxy-host android-mirror.bugly.qq.com --proxy-port 8080 -s --filter \
    "platform-tools,build-tools-23.0.3,build-tools-24.0.0,android-23,android-24" && \
    echo y | android update sdk --no-ui --all \
    --proxy-host android-mirror.bugly.qq.com --proxy-port 8080 -s --filter \
    "extra-android-m2repository,extra-google-m2repository,extra-android-support"
