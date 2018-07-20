## 如何创建给壁纸文件打包
这里讲三种不同的壁纸包，其实都换汤不换药，没什么技术水平含量

### Goals
好，首先来讲目的是什么？选几张好看的壁纸？不不不，其实来说呢，选择好看的壁纸，以及将之设置成桌面或是锁屏背景都是很简单的，现在要做的是不仅要让你最喜欢的壁纸生效，还要让其它“精挑细选”的图片在——设置-背景里显示出来，供别人选择。这里记住一个目录：/usr/share/gnome-background-properties  

### 1、简单的单张图片壁纸合集
安装完 GNOME ，进入目录，随便打开一个，比如gnome-backgrounds.xml，你会发现里面很简单，为了看的更舒服，下面是我整理后的  

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
    <wallpaper deleted="false">

    <name>Dandelion</name>
    <name xml:lang="zh_CN">思絮缠绵</name>
    <name xml:lang="zh_TW">蒲公英</name>
    <filename>/usr/share/backgrounds/gnome/Chmiri.jpg</filename>
    <options>zoom</options>
    <pcolor>#ffffff</pcolor>
    <scolor>#000000</scolor>
    </wallpaper>

    <wallpaper deleted="false">
    <name>Godafoss Iceland</name>
    <filename>/usr/share/backgrounds/gnome/Godafoss_Iceland.jpg</filename>
    <options>zoom</options>
    </wallpaper>
</wallpapers>

```

Title什么的，我们照搬就好，然后结构呢，下面是最简的情况，当然，如果条件允许（换句话说够水平），推荐加上多国语言的"name"项目。  

首先"wallpaper<font color=red>s</font>" 套 "wallpaper"，没毛病，其中 wallpaper 的 deleted 实为是否在设置里显示此张图片，然后里面夹的就是真正的“馅儿” 了，名字、文件位置及 options（默认zoom就好，也可stretched）。自己去写的话，

```

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name> 图片名A </name>
    <filename>图片A所在位置</filename>
    <options>zoom</options>
  </wallpaper>

  <!-- 注意，图片B不会在设置里显示 -->
  <wallpaper deleted="true">
    <name> 图片名B </name>
    <filename>图片B所在位置</filename>
    <options>zoom</options>
  </wallpaper>
  .
  .
</wallpapers>
```

### 2、同一样式而分辨率不同的壁纸
这个和下面要说的根据时间自动切换的壁纸差不多。在上面的基础上，filename 这项里，指定的是某个XML文件
```

<background>
  <starttime>
    <year>2016</year>
    <month>11</month>
    <day>15</day>
    <hour>00</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>
<static>
<duration>100000000.0</duration>
<file>
        <!-- Wide 16:9 -->
        <size width="1920" height="1080">/usr/share/backgrounds/default/tv-wide/default.png</size>
        <!-- Wide 16:10 -->
        <size width="1920" height="1200">/usr/share/backgrounds/default/wide/default.png</size>
        <!-- Standard 4:3 -->
        <size width="2048" height="1536">/usr/share/backgrounds/default/standard/default.png</size>
        <!-- Normalish 5:4 -->
        <size width="1280" height="1024">/usr/share/backgrounds/default/normalish/default.png</size>
</file>
</static>

</background>

```

现在先分析下，starttime为此壁纸生效时间，之后是static, 代表一张或是一组不同分辨率的图片，duration 是图片的持续时间，因为是长期用，不是切换的，所以这里设置了一个比较大的数值（单位/S）,file 里自然是放文件，格式自己看就好。

### 3、一天中自动切换的图片
上面说了，这个的格式基本是和第二各情况一样的，区别也是挺简单的，每个static里是一张图片，想要多长时间换一张，就在duration 里写明（比如半小时），file 项只用列出一个地址就好，之后就像下面这样：

```
<background>
  <starttime>
    <year>2016</year>
    <month>11</month>
    <day>15</day>
    <hour>00</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>

  <static>
    <duration>1800.0</duration>
    <file>/usr/share/backgrounds/qomo/5/droplet-on-pebble.jpg</file>
  </static>

  <static>
    <duration>1800.0</duration>
    <file>/usr/share/backgrounds/qomo/5/winter-in-bohemia.png </file>
  </static>

  <static>
    <duration>1800.0</duration>
    <file>/usr/share/backgrounds/qomo/5/matterhorn.png</file>
  </static>

  .
  .
  .

<background>
```

这样的壁纸切换方式呢，一般是许多张无规律的壁纸，当然，放多少张你随意就好。  
如果你看过GNOME 自带的 Adwaita，它呢，是一组基本上只有色系不同的相同样式壁纸，根据时间的早晚，来显示不同效果。也就是说有一个渐变的过程，如果刚好你也做了一组这样的图片，那可以试一下：

```
.
.
<static>
  <duration>3600.0</duration>
  <file>/usr/share/backgrounds/qomo/extra/AAA.jpg</file>
</static>

<transition type="overlay">
  <duration>3600</duration>
  <from>/usr/share/backgrounds/qomo/extra/AAA.jpg</from>
  <to>/usr/share/backgrounds/qomo/extra/BBB.jpg</to>
</transition>

<static>
  <duration>3600.0</duration>
  <file>/usr/share/backgrounds/qomo/extra/BBB.png </file>
</static>
.
.
```
主要是加上了transition 字段用覆盖，由BBB.jpg 渐渐替换 AAA.jpg，再说一遍，前提是样式一样的图片，不然若是随便搞两张图片就用这种方式切换你的屏会没法看。

### 最后
过两天打算试试网络自动更新并切换壁纸的工作，有兴趣的可以搞一哈。讲真，弄一套自己喜欢的壁纸换着来，让人工作时有个好心情。。
