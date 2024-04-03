# -----------------------------------------------------------------------------
# Script Name:   CopyControlRepositoryToFileServer.ps1
# Description:   ���[�J����Control���|�W�g�����ŐV�����������Ńt�@�C���T�[�o�փR�s�[���܂��B
# Usage:         �^�X�N�X�P�W���[���֓o�^���ă��O�I�����Ɏ������s���܂��B
# -----------------------------------------------------------------------------

# ���ϐ�
$logFilePath = "H:\tools\PMWB�R�s�[\LOG\log.txt"

# ���ݎ������擾
$year = Get-Date -Format "yyyy"
$month = Get-Date -Format "MM"
$day = Get-Date -Format "dd"
$hour = Get-Date -Format "HH"
$minute = Get-Date -Format "mm"
$second = Get-Date -Format "ss"
$datetime = "$year$month$day`_$hour$minute$second"

# �J�n���O���o�� 
Write-Output "=========================================================" | Out-File -FilePath $logFilePath -Encoding Default -Append
Write-Output "[$datetime]�������J�n���܂��B" | Out-File -FilePath $logFilePath -Encoding Default -Append

# ���[�J�����|�W�g�����ŐV��
Write-Output "[$datetime]���[�J�����|�W�g�����ŐV�����܂��B" | Out-File -FilePath $logFilePath -Encoding Default -Append
Set-Location -Path "H:\repos\Control"
git pull | Out-File -FilePath $logFilePath -Encoding Default -Append

# ���[�J�����|�W�g���̃f�[�^���t�@�C���T�[�o�փA�b�v���[�h
Write-Output "[$datetime]���[�J�����|�W�g���̃t�@�C�����t�@�C���T�[�o�փR�s�[���܂��B" | Out-File -FilePath $logFilePath -Encoding Default -Append
robocopy.exe "H:\repos\Control" "\\nttd-fs5\kumi5$\skc-cldsv\�N���E�h�J��G\99_Git�N���[��\Control" /E /LOG+:$logFilePath /TEE /XD *.git*

# �I�����O���o�� 
Write-Output "[$datetime]�������I�����܂��B" | Out-File -FilePath $logFilePath -Encoding Default -Append
