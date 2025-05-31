alpine_repo="https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main
https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/community"

# 获取对应源
get_repo() {
    case "$1" in
        aliyun) echo "$aliyun_repo";;
        qinghua) echo "$qinghua_repo";;
        ustc) echo "$ustc_repo";;
        huawei) echo "$huawei_repo";;
        tencent) echo "$tencent_repo";;
        alpine) echo "$alpine_repo";;
        *) return 1;;
    esac
}

set_apk_repo() {
    local repo_url=$1
    [ -z "$repo_url" ] && { echo "错误：请提供源地址"; return 1; }
    
    [ ! -f "$BACKUP_FILE" ] && cp /etc/apk/repositories "$BACKUP_FILE"
    echo -e "$repo_url" > /etc/apk/repositories
    apk update && echo "镜像源已切换并更新索引"
}

restore_default() {
    if [ -f "$BACKUP_FILE" ]; then
        cp "$BACKUP_FILE" /etc/apk/repositories
    else
        echo -e "${MIRRORS[alpine]}" > /etc/apk/repositories
    fi
    apk update && echo "已恢复默认源并更新索引"
}

case "$1" in
    list)
        echo "支持的镜像源:"
        echo "  aliyun qinghua ustc huawei tencent alpine"
        ;;
    current)
        echo "当前的镜像源:"
        cat  /etc/apk/repositories
        ;;
    --set)
        set_apk_repo "$2"
        ;;
    --restore)
        restore_default
        ;;
    *)
        repo=$(get_repo "$1")
        if [ $? -eq 0 ]; then
            set_apk_repo "$repo"
        else
            echo "用法: $0 [list|current|aliyun|qinghua|ustc|huawei|tencent|alpine]"
            echo "      $0 --set <自#!/bin/sh

# 备份原始配置
BACKUP_FILE='/etc/apk/repositories.backup'
ALPINE_VERSION=$(cat /etc/alpine-release | cut -d. -f1,2)

# 定义镜像源（兼容ash语法）
aliyun_repo="https://mirrors.aliyun.com/alpine/v$ALPINE_VERSION/main
https://mirrors.aliyun.com/alpine/v$ALPINE_VERSION/community"

qinghua_repo="https://mirrors.tuna.tsinghua.edu.cn/alpine/v$ALPINE_VERSION/main
https://mirrors.tuna.tsinghua.edu.cn/alpine/v$ALPINE_VERSION/community"

ustc_repo="https://mirrors.ustc.edu.cn/alpine/v$ALPINE_VERSION/main
https://mirrors.ustc.edu.cn/alpine/v$ALPINE_VERSION/community"

huawei_repo="https://repo.huaweicloud.com/alpine/v$ALPINE_VERSION/main
https://repo.huaweicloud.com/alpine/v$ALPINE_VERSION/community"

tencent_repo="https://mirrors.cloud.tencent.com/alpine/v$ALPINE_VERSION/main
https://mirrors.cloud.tencent.com/alpine/v$ALPINE_VERSION/community"

定义源URL>"
            echo "      $0 --restore"
            exit 1
        fi
        ;;
esac