Docker 守护进程的 `--config-file` 参数支持以下配置文件格式：

1. **JSON 格式** (最常用)
```json:/etc/docker/daemon.json
{
  "hosts": ["fd://", "tcp://0.0.0.0:2375"],
  "registry-mirrors": ["https://registry.example.com"],
  "debug": false,
  "log-level": "info"
}
```

2. **TOML 格式** (v20.10+ 支持)
```toml:/etc/docker/daemon.toml
debug = false
hosts = ["fd://", "tcp://0.0.0.0:2375"]
registry-mirrors = ["https://registry.example.com"]
```

3. **YAML 格式** (v20.10+ 支持)
```yaml:/etc/docker/daemon.yaml
debug: false
hosts:
  - "fd://"
  - "tcp://0.0.0.0:2375"
registry-mirrors:
  - "https://registry.example.com"
```

注意：
1. 默认读取 `/etc/docker/daemon.json`
2. 使用非JSON格式需明确指定扩展名：
```bash
dockerd --config-file /etc/docker/daemon.yaml
```
3. 所有格式最终都会被转换为相同的配置结构