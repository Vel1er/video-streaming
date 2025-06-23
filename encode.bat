@echo off
set FFMPEG="C:\ffmpeg\ffmpeg-2025-06-23-git-e6298e0759-full_build\bin\ffmpeg.exe"
set OUTPUT="hls"

:: Clean and create fresh directory
if exist %OUTPUT% rmdir /s /q %OUTPUT%
mkdir %OUTPUT%

:: Simplified 3-quality encode command
%FFMPEG% -i "All_star.mp4" ^
  -preset fast -g 48 -sc_threshold 0 ^
  -map 0 -map 0 -map 0 ^
  -c:v libx264 -crf 22 ^
  -filter:v:0 scale=1280:720 -maxrate:v:0 2500k -bufsize:v:0 5000k ^
  -filter:v:1 scale=854:480 -maxrate:v:1 1000k -bufsize:v:1 2000k ^
  -filter:v:2 scale=640:360 -maxrate:v:2 600k -bufsize:v:2 1200k ^
  -c:a aac -ar 44100 ^
  -f hls -hls_time 2 -hls_playlist_type vod ^
  -hls_segment_filename "%OUTPUT%\%%v\segment_%%03d.ts" ^
  -master_pl_name "master.m3u8" ^
  -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2" ^
  "%OUTPUT%\%%v\playlist.m3u8"

:: Verify output
if errorlevel 1 (
   echo Encoding failed! Check:
   echo 1. FFmpeg path is correct
   echo 2. All_star.mp4 exists
   pause
   exit /b
)

echo Success! Created:
dir /b /s hls
pause