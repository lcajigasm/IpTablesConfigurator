# IpTablesConfigurator

IpTablesConfigurator is a bash script for configuring iptables firewall rules on CentOS/RHEL systems. The script provides an interactive Spanish menu interface for common firewall configuration tasks including opening ports for Apache, MySQL, DRBD, Keep-Alived, SSH, and custom port configurations.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Prerequisites and Environment Setup
- **CRITICAL**: This script requires root privileges to function properly. Most iptables operations will fail without root access.
- **CRITICAL**: This script is designed for CentOS/RHEL systems with SysV init. It will NOT work properly on Ubuntu/Debian systems.
- Install required dependencies on CentOS/RHEL:
  - `yum install iptables-services` (if not already installed)
  - `yum install net-tools` (for ifconfig command)
  - Ensure `/etc/sysconfig/iptables` directory exists (CentOS-specific location)

### Basic Operations
- **Syntax validation** (always run this first): `bash -n iptables_config.sh` (takes < 1 second)
- **Make script executable**: `chmod +x iptables_config.sh` 
- **Run the script**: `sudo ./iptables_config.sh` or `sudo bash iptables_config.sh`
- **Exit the script**: Select option `[0]Salir` from any menu

### Navigation and Directory Structure
- **Repository root**: `/home/runner/work/IpTablesConfigurator/IpTablesConfigurator/`
- **Main script**: `iptables_config.sh` (6546 bytes, bash script with Spanish interface)
- **Documentation**: `README.md` (basic project description)
- **License**: `LICENSE` (MIT License)

## Validation

### Manual Validation Requirements
**CRITICAL**: After making any changes to the script, you MUST test the following scenarios:

1. **Syntax Validation**: 
   - `bash -n iptables_config.sh` must complete without errors (< 1 second)

2. **Menu Display Test**:
   - Run `echo "0" | bash iptables_config.sh` to test menu display and exit (< 1 second)
   - Verify the Spanish menu displays correctly with all 10 options [0-9]

3. **Interface Detection Test**:
   - Run `echo -e "1\n0" | timeout 5 bash iptables_config.sh` to test interface detection (< 1 second)
   - Verify it shows available network interfaces without errors

4. **Full Interface Listing Test**:
   - Run `echo -e "3\n0" | timeout 5 bash iptables_config.sh` to test `ifconfig -a` functionality (< 1 second)
   - Verify all network interfaces are displayed

5. **Service Status Test** (CentOS only):
   - Run `echo -e "4\n0" | timeout 5 bash iptables_config.sh` to test service status checking
   - On CentOS: Should check mysqld, keepalived, and httpd services
   - On Ubuntu: Will show no output (expected - services don't exist)

### Limitations in Non-CentOS Environments
- **iptables commands require root**: All firewall modification functions [5-9] will fail without root privileges
- **Service management**: Functions that check mysqld, httpd, keepalived services will not work on Ubuntu/Debian
- **Configuration path**: Script expects `/etc/sysconfig/iptables` which doesn't exist on Ubuntu (uses `/etc/iptables/` instead)

### Testing on Target Environment (CentOS with Root)
When testing on a proper CentOS system with root access, additionally validate:
- **Firewall restart**: Option 6 should successfully reset iptables rules
- **Port opening**: Option 7 should open ports for selected services  
- **Rule deletion**: Option 8 should allow deletion of iptables rules
- **Backup/restore**: Option 9 should backup/restore `/etc/sysconfig/iptables`

## Common Tasks

The following are outputs from frequently run commands. Reference them instead of running bash commands to save time.

### Repository Structure
```
ls -la [repo-root]:
total 32
drwxr-xr-x 4 runner docker 4096 Aug 10 12:47 .
drwxr-xr-x 3 runner docker 4096 Aug 10 12:43 ..
drwxr-xr-x 7 runner docker 4096 Aug 10 12:47 .git
drwxr-xr-x 2 runner docker 4096 Aug 10 12:47 .github
-rw-r--r-- 1 runner docker 1080 Aug 10 12:43 LICENSE
-rw-r--r-- 1 runner docker  166 Aug 10 12:43 README.md
-rwxr-xr-x 1 runner docker 6546 Aug 10 12:43 iptables_config.sh
```

### Script Content Overview
```
head -30 iptables_config.sh:
#!/bin/bash

# Main functions:
# - interfaz(): Detects network interfaces using ifconfig
# - servicios(): Checks status of mysqld, keepalived, httpd services  
# - restart_firewall(): Flushes and resets all iptables rules
# - open_apache(): Opens ports 80, 443, 8080 for Apache
# - open_mysql(): Opens port 3306 for MySQL
# - open_drbd(): Opens port 7788 for DRBD
# - open_keepalived(): Opens VRRP protocol for keepalived
# - open_ssh(): Opens port 22 for SSH
# - open_custom(): Interactive custom port opening
# - Main menu loop with Spanish interface
```

### Expected Menu Output
```
echo "0" | bash iptables_config.sh:
###############
#   M E N U   #
###############
======================
=     PARÁMETROS     =
======================
*Interfaz:   --- 
*Ip Origen:   000.000.000.000 
*Ip Destino:   000.000.000.000 
*Puerto:   0000 
======================
[1]Ver interfaces de red
[2]Reiniciar nombre interfaces  
[3]Ver [TODAS] las interfaces de red
[4]Ver servicios instalados/ en ejecución
[5]Ver estado IPTABLES
[6]Reiniciar reglas IPTABLES
[7]Abrir puertos IPTABLES
[8]Borrar una línea del fichero de configuración
[9]Respaldar/Restaurar fichero configuracion iptables
[0]Salir
Adios
```

## System Requirements

### Required Commands and Packages
- `bash` (script interpreter)
- `iptables` (firewall management) - requires root privileges
- `ifconfig` (from net-tools package) - for network interface detection
- `service` command (SysV init style service management)
- `egrep`, `cut` (text processing utilities - standard on most systems)

### Target Operating System
- **Primary**: CentOS 6/7 or RHEL 6/7 with SysV init
- **Directory structure**: `/etc/sysconfig/iptables` (CentOS-specific)
- **Service names**: Uses CentOS naming (mysqld, httpd, keepalived)

### Known Issues
- Line 245 has a minor comparison operator issue (not blocking functionality)
- Script assumes CentOS-style service management and file locations
- All iptables operations require root privileges

## Development Guidelines

### Making Changes to the Script
1. **Always validate syntax first**: `bash -n iptables_config.sh`
2. **Test menu display**: `echo "0" | bash iptables_config.sh` 
3. **Test non-destructive functions**: Options 1, 3, 4 can be tested safely
4. **NEVER test destructive options without root on CentOS**: Options 5-9 modify system firewall
5. **Preserve Spanish language interface**: All menu text and prompts are in Spanish
6. **Test on target CentOS system when possible**: Ubuntu testing has limitations

### Script Modification Guidelines
- **Do not modify the menu structure**: Users expect the 10-option Spanish menu
- **Preserve error handling**: Script uses `2>/dev/null` to suppress expected errors
- **Maintain CentOS compatibility**: Keep `/etc/sysconfig/iptables` path and service names
- **Test interactive elements**: Script relies heavily on user input and menu navigation

### File Management
- **No build process required**: This is a single bash script
- **No dependencies to install**: All required commands are system utilities
- **No tests directory**: Validation is done through manual script execution
- **No CI/CD pipeline**: Simple script doesn't require automated testing infrastructure