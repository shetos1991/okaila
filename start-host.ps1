# PS4 13.52 / 14.00 local HTTP host (AppCache MIME fixed)
# Serves the host/ folder. On PS4 open the printed http:// URL only (no extra title text).

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$hostDir = Join-Path $root 'host'
$port = 8080

if (-not (Test-Path (Join-Path $hostDir 'jb.html'))) {
  Write-Error "Missing host/jb.html under $root"
  exit 1
}

# Prefer a LAN IPv4 for the PS4 browser hint
$ip = $null
try {
  $ip = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop |
    Where-Object {
      $_.IPAddress -notlike '127.*' -and
      $_.IPAddress -notlike '169.254.*' -and
      $_.PrefixOrigin -ne 'WellKnown'
    } |
    Select-Object -First 1 -ExpandProperty IPAddress)
} catch {}
if (-not $ip) {
  try {
    $ip = (ipconfig | Select-String -Pattern 'IPv4.*:\s*([0-9.]+)' |
      ForEach-Object { $_.Matches[0].Groups[1].Value } |
      Where-Object { $_ -notlike '127.*' -and $_ -notlike '169.254.*' } |
      Select-Object -First 1)
  } catch {}
}
if (-not $ip) { $ip = '127.0.0.1' }

$py = @"
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os
os.chdir(r'$($hostDir -replace "'", "''")')
class H(SimpleHTTPRequestHandler):
    extensions_map = SimpleHTTPRequestHandler.extensions_map.copy()
    extensions_map['.appcache'] = 'text/cache-manifest'
    def guess_type(self, path):
        if path.endswith('.appcache'):
            return 'text/cache-manifest'
        return SimpleHTTPRequestHandler.guess_type(self, path)
print('PS4 14.00 host http://0.0.0.0:$port/', flush=True)
ThreadingHTTPServer(('0.0.0.0', $port), H).serve_forever()
"@

$tmp = Join-Path $env:TEMP 'ps4_1400_host_server.py'
Set-Content -Path $tmp -Value $py -Encoding UTF8

Write-Host "Serving $hostDir"
Write-Host ""
Write-Host "PS4 browser (HTTP):"
Write-Host "  http://${ip}:${port}/"
Write-Host "  http://${ip}:${port}/cache.html"
Write-Host "  http://${ip}:${port}/jb.html"
Write-Host ""
Write-Host "Ctrl+C to stop."
python $tmp
