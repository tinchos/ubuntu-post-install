# ubuntu-post-install

# Requisito

Para el uso del script, es necesario tener tu achivo de variables

## Archivo de variables

En el mismo path donde se encuentre el script, crear el archivo de variables:
ejecutar:
```bash
touch .env
```
y editarlo con tu programa de preferencia:
```bash
vim .env
```

## variables requeridas
Una vez editando el archivo .env agregar con tus datos las siguientes variables. esto podes usarlo de ejemplo, podes usar los valores que necesites y personalizarlo a gusto
```bash
## el path en donde tenes tu repo
PATH_GH_PERS=/home/your_user/path_your_repos
## path donde esta los config
PATH_GH_PERS_CONFIG=/home/your_user/path_repo/repo
```