# ubuntu-post-install

Archivo de uso personal, podes copiartelo, descargarlo y mejorarlo a tu gusto. 
Esto esta hecho para facilitar la tarea de instalar y configurar aplicaciones y archivos luego de una reinstalacion.
Puede que no sea lo mas optimo y proligo pero me es util.

Si llegaste a este repo, te invito a que lo uses y lo modifique a tu gusto, no hace falta que lo diga, pero si queres hacer comentarios y subir modificaciones bienvenido sea

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
Basicamente lo uso para las rutas de los path de algunas funciones que uso para enlaces simbolicos y carpetas de git

## variables requeridas

En caso de querer usar estas variables,edita el archivo .env agregar con tus datos las siguientes variables. esto podes usarlo de ejemplo, podes usar los valores que necesites y personalizarlo a gusto

```bash
## el path en donde tenes tu repo
PATH_GH_PERS=/home/your_user/path_your_repos
## path donde esta los config
PATH_GH_PERS_CONFIG=/home/your_user/path_repo/repo
```