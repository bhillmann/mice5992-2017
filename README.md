# mice5992-2017

To set up your MSI account for using QIIME, please follow these steps:

1. Get your login info for MSI
Click on this link: https://www.msi.umn.edu/user-agreement. After you agree to the user agreement you will get your login information. 

3. Connect to MSI with SSH!
### Windows users:
- Install "Putty" by downloading this file and running the installer:
https://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.msi

- Open the Putty application
- Under the "Hostname" field, enter `login.msi.umn.edu`
- Under "Port", enter `22`
- For "Connection type" click "SSH"
- Click "Open"
- Enter your MSI username and password
- You should now be connected.
- Visual instructions can be found here: http://www.fastcomet.com/tutorials/getting-started/putty#connect

### Mac/Linux users:
- Open the "Terminal" application. On a Mac you can click the search button (magnifying glass) and type "Terminal" to find the application.
- Enter this command into the terminal, using your username in place of `yourusername`:
ssh yourusername@login.msi.umn.edu
- Enter your password
- You should now be connected.

3. Copy this command, paste it into your terminal, and press "return"
wget -O setup.sh z.umn.edu/5992setup && chmod +x setup.sh && ./setup.sh

You are now ready to use MSI and QIIME.

