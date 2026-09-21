$ErrorActionPreference = "Stop"

$root = "life-pilot"

# Папки
$directories = @(
    "$root/backend/LifePilot.Api",

    "$root/frontend",

    "$root/db/migrations",

    "$root/nginx/conf.d",
    "$root/nginx/ssl",

    "$root/docker",

    "$root/.github/workflows",

    "$root/labs/lab0-devops/screenshots",
    "$root/labs/lab1-nginx/screenshots",
    "$root/labs/lab2-docker/screenshots",
    "$root/labs/lab3-cicd/screenshots",
    "$root/labs/lab-db",
    "$root/labs/lab-net/screenshots",

    "$root/docs"
)

foreach ($directory in $directories) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

# Файлы
$files = @(
    "$root/frontend/index.html",
    "$root/frontend/app.js",
    "$root/frontend/style.css",

    "$root/db/init.sql",

    "$root/nginx/nginx.conf",
    "$root/nginx/htpasswd",

    "$root/docker/Dockerfile.bad",
    "$root/docker/Dockerfile.good",
    "$root/docker/.dockerignore",

    "$root/docker-compose.yml",

    "$root/.github/workflows/bad-pipeline.yml",
    "$root/.github/workflows/good-pipeline.yml",

    "$root/labs/lab0-devops/README.md",

    "$root/labs/lab1-nginx/check.sh",
    "$root/labs/lab1-nginx/report.md",

    "$root/labs/lab2-docker/report.md",

    "$root/labs/lab3-cicd/report.md",

    "$root/labs/lab-db/ER.md",
    "$root/labs/lab-db/queries.sql",
    "$root/labs/lab-db/report.md",

    "$root/labs/lab-net/report.md",

    "$root/docs/architecture.md",

    "$root/README.md"
)

foreach ($file in $files) {
    if (-not (Test-Path $file)) {
        New-Item -ItemType File -Path $file -Force | Out-Null
    }
}

Write-Host ""
Write-Host "Project structure created successfully:" -ForegroundColor Green
Write-Host (Resolve-Path $root)
Write-Host ""