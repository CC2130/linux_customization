## How to sign RPM package with GPG Key  
当我们重新打包或新建了一些自己做的RPM包后，为了确保该包的正确性与安全性，最好用我们自己或是部门的 GPG Key 做好认证签名。
### 1、安装gnupg, 不过一般来讲，系统都已预装了  
> yum install gnupg -y

### 2、用gpg生成私钥与公钥对  
> gpg --gen-key

```
$ gpg --gen-key
gpg (GnuPG) 1.4.21; Copyright (C) 2015 Free Software Foundation, Inc.  
This is free software: you are free to change and distribute it.  
There is NO WARRANTY, to the extent permitted by law.  

Please select what kind of key you want:  
  (1) RSA and RSA (default)  
  (2) DSA and Elgamal  
  (3) DSA (sign only)  
  (4) RSA (sign only)  
Your selection?
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048)
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 2y
Key expires at Wed 27 Feb 2019 02:54:46 PM CST
Is this correct? (y/N) y
You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: Jia Chao
Email address: jiachao@redflag-linux.com
Comment:
You selected this USER-ID:
    "Jia Chao <jiachao@redflag-linux.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
You need a Passphrase to protect your secret key.

We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

Not enough random bytes available.  Please do some other work to give
the OS a chance to collect more entropy! (Need 280 more bytes)
..+++++
.+++++
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

Not enough random bytes available.  Please do some other work to give
the OS a chance to collect more entropy! (Need 100 more bytes)
.........+++++
Not enough random bytes available.  Please do some other work to give
the OS a chance to collect more entropy! (Need 53 more bytes)
.......+++++
gpg: key AB51340E marked as ultimately trusted
public and secret key created and signed.

gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   2  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 2u
gpg: next trustdb check due at 2019-02-27
pub   2048R/AB51340E 2017-02-27 [expires: 2019-02-27]
      Key fingerprint = 0DFB 068B 8BEA F7E4 96E2  2DD5 A5F0 6B0D AB51 340E
uid                  Jia Chao <jiachao@redflag-linux.com>
sub   2048R/246A16CE 2017-02-27 [expires: 2019-02-27]

```
首先是选择加密方式，默认RSA即可，然后是Key的长度，默认，再就是密钥的有效期，其实可以设置为长期有效（0），姓名、邮箱，comment 可不写。
总之，基本除了姓名与邮箱外，可一路回车默认，生成密钥时要多动动鼠标键盘什么的，或者多拷贝一些东西：
> dd if=/dev/zero of=/dev/null bs=4096 count=1000000000

### 3、查看、删除及导出生成的gpg key
完成以上步骤后现在可以查看刚生成的 key 了
```
$ gpg --list-key
/home/chao/.gnupg/pubring.gpg
-----------------------------
pub   2048R/81A49CCD 2017-02-27 [expires: 2019-02-27]
uid                  Jia Chao <jiachao2130@live.com>
sub   2048R/E6A9B4A1 2017-02-27 [expires: 2019-02-27]

pub   2048R/AB51340E 2017-02-27 [expires: 2019-02-27]
uid                  Jia Chao <jiachao@redflag-linux.com>
sub   2048R/246A16CE 2017-02-27 [expires: 2019-02-27]


```
很容易看出下面的是刚刚生成的新 Key ，为何？邮箱不一样啊。那么之前的如何删除呢，可以通过以下两条命令：
> gpg --delete-secret-keys mail  
> gpg --delete-keys mail  

需要注意的时，这两步顺序不能错。不然咧？不然会提醒你——哥们儿，先把私钥搞定再来找我！
```

# chao @ mock02 in ~/.gnupg [15:23:31]
$ gpg --delete-keys jiachao2130@live.com
gpg (GnuPG) 1.4.21; Copyright (C) 2015 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

gpg: there is a secret key for public key "jiachao2130@live.com"!
gpg: use option "--delete-secret-keys" to delete it first.

# chao @ mock02 in ~/.gnupg [15:23:49] C:2
$ gpg --delete-secret-keys jiachao2130@live.com
gpg (GnuPG) 1.4.21; Copyright (C) 2015 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


sec  2048R/81A49CCD 2017-02-27 Jia Chao <jiachao2130@live.com>

Delete this key from the keyring? (y/N) y
This is a secret key! - really delete? (y/N) y

# chao @ mock02 in ~/.gnupg [15:24:28]
$ gpg --delete-keys jiachao2130@live.com       
gpg (GnuPG) 1.4.21; Copyright (C) 2015 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


pub  2048R/81A49CCD 2017-02-27 Jia Chao <jiachao2130@live.com>

Delete this key from the keyring? (y/N) y

# chao @ mock02 in ~/.gnupg [15:24:32]
$ gpg --list-key                               
gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: next trustdb check due at 2019-02-27
/home/chao/.gnupg/pubring.gpg
-----------------------------
pub   2048R/AB51340E 2017-02-27 [expires: 2019-02-27]
uid                  Jia Chao <jiachao@redflag-linux.com>
sub   2048R/246A16CE 2017-02-27 [expires: 2019-02-27]

# chao @ mock02 in ~/.gnupg [15:24:45]
$
```

结果自己看，好，下面说如何导出公钥，供客户端验证时使用，这里需要，呃，你的名字....
> gpg --export -a 'Jia Chao' RPM-GPG-KEY-qomo-5-primary  

```
# chao @ mock02 in ~/.gnupg [15:24:45]
$ gpg --export -a 'Jia Chao' > RPM-GPG-KEY-qomo-5-primary
$ gpg --export-secret-key Jia Chao > RPM-GPG-KEY-redflag-9-primary.sec.key

# chao @ mock02 in ~/.gnupg [15:48:48]
$ ls
gpg.conf           pubring.gpg   random_seed                 secring.gpg
private-keys-v1.d  pubring.gpg~  RPM-GPG-KEY-qomo-5-primary  trustdb.gpg

# chao @ mock02 in ~/.gnupg [15:48:49]
$   

```

### 4、导入使用新的 Key
* 导入公钥
> sudo rpm --import RPM-GPG-KEY-qomo-5-primary
 导入公钥与私钥才可正常签名
```
$ gpg --import RPM-GPG-KEY-redflag-9-primary.sec.key
$ gpg --import RPM-GPG-KEY-redflag-9-primary.
```
* 列出查看一哈:  

```

$ rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

gpg-pubkey-fdb19c98-56fd6333 --> gpg(Fedora 25 Primary (25) <fedora-25-primary@fedoraproject.org>)
gpg-pubkey-ab51340e-58b3cd6f --> gpg(Jia Chao <jiachao@redflag-linux.com>)

```  
可以了，导入成功

### 5、使用 GPG Key 给 RPM 包签名
* 确保安装了 rpm-sign 包
> yum install rpm-sign -y

* 新建 ~/.rpmmacro 文件，只需加入以下两行：

  ```
  %_signature gpg  
  %_gpg_name Jia Chao

  ```
  注意，%_gpg_name很重要 ，若是当前机器上同时存在多个签名，这里指定用哪个


  * Just Do It
  > rpm --addsign /package/repo/*.rpm  

  签完后生成仓库便可在使用的时候加上 gpgcheck=1 来确保软件来源可靠性，对了，别忘了生成 Key 时的密码，不然你可签不上。
