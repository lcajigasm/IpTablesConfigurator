#!/bin/bash

interfaz()
{
	ifconfig | egrep eth | cut -c1-5 2>/dev/null	
}
servicios()
{
	service mysqld status 2>/dev/null
	service keepalived status 2>/dev/null
	service httpd status 2>/dev/null
}

restart_firewall()
{
	
	iptables -F
	iptables -X
	iptables -Z
	iptables -t nat -F	
	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -t nat -P PREROUTING ACCEPT
	iptables -t nat -P POSTROUTING ACCEPT
	/sbin/service iptables save
	service iptables restart >/dev/null
}

open_apache()
{
	change_interface
		
	iptables -A INPUT -p tcp -i $interface --dport 80 -j ACCEPT
	iptables -A OUTPUT -p tcp -o $interface --dport 80 -j ACCEPT

	iptables -A INPUT -p tcp -i $interface --dport 443 -j ACCEPT
	iptables -A OUTPUT -p tcp -o $interface --dport 443 -j ACCEPT

	iptables -A INPUT -p tcp -i $interface --dport 8080 -j ACCEPT
	iptables -A OUTPUT -p tcp -o $interface --dport 8080 -j ACCEPT
	/sbin/service iptables save
	service iptables restart >/dev/null
}

open_mysql()
{
	change_interface
	iptables -A INPUT -p tcp -i $interface --dport 3306 -j ACCEPT
	iptables -A OUTPUT -p tcp -o $interface --dport 3306 -j ACCEPT
	/sbin/service iptables save
	service iptables restart >/dev/null
}

open_drbd()
{
	change_interface	
	iptables -A INPUT -p tcp -i $interface --dport 7788 -j ACCEPT
	iptables -A OUTPUT -p tcp -o $interface --dport 7788 -j ACCEPT
	/sbin/service iptables save
	service iptables restart >/dev/null
}

open_keepalived()
{
	change_interface
	iptables -p vrrp -i $interface -A INPUT -j ACCEPT
    	iptables -p vrrp -o $interface -A OUTPUT -j ACCEPT
	/sbin/service iptables save
	service iptables restart >/dev/null
}

open_ssh()
{
	change_interface
	iptables -A INPUT -p tcp -i $interface --dport 22 -j ACCEPT
	iptables -A OUTPUT -p tcp -o $interface --dport 22 -j ACCEPT
	/sbin/service iptables save
	service iptables restart >/dev/null
}

open_custom()
{	
	clear
	echo "Estos son los parámetros establecidos:"	
	show_globals
	echo "¿Quieres cambiarlos? [S]i/[N]o"
	read resp_custom
	if [ $resp_custom == "S" ];
	then
		change_globals
	fi
	echo "¿Que protocolo?"
	echo "[1]TCP/[2]UDP"
	read prot_r
	case $prot_r in
	1) prot="tcp"
	   echo $prot;;
	2) prot="udp";;
	*) echo "OPC no válida";;
	esac

	echo "¿Qué quieres?"
	echo "[1]Abrir puerto de entrada"
	echo "[2]Abrir puerto de salida"
	echo "[3]Abrir ambos puertos"
	read resP
	case $resP in
	1)iptables -A INPUT -i $interface -p $prot -s $iporigen --dport $puerto -j ACCEPT;;
	2)iptables -A OUTPUT -o $interface -p $prot -d $ipdestino --dport $puerto -j ACCEPT;;
	3)iptables -A INPUT -i $interface -p $prot -s $iporigen --dport $puerto -j ACCEPT
	  iptables -A OUTPUT -o $interface -p $prot -d $ipdestino --dport $puerto -j ACCEPT;;
	*)echo "OPC no válida";;
	esac
	
	/sbin/service iptables save
	service iptables restart >/dev/null		
}

iptables_menu()
{
	echo "###############"
	echo "#   IPTABLES  #"
	echo "###############"
	echo "[1] Abrir puertos: APACHE"
	echo "[2] Abrir puertos: MySQL"
	echo "[3] Abrir puertos: DRDB"
	echo "[4] Abrir puertos: Keep-Alived"
	echo "[5] Abrir puertos: SSH"
	echo "[6] Abrir puerto personalizado"
	read im

	case $im in
	1)
		open_apache;;
	2)
		open_mysql;;
	3)
		open_drbd;;
	4)
		open_keepalived;;
	5)
		open_ssh;;
	6)
		open_custom;;
	esac			
}

iptables_delete()
{
	name_temp=$RANDOM	
	echo "Introduce la cadena a buscar"
	read isearch	
	iptables -L OUTPUT -n --line-numbers | grep $isearch
	if [ $? -ne 0 ];
	then
		echo "No se ha encontrado ninguna coincidencia"
	fi
	echo "¿Qué linea deseas borrar?"
	read lin_del
	iptables -D INPUT $lin_del
	/sbin/service iptables save
	service iptables restart >/dev/null
}

file_gestion()
{
	echo "[1]Respaldar conf. iptables"
	echo "[2]Restaurar conf. iptables"
	read fresp;
	case $fresp in
	1) cp /etc/sysconfig/iptables /etc/sysconfig/iptables.bak;;
	2) cp /etc/sysconfig/iptables.bak /etc/sysconfig/iptables 2>/dev/null
	   if [ $? -ne 0 ];
	   then
		echo "Error al copiar el fichero"
		echo "¿Habías realizado una copia previamente?"
	   fi;;
	*) echo "OPC no válida";;
	esac
}



show_globals()
{
	echo "======================"
	echo "=     PARÁMETROS     ="
	echo "======================"
	echo -e "*\e[0;31mInterfaz: \e[0m \e[1;34m $interface \e[0m"
	echo -e "*\e[0;31mIp Origen: \e[0m \e[1;34m $iporigen \e[0m"
	echo -e "*\e[0;31mIp Destino: \e[0m \e[1;34m $ipdestino \e[0m"
	echo -e "*\e[0;31mPuerto: \e[0m \e[1;34m $puerto \e[0m"
	echo "======================"
}


change_globals()
{
	cg=100
	while [ $cg -ne 0 ]
	do
		echo "[1]Cambiar la interfaz de red"
		echo "[2]Cambiar la ip de origen"
		echo "[3]Cambiar la ip de destino"
		echo "[4]Cambiar el puerto"
		echo "[0]Salir"
		read cg

		case $cg in
		1)
			echo "Introduce la interfaz deseada:"
			read interface;;
		2)
			echo "Introduce la IP de origen:"
			read iporigen;;
		3)
			echo "Introduce la IP de destino:"
			read ipdestino;;
		4)
			echo "Introduce el puerto:"
			read puerto;;
		esac
	done
}

change_interface()
{
	echo "La interfaz seleccionada es " $interface
	echo "¿Quieres cambiarla?"
	echo "[S]i/[N]o"
	read answ;
	if [ $answ == "S" ];
	then
		echo "Introduce la nueva interfaz"
		read interface
	fi
}

m=100
interface="---"
iporigen="000.000.000.000"
ipdestino="000.000.000.000"
puerto="0000"
while [ $m -ne 0 ]
do
	clear
	echo "###############"
	echo "#   M E N U   #"
	echo "###############"
	show_globals
	echo "[1]Ver interfaces de red"
	echo "[2]Reiniciar nombre interfaces"
	echo "[3]Ver [TODAS] las interfaces de red"
	echo "[4]Ver servicios instalados/ en ejecución"
	echo "[5]Ver estado IPTABLES"
	echo "[6]Reiniciar reglas IPTABLES"
	echo "[7]Abrir puertos IPTABLES"
	echo "[8]Borrar una línea del fichero de configuración"
	echo "[9]Respaldar/Restaurar fichero configuracion iptables"
	echo "[0]Salir"
	read m

	case $m in 
   	1) 
        	interfaz
		read -p "Presiona [Enter] para continuar...";;
    	2) 
        	rm -f /etc/udev/rules.d/70-persistent-net.rules 2>/dev/null
		read -p "Presiona [Enter] para continuar...";;
	3)
		ifconfig -a
		read -p "Presiona [Enter] para continuar...";;	
	4)
		servicios
		read -p "Presiona [Enter] para continuar...";;
	5)
		iptables -L -n
		read -p "Presiona [Enter] para continuar...";;
	6)
		restart_firewall
		read -p "Presiona [Enter] para continuar...";;
	7)
		iptables_menu
		read -p "Presiona [Enter] para continuar...";;
	8)
		iptables_delete
		read -p "Presiona [Enter] para continuar...";;
	9)	
		file_gestion
		read -p "Presiona [Enter] para continuar...";;
	0)
		echo "Adios";;
	esac
done


