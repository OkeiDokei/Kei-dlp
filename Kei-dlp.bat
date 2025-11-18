@echo off
setlocal enabledelayedexpansion

::Rest In Peace variable names boobs and egg

::update yt-dlp before start
yt-dlp.exe -U >NUL 2>&1
winget install DenoLand.Deno

::check to make sure setting.txt and debug.txt exist if not create them.
:prestart
	cls
	set counter=0

	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp" (
		MKDIR "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp"
	)
	
	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt" (
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		(echo=defaultmusic=%HOMEDRIVE%%HOMEPATH%\Music) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=%HOMEDRIVE%%HOMEPATH%\Videos) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=cookies=) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	)
	
	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt" (
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	)
	
	set settingsfile=%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		for /f "tokens=1,2,3 delims==" %%A in (%settingsfile%) do (
		set /a counter+=1
		set "settings[!counter!]=%%B
	)
		set settings[
		set defaultmusic=%settings[1]%
		set defaultvideos=%settings[2]%
		set cookies=%settings[3]%
		
		
		
	set format= null
	set thumbnail= null
	set typename= null
	set type= null

::Settings menu for script
:start
	cls
	echo 1.Start Script
	echo 2.Change Default Directory Settings
	echo 3.Open Settings Location
	echo 4.Exit
	echo 5.Features to work on
	
	CHOICE /C 1234 /M "Enter your choice: "
		if errorlevel 5 echo cookies form file, loading bar, ascii?, backwards and forwards options, change filter after seleceted,add downloads to arcive.
		if errorlevel 4 exit
		if errorlevel 3 start explorer "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp
		if errorlevel 2 goto settings
		if errorlevel 1 goto restart
		
::code to write new directorys to setting.txt and update variables based on a token delim parse
:settings
	cls
	echo Please set up your default directorys, Inputing nothing will choose Windows default directory.
	set /p defmusic= "Default Directory For Music: "
	set /p defvideo= "Default Directory For Videos: "
	
if "%defmusic%"=="" (
	set defmusic= %HOMEDRIVE%%HOMEPATH%\Music
)

if "%defvideo%"=="" (
	set defvideo= %HOMEDRIVE%%HOMEPATH%\Videos
)

	cls
	echo If left blank no cookies will be used.
	set /p defbrowser= "Please choose a browser supported by yt-dlp: "
	
	if !defbrowser!==[] (
		set browser=
		set cookiecode=
		set cookiebool=No
	) ELSE (
		set browser=!defbrowser!
		set cookiecode=--cookies-from-browser 
		set cookiebool=Yes
	)
	
	break>%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultmusic=!defmusic!) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=!defvideo!) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=cookies=%cookiecode%%browser%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	
	for /f "tokens=1,2,3 delims==" %%A in (%settingsfile%) do (
		set /a counter+=1
		set "settings[!counter!]=%%B
	)
	timeout 1 >nul
		set settings[
		set defaultmusic=%settings[1]%
		set defaultvideos=%settings[2]%
		set cookies=%settings[3]%
		cls
		echo your defaults are...
		echo ------------------------------------
		echo Music: %defmusic%
		echo Videos: %defvideo%
		echo Cookies:%cookiebool% Browser:%browser%
		echo ------------------------------------
		
	color 06
	%windir%\System32\choice.exe /m "is this correct?" /c YN
        if %errorlevel%==1 (
            goto start
        )
	goto settings
	
::Refactored Calls
:restart
	cls
	Call :filetype
	call :directory
	call :links
	call :playlist
	if "%plysbool%"=="yes" (
		call :filter
	) else (
		set deffilter=
		set filterCode=
	)
	call :fix
	call :download
	goto :done
	
	

::Choose File Type
:filetype
	color 06
	echo Choose a file type.
	echo 1.mp3
	echo 2.mp4
	
	CHOICE /C 12 /M "Enter your choice: "
		if errorlevel 2 (
			set type=-S ext:mp4:m4a -S vcodec:avc1
			set typename= mp4
			set thumbnail=--embed-thumbnail
			exit /b
		)
		
		if errorlevel 1 (
			set type=-x --audio-format mp3
			set typename=mp3
			set "thumbnail=--embed-thumbnail^ --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"""
			exit /b
		)


::Choose directory Code
:directory
	color 06
	cls
	echo Please specify a directory
	echo 1.Default Music
	echo 2.Default Video
	echo 3.Custom
	
	CHOICE /C 123 /M "Enter your choice: "
		if errorlevel 3 (
			cls
			color 02
			echo Leaving this blank will select Windows default Download Location
			set /p input= "Folder Name: "
			set format="!input!"
	
				IF [!input!]==[] (
					echo Downloads Folder Selected
				)	
		)
		
		if errorlevel 2 (
			cls
			color 02
			set /p input= "Folder Name: "
			set format="%defaultvideos%\!input!"
	
				if [!input!]==[] (
					cls
					echo No Folder
					pause
				)
		exit /b
		)
		
		if errorlevel 1 (
			cls
			color 02
			set /p input= "Folder Name: "
			set format="%defaultmusic%\!input!"
	
			if [!input!] ==[] (
				cls
				echo No Folder
				pause
			)
		exit /b
		)
		



		
::link code
:links
	cls
	color 0A
	set /p Link= "Link: "
	echo Target Link: %Link%
	exit /b

::playlsit select code
:playlist
	cls
	color 06
	%windir%\System32\choice.exe /m "Download a Playlist?" /c YN
		if %errorlevel%==1 (
			set plys=--yes-playlist
			echo playlist mode: %plys%
			set plysbool=yes
			exit /b
		)
		if %errorlevel%==2 (
			set plys=--no-playlist
			echo playlist mode: %plys%
			set plysbool=no
			exit /b
		)
:filter
	cls
	color 02
	echo No Filter Will be applied if left blank.
	set /p inputfilter= "What To Filter For: "
		
	if "%inputfilter%"=="" (
		set deffilter=
		set filterCode=
	) ELSE (
		set filterCode=--match-filter "_type!=video" --match-filter "title~=(?i)%inputfilter%"
	)

::fix incorrect settings code
:fix
	cls
	color 06
	echo ---- INFO --------------
	echo File Type is: %typename%
	echo Target Folder is: %format%
	echo Target Link: %link%
	echo Playlist Mode: %plys%
	echo Filter: %filterCode%
	echo="yt-dlp.exe -P %format% %type% --add-metadata %Cookies% --compat-options embed-metadata %filterCode% %thumbnail% %plys% %Link%"
	echo ------------------------
	echo Is This Correct? What would you like to fix?
	echo 1.File Type
	echo 2.Target Folder
	echo 3.Link
	echo 4.Playlist Mode
	echo 5.Done
	
	CHOICE /C 12345 /M "Enter your choice: "
		if errorlevel 5 goto :download
		if errorlevel 4 call :playlist
		if errorlevel 3 call :links
		if errorlevel 2 call :directory
		if errorlevel 1 call :type
	
::actual yt-dlp code
:download
	cls
	color 02
	break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	yt-dlp.exe -P %format% %type% --add-metadata %Cookies% --compat-options embed-metadata %filterCode% %thumbnail% %plys% %Link%
	pause
	exit /b
	
::done code exit, etc..
:done
	cls
	echo 1.Download More
	echo 2.Download More Same Settings
	echo 3.Re-Download
	echo 4.Last Downloaded Information
	echo 5.Exit
	echo 6.Open Folder
	echo 7.Open Debug.txt
	
	CHOICE /C 1234567 /M "Enter your choice: "
		if errorlevel 7 call :opendebug
		if errorlevel 6 call :opendir
		if errorlevel 5 exit
		if errorlevel 4 call :info
		if errorlevel 3 call :download
		if errorlevel 2 call :links
		if errorlevel 1 goto :restart

:opendebug
	start explorer "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	goto done

:opendir
	start explorer %format%
	goto done

:close
exit

:info
	cls
	color 02
	echo ---- INFO --------------
	echo File Type is: %typename%
	echo Target Folder is: %format%
	echo Target Link: %link%
	echo Playlist Mode: %plys%
	echo Filter: %filterCode%
	echo="yt-dlp.exe -P %format% %type% --add-metadata %Cookies% --compat-options embed-metadata %filterCode% %thumbnail% %plys% %Link%"
	echo ------------------------
	echo 1.Download More
	echo 2.Download More Same Settings
	echo 3.Re-Download
	echo 4.Last Downloaded Information
	echo 5.Exit
	echo 6.Open Folder
	echo 7.Open Debug.txt
	
	CHOICE /C 1234567 /M "Enter your choice: "
		if errorlevel 7 call :opendebug
		if errorlevel 6 call :opendir
		if errorlevel 5 exit
		if errorlevel 4 call :info
		if errorlevel 3 call :download
		if errorlevel 2 call :links
		if errorlevel 1 goto :restart
