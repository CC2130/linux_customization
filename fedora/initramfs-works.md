# initramfs

当前 fedora 上的 initramfs 是由两部分组成，
解压可以使用 `/usr/lib/dracut/skipcpio` 命令

```
cd /tmp && mkdir initramfs && cd initramfs
/usr/lib/dracut/skipcpio /boot/initramfs-$(uname -r).img
```

## 全手动操作 - 解开

其有 early_cpio 和 initramfs-cpio 两部分构成，先解出 early_cpio 并得到其大小
（这部分并未压缩，所以使用 `cat` 即可）

```
# mkdir /tmp/early_cpio && cd /tmp/early_cpio
# cat /boot/initramfs-$(uname -r).img | cpio -div
.
early_cpio
kernel
kernel/x86
kernel/x86/microcode
kernel/x86/microcode/GenuineIntel.bin
204 blocks

# 
```

由上可看出，大小为 204 blocks，故可从原始 initramfs 中 `dd` 出实际的 `fs.img`
（fs.img 是 gzip 压缩类型的，故使用 `zcat`）

```
# dd if=/boot/initramfs-$(uname -r).img of=/tmp/initramfs.img bs=512 skip=204
# mkdir /tmp/initramfs && cd /tmp/initramfs
# zcat /tmp/initramfs.img | cpio -div
```

## 手动操作 - 重新生成

先重新压缩 fs.img，然后将之 `dd` 到 early_cpio.img 中即可。
```
# cd /tmp/initramfs
# find . | cpio -o -c -R root:root | gzip -9 > /tmp/new-fs.img
# dd if=/boot/initramfs-$(uname -r).img of=/tmp/initramfs-$(uname -r).img bs=512 count=204
# dd if=/boot/new-fs.img of=/tmp/initramfs-$(uname -r).img bs=512
```

现在的 `/tmp/initramfs-$(uname -r).img`。
