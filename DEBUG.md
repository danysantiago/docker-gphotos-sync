Some more instructions regarding building and using the image on DSM (Synology)

Since I am on Windows there is some requirements:
* Docker Desktop for Windows Installed
* WSL2 (Windows Subsystem for Linu) installed
* Docker WSL2 integration enabled.

### Build

In WSL
```
sudo docker build -t gphotos-sync-head .
sudo docker save gphotos-sync-head:latest | gzip > gphoto-sync-head.tar.gz
```
Then in DSM container managment import image from local file. To quickly find it do `explorer.exe .` from the working dir in WSL.
