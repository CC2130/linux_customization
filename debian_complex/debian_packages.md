### Prepare System

#### Install Packages

        $ apt install dh-make autoconf automake autotools-dev devscripts fakeroot git gnupg lintian patch patchutils pbuilder quilt xutils-dev

  
#### 源码包构成  
  从官方仓库下载源码包： 
```
上游软件包：package-version.tar.gz

$ apt-get source package

    - pacakge_version.orig.tar.gz
    - package_version-reversion.debian.tar.gz
    - package_version-reversion.dsc

构建的二进制源码包：
    package_version-reversion_arch.deb
```

### 初始化外来源码包

#### 设置dh_make(若默认使用bash)
首先设置两个环境变量，$DEBEMAIL 和 $DEBFULLNAME，这样大多数 Debian 维护工具就能够正确识别你用于维护软
件包的姓名和电子邮件地址。
```
$ cat >>~/.bashrc <<EOF
DEBEMAIL=”your.email.address@example.org”
DEBFULLNAME=”Firstname Lastname”
export DEBEMAIL DEBFULLNAME
EOF
$ . ~/.bashrc
```

#### 获取源码包
通过wget，git 等获取上游源码包。
```
$ mkdir 
$ git clone https://github.com/fuck/archive/fuck.git

```

#### 初始化软件包
解压并进入软件包目录，执行 

        dh_make -f ../source.tar.bz2

### 修改源代码

#### 1、设置quilt  
首先创建 ~/.quiltrc-dpkg 文件

```
$ cat >> ~/.quiltrc-dpkg <<EOF

d=. ; while [ ! -d $d/debian -a `readlink -e $d` != / ]; do d=$d/..; done
if [ -d $d/debian ] && [ -z $QUILT_PATCHES ]; then
    # if in Debian packaging tree with unset $QUILT_PATCHES
    QUILT_PATCHES="debian/patches"
    QUILT_PATCH_OPTS="--reject-format=unified"
    QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
    QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
    QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"
    if ! [ -d $d/debian/patches ]; then mkdir $d/debian/patches; fi
fi

EOF
```  
  
此外，创建一个别名dquilt,以方便打包之需，添加以下几行内容至~/.*shrc,第二行可以给 dquilt 命令提供与 quilt 命令相同的 shell 补全:

```
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
complete -F _quilt_completion -o filenames dquilt
```  

#### 2、修复上游BUG
如你在上游的包里发现一个错误，Debian 打包的软件中不满足以下条件——Makefile 文件应当遵循 GNU 的规定支持 $(DESTDIR) 变量：  

    INSTALLBASE = ~/.local/share/gnome-shell/extensions
    INSTALLNAME = dash-to-dock@micxgx.gmail.com

现使用 dquilt 修复这个问题，并把补丁命名为：fix-install_path.patch

    dquilt new fix-install_path.patch       //cd至源码根目录
    dquilt add Makefile

之后编辑 Makefile 文件，将 INSTALLBASE 字段改为如下：
```
ifeq ($(strip $(DESTDIR)),)
    INSTALLBASE = $(HOME)/.local/share/gnome-shell/extensions
else
    INSTALLBASE = $(DESTDIR)/usr/share/gnome-shell/extensions
endif
INSTALLNAME = dash-to-dock@micxgx.gmail.com
```

执行 dquilt refresh 更新patch文件并通过 dquilt header -e 添加描述文件
```
$ dquilt refresh
$ dquilt header -e
    ...描述补丁
```
