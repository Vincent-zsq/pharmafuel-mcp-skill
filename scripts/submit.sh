#!/usr/bin/env bash
# 药研补给官 PharmaFuel — 一键投稿脚本（麦当劳 × WorkBuddy 1024 大赛）
# 用法：
#   1) 先在本机终端完成 GitHub 登录： gh auth login   （需浏览器/设备验证，AI 无法代做）
#   2) 在本目录执行： bash scripts/submit.sh
set -e

REPO="pharmafuel-mcp-skill"
ACTIVITY_REPO="M-China/mcd-developer-innovation-challenge"   # 官方活动仓库（报名 Issue 发这里）
USER=$(gh api user --jq .login)

echo "==> 已登录 GitHub 账号： $USER"

# 0) 规范默认分支为 main（与 GitHub 新建仓库默认分支一致）
git branch -M main 2>/dev/null || true

# 1) 创建公开仓库并推送当前分支
echo "==> 创建公开仓库 $USER/$REPO 并推送..."
gh repo create "$REPO" --public \
  --source=. --push \
  --description "药研补给官 PharmaFuel — 基于麦当劳 MCP 的医药研发能量与团餐智能助手（1024 程序员节参赛作品）"

# 2) 在官方活动仓库发布报名 Issue（标题与正文间不留空行；项目地址不用 Markdown）
echo "==> 在 $ACTIVITY_REPO 发布报名 Issue..."
gh issue create \
  --repo "$ACTIVITY_REPO" \
  --title "参赛申请：药研补给官 PharmaFuel" \
  --body "【参赛申请】
项目名称：药研补给官 PharmaFuel
项目地址：https://github.com/$USER/$REPO
项目简介：基于麦当劳 MCP 的医药研发团队能量与团餐智能助手，用可量化营养指标为倒班/团餐场景做决策。"

echo "==> 完成！请到 $ACTIVITY_REPO 的 Issues 查看系统自动回复的报名成功通知。"
echo "==> 提醒：积分按 Star 排名发放（前 100 名 + 已提交 workbuddy.md 即得 3000 分），记得分享仓库拉 Star。"
