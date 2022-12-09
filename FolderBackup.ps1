### FolderBackup
# 指定したフォルダ内の全ファイルをバックアップします。
# バックアップは実行日時を名称とするフォルダ内へ格納されます。
# バックアップの事後処理として古いフォルダを削除します。
###

### Execution Example
# .\FolderBackup.ps1 -src_dir C:\Users\xxx\AppData\Roaming\AppName -dst_base_dir D:\BACKUP\AppName\
###

### Param
# src_dir: コピー対象フォルダ
# dst_base_dir: コピー先フォルダ（基点）
# save_days: 保管日数（省略可）
###
Param (
	[Parameter(mandatory=$true)][String]$src_dir,
	[Parameter(mandatory=$true)][String]$dst_base_dir,
	[int]$save_days = 30
)

# 記録開始
Start-Transcript -Append -Path "FolderBackup.log"

### バックアップ処理

# コピー元のパスをコンソール出力
Write-Host "### Source Path ###`r`n" $src_dir
 
# コピー先の基点フォルダが存在しない場合
if (!(Test-Path $dst_base_dir))
{
	# 基点フォルダを作成する
	New-Item -ItemType Directory -Force -Path $dst_base_dir
}

# コピー先のパスを生成する（年月日_時分秒）
$dst_date = Get-Date -Format("yyyyMMdd_HHmmss")
$dst_dir = $dst_base_dir + "\" + $dst_date
 
# コピー先のパスをコンソール出力
Write-Host "### Destination Path ###`r`n" $dst_dir
 
# コピー先に既にフォルダが存在する場合
if (Test-Path $dst_dir)
{
	# 該当のフォルダを削除する
	Remove-Item $dst_dir -Recurse
}
 
# バックアップの実行（フォルダごとコピー）
Copy-Item $src_dir $dst_dir -Recurse -Force

### 世代管理処理（古いフォルダを削除）

# 削除基準日（システム日付から保管期間分過去の日付）を取得
$del_base_date = (Get-Date).AddDays(-$save_days).ToString("yyyyMMdd")

# 削除基準日をコンソール出力
Write-Host "### Delete Base Date ###`r`n" $del_base_date

# 全フォルダについてループ
$srch_path = $dst_base_dir + "\*"
$folders = Get-Item $srch_path
foreach($f in $folders) {

	# 対象フォルダの最終更新日を取得
	$LastWrite = (Get-ItemProperty $f).LastWriteTime.ToString("yyyyMMdd")

	# 基準日より古い場合
	if ($LastWrite -lt $del_base_date) {

		# フォルダ名がyyyyMMdd_HHmmss形式（誤削除防止）
		if ($f.Name -match "^[0-9]{8}_[0-9]{6}") {

			# 削除対象のフォルダ名をコンソール出力
			Write-Host "### Delete Folder ###`r`n" $f.Name

			# フォルダを削除
			Remove-Item $f -Recurse
		}
	}
}

# 記録終了
Stop-Transcript
