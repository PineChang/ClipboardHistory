# CLAUDE.md — 历史粘贴App

macOS 菜单栏剪贴板历史管理工具。

## 项目文档指引

| 文档 | 路径 | 说明 |
|------|------|------|
| 需求文档 | [docs/requirements.md](docs/requirements.md) | 功能需求、非功能需求、范围边界 |
| 技术规范 | [docs/tech-spec.md](docs/tech-spec.md) | 技术栈、架构、存储方案、权限 |
| 设计规范 | [docs/design-spec.md](docs/design-spec.md) | 色彩、字体、布局、动效 |
| 执行步骤 | [docs/execution-plan.md](docs/execution-plan.md) | 分阶段开发计划、验证标准 |

## 开发日志

每日开发日志存放在 [dev-log/](dev-log/) 目录，按日期命名 `YYYY-MM-DD.md`。

每个阶段结束时更新日志，记录：
- 完成事项（打勾）
- 待办事项
- 遇到的问题和解决方式

## 工作约定

1. **按阶段推进**：严格按 [execution-plan.md](docs/execution-plan.md) 的阶段顺序开发，不跳步
2. **一次一阶段**：完成当前阶段并验证后，再进入下一阶段
3. **验证优先**：每个阶段的验证标准必须通过
4. **简洁第一**：不过度设计，不写未来才需要的代码
5. **不改无关代码**：每个改动都要能追溯到当前阶段的需求
6. **每次开发后提交并推送**：每个阶段或子任务完成后，`git add` + `git commit` + `git push`，保持远端同步。提交信息使用约定式格式（feat/fix/chore/docs）。

## 项目结构

```
历史粘贴App/
├── CLAUDE.md                  # 本文件
├── Package.swift              # SPM 项目定义
├── dev-log/                   # 开发日志
│   └── YYYY-MM-DD.md
├── docs/                      # 项目文档
│   ├── requirements.md
│   ├── tech-spec.md
│   ├── design-spec.md
│   └── execution-plan.md
└── Sources/
    ├── App.swift              # 应用入口
    ├── Models/
    │   └── ClipboardItem.swift
    ├── Services/
    │   ├── ClipboardMonitor.swift
    │   ├── ClipboardStore.swift
    │   └── AutoPasteService.swift
    ├── Views/
    │   ├── ContentView.swift
    │   ├── ClipboardCard.swift
    │   ├── SearchBar.swift
    │   └── SettingsView.swift
    └── Utils/
        └── DateFormatter+Ext.swift
```

## 技术摘要

- **Swift 5.9+ / SwiftUI**，macOS 13+
- **SPM** 包管理
- **MenuBarExtra** 菜单栏驻留
- **JSON 文件 + 文件系统** 持久化
- **NSPasteboard 轮询** 剪贴板监听
- **CGEvent** 自动粘贴
- **SMAppService** 开机启动
