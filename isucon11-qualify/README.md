# oci-arm-isucon/isucon11-qualify

[Oracle Cloud Infrastructure](https://www.oracle.com/jp/cloud/)の[Always Free Cloud Services](https://www.oracle.com/jp/cloud/free/)枠を利用してISUCON11予選に似た環境を構築するためのTerraformです。

## 使い方

* Oracle Cloud Infrastructureのアカウントを用意する
    * 新たに作成する場合は[サインアップ](https://signup.cloud.oracle.com/)
* [APIキー](https://docs.oracle.com/ja-jp/iaas/Content/API/Concepts/apisigningkey.htm)を作成する
* [APIキー認証](https://docs.oracle.com/ja-jp/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)に必要な情報を取得して `terraform.tfvars` を用意する
    ```
    cp terraform.tfvars.example terraform.tfvars 
    ${EDITOR} terraform.tfvars
    ```
* terraformを実行する
    ```
    terraform init
    terraform plan
    terraform apply
    ```
* ubuntuユーザでログインが可能です
    ```
    terraform output
    ssh -l ubuntu (webapp_public_ipとして表示されたアドレス)
    ```
* terraform apply後もuserdataによるプロビジョニングが継続しています。進捗はcloud-initのログで確認ができます。
    ```
    tail -f /var/log/cloud-init-output.log
    ```
* ベンチマーカから負荷テストが可能です
    ```
    sudo -i -u isucon
    cd bench
    # 本番同様にnginx(https)へアクセスを向けたい場合
    ./bench -all-addresses 127.0.0.11 -target 127.0.0.11:443 -tls -jia-service-url http://127.0.0.1:4999
    # isucondition(3000)へ直接アクセスを向けたい場合
    ./bench -all-addresses 127.0.0.11 -target 127.0.0.11:3000 -jia-service-url http://127.0.0.1:4999
    ```

## 本来の設定と異なるところ

* 本来のサーバはamd64ですが、構築されたサーバはarm64になります
* 本来のサーバはc5.large(CPU 2コア、メモリ4GB)の3台構成です
* 本来のベンチマークサーバはc4.xlarge(CPU 4コア、メモリ7.5GB)です
