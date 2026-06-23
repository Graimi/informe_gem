# setup.ps1 — Instalación automática del entorno GEM Extremadura en Windows
# Ejecutar desde PowerShell con permisos de administrador:
#   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#   cd C:\Users\jamil\Desktop\Freelance\informe_gem
#   .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Setup Informe GEM Extremadura                      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ─── Funciones helper ─────────────────────────────────────────────────────────

function Check-Command($cmd) {
    return (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null
}

function Write-Step($msg) {
    Write-Host ""
    Write-Host "▶ $msg" -ForegroundColor Yellow
}

function Write-OK($msg) {
    Write-Host "  ✓ $msg" -ForegroundColor Green
}

function Write-Skip($msg) {
    Write-Host "  · $msg (ya instalado)" -ForegroundColor Gray
}

# ─── 1. Winget (comprobación previa) ──────────────────────────────────────────

Write-Step "Comprobando winget..."
if (-not (Check-Command "winget")) {
    Write-Host "  ✗ winget no encontrado." -ForegroundColor Red
    Write-Host "    Instálalo desde https://aka.ms/winget-install" -ForegroundColor Red
    exit 1
}
Write-OK "winget disponible"

# ─── 2. Quarto ────────────────────────────────────────────────────────────────

Write-Step "Quarto (motor del informe + Typst para PDF)..."
if (-not (Check-Command "quarto")) {
    Write-Host "  Instalando Quarto via winget..." -ForegroundColor White
    winget install --id Posit.Quarto --silent --accept-source-agreements --accept-package-agreements
    # Refrescar PATH en esta sesión
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-OK "Quarto instalado"
} else {
    $qv = (quarto --version 2>$null)
    Write-Skip "Quarto $qv"
}

# ─── 3. R ─────────────────────────────────────────────────────────────────────

Write-Step "R (análisis y gráficos)..."
if (-not (Check-Command "Rscript")) {
    Write-Host "  Instalando R via winget..." -ForegroundColor White
    winget install --id RProject.R --silent --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
    # winget instala en Program Files; añadir al PATH de esta sesión
    $rPaths = @(
        "${env:ProgramFiles}\R",
        "${env:ProgramFiles(x86)}\R"
    )
    foreach ($base in $rPaths) {
        if (Test-Path $base) {
            $rBin = Get-ChildItem $base -Filter "R-*" -Directory |
                    Sort-Object Name -Descending |
                    Select-Object -First 1 -ExpandProperty FullName
            $env:Path += ";$rBin\bin"
            break
        }
    }
    Write-OK "R instalado"
} else {
    $rv = (Rscript --version 2>&1 | Select-String "version")
    Write-Skip "R ($rv)"
}

# ─── 4. Fuente Liberation Sans (para el PDF) ──────────────────────────────────

Write-Step "Fuente Liberation Sans (maquetación del PDF)..."
$fontPath = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\LiberationSans-Regular.ttf"
$sysFontPath = "$env:SystemRoot\Fonts\LiberationSans-Regular.ttf"
if (-not (Test-Path $fontPath) -and -not (Test-Path $sysFontPath)) {
    Write-Host "  Descargando fuentes Liberation..." -ForegroundColor White
    $tmpZip = "$env:TEMP\liberation-fonts.zip"
    $tmpDir = "$env:TEMP\liberation-fonts"
    Invoke-WebRequest -Uri "https://github.com/liberationfonts/liberation-fonts/releases/download/2.1.5/liberation-fonts-ttf-2.1.5.tar.gz" `
                      -OutFile $tmpZip -UseBasicParsing 2>$null
    if (-not (Test-Path $tmpZip)) {
        # Alternativa: descargar solo la Regular
        Invoke-WebRequest -Uri "https://github.com/liberationfonts/liberation-fonts/raw/main/src/LiberationSans-Regular.ttf" `
                          -OutFile "$env:TEMP\LiberationSans-Regular.ttf" -UseBasicParsing
        $fontFile = "$env:TEMP\LiberationSans-Regular.ttf"
    }
    if ($fontFile -and (Test-Path $fontFile)) {
        Copy-Item $fontFile $fontPath
        Write-OK "Liberation Sans instalada en %LOCALAPPDATA%\Microsoft\Windows\Fonts"
    } else {
        Write-Host "  · No se pudo descargar la fuente automáticamente." -ForegroundColor DarkYellow
        Write-Host "    Descárgala manualmente de https://github.com/liberationfonts" -ForegroundColor DarkYellow
    }
} else {
    Write-Skip "Liberation Sans ya instalada"
}

# ─── 5. Paquetes de R ─────────────────────────────────────────────────────────

Write-Step "Paquetes de R (ggplot2, gt, rprojroot, ...)..."

$rScript = @'
options(repos = c(CRAN = "https://cloud.r-project.org"))
pkgs_necesarios <- c("ggplot2", "dplyr", "tidyr", "readr", "gt", "yaml", "rprojroot")
pkgs_modob      <- c("haven", "srvyr")   # solo para modo B (microdatos)

instalar_si_falta <- function(pkgs) {
  falta <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
  if (length(falta)) {
    message("Instalando: ", paste(falta, collapse = ", "))
    install.packages(falta)
  }
}

instalar_si_falta(pkgs_necesarios)

# Modo B: preguntar antes de instalar haven + srvyr (más pesados)
cat("\n¿Instalar también paquetes para modo B (microdatos APS/NES)?\n")
cat("Necesarios solo si calculas los indicadores desde los ficheros SPSS/Stata.\n")
resp <- readline("  [s/n]: ")
if (tolower(trimws(resp)) == "s") {
  instalar_si_falta(pkgs_modob)
  message("Paquetes modo B instalados.")
}

# Verificación final
todos <- c(pkgs_necesarios)
ok <- sapply(todos, requireNamespace, quietly = TRUE)
cat("\n=== RESULTADO ===\n")
for (pkg in names(ok)) {
  cat(sprintf("  %s  %s\n", if (ok[pkg]) "OK" else "FAIL", pkg))
}
'@

$rScript | Out-File -FilePath "$env:TEMP\gem_install_pkgs.R" -Encoding UTF8
Rscript "$env:TEMP\gem_install_pkgs.R"
Write-OK "Paquetes de R verificados"

# ─── 6. Verificación final ────────────────────────────────────────────────────

Write-Host ""
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Verificación final" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan

$checks = @{
    "quarto"   = "quarto --version"
    "Rscript"  = "Rscript --version"
}
foreach ($tool in $checks.Keys) {
    if (Check-Command $tool) {
        $ver = Invoke-Expression $checks[$tool] 2>&1 | Select-Object -First 1
        Write-Host "  OK  $tool  $ver" -ForegroundColor Green
    } else {
        Write-Host "  ✗   $tool  NO ENCONTRADO — reinicia PowerShell y vuelve a ejecutar" -ForegroundColor Red
    }
}

# ─── 7. Instrucciones de uso ──────────────────────────────────────────────────

Write-Host ""
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ¡Todo listo! Cómo renderizar el informe:" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Pon los datos en   ediciones\2025-26\procesados\" -ForegroundColor White
Write-Host "     (ver ediciones\2025-26\datos_entregados\README.md)" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Edita el texto en  informe\_*.qmd" -ForegroundColor White
Write-Host ""
Write-Host "  3. Renderiza:" -ForegroundColor White
Write-Host "       cd informe" -ForegroundColor Cyan
Write-Host "       quarto render" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Salidas:  informe\_book\informe.html" -ForegroundColor Gray
Write-Host "            informe\_book\informe.pdf" -ForegroundColor Gray
Write-Host ""
