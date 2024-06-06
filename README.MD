# Linux Updater Tool

The Linux Updater Tool is a script designed for updating Ubuntu-based Linux distributions. It not only handles the update process but also provides additional functionalities such as sending Slack messages, activating maintenance mode for HetrixTools, and logging for tracking purposes.

## Features

- **Automatic updates**: Updates the Ubuntu-based Linux distribution to the latest available packages.
- **Slack integration**: Sends a notification to a specified Slack channel after the update process is completed.
- **HetrixTools integration**: Activates maintenance mode in HetrixTools to indicate that updates are being performed.
- **Logging**: Logs the update process for monitoring and troubleshooting purposes.

## Requirements

- **sudo**: Requires sudo privileges to execute system updates and other administrative tasks.
- **curl**: The script utilizes curl for sending Slack messages and activating maintenance mode in HetrixTools.
- **zip**: The zip utility is required for compressing logs into a zip file.

## Installation

1. **Clone the Repository**: 

Clone the repository to your local machine or server.

    git clone https://github.com/vastgoedflow/linux-updater.git

2. **Copy Configuration File**: 

Copy the provided `.env.dist` file to `.env`.

    cp .env.dist .env

3. **Edit Configuration**: 

Edit the `.env` file to specify your wishes.

4. **Set Permissions**: 

Make the script executable and ensure it has proper permissions.

    chmod +x update.sh
    chmod +x reset.sh


5. **Make a cron**:

To automate the update process on your Ubuntu-based Linux distribution, you can schedule the Linux Updater Tool to run at specified intervals using a cron job.

### Setting up Cron Jobs

#### 1. Update Script

To schedule the `update.sh` script to run every Monday at 7:00 AM, follow these steps:

1. Open your terminal.

TODO: Update the /etc/cron.d and service

2. Edit your crontab file by running:

   ```
   sudo crontab -e
   ```

3. Add a new line at the end of the file with the following cron expression:

   ```
   0 7 * * 1 /opt/linux-updater/update.sh
   ```

   This cron expression represents "0 minutes, 7 hours, every Monday".

4. Save and exit the crontab editor.

#### 2. Reset Script after Reboot

To execute a shell script with sudo privileges after reboot using systemd, follow these steps:

1. Create a systemd service unit file. For example, let's name it `maintenance-reset.service`:

   ```
   sudo nano /etc/systemd/system/maintenance-reset.service
   ```

2. Add the following content to the `maintenance-reset.service` file:

   ```
   [Unit]
   Description=Reset maintenance
   After=network.target

   [Service]
   Type=simple
   ExecStart=sudo /opt/linux-updater/reset.sh

   [Install]
   WantedBy=multi-user.target
   ```

3. Save and close the file.

4. Reload systemd to update changes:

   ```
   sudo systemctl daemon-reload
   ```

5. Enable the service to start at boot:

   ```
   sudo systemctl enable maintenance-reset.service
   ```

6. Reboot your system to apply changes:

   ```
   sudo reboot
   ```

This will execute your shell script with sudo privileges after the system reboots. Ensure that your script and any actions it performs are safe and secure, as they will run with elevated privileges.

## Usage

Run the script with sudo privileges:

    sudo ./update.sh
    sudo ./reset.sh

## Configuration
Edit the .env file 

##  Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License
..
