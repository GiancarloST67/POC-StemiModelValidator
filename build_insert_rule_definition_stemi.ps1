$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$rulesDir = Join-Path $root 'CARDIO\STEMI\RULES'
$outFile = Join-Path $root 'insert_rule_definition_stemi.sql'
$cpId = 1

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('BEGIN;')
[void]$sb.AppendLine('SET search_path TO riskm_manager_model_evaluation, public;')
[void]$sb.AppendLine('')

Get-ChildItem -LiteralPath $rulesDir -Filter '*.json' | Sort-Object Name | ForEach-Object {
    $raw = Get-Content -LiteralPath $_.FullName -Encoding utf8 -Raw
    $obj = $raw | ConvertFrom-Json

    $name = if ($null -ne $obj.rule_id -and -not [string]::IsNullOrWhiteSpace([string]$obj.rule_id)) {
        [string]$obj.rule_id
    } else {
        [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    }

    $safeName = $name.Replace("'", "''")
    $tagBase = 'json_' + ($name -replace '[^A-Za-z0-9_]', '_')
    $tag = $tagBase
    $i = 1
    while ($raw.Contains('$' + $tag + '$')) {
        $tag = "${tagBase}_$i"
        $i++
    }

    $open = '$' + $tag + '$'
    $close = '$' + $tag + '$'

    [void]$sb.AppendLine('INSERT INTO riskm_manager_model_evaluation.rule_definition (clinical_pathway_id, name, body)')
    [void]$sb.AppendLine("VALUES ($cpId, '$safeName', $open")
    [void]$sb.AppendLine($raw.Trim())
    [void]$sb.AppendLine("$close::jsonb)")
    [void]$sb.AppendLine('ON CONFLICT (clinical_pathway_id, name) DO UPDATE')
    [void]$sb.AppendLine('SET body = EXCLUDED.body;')
    [void]$sb.AppendLine('')
}

[void]$sb.AppendLine('COMMIT;')

Set-Content -LiteralPath $outFile -Value $sb.ToString() -Encoding utf8

$insertCount = (Select-String -Path $outFile -Pattern '^INSERT INTO riskm_manager_model_evaluation\.rule_definition' | Measure-Object).Count
Write-Output "Generated: $outFile"
Write-Output "Insert statements: $insertCount"
