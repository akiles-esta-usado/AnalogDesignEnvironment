# Installation

## LMOD

Es un gestor de módulos, que es una abstracciòn realizada sobre una herramienta o biblitecas de software .

LMOD ofrece características deseadas en este tipo de herramientas

**Modulefiles Jerárquicos**

Cada programa y las bibliotecas de las que depende deben ser compiladas con el mismo compilador y la misma versión. 
Un programa y las biblio
Resuelven el problema de las bibliotecas de sistema preconstruidas

**Características de Seguridad**



#### Instalación de Lua

Ya está automatizada

#### Instalación de LMOD

https://lmod.readthedocs.io/en/latest/030_installing.html#installing-lmod
https://docs.easybuild.io/installing-lmod-without-root-permissions/


Ha sido más complicada de lo que pensé, ya existe un archivo.

Por lo que vi, en este servidor la shell BASH lee un archivo llamado `\etc\bash.bashrc`,
entonces ahí dejaré el script que activa module. 

Efectivamente, ese archivo se invoca.
Para enlazarlo con el script hecho, se le agrega lo siguiente:

~~~
#### ENABLE LMOD FOR ALL BASH USERS
. /etc/profile.d/z00_lmod.sh

~~~

#### Uso de easybuild

https://tutorial.easybuild.io/files/EasyBuild-EESSI-UK-workshop-202304.pdf


p 30: Configuración de EasyBuild.