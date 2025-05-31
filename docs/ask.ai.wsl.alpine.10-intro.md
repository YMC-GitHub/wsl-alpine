## 关于 /etc/rc.local文件及其他类似文件
### `/etc/rc.local` 文件解释

#### 功能
`/etc/rc.local` 是一个在类 Unix 系统启动过程中，初始化脚本执行完毕后最后执行的脚本文件。通常用于在系统启动完成后执行一些自定义的任务，比如启动特定的服务、挂载额外的文件系统或者运行某些后台程序等。

#### 执行条件
在不同的 Linux 发行版中，`/etc/rc.local` 的执行条件有所不同：
- **SysVinit 系统**：只要该文件存在且具有可执行权限（`chmod +x /etc/rc.local`），系统启动时就会执行它。
- **systemd 系统**：很多使用 `systemd` 的发行版需要额外配置一个 `systemd` 服务单元来确保 `rc-local.service` 能够正确执行 `/etc/rc.local`。

#### 示例
在你的代码里，`echo "$DOCKERD_CMD" >> /etc/rc.local` 这行代码的作用是把启动 Docker 守护进程的命令追加到 `/etc/rc.local` 文件中，这样系统下次启动时就会自动执行该命令来启动 Docker 守护进程。

### 其他类似文件

#### 1. `/etc/init.d`
- **功能**：这是一个目录，里面存放着各种系统服务的初始化脚本，这些脚本遵循 SysVinit 标准。每个脚本都可以通过 `service` 命令或者直接调用脚本来启动、停止、重启服务。
- **示例**：在 Debian 或 Ubuntu 系统中，`/etc/init.d/apache2` 是 Apache 服务器的初始化脚本，你可以使用 `service apache2 start` 来启动 Apache 服务。

#### 2. `~/.bashrc` 和 `~/.bash_profile`
- **功能**：这两个文件是用户级别的配置文件，用于在用户登录或者打开新的终端会话时执行一些自定义的命令。`~/.bash_profile` 通常在用户登录时执行，而 `~/.bashrc` 则在每次打开新的终端会话时执行。
- **示例**：你可以在 `~/.bashrc` 中添加环境变量的配置，如 `export PATH=$PATH:/usr/local/myapp/bin`。

#### 3. `/etc/profile`
- **功能**：这是系统级别的配置文件，在所有用户登录时都会执行。通常用于设置全局的环境变量、别名等。
- **示例**：在 `/etc/profile` 中添加 `export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64` 来设置全局的 Java 环境变量。

#### 4. `systemd` 服务单元文件
- **功能**：在使用 `systemd` 的系统中，服务单元文件（通常位于 `/etc/systemd/system` 或 `/usr/lib/systemd/system` 目录）用于管理系统服务的启动、停止、重启等操作。这些文件以 `.service` 为扩展名。
- **示例**：下面是一个简单的 `docker.service` 文件示例：
```ini:/etc/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

[Install]
WantedBy=multi-user.target
```
你可以使用 `systemctl start docker` 来启动 Docker 服务，使用 `systemctl enable docker` 来设置 Docker 服务开机自启。 