# IpTablesConfigurator

A user-friendly shell script for configuring iptables firewall rules on Linux systems. This interactive menu-driven tool simplifies common firewall management tasks and supports both legacy and modern Linux distributions.

## Features

- **Interactive menu interface** - Easy-to-use command line interface
- **Service-specific rules** - Pre-configured rules for common services:
  - Apache/HTTP(S) web server (ports 80, 443, 8080)
  - MySQL/MariaDB database (port 3306)
  - DRBD replication (port 7788)
  - Keepalived/VRRP high availability
  - SSH remote access (port 22)
- **Custom rule creation** - Create custom firewall rules with flexible parameters
- **Network interface management** - View and configure network interfaces
- **Rule management** - Backup, restore, and delete firewall rules
- **Modern system support** - Compatible with both systemd and legacy service management
- **Multi-distribution support** - Works with CentOS, RHEL, Ubuntu, Debian, and other Linux distributions

## System Requirements

- Linux operating system with iptables support
- Bash shell
- Root/sudo privileges for firewall configuration
- One of the following service management systems:
  - systemd (modern distributions)
  - System V init (legacy distributions)

### Network Tools Required

The script will automatically detect and use available network tools:
- `ip` command (preferred, modern)
- `ifconfig` (fallback for older systems)

### Service Management

Supports both modern and legacy service management:
- `systemctl` (systemd-based systems)
- `service` command (legacy systems)

## Installation

1. Clone or download the repository:
   ```bash
   git clone https://github.com/lcajigasm/IpTablesConfigurator.git
   cd IpTablesConfigurator
   ```

2. Make the script executable:
   ```bash
   chmod +x iptables_config.sh
   ```

3. Run as root or with sudo privileges:
   ```bash
   sudo ./iptables_config.sh
   ```

## Usage

Launch the script with root privileges:

```bash
sudo ./iptables_config.sh
```

### Main Menu Options

The script presents an interactive menu with the following options:

1. **Ver interfaces de red** - View active network interfaces
2. **Reiniciar nombre interfaces** - Reset network interface names
3. **Ver [TODAS] las interfaces de red** - View all network interfaces
4. **Ver servicios instalados/ en ejecución** - View running services
5. **Ver estado IPTABLES** - Display current iptables rules
6. **Reiniciar reglas IPTABLES** - Reset all iptables rules to default
7. **Abrir puertos IPTABLES** - Configure firewall rules for services
8. **Borrar una línea del fichero de configuración** - Delete specific firewall rules
9. **Respaldar/Restaurar fichero configuracion iptables** - Backup/restore iptables configuration
0. **Salir** - Exit the program

### Service Configuration

When selecting option 7 (Configure firewall rules), you can choose from:

- **Apache/HTTP** - Opens ports 80 (HTTP), 443 (HTTPS), and 8080 (alternative HTTP)
- **MySQL** - Opens port 3306 for database connections
- **DRBD** - Opens port 7788 for DRBD replication
- **Keepalived** - Configures VRRP protocol rules for high availability
- **SSH** - Opens port 22 for secure shell access
- **Custom** - Create custom rules with specific parameters

### Custom Rule Configuration

The custom rule option allows you to specify:
- Network interface
- Source IP address
- Destination IP address
- Port number
- Protocol (TCP/UDP)
- Rule type (INPUT, OUTPUT, or both)

## File Locations

The script supports multiple iptables configuration file locations:

- **Modern systems (systemd)**: `/etc/iptables/rules.v4`
- **Legacy systems**: `/etc/sysconfig/iptables`

Backup files are created with `.bak` extension in the same directory.

## Compatibility

### Tested Distributions
- CentOS 7/8/9
- RHEL 7/8/9
- Ubuntu 18.04/20.04/22.04
- Debian 10/11/12

### Service Names
The script automatically detects common service variations:
- MySQL: `mysqld`, `mysql`, or `mariadb`
- Web server: `httpd` or `apache2`
- Keepalived: `keepalived`

## Examples

### Basic Usage
```bash
# Run the configurator
sudo ./iptables_config.sh

# Select option 7 to configure services
# Choose option 1 to open Apache ports
# Follow the prompts to select network interface
```

### Backup Configuration
```bash
# Run the script and select option 9
# Choose option 1 to backup current configuration
```

### Custom Rule Example
```bash
# Select option 7, then option 6 for custom rules
# Configure: Interface eth0, TCP, port 8443, allow INPUT
```

## Security Considerations

- Always test firewall changes in a safe environment first
- Keep backups of working configurations
- Ensure you have console access before making changes to SSH rules
- Review rules before applying them in production environments

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:

- Bug fixes
- New features
- Documentation improvements
- Additional distribution support
- Translation improvements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Luis Cajigas

## Changelog

### Current Version
- Updated for modern Linux distributions
- Added systemd support
- Improved network interface detection
- Enhanced service management compatibility
- Updated documentation in English

### Legacy Features
- Original Spanish interface (maintained)
- Classic iptables rule management
- Support for legacy systems
