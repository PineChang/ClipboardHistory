# 技术规范

## 技术栈

| 项 | 选择 | 版本要求 |
|---|------|---------|
| 语言 | Swift | 5.9+ |
| UI 框架 | SwiftUI | — |
| 最低系统 | macOS 13 (Ventura) | — |
| 菜单栏 | MenuBarExtra (SwiftUI) | macOS 13+ |
| 持久化 | JSON 文件 + 文件系统 | — |
| 设置 | UserDefaults / @AppStorage | — |
| 自动启动 | SMAppService | macOS 13+ |
| 包管理 | Swift Package Manager | — |

## 架构设计

### 分层架构

```
┌─────────────────────────────────┐
│  Views (SwiftUI)                │  UI 层
│  ContentView, ClipboardCard...  │
├─────────────────────────────────┤
│  Services                       │  业务逻辑层
│  ClipboardMonitor,              │
│  ClipboardStore,                │
│  AutoPasteService               │
├─────────────────────────────────┤
│  Models                         │  数据层
│  ClipboardItem                  │
├─────────────────────────────────┤
│  Storage (JSON + Filesystem)    │  持久化层
│  UserDefaults                   │
└─────────────────────────────────┘
```

### 数据流

```
系统剪贴板 ──poll──> ClipboardMonitor ──新条目──> ClipboardStore
                                                      │
                                                    JSON 文件
                                                   图片文件系统
                                                      │
ContentView <──@Published── ClipboardStore <──读取──┘
```

### 核心类型

```swift
struct ClipboardItem: Codable, Identifiable, Equatable {
    let id: UUID
    let type: ItemType          // text / image
    let content: String         // 文字内容（图片时为空）
    let imageFileName: String?  // 图片文件名（文字时为空）
    let timestamp: Date
    var isPinned: Bool
}

enum ItemType: String, Codable {
    case text
    case image
}
```

## 存储方案

### 元数据
- 文件路径: `~/Library/Application Support/ClipboardHistory/items.json`
- 格式: JSON 数组，每个元素为 ClipboardItem

### 图片文件
- 目录: `~/Library/Application Support/ClipboardHistory/images/`
- 命名: `{UUID}.png`（与条目 ID 对应）
- 格式: PNG

### 设置
- `storageDays`: Int（1/3/5，默认 3）
- `launchAtLogin`: Bool（默认 false）

### 数据量估算
- 每条文字记录 ~500 bytes（含元数据）
- 每条图片记录 ~200KB-2MB
- 500 条上限，最大磁盘占用约 1GB

## 剪贴板监听

### 轮询策略
- 每 0.5 秒检查 `NSPasteboard.general.changeCount`
- changeCount 变化时读取内容
- 文字: `NSPasteboard.general.string(forType: .string)`
- 图片: `NSPasteboard.general.data(forType: .png)` 或 `.tiff`

### 去重
- 文字: 与上一条记录的内容字符串比较
- 图片: 与上一条记录的图片数据 MD5 比较（轻量）

## 权限要求

| 权限 | 用途 | 获取方式 |
|------|------|---------|
| 辅助功能 (Accessibility) | 自动粘贴（模拟 Cmd+V） | 系统偏好设置引导 |
| 磁盘访问 | 读写 Application Support | 默认拥有 |

## 自动粘贴实现

使用 `CGEvent` 模拟键盘事件:
1. 将目标内容写入剪贴板
2. 创建 CGEvent 模拟 Cmd+V 按键
3. 发送到系统

需要辅助功能权限，首次使用时引导用户开启。
