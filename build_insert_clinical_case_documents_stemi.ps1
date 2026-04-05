$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$episodesDir = Join-Path $root 'CARDIO\STEMI\EPISODES'
$outFile = Join-Path $root 'insert_clinical_case_documents_stemi.sql'
$clinicalPathwayId = 1
$episodeFiles = @(
    'CARDIO-STEMI-VANILLA.json',
    'CARDIO-STEMI-V01-05-08.json'
)

$cases = @()
foreach ($fileName in $episodeFiles) {
    $path = Join-Path $episodesDir $fileName
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Episode file not found: $path"
    }

    $rawJson = Get-Content -LiteralPath $path -Encoding utf8 -Raw
    $obj = $rawJson | ConvertFrom-Json
    $records = @($obj.healthRecords)

    if ($records.Count -eq 0) {
        throw "No healthRecords found in: $fileName"
    }

    $identifier = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $tagBase = 'case_' + ($identifier -replace '[^A-Za-z0-9_]', '_')
    $tag = $tagBase
    $i = 1
    while ($rawJson.Contains('$' + $tag + '$')) {
        $tag = "${tagBase}_$i"
        $i++
    }

    $cases += [pscustomobject]@{
        FileName = $fileName
        Identifier = $identifier
        Json = $rawJson.Trim()
        Tag = $tag
        HealthRecordCount = $records.Count
    }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('BEGIN;')
[void]$sb.AppendLine('SET search_path TO riskm_manager_model_evaluation, public;')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('/*')
[void]$sb.AppendLine('Load 2 clinical cases from episode JSON files and rebuild their documents from healthRecords.')
[void]$sb.AppendLine('Each clinical_case.body stores the entire episode JSON (including healthRecords).')
[void]$sb.AppendLine('Each document row stores one healthRecord JSON in body and date extracted from healthRecord.dateTime.')
[void]$sb.AppendLine('*/')
[void]$sb.AppendLine('WITH source_cases(identifier, body) AS (')
[void]$sb.AppendLine('    VALUES')

for ($idx = 0; $idx -lt $cases.Count; $idx++) {
    $c = $cases[$idx]
    $safeIdentifier = $c.Identifier.Replace("'", "''")
    $open = '$' + $c.Tag + '$'
    $close = '$' + $c.Tag + '$'
    $suffix = if ($idx -lt ($cases.Count - 1)) { ',' } else { '' }

    [void]$sb.AppendLine("        ('$safeIdentifier', $open")
    [void]$sb.AppendLine($c.Json)
    [void]$sb.AppendLine("$close::jsonb)$suffix")
}

[void]$sb.AppendLine('),')
[void]$sb.AppendLine('upserted_cases AS (')
[void]$sb.AppendLine('    INSERT INTO clinical_case (clinical_pathway_id, identifier, body)')
[void]$sb.AppendLine('    SELECT')
[void]$sb.AppendLine("        $clinicalPathwayId AS clinical_pathway_id,")
[void]$sb.AppendLine('        sc.identifier,')
[void]$sb.AppendLine('        sc.body')
[void]$sb.AppendLine('    FROM source_cases sc')
[void]$sb.AppendLine('    ON CONFLICT (clinical_pathway_id, identifier) DO UPDATE')
[void]$sb.AppendLine('    SET body = EXCLUDED.body')
[void]$sb.AppendLine('    RETURNING case_id, identifier')
[void]$sb.AppendLine('),')
[void]$sb.AppendLine('resolved_cases AS (')
[void]$sb.AppendLine('    SELECT')
[void]$sb.AppendLine('        uc.case_id,')
[void]$sb.AppendLine('        uc.identifier,')
[void]$sb.AppendLine('        sc.body')
[void]$sb.AppendLine('    FROM upserted_cases uc')
[void]$sb.AppendLine('    JOIN source_cases sc USING (identifier)')
[void]$sb.AppendLine('),')
[void]$sb.AppendLine('purged_docs AS (')
[void]$sb.AppendLine('    DELETE FROM document d')
[void]$sb.AppendLine('    USING resolved_cases rc')
[void]$sb.AppendLine('    WHERE d.case_id = rc.case_id')
[void]$sb.AppendLine('    RETURNING d.case_id')
[void]$sb.AppendLine(')')
[void]$sb.AppendLine('INSERT INTO document (case_id, document_date, body)')
[void]$sb.AppendLine('SELECT')
[void]$sb.AppendLine('    rc.case_id,')
[void]$sb.AppendLine('    CASE')
[void]$sb.AppendLine("        WHEN COALESCE(hr ->> 'dateTime', '') <> '' THEN (hr ->> 'dateTime')::timestamptz::date")
[void]$sb.AppendLine('        ELSE NULL')
[void]$sb.AppendLine('    END AS document_date,')
[void]$sb.AppendLine('    hr AS body')
[void]$sb.AppendLine('FROM resolved_cases rc')
[void]$sb.AppendLine("CROSS JOIN LATERAL jsonb_array_elements(rc.body -> 'healthRecords') AS hr;")
[void]$sb.AppendLine('')
[void]$sb.AppendLine('COMMIT;')

Set-Content -LiteralPath $outFile -Value $sb.ToString() -Encoding utf8

$totalDocs = ($cases | Measure-Object -Property HealthRecordCount -Sum).Sum
Write-Output "Generated: $outFile"
Write-Output "Cases: $($cases.Count)"
Write-Output "Documents expected from healthRecords: $totalDocs"
$cases | ForEach-Object {
    Write-Output ("- {0}: {1} healthRecords" -f $_.Identifier, $_.HealthRecordCount)
}
