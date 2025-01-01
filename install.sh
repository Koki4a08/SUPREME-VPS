#!/bin/bash

# Colors for better visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

clear

echo -e "${BLUE}=== VPS Installation Script ===${NC}"
echo -e "${GREEN}Select operating system:${NC}"
echo "1) Ubuntu"
echo "2) Debian"
echo "3) CentOS"
echo -n "Enter number (1-3): "
read os_choice

case $os_choice in
    1)
        echo -e "${GREEN}Select Ubuntu version:${NC}"
        echo "1) 22.04 LTS"
        echo "2) 20.04 LTS"
        echo "3) 18.04 LTS"
        echo -n "Enter number (1-3): "
        read ubuntu_version
        case $ubuntu_version in
            1) OS_VERSION="ubuntu:22.04" ;;
            2) OS_VERSION="ubuntu:20.04" ;;
            3) OS_VERSION="ubuntu:18.04" ;;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
        esac
        ;;
    2)
        echo -e "${GREEN}Select Debian version:${NC}"
        echo "1) 12 (Bookworm)"
        echo "2) 11 (Bullseye)"
        echo "3) 10 (Buster)"
        echo -n "Enter number (1-3): "
        read debian_version
        case $debian_version in
            1) OS_VERSION="debian:12" ;;
            2) OS_VERSION="debian:11" ;;
            3) OS_VERSION="debian:10" ;;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
        esac
        ;;
    3)
        echo -e "${GREEN}Select CentOS version:${NC}"
        echo "1) CentOS 9 Stream"
        echo "2) CentOS 8 Stream"
        echo "3) CentOS 7"
        echo -n "Enter number (1-3): "
        read centos_version
        case $centos_version in
            1) OS_VERSION="quay.io/centos/centos:stream9" ;;
            2) OS_VERSION="quay.io/centos/centos:stream8" ;;
            3) OS_VERSION="centos:7" ;;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
        esac
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}Dockerfile created successfully!${NC}"
echo -e "${BLUE}Starting build process...${NC}"

docker build -t my-vps-image .

echo -e "${GREEN}Image created successfully!${NC}"
echo -e "${BLUE}To start the container use:${NC}"
echo "docker run -it my-vps-image" 