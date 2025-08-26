# Yocto BitBake Recipe for RUBIK Pi 3 Thermal Management

This directory contains BitBake recipe files for integrating the RUBIK Pi 3 thermal management system into Yocto builds.

## Recipe Files

### rubikpi3-thermal_1.0.1.bb
This is the stable release recipe that uses a specific git commit for reproducible builds:
- Uses fixed SRCREV: `89a252f93aa689b3e9c802ccac7cae3265fac0ef`
- Recommended for production builds
- Ensures consistent results across builds

### rubikpi3-thermal_git.bb
This is the development recipe that uses the latest code from the main branch:
- Uses `SRCREV = "${AUTOREV}"`
- Automatically fetches the latest commit from main branch
- Recommended for development and testing

## Usage

### Adding to Your Yocto Layer

1. Copy the desired bb file to your Yocto layer's recipes directory:
   ```bash
   cp rubikpi3-thermal_1.0.1.bb /path/to/your/layer/recipes-support/rubikpi3-thermal/
   ```

2. Add the package to your image recipe or machine configuration:
   ```bitbake
   IMAGE_INSTALL:append = " rubikpi3-thermal"
   ```

### Recipe Features

- **Systemd Integration**: Automatically installs and enables the thermal management service
- **Machine Compatibility**: Restricted to RUBIK Pi 3 machines (`COMPATIBLE_MACHINE = "^rubikpi3.*"`)
- **Dependencies**: Requires bash runtime
- **Files Installed**:
  - `/etc/rubikpi/rubikpi_thermal.sh` - Main thermal management script
  - `/lib/systemd/system/rubikpi-thermal.service` - Systemd service file

### Temperature Control Logic

The thermal management script monitors `/sys/class/thermal/thermal_zone10/temp` and controls fan speed based on temperature thresholds:

- **≥90°C**: Fan at maximum speed (PWM 255)
- **≥75°C**: Fan at medium-high speed (PWM 124)  
- **≥60°C**: Fan at low speed (PWM 64)
- **<60°C**: Fan off (PWM 0)

### Service Management

The systemd service is automatically enabled and will start at boot. You can also control it manually:

```bash
# Check service status
systemctl status rubikpi-thermal

# Start/stop the service
systemctl start rubikpi-thermal
systemctl stop rubikpi-thermal

# Check current temperature and fan speed
/etc/rubikpi/rubikpi_thermal.sh status
```

## License

This package is licensed under GPL-2.0-or-later as specified in the original project.

## Maintenance

When updating the stable recipe:
1. Update the SRCREV to the desired git commit
2. Test the build and functionality
3. Update the PV version if needed