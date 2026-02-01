#!/bin/bash

# VPC情報取得スクリプト（東京リージョン）

REGION="ap-northeast-1"

echo "================================================================================"
echo "AWS VPC情報 - リージョン: ${REGION}"
echo "取得日時: $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================================================================"
echo

# VPC情報を取得
echo "VPC一覧を取得中..."
VPC_DATA=$(aws ec2 describe-vpcs --region ${REGION} --output json)

# VPC数を取得
VPC_COUNT=$(echo "${VPC_DATA}" | jq '.Vpcs | length')

if [ "${VPC_COUNT}" -eq 0 ]; then
    echo "VPCが見つかりませんでした。"
    exit 0
fi

echo "VPC数: ${VPC_COUNT}"
echo

# 各VPCの詳細を表示
echo "${VPC_DATA}" | jq -r '.Vpcs[] | 
"--- VPC ---
VPC ID: \(.VpcId)
CIDR Block: \(.CidrBlock)
State: \(.State)
Is Default: \(.IsDefault)
DHCP Options ID: \(.DhcpOptionsId)
Instance Tenancy: \(.InstanceTenancy)
Tags: \(if .Tags then (.Tags | map("\(.Key): \(.Value)") | join(", ")) else "なし" end)
"'

echo "================================================================================"
echo "詳細情報 (JSON形式)"
echo "================================================================================"
echo "${VPC_DATA}" | jq '.'

# JSON出力をファイルに保存
echo "${VPC_DATA}" | jq '.' > vpc_info.json
echo
echo "VPC情報を vpc_info.json に保存しました。"