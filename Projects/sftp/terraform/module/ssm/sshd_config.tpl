# ==== グローバル設定 ====
Port 22
# 複数ポートを使用する場合は下記のように追記。ただし通常のSSHDと競合しないように注意
# Port 8022
# SFTPサブシステムの設定
Subsystem sftp internal-sftp -f AUTH -l VERBOSE
# 公開鍵認証を有効
PubkeyAuthentication yes
# パスワード認証を有効
PasswordAuthentication yes
# PAMの使用
UsePAM yes
# ログ出力用ファシリティ
SyslogFacility LOCAL5
# MOTDを表示しない
PrintMotd no

# ==== SFTPユーザー設定 ====
# すべての非rootユーザーを対象（必要に応じてMatch Userで個別指定可能）
Match User *,!root
    # 認証方法: パスワードのみ
    AuthenticationMethods password
    PubkeyAuthentication no
    PasswordAuthentication yes
    # Chrootディレクトリ
    ChrootDirectory /srv/efs
    # SFTPコマンドを強制、ログレベルINFO、ログ認証情報出力
    ForceCommand internal-sftp -f AUTH -l INFO -d /sftp
    # X11フォワーディングを禁止
    X11Forwarding no
    # TCPフォワーディングを禁止
    AllowTcpForwarding no
    # ログレベル
    LogLevel VERBOSE

# ==== 特定ユーザー公開鍵認証のみ ====
# Match User xxxxx1
#     AuthenticationMethods publickey
#     AuthorizedKeysFile /srv/efs/sftp/.ssh/authorized_keys
#     PubkeyAuthentication yes
#     PasswordAuthentication no

# ==== 特定ユーザー公開鍵認証+パスワード併用 ====
# Match User xxxxx2
#     AuthenticationMethods publickey,password
#     AuthorizedKeysFile /srv/efs/sftp/.ssh/authorized_keys
#     PubkeyAuthentication yes
#     PasswordAuthentication yes