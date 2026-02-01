import boto3
import json
from datetime import datetime

def describe_vpcs():
    """東京リージョンのVPC情報を取得して表示"""
    
    # 東京リージョンのEC2クライアントを作成
    region = 'ap-northeast-1'
    ec2 = boto3.client('ec2', region_name=region)
    
    try:
        # VPC情報を取得
        response = ec2.describe_vpcs()
        
        print(f"=" * 80)
        print(f"AWS VPC情報 - リージョン: {region}")
        print(f"取得日時: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"=" * 80)
        print()
        
        vpcs = response.get('Vpcs', [])
        
        if not vpcs:
            print("VPCが見つかりませんでした。")
            return
        
        print(f"VPC数: {len(vpcs)}")
        print()
        
        # 各VPCの詳細を表示
        for i, vpc in enumerate(vpcs, 1):
            print(f"--- VPC {i} ---")
            print(f"VPC ID: {vpc['VpcId']}")
            print(f"CIDR Block: {vpc['CidrBlock']}")
            print(f"State: {vpc['State']}")
            print(f"Is Default: {vpc.get('IsDefault', False)}")
            
            # タグ情報を表示
            tags = vpc.get('Tags', [])
            if tags:
                print("Tags:")
                for tag in tags:
                    print(f"  - {tag['Key']}: {tag['Value']}")
            else:
                print("Tags: なし")
            
            # その他の属性
            print(f"DHCP Options ID: {vpc.get('DhcpOptionsId', 'N/A')}")
            print(f"Instance Tenancy: {vpc.get('InstanceTenancy', 'N/A')}")
            
            # IPv6 CIDR Block
            ipv6_blocks = vpc.get('Ipv6CidrBlockAssociationSet', [])
            if ipv6_blocks:
                print("IPv6 CIDR Blocks:")
                for block in ipv6_blocks:
                    print(f"  - {block.get('Ipv6CidrBlock', 'N/A')} (State: {block.get('Ipv6CidrBlockState', {}).get('State', 'N/A')})")
            
            print()
        
        # JSON形式でも出力
        print("=" * 80)
        print("詳細情報 (JSON形式)")
        print("=" * 80)
        print(json.dumps(response, indent=2, default=str, ensure_ascii=False))
        
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        print("AWS認証情報が正しく設定されているか確認してください。")

if __name__ == "__main__":
    describe_vpcs()