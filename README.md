# sqltool
MySQL Tool

Lightweight command line tool for managing MySQL load / dump processes across development environments

### Requirements
GPG:
https://www.gnupg.org/download/index.html

```
Debian/Ubuntu:
sudo apt-get install gpg

CentOS/RHEL:
sudo yum install gnupg
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
