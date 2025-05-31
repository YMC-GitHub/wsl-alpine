## slim vhdx in window

```cmd
diskpart
# open window Diskpart
select vdisk file="D:\WSL\Ubuntu\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit
```
[slim vhdx](https://www.jianshu.com/p/a20c2d58eaac)