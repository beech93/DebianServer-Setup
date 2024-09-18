#!/bin/sh
setup_sudo () {
    echo "Setting up sudo..."
    apt-get update > /dev/null 2>&1
    apt-get install sudo -yy > /dev/null 2>&1
    user=$(getent passwd 1000 |  awk -F: '{ print $1}') > /dev/null 2>&1
    echo "$user  ALL=(ALL:ALL)  ALL" >> /etc/sudoers
    echo "Defaults rootpw" >> /etc/sudoers
    echo "Sudo setup complete."
}

install_docker () {
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1
    echo "..."
    sudo sh get-docker.sh
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4) > /dev/null 2>&1
    sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose > /dev/null 2>&1
    sudo chmod +x /usr/local/bin/docker-compose > /dev/null 2>&1
    echo "..."
    sudo curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose > /dev/null 2>&1
    user=$(getent passwd 1000 |  awk -F: '{ print $1}') > /dev/null 2>&1
    sudo usermod -aG docker $USER > /dev/null 2>&1
    echo "Docker setup complete. Please log out & log back in after exiting to use without sudo."
}

setup_firewall () {
    echo "Setting up firewall.."
    sudo apt-get install ufw > /dev/null 2>&1
    sudo ufw allow ssh > /dev/null 2>&1
    sudo ufw enable
    echo "UFW enabled..."
}

install_software () {
    echo "Installing software..."
    sudo apt-get install git
    echo "Software installed."
}

while true; do
    options=("Setup Sudo" "Install Docker" "Setup Firewall" "Install Software" "Exit")

    echo "Debian Server Setup: "
    select opt in "${options[@]}"; do
        case $REPLY in
            1) setup_sudo; break ;;
            2) install_docker; break ;;
            3) setup_firewall; break ;;
            4) install_software; break ;;
            5) break 2 ;;
            *) echo "Invalid" >&2
        esac
    done
done

echo "Exiting!"
