# CryptoVault
Este es un borrador de cómo me imagino una cold-wallet o Vault para manejar las llaves de tokens ERC20

Lo que intenta lograr esta Shell, es dividir y encriptar una llave privada para un token ERC20 en dos partes, de manera que puedan ser separadas y almacenables, y así asegurar la confidencialidad e integridad de éstas.

Una llave privada típica entregada por MyEtherWallet tiene 64 caracteres hexadecimales (32 bytes) de esta forma:
PRIVATEKEY=f576218123462144794e001234567890123456677120d03803c86c5c000abcde

Esta algoritmo toma como input la llave y hace lo siguiente

1.- Divide la llave en 2 strings de 32 caracteres cada uno.

Con esto tengo:
PRIVATEKEY = La llave privada completa

ADDRESS = La Address de mi Wallet ERC20

MITAD1 = Los primeros 32 caracteres de la llave privada

MITAD2 = Los segundos 32 caracteres de la llave privada


PASSWORD = Una clave personal que usaré para encriptar estas partes.



2.- La primera mitad, la encripto con AES256 y una llave personal PASSWORD y la guardo en un archivo llamado MD5(ADADRESS)

Con esto obtengo mi FILE1 que es la primera mitad de mi llave privada encriptada

3.- La segunda mitad, la encripto con AES256 y como llave uso ADADRESS y luego la guardo en un archivo llamado MD5(MITAD2)

Finalmente obtengo mi FILE2, con la segunda mitad de la llave privada encriptada.

Segunda parte del Script
==========================
La siguiente parte de mi script lo que hace es presentar estos archivos en formato QR para ser mas facil imprimirlos y almacenarlos.

Para esto uso las siguientes utilidades
- qrencode
- ImageMagick

Al final del script uso un aplicativo llamado gshred para eliminar de manera segura cualquier archivo dejado en el computador con informacion confidencial de mis llaves.


Saludos

Alex Harasic
aharasic@gmail.com
