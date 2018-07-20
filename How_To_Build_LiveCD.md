## 如何创建Linux桌面LiveCD（基于Fedora）

### Prepare

* 1、首先安装一个该版本号的Fedora系列系统

* 2、关闭系统防火墙，并禁用SELinux

* 3、安装所需工具，且保证用户有超级用户权限：
```
sudo dnf install livecd-tools spin-kickstarts -y
```

### Kickstart File
制作LiveCD的ks文件主要由四部分组成：
* 1、Repo（基本格式如下）
> repo --name=qomo-base --baseurl=http://qomoproject.org/repo/x86_64  
> repo --name=qomo-updates --baseurl=http://qomoproject.org/repo/updates

* 2、Packages （构建系统所需的软件包）
> ###需要注意格式，将所有软件包、组写在%packages与%end之间###  
> %Packages  
> kernel  
> kernel-modules  
> kernel-modules-extra  
> .  
> .  
> .  
> @gnome-desktop  #以@开头的为软件组  
> @hardware-support  
> .  
> .  
> %end

* 3、LiveCD的基本默认设置  
      主要包括时区、键盘、语言及服务的默认开启状态等
> #Keyboard layouts  
> keyboard 'cn'  
>  
> #System Languagte  
> lang zh_CN.UTF-8  
> .  
> .  
> .  
> #System service  
> services --disabled="sshd,network" --enabled="NetworkManager"

* 4、LiveCD初始化脚本  
        这里无非是LiveCD每次启动时创建新用户之类的操作，可以自己读一下，其实主要修改的地方是开机提示“安装”还是“试用”的欢迎界面，根据anaconda包里"product-welcome.desktop"的名称：  
> #\ Make the welcome Screen show up  
> if [ -f /usr/share/anaconda/gnome/qomo-welcome.desktop ]; then  
>       mkdir -p ~liveuser/.config/autostart  
> .  
> .  
> fi

### Livecd-tools工具  
这里主要使用 livecd-creator 这个命令，示例如下：
```
sudo livecd-creator --title="Redflag Desktop Gnome Live" \
--product="Redflag Desktop v8.2" -f Redflag-Desktop-8-LiveCD-Beta \
-c rfdt.ks 2>&1 | tee redflag8-iso-build.log
```
自己可以去看一下man手册，这里只介绍几个用到的参数：
> --title　　　　LiveCD的grub界面标题  
> --product　　grub中启动项名称  
> -f　　　　　　fslable，生成的镜像文件名  
> -c　　　　　　指定使用的ks文件  

还有其它的一些如--cache --releasever -b 等，不作介绍，想用就查就好

### 新镜像的测试与安装
* 可首先使用kvm或其它虚拟化工具进行启动测试，是否能正常启动，进入系统并打开安装界面  
* 定制系统自然有些功能及界面优化更改，查看准备工作时改的相应包是否生效，此时主要是“看”
* 若以上均正常，可在物理机上进行U盘，光驱安装测试工作
