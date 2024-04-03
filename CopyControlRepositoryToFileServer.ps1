# -----------------------------------------------------------------------------
# Script Name:   CopyControlRepositoryToFileServer.ps1
# Description:   ローカルのControlリポジトリを最新化したうえでファイルサーバへコピーします。
# Usage:         タスクスケジューラへ登録してログオン時に自動実行します。
# -----------------------------------------------------------------------------

# 環境変数
$logFilePath = "H:\tools\PMWBコピー\LOG\log.txt"

# 現在時刻を取得
$year = Get-Date -Format "yyyy"
$month = Get-Date -Format "MM"
$day = Get-Date -Format "dd"
$hour = Get-Date -Format "HH"
$minute = Get-Date -Format "mm"
$second = Get-Date -Format "ss"
$datetime = "$year$month$day`_$hour$minute$second"

# 開始ログを出力 
Write-Output "=========================================================" | Out-File -FilePath $logFilePath -Encoding Default -Append
Write-Output "[$datetime]処理を開始します。" | Out-File -FilePath $logFilePath -Encoding Default -Append

# ローカルリポジトリを最新化
Write-Output "[$datetime]ローカルリポジトリを最新化します。" | Out-File -FilePath $logFilePath -Encoding Default -Append
Set-Location -Path "H:\repos\Control"
git pull | Out-File -FilePath $logFilePath -Encoding Default -Append

# ローカルリポジトリのデータをファイルサーバへアップロード
Write-Output "[$datetime]ローカルリポジトリのファイルをファイルサーバへコピーします。" | Out-File -FilePath $logFilePath -Encoding Default -Append
robocopy.exe "H:\repos\Control" "\\nttd-fs5\kumi5$\skc-cldsv\クラウド開発G\99_Gitクローン\Control" /E /LOG+:$logFilePath /TEE /XD *.git*

# 終了ログを出力 
Write-Output "[$datetime]処理を終了します。" | Out-File -FilePath $logFilePath -Encoding Default -Append
