#!/bin/bash

## load variables
if [[ -f .env ]]; then
  source .env
fi

## colors
LINE=$(ColorGreen '# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #')

GREEN='\e[32m'
BLUE='\e[34m'
CLEAR='\e[0m'
RED='\033[0;31m'
NC='\033[0m'

## Funciones 
ColorGreen() {
	echo -ne $GREEN$1$CLEAR
}
ColorBlue() {
	echo -ne $BLUE$1$CLEAR
}

function inst_helm() { 
	cd $HOME
	helm_v=$(helm version --short)
	echo -e "$BLUE Comprando si esta instalado Helm...$CLEAR"
	if ! command -v helm &> /dev/null; then
		echo -e "$RED Helm no está instalado. Instalando Helm...$CLEAR"
		curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
		chmod 700 get_helm.sh
		./get_helm.sh
        echo -e "$GREEN Helm ($helm_v) se ha instalado correctamente.$CLEAR"
    else
        echo -e "$BLUE Ya existe la instalacion de Helm ($helm_v).$CLEAR"
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
function inst_azure() { 
	cd ~
	azure_v=$(az version)
	echo -e "$BLUE Comprando si esta instalado AzureCli...$CLEAR"
	if ! command -v az &> /dev/null; then
		echo -e "$RED AzureCli no esta instalado. Instalando Azure...$CLEAR"
		sudo mkdir -p /etc/apt/keyrings
		curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
        sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
        echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ jammy main" |
            sudo tee /etc/apt/sources.list.d/azure-cli.list
        sudo apt-get update
        sudo apt-get install azure-cli
        echo -e "$GREEN Azure ($azure_v) se ha instalado correctamente.$CLEAR"
    else
        echo -e "$BLUE Ya existe la instalacion de Azure ($azure_v).$CLEAR"
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
function inst_minikube() {
		cd $HOME
		mk_v=$(minikube version --short)
		echo -e "$BLUE Comprando si esta instalado Minikube...$CLEAR"
		if ! command -v minikube &> /dev/null; then
   			echo -e "$RED Minikube no está instalado. Instalando Minikube...$CLEAR"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
			sudo install minikube-linux-amd64 /usr/local/bin/minikube
			echo -e "$GREEN Minikube ($mk_v) se ha instalado correctamente.$CLEAR"
		else
			echo -e "$BLUE Ya existe la instalacion de Minikube ($mk_v).$CLEAR"
		fi
}
function inst_terra() { 
	cd $HOME
	terra_v=$(terraform version | grep -oP '(?<=Terraform v)\d+\.\d+\.\d+')
	echo -e "$BLUE Comprando si esta instalado Terraform...$CLEAR"
	if ! command -v terraform &> /dev/null; then
		echo -e "$RED terraform no está instalado. Instalando terraform...$CLEAR"
		curl "https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip" -o terra_1.0.11.zip
		unzip terra_1.0.11.zip
		sudo mv terraform /usr/local/bin/
		echo "Limpiando instalacion"
		rm -f terra_1.0.11.zip
		echo -e "$GREEN Terraform ($terra_v) se ha instalado correctamente.$CLEAR"
	else
		echo -e "$BLUE Ya existe la instalacion de Terraform ($terra_v).$CLEAR"
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
	echo -e "$BLUE Comprando si esta instalado Docker...$CLEAR"
	cd $HOME
	docker_v=$(docker version --format '{{.Server.Version}}')
	if ! command -v docker &> /dev/null; then
        echo -e "$RED Docker no está instalado. Instalando Docker...$CLEAR"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
		echo -e "$GREEN Docker ($docker_v) se ha instalado correctamente.$CLEAR"
		rm -y get-docker.sh
    else
        echo -e "$BLUE Ya existe la instalacion de Docker ($docker_v).$CLEAR"
    fi
}
function inst_ohmyzsh() {
		echo -e "${BLUE}### Comprobando OhMyZSH ### ${NC}"
		if [ ! -d "$HOME/.oh-my-zsh" ]; then
   				echo -e "${RED}### Oh My Zsh no está instalado. Instalando... ### ${NC}"
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
			else
   				echo -e "${GREEN}### Oh My Zsh ya está instalado.${NC}"
			fi
}
function inst_antigen() {
		echo -e "${BLUE}### Comprobando Antigen ### ${NC}"
		FILE_ANTIGEN="~/.oh-my-zsh/antigen.zsh"
		if [[ -f "$FILE_ANTIGEN" ]]; then
			echo -e "${RED}### Instalando Antigen ### ${NC}"
			curl -L git.io/antigen > ~/.oh-my-zsh/antigen.zsh
			echo -e "${GREEN}### Antigen se instalo correctamente ### ${NC}"
   		else
			echo -e "${GREEN}### Antigen ya esta instalado ### ${NC}"
		fi
}
function inst_coreapps() {
	local script_dir="$(dirname "$0")"  # Directorio del script
    local file_path="$script_dir/programs_core.src"  # Ruta del archivo "programs.src"

	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Preparando repositorios') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	sleep 3
	programs_core=($(cat "$file_path"))
	for program in "${programs_core[@]}"
	do
		if dpkg -s "$program" &> /dev/null; then
			echo -e "${BLUE}El programa '$program' ya esta instalado ${NC}"
		else
			sudo apt install -y "$program"
			echo -e "${GREEN}'$program' Se instalo satisfactoriamente ${NC}"
		fi
	done
}
function inst_apps() {
	local script_dir="$(dirname "$0")"  # Directorio del script
    local file_path="$script_dir/programs.src"  # Ruta del archivo "programs.src"

	echo -ne " $LINE $(ColorGreen '# # # # # # # # #') $(ColorBlue 'Preparando repositorios') $(ColorGreen '# # # # # # # # #') $LINE "
	sleep 3
	programs=($(cat "$file_path"))
	for program in "${programs[@]}"
	do
		if dpkg -s "$program" &> /dev/null; then
			echo -e "${BLUE}El programa '$program' ya esta instalado ${NC}"
		else
			sudo apt install -y "$program"
			echo -e "${GREEN}'$program' Se instalo satisfactoriamente ${NC}"
		fi
	done
}
function config_enlaces() {
	echo -ne "
	$LINE
	$(ColorGreen '# # # # # # # # #') $(ColorBlue 'Creando enlaces simbolicos') $(ColorGreen '# # # # # # # # #')
	$LINE
	"
	cd ~
	sleep 3

	mv $HOME/.zshrc $HOME/.zshrc_bak
	ln -s $PATH_GH_PERS_CONFIG/.zshrc $HOME/.zshrc
}
function config_git() {
    cd $PATH_GH_PERS
	git config --global user.email "$GIT_USER"
	git config --global user.name "$GIT_NAME"
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
		echo -e "${BLUE}### Comprobando Antigen ### ${NC}"
		FILE_ANTIGEN="~/.oh-my-zsh/antigen.zsh"
		if [[ -f "$FILE_ANTIGEN" ]]; then
			echo -e "${RED}### Instalando Antigen ### ${NC}"
			curl -L git.io/antigen > ~/.oh-my-zsh/antigen.zsh
			echo -e "${GREEN}### Antigen se instalo correctamente ### ${NC}"
   		else
			echo -e "${GREEN}### Antigen ya esta instalado ### ${NC}"
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
$(ColorGreen '7)') funcion test
$(ColorGreen '9)') Actualizar y Limpiar
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
                1) inst_coreapps ; inst_ohmyzsh ; inst_antigen ; os_upgrade ; menu_ubuntu ;;
                2) inst_docker ; inst_kube ; inst_terra ; inst_argo ; inst_helm ; inst_azure ; inst_minikube ; menu_ubuntu ;;
                3) carpetas_github ; git ; enlaces ; menu_ubuntu ;;
                4) inst_apps ; menu_ubuntu ;;
#               5)  ; menu_ubuntu ;;
#				6)  ; menu_ubuntu ;;
				7) test_func ; menu_ubuntu ;;
				9) os_upgrade ; menu_ubuntu ;;
                0) exit 0 ;;
                *) echo -e $RED"Wrong option."$CLEAR; WrongCommand;;
        esac
}

# Call the menu function
menu_ubuntu