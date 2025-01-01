FROM ubuntu:22.04

# Задаване на environment променливи
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Sofia

# Инсталиране на базови пакети
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        wget \
        git \
        nano \
        sudo \
        python3 \
        python3-pip \
        nodejs \
        npm \
        zip \
        unzip \
        htop \
        net-tools \
        iputils-ping \
        openssh-server \
        locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Конфигуриране на локализация
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Създаване на нужните директории
WORKDIR /home/container

# Създаване на потребител и група
RUN groupadd -g 987 container && \
    useradd -m -d /home/container -g container -s /bin/bash container && \
    chown -R container:container /home/container && \
    echo "container ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Задаване на правилния часови пояс
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Задаване на потребител и environment променливи
USER container
ENV USER=container
ENV HOME=/home/container

# Стартова команда
CMD ["/bin/bash"] 
