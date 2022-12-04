echo "`n=> commod shell: [ ls ] "
ls
echo "`n-> this same as: [ Get-ChildItem ]"
Get-ChildItem


echo "`n=> commod shell: [ pwd ] "
pwd
echo "`n-> this same as: [ Get-Location ]"
Get-Location

echo "`n=> commod shell: [ cd ] "
cd .
echo "`n-> this same as: [ Set-Location ]"
Set-Location .