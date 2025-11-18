@echo off
::V5.0
setlocal enabledelayedexpansion

::Rest In Peace variable names boobs and egg

::update yt-dlp before start and install deloland.deno
yt-dlp.exe -U >NUL 2>&1

::check to make sure setting.txt and debug.txt exist if not create them.
:preStart
	cls
	color 02
	set counter=0

	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp" (
		MKDIR "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp"
	)
	
	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt" (
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		(echo=defaultmusic=%HOMEDRIVE%%HOMEPATH%\Music) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=%HOMEDRIVE%%HOMEPATH%\Videos) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=cookies=) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=setup=false) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	)
	
	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt" (
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	)
	
	set settingsfile=%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		for /f "tokens=1,2,3,4 delims==" %%A in (%settingsfile%) do (
		set /a counter+=1
		set "settings[!counter!]=%%B
	)
		set settings
		set defaultmusic=%settings[1]%
		set defaultvideos=%settings[2]%
		set cookies=%settings[3]%
		set setup=%settings[4]%
		
	set format= null
	set thumbnail= null
	set typename= null
	set type= null
	
:firstTimeSetup
	cls
	color 07
	if !setup!==true (
		GOTO :start
	)

:wizard
	cls
	color 07
CHOICE /C yn /M "Seams like you haven't ran Kei-dlp before would you like to open the Config Wizard?"
			IF ERRORLEVEL 2 GOTO :setupNo
			IF ERRORLEVEL 1 GOTO :setupYes

:setupYes
	cls
	color 07
	call :settings
:setupNo
	cls
	color 07
	CHOICE /C yn /M "Are you sure?"
				IF ERRORLEVEL 2 GOTO :wizard
				IF ERRORLEVEL 1 GOTO :setupNoConfirm


:setupNoConfirm
	cls
	color 07
	CHOICE /C yn /M "Disable Wizard on startup?"
				IF ERRORLEVEL 2 GOTO :setupBack2
				IF ERRORLEVEL 1 GOTO :setupNoConfirm2
			echo Yes? You will no longer see the wizard on start up. It can be accessed through the settings page if you need it.
			echo No? Wizard will show on next launch.
				
:setupNoConfirm2
	cls
	color 07
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		(echo=defaultmusic=%defaultmusic%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=%defaultvideos%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=cookies=%cookies%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=setup=true) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		goto :start
:setupBack2
	cls
	color 07
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		(echo=defaultmusic=%defaultmusic%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=%defaultvideos%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=cookies=%cookies%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=setup=false) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		goto :start
		
::Settings menu for script
:start
	cls
	color 07
	echo=             ❥︎ Kei-dlp! V5.0
	echo= "Wizards Cast Meatballs Edition! (∩๏﹏๏)⊃━☆ﾟ.*"
	echo= ------------------------------------------
	echo= 1.Start Script
	echo= 2.Change Default Directory Settings
	echo= 3.Open Settings Location
	echo= 4.Exit
	echo= 5.Troubleshoot Options
	echo= 6.Features to work on
	
	CHOICE /C 12345 /M "Enter your choice: "
		if errorlevel 6 call :wip
		if errorlevel 5 call :troubleshoot
		if errorlevel 4 exit
		if errorlevel 3 (
			notepad.exe "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
			goto :start
		)
		if errorlevel 2 goto :settings
		if errorlevel 1 goto :restart
		
:troubleshoot
	cls
	color 07
	echo What Would you like to try?
	echo 1. Install Winget
	echo 2. Install yt-dlp
	echo 3. Install Deno Land
	echo 4. Run Wizard
	echo 5. Update yt-dlp
	echo 6. exit
	
	CHOICE /C 12345 /M "Enter your choice: "
		if errorlevel 6 (
			goto :start
		)
		if errorlevel 5 (
			yt-dlp.exe -U >NUL 2>&1
		)
		if errorlevel 4 (
			goto :wizard
		)
		if errorlevel 3 (
			winget install DenoLand.Deno
		)
		if errorlevel 2 (
			winget install yt-dlp
		)
		if errorlevel 1 (
			Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
		)
	goto :start

:wip
cls
color 07
echo= ❥︎. cookies form file
echo= ❥︎. loading bar?
echo= ❥︎. More ascii? 
echo= ❥︎. backwards and forwards options
echo= ❥︎. change filter after seleceted
echo= ❥︎. add downloads to arcive options
echo=-----------------------------------------------
echo= press anybutton to return to the main menu.
pause
goto :start

::code to write new directorys to setting.txt and update variables based on a token delim parse
:settings
	cls
	color 07
	echo Please set up your default directorys, Inputing nothing will choose Windows default directory.
	echo= ------------------------------------------------------------------------------------------------
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
	echo= ------------------------------------------------------------------------------------------------
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
	
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		(echo=defaultmusic=%defaultmusic%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=%defaultvideos%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	    (echo=cookies=%cookiecode%%browser%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=setup=%setup%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	
	for /f "tokens=1,2,3,4 delims==" %%A in (%settingsfile%) do (
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
		
	color 07
	%windir%\System32\choice.exe /m "is this correct?" /c YN
        if %errorlevel%==1 (
            goto ;start
        )
	goto settings
	
::Refactored Calls
:restart
	cls
	color 07
	Call :filetype
	call :directory
	call :links
:playlistFix
	call :playlist
		if "%plysbool%"=="yes" (
		call :filter
		) else (
			set deffilter=
			set filterCode=
		)
	goto :fix

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
		if errorlevel 5 goto :optionFive
		
		if errorlevel 4 (
			goto :playlistFix
		)
		
		if errorlevel 3 (
			call :links
		)
		
		if errorlevel 2 (
			call :directory
		)
		
		if errorlevel 1 (
			call :filetype
		)
	goto :fix
	
::the fith optionform fix variable
:optionFive
	goto :download
	goto :done

::Choose File Type
:filetype
	color 06
	cls
	echo Choose a file type.
	echo= --------------------
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
	echo= --------------------
	echo 1.Default Music
	echo 2.Default Video
	echo 3.Custom
	
	CHOICE /C 123 /M "Enter your choice: "
		if errorlevel 3 (
			cls
			color 02
			echo Leaving this blank will select Windows default Download Location
			echo= -----------------------------------------------------------------
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
	echo= ----------------------------------------
	set /p inputfilter= "What To Filter For: "
		
	if "%inputfilter%"=="" (
		set deffilter=
		set filterCode=
	) ELSE (
		set filterCode=--match-filter "_type!=video" --match-filter "title~=(?i)%inputfilter%"
	)
goto :fix

::actual yt-dlp code
:download
	cls
	color 02
	break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	yt-dlp.exe -P %format% %type% --add-metadata %Cookies% --compat-options embed-metadata %filterCode% %thumbnail% %plys% %Link%
	goto :done
	
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
		if errorlevel 7 call :openDebug
		if errorlevel 6 call :openDir
		if errorlevel 5 exit
		if errorlevel 4 call :info
		if errorlevel 3 call :download
		if errorlevel 2 call :links
		if errorlevel 1 goto :restart

:openDebug
	start explorer "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	goto done

:openDir
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
	echo 8.Go To Main Menu
	
	CHOICE /C 1234567 /M "Enter your choice: "
		if errorlevel 8 goto :start
		if errorlevel 7 call :openDebug
		if errorlevel 6 call :openDir
		if errorlevel 5 exit
		if errorlevel 4 call :info
		if errorlevel 3 call :download
		if errorlevel 2 call :links
		if errorlevel 1 goto :restart
