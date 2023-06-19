#!/bin/bash

## load variables
if [[ -f .env ]]; then
  source .env
fi

## colors
LINE=$(ColorGreen '# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #')

green='\e[32m'
blue='\e[34m'
RED='\e[31m'
clear='\e[0m'

## Funciones 
ColorGreen() {
	echo -ne $green$1$clear
}
ColorBlue() {
	echo -ne $blue$1$clear
}

function carpetas_github() {
		echo "Configuracion de GitHub"
			if [ -f "$PATH_GH_PERS" ]
			then
   				echo "La carpeta PERSONAL esta creada"
			else
   				echo "Creando carpeta PERSONAL"
				mkdir -p $PATH_GH_PERS
				sleep 3
			fi
}
function inst_helm() { 
	cd $HOME
	helm_v=$(helm version --short)
	echo -e "$blue Comprando si esta instalado Helm...$clear"
	if ! command -v helm &> /dev/null; then
		echo -e "$RED Helm no está instalado. Instalando Helm...$clear"
		curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
		chmod 700 get_helm.sh
		./get_helm.sh
        echo -e "$green Helm ($helm_v) se ha instalado correctamente.$clear"
    else
        echo -e "$green Ya existe la instalacion de Helm ($helm_v).$clear"
	fi
}
function inst_argo() { 
	cd ~
	helm_v=$(argo version --short)
	echo -e "$blue Comprando si esta instalado Argo...$clear"
	if ! command -v argo &> /dev/null; then
		echo -e "$RED Argo no está instalado. Instalando Argo...$clear"
		curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.4.8/argo-linux-amd64.gz		chmod 700 get_helm.sh
		gunzip argo-linux-amd64.gz
		chmod +x argo-linux-amd64
		mv ./argo-linux-amd64 /usr/local/bin/argo
        echo -e "$green Helm ($helm_v) se ha instalado correctamente.$clear"
    else
        echo -e "$green Ya existe la instalacion de Helm ($helm_v).$clear"
	fi
}
function inst_kube() { 
		cd $HOME
		kube_v=$(kubectl version --client=true | grep -oP '(?<=GitVersion:"v)\d+\.\d+\.\d+')
		echo -e "$blue Comprando si esta instalado Kubectl...$clear"
		if ! command -v kubectl &> /dev/null; then
   			echo -e "$RED Kubectl no está instalado. Instalando Kubectl...$clear"
			curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
			sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
			echo -e "$green Kubectl ($kube_v) se ha instalado correctamente.$clear"
		else
			echo -e "$green Ya existe la instalacion de Kubectl ($kube_v).$clear"
		fi
}
function inst_minikube() {
		cd $HOME
		mk_v=$(minikube version --short)
		echo -e "$blue Comprando si esta instalado Minikube...$clear"
		if ! command -v minikube &> /dev/null; then
   			echo -e "$RED Minikube no está instalado. Instalando Minikube...$clear"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
			sudo install minikube-linux-amd64 /usr/local/bin/minikube
			echo -e "$green Minikube ($mk_v) se ha instalado correctamente.$clear"
		else
			echo -e "$green Ya existe la instalacion de Minikube ($mk_v).$clear"
		fi
}
function inst_terra() { 
	cd $HOME
	terra_v=$(terraform version | grep -oP '(?<=Terraform v)\d+\.\d+\.\d+')
	echo -e "$blue Comprando si esta instalado Terraform...$clear"
	if ! command -v terraform &> /dev/null; then
		echo -e "$RED terraform no está instalado. Instalando terraform...$clear"
		curl "https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip" -o terra_1.0.11.zip
		unzip terra_1.0.11.zip
		sudo mv terraform /usr/local/bin/
		echo "Limpiando instalacion"
		rm -f terra_1.0.11.zip
		echo -e "$green Terraform ($terra_v) se ha instalado correctamente.$clear"
	else
		echo -e "$green Ya existe la instalacion de Terraform ($terra_v).$clear"
	fi
}
function inst_awscli() {
		cd $HOME
		echo "Instalando aws cli"
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		unzip awscliv2.zip
		sudo ./aws/install
		echo "Limpiando instalacion"
		rm -rf ./aws && rm -f awscliv2.zip
		aws --version
		sleep 3
}
function inst_docker() {
	echo -e "$blue Comprando si esta instalado Docker...$clear"
	docker_v=$(docker version --format '{{.Server.Version}}')
	if ! command -v docker &> /dev/null; then
        echo -e "$RED Docker no está instalado. Instalando Docker...$clear"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
		echo -e "$green Docker ($docker_v) se ha instalado correctamente.$clear"
    else
        echo -e "$green Ya existe la instalacion de Docker ($docker_v).$clear"
    fi
}
function inst_coreapps() {
	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Preparando repositorios y core apps') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	sudo apt-get install build-essential python3-dev libssl-dev inotify-tools python3-dbus
	sleep 3
	sudo apt-get -y install \
		install ubuntu-restricted-extras \
		chrome-gnome-shell \
    	ca-certificates \
		build-essential \
		python3-dev \
		libssl-dev \
		inotify-tools \
		python3-dbus \
    	zsh \
    	apt-transport-https \
    	curl \
        git \
    	gnupg \
		python3-pip \
    	gnupg-agent \
    	software-properties-common \
    	lsb-release
	# sudo add-apt-repository ppa:obsproject/obs-studio -y
	echo =ne "$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Finalizado la instalacion de core apps') $(ColorGreen '# # # # # # # # #')"
	sleep 5
}
function inst_apps() {
	echo -ne "$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Instalando Aplicaciones') $(ColorGreen '# # # # # # # # #')"
	sleep 3
	sudo apt -y install \
		mc \
		dialog \
		obs-studio \
		zsh \
		neovim \
		wget \
		flameshot \
		jq \
		htop \
		exa \
		tree \
		fonts-powerline \
		neofetch \
		kubecolor \
		ffmpeg \
		vlc \
		ttf-mscorefonts-installer \
		inetutils-traceroute \
		dnsutils

	# echo -ne "$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Instalando SNAP Apps') $(ColorGreen '# # # # # # # # #')"
	# sleep 3
	# sudo snap install \
	# 	cacher \
	# 	spotify \
	# 	postman
	#	kontena-lens --classic \ #no es la version oficial
	#	code --classic
}
function inst_ohmyzsh() {
		echo "Comprobando OhMyZSH"
		cd ~
		FILE_ZSH="~/.zshrc"
		if [ -f "$FILE_ZSH" ]; then
   				echo "ZSH ya esta instalado"
			else
   				echo "Instalando ZSH y Antigen"
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
				sleep 5
				echo "Instalando Antigen"
				curl -L git.io/antigen > ~/.oh-my-zsh/antigen.zsh
			fi
}
function inst_antigen() {
		echo "Comprobando Antigen"
		cd ~
		FILE_ANTIGEN="~/.oh-my-zsh/antigen.zsh"
		if [ -f "$FILE_ANTIGEN" ]; then
   				echo "Antigen ya esta instalado"
			else
				echo "Instalando Antigen"
				curl -L git.io/antigen > ~/.oh-my-zsh/antigen.zsh
			fi
}
function inst_brave() { 
		cd ~
		echo -e "$blue Comprando si esta instalado Brave Browser...$clear"
		if ! command -v brave-browser &> /dev/null; then
   			echo -e "$RED Brave no está instalado. Instalando Brave...$clear"
			sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
			echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
			sudo apt update && sudo apt install brave-browser
			echo -e "$green Brave se ha instalado correctamente.$clear"
		else
			echo -e "$green Ya existe la instalacion de brave.$clear"
		fi
}
function config_enlaces() {
	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Creando enlaces simbolicos') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	cd ~
	sleep 3
	#ln -s $REPO_MJC_1/.kube $HOME/.kube
	mv $HOME/.zshrc $HOME/.zshrc_bak
	ln -s $PATH_GH_PERS_CONFIG/.zshrc $HOME/.zshrc
	#ln -s $REPO_MJC_1/.aws $HOME/.aws
	#ln -s $REPO_MJC_1/ssh-configs/config $HOME/.ssh/config
}
function config_git() {
    cd $PATH_GH_PERS
	git config --global user.email "mjcheveste@gmail.com"
	git config --global user.name "Martin J. Cheveste"
    # git clone git@github.com:tinchos/configs.git
	# sleep 3
    git clone git@github.com:tinchos/terra-lab.git
    sleep 3
	git clone git@github.com:tinchos/docker-lab.git
	sleep 3
    # cd congigs
    # git checkout linux
	# sleep 3
    # git pull
}
function os_upgrade() {
		echo -ne "
		$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Actualizando Ubuntu') $(ColorGreen '# # # # # # # # #')
		"
		sleep 3
		sudo apt -y update && sudo apt install --fix-missing -y && sudo apt -y upgrade

		echo -ne "
		$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Limpiando Ubuntu') $(ColorGreen '# # # # # # # # #')
		"
		sleep 3
		sudo apt install -f && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean

}
function test_func() { 
	cd $HOME
	terra_v=$(terraform version | grep -oP '(?<=Terraform v)\d+\.\d+\.\d+')
	echo -e "$blue Comprando si esta instalado Terraform...$clear"
	if ! command -v terraform &> /dev/null; then
		echo -e "$RED terraform no está instalado. Instalando terraform...$clear"
		curl "https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip" -o terra_1.0.11.zip
		unzip terra_1.0.11.zip
		sudo mv terraform /usr/local/bin/
		echo "Limpiando instalacion"
		rm -f terra_1.0.11.zip
		echo -e "$green Terraform ($terra_v) se ha instalado correctamente.$clear"
	else
		echo -e "$green Ya existe la instalacion de Terraform ($terra_v).$clear"
	fi
}

## start menu options

menu_ubuntu() {
echo -ne "
Menu PostInstall para Ubuntu
$(ColorGreen '1)') Configuracion Post Instalacion
$(ColorGreen '2)') Instalacion de Devops Tools
$(ColorGreen '3)') Configuracion y Clonacion de repos
$(ColorGreen '4)') Instalacion de Aplicaciones
$(ColorGreen '5)') 
$(ColorGreen '6)') 
$(ColorGreen '7)') funcion de test
$(ColorGreen '9)') Actualizar y Limpiar
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
                1) inst_coreapps ; inst_ohmyzsh ; inst_antigen ; os_upgrade ; menu_ubuntu ;;
                2) inst_docker ; inst_kube ; inst_terra ; inst_minikube ; inst_argo ; inst_helm ; menu_ubuntu ;;
                3) carpetas_github ; config_git ; config_enlaces ; menu_ubuntu ;;
                4) inst_apps ; inst_brave ; menu_ubuntu ;;
				7) test_func ; menu_ubuntu ;;
				9) os_upgrade ; menu_ubuntu ;;
                0) exit 0 ;;
                *) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu_ubuntu
