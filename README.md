# 历史粘贴App

macOS 菜单栏剪贴板历史管理工具。自动记录复制的文字和图片，随时查找、置顶、再次粘贴。

## 功能

- **自动记录** — 后台监听系统剪贴板，文字和图片自动存入历史
- **卡片浏览** — 按时间降序排列，置顶条目优先显示
- **搜索过滤** — 实时搜索历史文字内容
- **再次粘贴** — 点击任意条目，自动粘贴到当前应用
- **过期清理** — 可设置 1/3/5 天存储时长，过期自动删除
- **开机启动** — 设置后可随系统自动启动

## 系统要求

macOS 13 (Ventura) 及以上

## 开发运行

```bash
# 克隆项目
git clone https://github.com/PineChang/ClipboardHistory.git
cd ClipboardHistory

# 用 Xcode 打开
open ClipboardHistory.xcodeproj

# 或命令行编译
xcodebuild -project ClipboardHistory.xcodeproj -scheme ClipboardHistory build
```

在 Xcode 中选择 **My Mac** 目标，按 **Cmd+R** 运行。App 会出现在屏幕右上角菜单栏。

## 技术栈

SwiftUI · MenuBarExtra · NSPasteboard · JSON 持久化

## 项目结构

```
Sources/
├── App.swift                    # 应用入口 + 菜单栏
├── Models/
│   └── ClipboardItem.swift      # 数据模型
├── Services/
│   ├── ClipboardStore.swift     # 存储服务
│   └── ClipboardMonitor.swift   # 剪贴板监听
└── Views/
    ├── ContentView.swift        # 主面板
    └── SettingsView.swift       # 设置面板
docs/                            # 项目文档
dev-log/                         # 开发日志
```

## 开发阶段

- [x] 阶段 0: 项目初始化
- [x] 阶段 1: 数据模型 + 存储层
- [x] 阶段 2: 剪贴板监听
- [ ] 阶段 3: 菜单栏 + 主面板 UI
- [ ] 阶段 4: 搜索功能
- [ ] 阶段 5: 卡片操作 + 粘贴
- [ ] 阶段 6: 设置面板
- [ ] 阶段 7: 开机启动 + 打包

## 许可

MIT
