# MySQL DB Management Tool
Lightweight command line tool for managing MySQL load / dump processes across development environments

### Requirements
GNU Privacy Guard:
https://www.gnupg.org/download/index.html

Dialog:
https://invisible-island.net/dialog/dialog.html

```
Debian/Ubuntu:
sudo apt-get install gpg
sudo apt-get install dialog
```
### Instructions
Create a login csv file with headers:
```Environment, Host, Username, Password```

Encrypt Using GPG:
```gpg -c login```

Enable Execution and Run the tool:
```
chmod +x script.sh
./script.sh
```

### Menu Options
[todo]
