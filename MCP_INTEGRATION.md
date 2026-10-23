# MCP_INTEGRATION.md — 麦当劳 MCP 集成说明

本项目 **药研补给官 PharmaFuel** 基于 **麦当劳中国 MCP（`mcd-mcp`，远程托管地址 `https://mcp.mcd.cn`）** 构建，所有餐品、营养、价格、优惠券、团餐与订单数据均来自该 MCP 实时接口，无任何"套壳"硬编码。

## 一、接入配置

协议：Streamable HTTP（MCP 版本 2025-06-18 及之前）。在 WorkBuddy【连接器】→【自定义连接器】→【配置 MCP】填入（Token 用环境变量占位，见 `mcp-config.example.json`）：

```json
{
  "mcpServers": {
    "mcd-mcp": {
      "type": "streamablehttp",
      "url": "https://mcp.mcd.cn",
      "headers": { "Authorization": "Bearer ${MCD_TOKEN}" }
    }
  }
}
```

`MCD_TOKEN` 由参赛者在 https://open.mcd.cn/mcp 登录后"控制台→激活"免费申请，限流 600 次/分钟。

## 二、实际使用的麦当劳 MCP Server / Tool

| MCP Server | Tool | 本项目用途 | 调用阶段 |
|---|---|---|---|
| mcd-mcp | `list-nutrition-foods` | 餐品营养成分（能量/蛋白/脂肪/碳水/钠/钙），决策评分的数据底座 | 倒班套餐、周报 |
| mcd-mcp | `query-meals` | 查询当前门店可售餐品菜单（分类/编码/标签） | 取数 |
| mcd-mcp | `query-meal-detail` | 餐品详情、套餐组成与可替换项 | 取数 |
| mcd-mcp | `query-nearby-stores` | 到店自取 / 得来速门店查询 | 倒班套餐、团餐 |
| mcd-mcp | `delivery-query-addresses` | 用户已保存外送/团餐地址 | 团餐 |
| mcd-mcp | `delivery-query-stores` | 收货地址附近可配送门店 | 团餐 |
| mcd-mcp | `query-meal-assistance` | **企业团餐助餐服务**查询（核心差异化能力） | 课题组团餐 |
| mcd-mcp | `query-store-coupons` | 当前门店可用优惠券 | 核价 |
| mcd-mcp | `query-my-coupons` | 卡包已有优惠券 | 核价 |
| mcd-mcp | `available-coupons` | 可领取的麦麦省券列表 | 核价 |
| mcd-mcp | `auto-bind-coupons` | 麦麦省一键领券 | 核价 |
| mcd-mcp | `calculate-price` | 商品 + 优惠券计算应付金额 | 倒班套餐、团餐 |
| mcd-mcp | `create-order` | 创建订单（**需用户确认后**调用，返回支付链接） | 下单 |
| mcd-mcp | `order-list` | 近期历史订单（周报聚合数据源） | 营养周报 |
| mcd-mcp | `now-time-info` | 获取当前时间与餐段，判断活动有效期 | 全局 |

> 未使用的工具（如 `mall-*` 积分商城、`query-party-*` 派对预订、`query-lottery-*` 抽奖）不在本项目调用范围内，保持最小权限。

## 三、典型调用流程

**倒班能量套餐规划**
```
now-time-info → query-nearby-stores → query-meals → query-meal-detail
→ list-nutrition-foods → query-store-coupons / query-my-coupons / available-coupons
→ auto-bind-coupons → calculate-price(商品+券) → [用户确认] → create-order
```

**课题组团餐优化**
```
delivery-query-addresses → delivery-query-stores → query-meal-assistance(企业团餐)
→ query-meals → list-nutrition-foods → calculate-price(团体商品+券)
→ [用户确认] → create-order(就餐方式=企业团餐)
```

**研发人营养周报**（纯只读，无下单）
```
order-list → list-nutrition-foods → 聚合周度能量/蛋白/钠 → 输出趋势与职业健康提示
```

## 四、业务价值

1. **差异化垂直场景**：大赛示例（点餐/省钱/活动）高度同质化；本项目锁定"医药研发职业人群"这一真实且高价值的垂直切口，用研发体系熟悉的"可量化指标"做营养决策。
2. **真实痛点**：工艺验证 24h 取样、临床样本夜班、注册申报冲刺、课题组/临床会议团餐——均为药企研发日常，且"研发人职业健康"是药企 ESG/员工关怀的真实议题。
3. **数据驱动而非噱头**：以能量区间、蛋白质供能比、钠上限、升糖负荷四项指标做套餐评分，而非简单"热量越低越好"。
4. **合规与安全**：下单前强制人工确认，支付由用户本人完成；配置文件仅用环境变量占位符，不泄露任何 Token。

## 五、参考实现中 MCP 的落地方式

`scripts/pharmafuel.py` 内 `McdMCPClient` 以 JSON-RPC 2.0 `tools/call` 直连 `https://mcp.mcd.cn`（与官方 curl 示例一致），并保留 `Mcp-Session-Id` 会话头；未配置 `MCD_TOKEN` 时自动降级到 `--demo` 离线模式（内置脱敏示例数据），便于评审与演示。
