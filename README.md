vm-provision-freebsd-shellgei
===

[USP友の会](https://www.usptomo.com/)で行われている通称「シェル芸」の練習を、FreeBSD上で行うためのVMWare Player用のプロビジョニングツールです。

テンプレートファイルとこのリポジトリをcloneし、「#provision.bat」を起動するだけで、「シェル芸」でよく使用するコマンドがセットアップされたFreeBSDの仮想マシンを作成することができます。

※このリポジトリは @kunst1080 が個人的に作成しているものです。問い合わせなどは[本人のTwitterアカウント](https://twitter.com/kunst1080)か[Issues](https://github.com/kunst1080/https://github.com/kunst1080/vm-provision-freebsd-shellgei/issues)へお願いします。


## Getting Started
1. Install dependencies:

  * VMWare Player
  * VMWare VIX
  * Virtual Machine Template (https://github.com/kunst1080/vm-install-freebsd)

2. Clone this repository:

  ```bash
  git clone https://github.com/kunst1080/vm-provision-freebsd-shellgei.git
  ```

3. Start provisioning:

  ```
  #provision.bat
  ```

## License
The MIT License

※このリポジトリは、 https://github.com/kunst1080/vm-provision-freebsd-base をフォークし、プロビジョニング設定を追加したものです。
