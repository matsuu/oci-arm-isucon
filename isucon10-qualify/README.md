# oci-arm-isucon/isucon10-qualify

[Oracle Cloud Infrastructure](https://www.oracle.com/jp/cloud/)の[Always Free Cloud Services](https://www.oracle.com/jp/cloud/free/)枠を利用してISUCON10予選に似た環境を構築するためのTerraformです。

## 使い方

* Oracle Cloud Infrastructureのアカウントを用意する
    * 新たに作成する場合は[サインアップ](https://signup.cloud.oracle.com/)
* [APIキー](https://docs.oracle.com/ja-jp/iaas/Content/API/Concepts/apisigningkey.htm)を作成する
* [APIキー認証](https://docs.oracle.com/ja-jp/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)に必要な情報を取得して `terraform.tfvars.example` をもとに `terraform.tfvars` を用意する
    ```
    cp terraform.tfvars.example terraform.tfvars 
    ${EDITOR} terraform.tfvars
    ```
* terraformを実行する
    ```
    terraform plan
    terraform apply
    ```
* ubuntuユーザでベンチマーカおよび競技用サーバにログインが可能です
    ```
    terraform output
    ssh -l ubuntu (bench_public_ipとして表示されたアドレス)
    ssh -l ubuntu (competitor_public_ipとして表示されたアドレス)
    ```
* terraform apply後もuserdataによるプロビジョニングが継続しています。進捗はcloud-initのログで確認ができます。
    ```
    tail -f /var/log/cloud-init-output.log
    ```
* ベンチマーカから負荷テストが可能です
    ```
    sudo -i -u isucon
    cd isuumo/bench
    ./bench -target-url http://(competitor_private_ipとして表示されたアドレス)
    ```

## 本来の設定と異なるところ

* 本来のサーバはamd64ですが、構築されたサーバはarm64になります
* 本来のサーバはUbuntu 18.04ですが、OCI側の制約でUbuntu 20.04に移植しておりMySQLなどのバージョンが異なります
* 本来のサーバのDisk I/O制限(IOスループット100Mbps、IOPS 200)が再現できていません
* 本来ののベンチマーカのNIC制限(100Mbps)が再現できていません
