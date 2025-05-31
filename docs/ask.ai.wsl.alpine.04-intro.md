## 05-alpine-set-sh-timezone.sh 脚本中关键时间相关概念的详细解释：

### 1. 硬件时钟 (hwclock)
```bash
hwclock --systohc
hwclock -r
```
- **硬件时钟**（RTC, Real-Time Clock）是主板上的独立计时芯片，断电后依靠主板电池保持运行
- `--systohc`：将当前系统时间写入硬件时钟（同步系统时间到硬件）
- `-r`：读取硬件时钟时间显示
- 特点：独立于操作系统，精度较低（每天可能有几秒误差）

### 2. 系统时间 (date)
```bash
date
```
- 由Linux内核维护的软件时钟
- 读取自系统启动时从硬件时钟初始化，之后由CPU计时器中断保持更新
- 可通过NTP服务自动校准
- 特点：精度高但依赖系统运行

### 3. chrony时间同步
```bash
apk add chrony
rc-service chronyd start
```
- chrony是NTP协议的现代化实现，包含：
  - chronyd：守护进程，持续调整系统时钟
  - chronyc：命令行控制工具
- 优势：
  - 比传统ntpd更快收敛
  - 更好的网络波动适应性
  - 支持间歇性网络连接

### 4. 阿里云NTP服务器
```bash
sed -i 's/^pool.*/server ntp.aliyun.com iburst/' /etc/chrony/chrony.conf
```
- `ntp.aliyun.com` 是阿里云提供的公共NTP服务
- `iburst` 参数表示初始同步时发送突发包加速同步
- 国内优势：
  - 低延迟（通常<50ms）
  - 高可用（多节点冗余）
  - 免费公共服务

### 完整工作流程
1. 安装时区数据 → 2. 设置上海时区 → 3. 同步硬件时钟 → 4. 启用chrony服务 → 5. 配置阿里云NTP源 → 6. 建立持续时间同步机制

该配置最终实现：
- 系统时区永久设置为CST（中国标准时间）
- 硬件时钟与系统时间保持同步
- 通过阿里云NTP服务自动校准，误差可控制在毫秒级