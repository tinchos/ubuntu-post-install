#!/bin/bash
# load variables
if [[ -f .env ]]; then
  source .env
fi

## Variables ##################################
PATH_GH_PERS="$HOME/${PATH1}"
PATH_GH_WORK="$HOME/${PATH2}"
LINE=$(ColorGreen '# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #')

REPO_MJC_1="$PATH_GH_PERS/configs"

green='\e[32m'
blue='\e[34m'
clear='\e[0m'
###############################################

## Funciones ##################################
ColorGreen() {
	echo -ne $green$1$clear
}
ColorBlue() {
	echo -ne $blue$1$clear
}

function carpetas_github() {
		echo "Creando carpetas para GitHub"
		mkdir -p $PATH_GH_PERS
		mkdir -p $PATH_GH_WORK
		echo "Carpetas Creadas"
}

function inst_helm() {
		curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
		chmod 700 get_helm.sh
		./get_helm.sh
}

function inst_kube() {
		echo "Instalando kubectl"
		PATH_KUBE="/usr/local/bin/kubectl"
		if [ -f "$PATH_KUBE" ]
			then
   				echo "Kubectl ya esta instalado"
			else
   				echo "Instalando kubectl"
				curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
				sleep 10
				sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
				kubectl version
		
				sleep 3
		fi        
		
}

function inst_minikube() {	
		PATH_MK="/usr/local/bin/minikube"
		if [ -f "$DIRECTORIO" ]
			then
   				echo "Minikube ya esta instalado"
			else
   				echo "Instalando Minikube"
				curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        		sleep 10
				sudo install minikube-linux-amd64 /usr/local/bin/minikube
				minikube version
				sleep 3
		fi	
		
}

function inst_terra() {
		echo "Comprobando Terraform 0.11"
		PATH_TERRA="/usr/local/bin/terraform"
		if [ -d "$DIRECTORIO" ]
			then
   				echo "Terraform 0.11 ya esta instalado"
			else
   				echo "Instalando Terraform 0.11"
				curl "https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip" -o terra_1.0.11.zip
        		sleep 5
				unzip terra_1.0.11.zip
				sudo mv terraform /usr/local/bin/
				echo "Limpiando instalacion"
				rm -f terra_1.0.11.zip
				terraform -v
				sleep 3
			fi
		
}

function inst_awscli() {
		echo "Instalando aws cli"
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		unzip awscliv2.zip
		sudo ./aws/install
		echo "Limpiando instalacion"
		rm -rf ./aws && rm -f awscliv2.zip
		aws --version
		sleep 3
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

function inst_docker() {
		echo "Desinstalando paquetes viejos de docker"
		sudo apt -y remove docker docker-engine docker.io containerd runc
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
		#os_upgrade
		echo "Instalando Docker"
		sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
		echo "Docker PostInstall"
		sleep 5
		sudo groupadd docker #creamos el grupo docker
		sudo usermod -aG docker $USER #agregamos el usuario actual al grupo docker
}

function inst_ohmyzsh() {
		echo "Comprobando OhMyZSH y Antigen"
		PATH_ZSH="~/.zshrc"
		if [ -f "$PATH_ZSH" ]
			then
   				echo "ZSH ya esta instalado"
			else
   				echo "Instalando ZSH y Antigen"
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
				sleep 5
				echo "Instalando Antigen"
				curl -L git.io/antigen > ~/.oh-my-zsh/antigen.zsh
			fi
}

function inst_apps() {
	echo -ne "$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Instalando Aplicaciones') $(ColorGreen '# # # # # # # # #')"
	sleep 3
	sudo apt -y install \
		mc \
		dialog \
		obs-studio \
		v4l2loopback-dkms \
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
		net-tools \
		ffmpeg \
		vlc \
		ttf-mscorefonts-installer \
		inetutils-traceroute \
		dnsutils

	echo -ne "$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Instalando SNAP Apps') $(ColorGreen '# # # # # # # # #')"
	sleep 3
	sudo snap install \
		cacher \
		spotify \
		postman
	#	kontena-lens --classic \ #no es la version oficial
	#	code --classic
}

function inst_coreapps() {
	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Preparando repositorios') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	sleep 3
	sudo apt-get -y install \
    	ca-certificates \
    	apt-transport-https \
    	curl \
        git \
    	gnupg \
		python3-pip \
    	gnupg-agent \
    	software-properties-common \
    	lsb-release
	sudo add-apt-repository ppa:obsproject/obs-studio -y
}

function enlaces() {
	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Creando enlaces simbolicos') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	sleep 3
	ln -s $REPO_MJC_1/.kube $HOME/.kube
	mv $HOME/.zshrc $HOME/.zshrc_bak
	ln -s $REPO_MJC_1/.zshrc $HOME/.zshrc
	ln -s $REPO_MJC_1/.aws $HOME/.aws
	ln -s $REPO_MJC_1/ssh-configs/config $HOME/.ssh/config
}

function git() {
    cd $PATH_GH_PERS
	git config --global user.email "mjcheveste@gmail.com"
	git config --global user.name "Martin J. Cheveste"
    git clone git@github.com:tinchos/configs.git
	sleep 3
    git clone git@github.com:tinchos/terra-lab.git
    sleep 3
	git clone git@github.com:tinchos/docker-lab.git
	sleep 3
    cd congigs
    git checkout linux
	sleep 3
    git pull
################################################

menu_ubuntu() {
echo -ne "
Menu PostInstall para Ubuntu
$(ColorGreen '1)') Configuracion Post Instalacion
$(ColorGreen '2)') Instalacion de Devops Tools
$(ColorGreen '3)') Configuracion y Clonacion de repos
$(ColorGreen '4)') Instalacion de Aplicaciones
$(ColorGreen '5)') 
$(ColorGreen '6)') 
$(ColorGreen '7)') 
$(ColorGreen '9)') Actualizar y Limpiar
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
                1) inst_coreapps ; inst_ohmyzsh ; os_upgrade ; menu_ubuntu ;;
                2) inst_docker ; inst_kube ; inst_terra ; inst_minikube ; menu_ubuntu ;;
                3) carpetas_github ; git ; enlaces ; menu_ubuntu ;;
                4) inst_apps ; menu_ubuntu ;;
#               5)  ; menu_ubuntu ;;
#				6)  ; menu_ubuntu ;;
#				7)  ; menu_ubuntu ;;
				9) os_upgrade ; menu_ubuntu ;;
                0) exit 0 ;;
                *) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu_ubuntu
