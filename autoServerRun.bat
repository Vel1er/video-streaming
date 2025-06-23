@echo off
cd /d "D:\MyDoc\Desktop\dz\operating sys\video-streaming"
start python -m http.server 8000
timeout /t 2 >nul
start "" "http://localhost:8000/index.html"
exit