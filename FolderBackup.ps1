### FolderBackup
# 指定したフォルダ内の全ファイルをバックアップします。
# バックアップは実行日時を名称とするフォルダ内へ格納されます。
# バックアップ先フォルダに存在する古いデータは削除されます。
###

### Param
# src_dir: コピー対象フォルダ
# dst_tmp_dir: コピー先フォルダ
# save_days: 保管日数（省略可）
Param (
	[Parameter(mandatory=$true)][String]$src_dir,
	[Parameter(mandatory=$true)][String]$dst_tmp_dir,
	[int]$save_days = 30
)

# 記録開始
Start-Transcript -Append -Path "FolderBackup.log"

# パスをコンソール出力
Write-Host "### Source Path ###`r`n" $src_dir
 
# バックアップ先のフォルダを指定
# フォルダの末尾にyyyymmdd_hhmm（年月日_時分）を付与
$dst_date = Get-Date -Format("yyyyMMdd_HHmm")
$dst_dir = $dst_tmp_dir + "\" + $dst_date
 
# パスをコンソール出力
Write-Host "### Destination Path ###`r`n" $dst_dir
 
# バックアップ先に既にフォルダが存在するか？をチェックし、結果をフラグに格納
$check_flg = Test-Path $dst_dir
 
# 既に存在する場合は、該当のフォルダを削除する
if ($check_flg -eq $true)
{
	# 該当のフォルダを削除します
	Remove-Item $dst_dir -Recurse
}
 
# バックアップの実行（フォルダごとコピー）
Copy-Item $src_dir $dst_dir -Recurse -Force

### 古いフォルダを削除
# 保管日数前の日付を取得
$BaseDate = (Get-Date).AddDays(-$save_days).ToString("yyyyMMdd")
Write-Host "### Base Date ###`r`n" $BaseDate
# 全フォルダについてループ
$folders = Get-Item D:\BACKUP\Executor\*
foreach($f in $folders) {
	# 対象フォルダの最終更新日を取得
	$LastWrite = (Get-ItemProperty $f).LastWriteTime.ToString("yyyyMMdd")
	# 基準日より古い
	if ($LastWrite -lt $BaseDate) {
		Write-Host "### Old Folder ###`r`n" $f.Name
		# フォルダ名がyyyyMMdd_HHmm形式
		if ($f.Name -match "^[0-9]{8}_[0-9]{4}") {
			# 削除
			Write-Host "### Delete Folder ###`r`n" $f.Name
			Remove-Item $f -Recurse
		}
	}
}

# 記録終了
Stop-Transcript
