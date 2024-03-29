#!/bin/bash

# load variables
if [[ -f .env ]]; then
  source .env
fi

## Variables ##################################
LINE=$(ColorGreen '# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #')

green='\e[32m'
blue='\e[34m'
clear='\e[0m'
RED='\033[0;31m'
NC='\033[0m'
###############################################

## Funciones ##################################
ColorGreen() {
	echo -ne $green$1$clear
}
ColorBlue() {
	echo -ne $blue$1$clear
}

function carpetas_github() {
    cd $HOME
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
	cd $HOME
	argo_v=$(argo version --short)
	echo -e "$BLUE Comprando si esta instalado Argo...$CLEAR"
	if ! command -v argo &> /dev/null; then
        echo -e "$RED ArgoCD no está instalado. Instalando ArgoCD...$CLEAR"
        sudo curl -sLO https://github.com/argoproj/argo/releases/latest/download/argo-linux-amd64.gz
        sudo gunzip -f argo-linux-amd64.gz
        sudo mv argo-linux-amd64 /usr/local/bin/argo
        sudo chmod +x /usr/local/bin/argo
        echo -e "$GREEN Helm ($argo_v) se ha instalado correctamente.$CLEAR"
    else
        echo -e "$BLUE Ya existe la instalacion de ArgoCD ($argo_v).$CLEAR"
    fi
}
	# argo_v=$(argo version --short)
	# echo -e "$blue Comprando si esta instalado Argo...$clear"
	# if ! command -v argo &> /dev/null; then
	# 	echo -e "$RED Argo no está instalado. Instalando Argo...$clear"
	# 	curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.4.8/argo-linux-amd64.gz
	# 	gunzip argo-linux-amd64.gz
	# 	chmod +x argo-linux-amd64
	# 	mv ./argo-linux-amd64 /usr/local/bin/argo
    #     echo -e "$green Argo ($argo_v) se ha instalado correctamente.$clear"
    # else
    #     echo -e "$green Ya existe la instalacion de Argo ($argo_v).$clear"
	# fi
#}
function inst_azure() { 
	cd ~
	azure_v=$(az --version)
	echo -e "$blue Comprando si esta instalado AzureCli...$clear"
	if ! command -v az &> /dev/null; then
		echo -e "$RED AzureCli no esta instalado. Instalando Azure...$clear"
		sudo mkdir -p /etc/apt/keyrings
		curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
        sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
        echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ jammy main" |
            sudo tee /etc/apt/sources.list.d/azure-cli.list
        sudo apt-get update
        sudo apt-get install azure-cli
        echo -e "$green Azure ($azure_v) se ha instalado correctamente.$clear"
    else
        echo -e "$green Ya existe la instalacion de Azure ($azure_v).$clear"
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
function inst_kube() { 
		cd $HOME
		kube_v=$(kubectl version --client=true | grep -oP '(?<=GitVersion:"v)\d+\.\d+\.\d+')
		echo -e "$BLUE Comprando si esta instalado Kubectl...$CLEAR"
		if ! command -v kubectl &> /dev/null; then
   			echo -e "$RED Kubectl no está instalado. Instalando Kubectl...$CLEAR"
			curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
			sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
			echo -e "$GREEN Kubectl ($kube_v) se ha instalado correctamente.$CLEAR"
		else
			echo -e "$BLUE Ya existe la instalacion de Kubectl ($kube_v).$CLEAR"
		fi
}
function inst_terra() { 
	cd $HOME
	terra_v=$(terraform version | grep -oP '(?<=Terraform v)\d+\.\d+\.\d+')
	echo -e "$blue Comprando si esta instalado Terraform...$clear"
	if ! command -v terraform &> /dev/null; then
		echo -e "$RED terraform no está instalado. Instalando terraform...$clear"
		#curl "https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip" -o terra_1.0.11.zip
		curl "https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip" -o terra_1.6.0.zip
		unzip terra_1.6.0.zip
		sudo mv terraform /usr/local/bin/
		echo "Limpiando instalacion"
		rm -f terra_1.6.0.zip
		echo -e "$green Terraform ($terra_v) se ha instalado correctamente.$clear"
	else
		echo -e "$green Ya existe la instalacion de Terraform ($terra_v).$clear"
	fi
}
function inst_awscli() {
		cd $HOME
		echo -e "$blue Comprando si esta instalado awsCli...$clear"
		aws_v=$(aws --version)
		if ! command -v aws &> /dev/null; then
			echo -e "$RED awsCli no está instalado. Instalando AWS...$clear"
			curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
			unzip awscliv2.zip
			sudo ./aws/install
			echo "Limpiando instalacion"
			rm -rf ./aws && rm -f awscliv2.zip
			aws --version
		else
        	echo -e "$green Ya existe la instalacion de awsCli ($aws_v).$clear"
    	fi
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
function inst_kubelogin() {
	echo -e "$blue Comprando si esta instalado Kubelogin...$clear"
	cd $HOME
	Kubelogin_v=$(kubelogin version)
	if ! command -v kubelogin &> /dev/null; then
        echo -e "$RED kubelogin no está instalado. Instalando kubelogin...$clear"
        curl -LO https://github.com/int128/kubelogin/releases/latest/download/kubelogin_linux_amd64.zip
        unzip kubelogin_linux_amd64.zip
        sudo mv kubelogin /usr/local/bin/kubelogin
		sudo chmod +x /usr/local/bin/kubelogin
		echo -e "$green kubelogin ($Kubelogin_v) se ha instalado correctamente.$clear"
    else
        echo -e "$green Ya existe la instalacion de kubelogin ($Kubelogin_v).$clear"
    fi
}
function inst_ohmyzsh() {
		echo -e "${blue}### Comprobando OhMyZSH ### ${NC}"
		if [ ! -d "$HOME/.oh-my-zsh" ]; then
   				echo -e "${RED}### Oh My Zsh no está instalado. Instalando... ### ${NC}"
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
			else
   				echo -e "${green}### Oh My Zsh ya está instalado.${NC}"
			fi
}
function inst_antigen() {
		echo -e "${blue}### Comprobando Antigen ### ${NC}"
		FILE_ANTIGEN="~/.oh-my-zsh/antigen.zsh"
		if [ -f "$FILE_ANTIGEN" ]; then
   				-e "${RED}### Instalando Antigen ### ${NC}"
				curl -L git.io/antigen > ~/.oh-my-zsh/antigen.zsh
			else
				echo -e "${green}### Antigen ya esta instalado ### ${NC}"
			fi
}

function inst_brave() {
    echo -e "${blue}### Comprobando Brave Browser ### ${NC}"

    if [ -n "$(command -v brave-browser)" ]; then
        echo -e "${green}### Brave Browser ya está instalado. Verificando versión... ### ${NC}"
        current_version=$(brave-browser --version | awk '{print $2}')
        echo -e "Versión actual: $current_version"

        echo -e "${yellow}### Actualizando Brave Browser ### ${NC}"
        sudo apt update
        sudo apt upgrade brave-browser -y
    else
        echo -e "${red}### Brave Browser no está instalado. Instalando... ### ${NC}"
        sudo apt install apt-transport-https curl -y
        curl -sS https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
        echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
        sudo apt install brave-browser -y
    fi
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
function inst_apps() {
	echo -ne " $LINE $(ColorGreen '# # # # # # # # #') $(ColorBlue 'Preparando repositorios') $(ColorGreen '# # # # # # # # #') $LINE "
	sleep 3
	programs=($(cat programs.src))
	for program in "${programs[@]}"
	do
		if dpkg -s "$program" &> /dev/null; then
			echo -e "${blue}El programa '$program' ya esta instalado ${NC}"
		else
			sudo apt install -y "$program"
			echo -e "${green}'$program' Se instalo satisfactoriamente ${NC}"
		fi
	done
}
function inst_snap() {
	echo -ne " $LINE $(ColorGreen '# # #') $(ColorBlue 'Instalando SNAP Apps') $(ColorGreen '# # #') $LINE "
	sleep 3
	programs=($(cat programs_snap.src))
	for program in "${programs[@]}"
	do
		if dpkg -s "$program" &> /dev/null; then
			echo -e "${blue}El programa '$program' ya esta instalado ${NC}"
		else
			sudo apt install -y "$program"
			echo -e "${green}'$program' Se instalo satisfactoriamente ${NC}"
		fi
	done
}
function inst_coreapps() {
	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Preparando repositorios') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	sleep 3
	programs_core=($(cat programs_core.src))
	for program in "${programs_core[@]}"
	do
		if dpkg -s "$program" &> /dev/null; then
			echo -e "${blue}El programa '$program' ya esta instalado ${NC}"
		else
			sudo apt install -y "$program"
			echo -e "${green}'$program' Se instalo satisfactoriamente ${NC}"
		fi
	done

}
function enlaces() {
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
function git() {
	cd ~
	# ssh_keys=("$GIT_KEY1" "$GIT_KEY2")
	# for key in "${ssh_keys[@]}"
    # do
    #     if ! ssh-add -L | grep -q "$key"; then
    #         echo -e "${RED} La SSH key '$key' no está agregada. Agregando... ${NC}"
    #         ssh-add "$key"
    #         echo -e "${green} La SSH key '$key' ha sido agregada correctamente.${NC}"
    #     else
    #         echo -e "${blue} La SSH key '$key' ya está agregada.${NC}"
    #     fi
    # done
    cd $PATH_GH_PERS
	if [[ -z "$(git config --global user.email)" ]]; then
        if [[ -z "$GIT_USER_EMAIL" ]]; then
            echo "No se ha especificado el valor de GIT_USER_EMAIL en las variables de entorno."
            return 1
    	fi

        git config --global user.email "$GIT_USER_EMAIL"
        echo "user.email ha sido configurado correctamente."
    else
        echo "user.email ya está configurado."
    fi

    if [[ -z "$(git config --global user.name)" ]]; then
        if [[ -z "$GIT_USER_NAME" ]]; then
            echo "No se ha especificado el valor de GIT_USER_NAME en las variables de entorno."
            return 1
        fi

        git config --global user.name "$GIT_USER_NAME"
        echo "user.name ha sido configurado correctamente."
    else
        echo "user.name ya está configurado."
    fi
	
    git clone git@github.com:tinchos/helm-argo.git && sleep 3
    git clone git@github.com:tinchos/test-docker-compose.git && sleep 3
    git clone git@github.com:tinchos/configs.git && sleep 3
    git clone git@github.com:tinchos/terra-lab.git && sleep 3
	git clone git@github.com:tinchos/docker-lab.git && sleep 3
    cd congigs
    git checkout linux
	sleep 3
    git pull
}
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
$(ColorGreen '7)') funcion test
$(ColorGreen '9)') Actualizar y Limpiar
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
                1) inst_coreapps ; inst_ohmyzsh ; inst_antigen ; os_upgrade ; menu_ubuntu ;;
                2) inst_docker ; inst_kube ; inst_terra ; inst_argo ; inst_azure ; inst_minikube ; inst_kubelogin ; menu_ubuntu ;;
                3) carpetas_github ; git ; enlaces ; menu_ubuntu ;;
                4) inst_apps ; inst_brave ; inst_snap ; menu_ubuntu ;;
#               5)  ; menu_ubuntu ;;
#				6)  ; menu_ubuntu ;;
				7) inst_brave ; menu_ubuntu ;;
				9) os_upgrade ; menu_ubuntu ;;
                0) exit 0 ;;
                *) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu_ubuntu