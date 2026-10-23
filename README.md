# 💊 药研补给官 PharmaFuel

> **基于麦当劳 MCP 的医药研发团队能量与团餐智能助手**
> 麦当劳 × WorkBuddy「1024 程序员节 · 程序员创意开发大赛」参赛作品

[![1024](https://img.shields.io/badge/1024-程序员节-orange)](https://github.com/M-China/mcd-developer-innovation-challenge)
[![MCP](https://img.shields.io/badge/Power-McDonald's%20MCP-blue)](https://open.mcd.cn/mcp)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 一、这是什么

**药研补给官（PharmaFuel）** 是一个基于 **麦当劳中国 MCP（`mcd-mcp`）** 的 Skill，把麦当劳真实的菜单、营养、优惠券、算价、企业团餐与下单能力，封装成面向 **医药研发团队** 的能量管理与团餐决策助手。

它不是又一个"省钱/热量"类通用助手，而是锁定 **医药研发职业人群** 这一垂直场景——用研发体系熟悉的"可量化指标"（能量密度、蛋白质供能比、钠摄入、升糖负荷）做套餐评分，解决研发人长期倒班、久坐、高压下的真实膳食与团餐痛点。

## 二、为什么选"医药研发"这个垂直场景（差异化价值）

大赛官方示例（套餐推荐 / 麦门省钱 / 活动推荐）已严重同质化，榜单前列几乎全是"省钱"类。我们选择垂直人群切入口：

- **真实痛点**：工艺验证 24h 取样、临床样本检测夜班、注册申报冲刺、课题组周会/学术会议茶歇、IND 前封闭办公——研发人长期倒班、久坐、高压。
- **科学抓手**：以营养学指标做套餐评分，而非"热量越低越好"，呼应研发体系对"数据驱动、可量化"的偏好。
- **团餐合规**：企业团餐（`query-meal-assistance`）+ 预算硬约束，解决"课题组/临床会议订餐"真实行政需求。
- **ESG 叙事**：研发人职业健康是药企员工关怀的真实议题，垂直定位更易在榜单中脱颖而出获 Star。

## 三、三大核心能力（均真实调用麦当劳 MCP）

| 能力 | 输入 | 调用的主要 MCP 工具 | 输出 |
|---|---|---|---|
| 🍔 倒班能量套餐规划 | 研发场景 + 预算 + 时长 | `list-nutrition-foods` `query-meals` `calculate-price` `query-my-coupons` 等 | 含营养拆解与省钱金额的套餐 |
| 👥 课题组团餐优化 | 人数 + 人均预算 | `query-meal-assistance` `delivery-query-stores` `calculate-price` | 团餐方案、人均成本、节省额 |
| 📊 研发人营养周报 | 近期订单 | `order-list` `list-nutrition-foods` | 周度能量/蛋白/钠趋势 + 职业健康提示 |

## 四、项目结构

```
pharmafuel-mcp-skill/
├── SKILL.md                  # WorkBuddy Skill 定义（驱动 Agent 调用麦当劳 MCP）
├── scripts/
│   └── pharmafuel.py         # 麦当劳 MCP 客户端 + 决策引擎（含 --demo 离线模式）
├── web/
│   └── index.html            # 单文件可预览演示应用（脱敏示例数据）
├── README.md                 # 本文件
├── CONTEST_DECLARATION.md    # 参赛声明（官方原文，不可修改）
├── MCP_INTEGRATION.md        # 麦当劳 MCP 集成说明
├── mcp-config.example.json   # 配置模板（仅环境变量占位符）
├── workbuddy.md              # WorkBuddy 开发对话上下文（联动积分用）
└── LICENSE
```

## 五、三行命令跑起来（演示 / 评审）

无需 Token，内置脱敏示例数据：

```bash
# 1) 倒班能量套餐（工艺验证 24h 取样，预算 55 元）
python scripts/pharmafuel.py --demo shift-meal --scenario validation --budget 55

# 2) 课题组团餐（8 人，人均 35 元）
python scripts/pharmafuel.py --demo team-catering --size 8 --per-person 35

# 3) 研发人营养周报
python scripts/pharmafuel.py --demo weekly-report
```

或直接用浏览器打开 `web/index.html` 体验交互演示（无需任何环境）。

## 六、接入真实麦当劳 MCP

1. 登录 https://open.mcd.cn/mcp → 控制台 → 激活，免费申请 `MCD_TOKEN`（限流 600 次/分钟）。
2. 在 WorkBuddy【连接器】→【自定义连接器】→【配置 MCP】填入 `mcp-config.example.json` 内容，将 `YOUR_MCP_TOKEN` 替换为实际 Token 并启用 `mcd-mcp`。
3. 在 WorkBuddy 加载本 Skill，直接对话即可，例如：
   > "我是工艺验证 24h 取样，今晚连轴转，帮我规划能量套餐，预算 55 元"
4. 命令行真实调用（需 `MCD_TOKEN` 环境变量）：
   ```bash
   export MCD_TOKEN=你的token
   python scripts/pharmafuel.py shift-meal --scenario validation --budget 55
   ```

## 七、目标用户

- 医药研发企业（CMC / 分析 / 制剂 / 临床 / DRA）从业者与课题组长；
- 研发行政 / HR 员工关怀项目；
- CRO 现场团队与临床监查员（出差餐食规划）。

## 八、合规与边界

- 仅使用麦当劳 MCP **只读/决策**接口做规划；`create-order` 前必须取得用户明确确认，支付由用户本人完成。
- 输出仅供参考，不构成医疗 / 营养专业建议；餐品、价格、供应状态以麦当劳官方实时数据为准。
- 不输出任何 Token / 密钥；配置仅用环境变量占位符。

## 九、参赛与报名

本仓库已包含大赛要求的全部固定文件名。报名方式（在 https://github.com/M-China/mcd-developer-innovation-challenge 提交 Issue）：

```
【参赛申请】
项目名称：药研补给官 PharmaFuel
项目地址：https://github.com/<你的用户名>/pharmafuel-mcp-skill
项目简介：基于麦当劳 MCP 的医药研发团队能量与团餐智能助手，用可量化营养指标为倒班/团餐场景做决策。
```

> ⚠️ Issue 标题与正文之间、各字段之间暂不要使用换行符；项目地址勿用 Markdown 格式。

---

🏆 参赛作品，非麦当劳官方产品。PharmaFuel · 让研发人吃得更稳、更省、更合规。
