## alpine 重启网络
在 Alpine 系统中，重启网络可以根据网络配置方式（静态 IP 或 DHCP）采用不同的方法，下面分别介绍不同场景下的操作。

### 1. 使用 `/etc/network/interfaces` 配置文件
若网络配置是通过 `/etc/network/interfaces` 文件完成的，可以使用 `ifup` 和 `ifdown` 命令来重启网络接口。

#### 重启单个网络接口（如 `eth0`）
```shellscript
# 关闭网络接口
ifdown eth0
# 启动网络接口
ifup eth0
```

#### 重启所有网络接口
```shellscript
/etc/init.d/networking restart
```

### 2. 使用 `ip` 命令
`ip` 命令是一个强大的网络管理工具，也能用来重启网络接口。

#### 重启单个网络接口（如 `eth0`）
```shellscript
# 关闭网络接口
ip link set eth0 down
# 启动网络接口
ip link set eth0 up
```

### 3. 刷新 DHCP 租约
如果网络使用 DHCP 配置，可使用 `udhcpc` 工具来刷新 DHCP 租约。

```shellscript
# 释放当前的 DHCP 租约
udhcpc -n -k -i eth0
# 重新获取新的 DHCP 租约
udhcpc -i eth0
```

### 完整示例
假设你要重启 `eth0` 接口，且网络配置使用 `/etc/network/interfaces` 文件，可按如下步骤操作：
```shellscript
# 关闭 eth0 接口
ifdown eth0
# 启动 eth0 接口
ifup eth0
# 检查网络接口状态
ip addr show eth0
```

执行上述命令后，网络接口会重启，你可以通过 `ping` 命令或者查看网络配置来验证网络是否恢复正常。 