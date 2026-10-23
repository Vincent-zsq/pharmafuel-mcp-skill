# workbuddy.md — WorkBuddy 开发对话上下文（参赛联动积分用）

> 本文件用于证明本项目真实使用腾讯 WorkBuddy 智能体开发，符合「麦当劳 × WorkBuddy 1024 程序员节创意开发大赛」联动奖励条件。内容为开发过程的真实还原（已脱敏）。

---

## 用户原始需求

> 做个符合"VorkBuddy「1024造物挑战」程序员节应用创作大赛"投稿要求的医药研发的创意应用出来。

## 第一轮：活动规则核验与选题

**WorkBuddy**：经检索，官方赛事为「麦当劳 × WorkBuddy 1024 程序员节·程序员创意开发大赛」，硬性要求：项目必须**真实调用麦当劳 MCP**，提交公开 GitHub 仓库，含 5 个固定文件名（`README.md` / `CONTEST_DECLARATION.md` / `MCP_INTEGRATION.md` / 源代码 / `mcp-config.example.json`），外加拿积分用的 `workbuddy.md`，按 GitHub Star 排名，报名截止 2026-10-25 23:59。

**关键判断**：大赛示例（点餐/省钱/活动）已严重红海。要突围，必须绑定垂直人群。结合您的医药研发背景，我建议把麦当劳 MCP 变成"药研人能量补给 + 课题组团餐决策"助手——既真实用 MCP，又紧扣专业场景。

**用户**：继续，做出来给我。

## 第二轮：抓取官方原文与工具清单

**WorkBuddy**：已抓取官方 `CONTEST_DECLARATION.md` 原文（逐字不改）、`mcp-config.example.json` 模板（Streamable HTTP，`https://mcp.mcd.cn`，Bearer Token），以及麦当劳 MCP 工具清单（24–35 个工具，含 `list-nutrition-foods`、`query-meal-assistance` 企业团餐、`calculate-price`、`auto-bind-coupons`、`order-list` 等）。据此锁定三大模块与差异化的"企业团餐 + 营养评分"卖点。

## 第三轮：核心 Skill 与决策引擎

**WorkBuddy**：编写 `SKILL.md`（WorkBuddy Skill 定义，明确触发词、执行流程、研发场景营养目标表、合规边界）。编写 `scripts/pharmafuel.py`：

- `McdMCPClient`：JSON-RPC 2.0 `tools/call` 直连 `https://mcp.mcd.cn`，保留 `Mcp-Session-Id` 会话头，与官方 curl 示例一致；
- 决策引擎：`plan_shift_meal`（场景化蛋白/钠评分）、`plan_team_catering`（企业团餐组合）、`weekly_report`（order-list 聚合）；
- 内置 `--demo` 离线模式（脱敏示例数据），无 Token 也能演示与评审。

**验证**：`--demo shift-meal --scenario validation --budget 55` 输出"双层吉士汉堡 + 麦乐鸡(5块) + 大杯鲜萃咖啡"，蛋白 40g、钠 1442mg、应付 ¥45（省 ¥8）；团餐与周报模块均通过。

## 第四轮：可预览演示应用

**WorkBuddy**：编写 `web/index.html`（单文件、无外部依赖、浅色主题），用同源脱敏数据实现三大模块交互：倒班套餐营养进度条、团餐明细表与人均成本、周报 SVG 趋势图。可直接浏览器打开预览，并作为 README 展示资产。

## 第五轮：补齐投稿文件

**WorkBuddy**：生成 `README.md`（含差异化论证、三行命令跑起来、报名 Issue 模板）、`MCP_INTEGRATION.md`（工具表 + 调用流程 + 业务价值）、`mcp-config.example.json`（环境变量占位符）、`CONTEST_DECLARATION.md`（官方原文逐字）、本 `workbuddy.md`，并附 `LICENSE`（MIT）。

## 交付清单（与大赛要求一一对应）

| 大赛要求 | 本仓库文件 | 状态 |
|---|---|---|
| README.md | `README.md` | ✅ |
| CONTEST_DECLARATION.md（不可改） | `CONTEST_DECLARATION.md` | ✅ 官方原文 |
| MCP_INTEGRATION.md | `MCP_INTEGRATION.md` | ✅ |
| 源代码（形式不限） | `SKILL.md` + `scripts/pharmafuel.py` + `web/index.html` | ✅ |
| mcp-config.example.json | `mcp-config.example.json` | ✅ |
| workbuddy.md（联动积分） | `workbuddy.md` | ✅ |

---

*本记录由 WorkBuddy 在开发过程中自动整理，用于赛事联动奖励核验。*
