# Аргументи за избор на базов image
ARG BASE_IMAGE=ubuntu:22.04

# Използваме избрания базов image
FROM ${BASE_IMAGE}

# Задаване на environment променливи
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Sofia

# Инсталиране на базови пакети според операционната система
RUN if command -v apt-get > /dev/null; then \
        # Ubuntu/Debian пакети
        apt-get update && \
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
            software-properties-common \
            locales \
            tzdata && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* ; \
    elif command -v yum > /dev/null; then \
        # CentOS/RHEL пакети
        yum update -y && \
        yum install -y \
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
            iputils \
            langpacks-en && \
        yum clean all && \
        rm -rf /var/cache/yum ; \
    fi

# Конфигуриране на локализация
RUN if command -v locale-gen > /dev/null; then \
        locale-gen en_US.UTF-8 && \
        update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8; \
    fi

# Създаване на работна директория
WORKDIR /app

# Създаване на нов потребител и добавяне към sudo групата
RUN useradd -m -s /bin/bash docker && \
    echo "docker:docker" | chpasswd && \
    adduser docker sudo && \
    echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Задаване на правилния часови пояс
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Създаване на нужните директории и задаване на правилни права
RUN mkdir -p /app/data && \
    chown -R docker:docker /app

# Преминаване към потребителя docker
USER docker

# Конфигуриране на Git (пример)
RUN git config --global core.editor "nano"

# Добавяне на удобни алиаси в .bashrc
RUN echo "alias ll='ls -la'" >> ~/.bashrc && \
    echo "alias update='sudo apt-get update && sudo apt-get upgrade -y'" >> ~/.bashrc

# Създаване на health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Изложване на често използвани портове
EXPOSE 80 443 3000 8080

# Стартов команден интерпретатор
CMD ["/bin/bash"] 