# 使用官方的 OpenJDK 镜像作为基础镜像，因为 Android 编译需要 Java
#FROM openjdk:17-jdk-buster

FROM openjdk:11-jdk-slim

# 查看 Java 版本
RUN java -version

# 设置环境变量避免交互式配置
ENV DEBIAN_FRONTEND=noninteractive


# 更换 APT 的软件源到阿里云提供的更快捷稳定的镜像站点
RUN sed -i 's@http://deb.debian.org@https://mirrors.aliyun.com@g' /etc/apt/sources.list

# 更新软件包索引
RUN apt-get update

# 安装一组常用的开发和构建工具
RUN apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    curl \
    qrencode \
    build-essential

# 清理不必要的文件以减小镜像大小
RUN rm -rf /var/lib/apt/lists/*


# 下载并安装 Android SDK Command-line Tools
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools

# 验证环境变量设置
RUN echo "ANDROID_HOME=${ANDROID_HOME}" && \
    echo "PATH=${PATH}"

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9862592_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d . && \
    mv cmdline-tools latest && \
    rm cmdline-tools.zip

RUN which sdkmanager
    # 确认 sdkmanager 存在
#    ls -al &&\
#    pwd
    # 确保 sdkmanager 可执行
    #chmod +x ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager
#RUN ls -la ${ANDROID_HOME}/cmdline-tools
# 同意 SDK 许可证
#RUN yes | sdkmanager --licenses
#RUN sdkmanager --licenses

# 安装所需的 SDK 组件
#RUN sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"

# 设置 Gradle 环境（你可以选择使用官方 Gradle 镜像或自己安装）
#ENV GRADLE_HOME=/opt/gradle
#ENV PATH=${PATH}:${GRADLE_HOME}/bin


# "https://dockerproxy.com",
#    "https://docker.mirrors.ustc.edu.cn",
#    "https://docker.nju.edu.cn",
#    "https://mirror.ccs.tencentyun.com"


#docker buildx build . --platform linux/amd64,linux/arm64 -t android-build-jdk11
#docker buildx build . --platform linux/amd64 -t android-build-jdk11


# 推送到coding 制品库
#docker tag android-build-jdk11:latest g-mkrc6872-docker.pkg.coding.net/android/build-env/android-build-jdk11:1.0
#docker push g-mkrc6872-docker.pkg.coding.net/android/build-env/android-build-jdk11:1.0


#sh 'mkdir -p /temp/jarclass'
#sh 'unzip -d /temp/jarclass ${ANDROID_HOME}/cmdline-tools/latest/lib/sdklib/libsdkmanager_lib.jar'
#sh 'javap -verbose /temp/jarclass/com/android/sdklib/tool/sdkmanager/SdkManagerCli.class'