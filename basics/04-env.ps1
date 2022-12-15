# set env RUN_MODE
Write-Output "`n=> can use`
`$env:RUN_MODE=`"dev`"`
to set env
"
$env:RUN_MODE="dev"

# show env RUN_MODE
Write-Output "`n=> show as env like this`
echo `"show env RUN_MODE: `${env:RUN_MODE}`"`
"
Write-Output "show env RUN_MODE: ${env:RUN_MODE}"