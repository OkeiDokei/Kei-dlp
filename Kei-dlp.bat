@echo off

::Ignore my goofy variable names pls :3

::update yt-dlp before start
yt-dlp.exe -U >NUL 2>&1

::check to make sure setting.txt and debug.txt exist if not create them.
:prestart2
	cls
	setlocal enabledelayedexpansion
	set counter=0

	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp" (
		MKDIR "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp"
	)
	
	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt" (
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt"
		(echo=defaultmusic=%HOMEDRIVE%%HOMEPATH%\Music) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		(echo=defaultvideos=%HOMEDRIVE%%HOMEPATH%\Videos) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	)
	
	if not exist "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt" (
		break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	)
	
	set settingsfile=%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
		for /f "tokens=1,2 delims==" %%A in (%settingsfile%) do (
		set /a counter+=1
		set "settings[!counter!]=%%B
	)
		set settings[
		set defaultmusic=%settings[1]%
		set defaultvideos=%settings[2]%

::Settings menu for script
:start
	cls
	echo 1.Start Script
	echo 2.Change Default Directory Settings
	echo 3.Open Settings Location
	echo 4.Exit
	
	CHOICE /C 1234 /M "Enter your choice: "
		if errorlevel 4 exit
		if errorlevel 3 start explorer %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp & goto start
		if errorlevel 2 goto settings
		if errorlevel 1 goto restart

::code to write new directorys to setting.txt and update variables based on a token delim parse
:settings
	cls
	echo Please set up your default directorys, Inputing nothing will choose Windows default directory.
	set /p defmusic= "Default Directory For Music: "
	set /p defvideo= "Default Directory For Videos: "
	
	if %defmusic%==[] (
		set defmusic=%HOMEDRIVE%%HOMEPATH%\Music
	)
	
		if %defvideo%==[] (
		set defmusic=%HOMEDRIVE%%HOMEPATH%\Video
	)
	
	break>%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	(echo=defaultmusic=%defmusic%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	(echo=defaultvideos=%defvideo%) >> %HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\Settings.txt
	
	for /f "tokens=1,2 delims==" %%A in (%settingsfile%) do (
		set /a counter+=1
		set "settings[!counter!]=%%B
	)
	timeout 1 >nul
		set settings[
		set defaultmusic=%settings[1]%
		set defaultvideos=%settings[2]%
		cls
		echo your defaults are...
		echo ------------------------------------
		echo Music: %defaultmusic%
		echo Videos: %defaultvideos%
		echo ------------------------------------
		
	color 06
	%windir%\System32\choice.exe /m "is this correct?" /c YN
        if %errorlevel%==1 (
            goto start
        )
	goto settings

::Start of script
:restart
	cls

::Choose File Type
:filetype
	color 06
	echo Choose a file type.
	echo 1.mp3
	echo 2.mp4
	
	CHOICE /C 12 /M "Enter your choice: "
		if errorlevel 2 goto typemp4
		if errorlevel 1 goto typemp3

:typemp3
	set type=-x --audio-format mp3
	set typename=mp3
	set thumbnail=--embed-thumbnail^ --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\""
	goto dirop

:typemp4
	set type=-S ext:mp4:m4a -S vcodec:avc1
	set typename= mp4
	set thumbnail=--embed-thumbnail
	goto dirop

::Code for fixing type after selected
:typenew
	cls
	color 06
	echo Choose a diffrent file type.
	echo 1.mp3
	echo 2.mp4
	
	CHOICE /C 12 /M "Enter your choice: "
		if errorlevel 2 goto typemp4new
		if errorlevel 1 goto typemp3new

:typemp3new
	set type=-x --audio-format mp3
	set typename=mp3
	set thumbnail=--embed-thumbnail^ --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\""
	goto fix

:typemp4new
	set type=-S ext:mp4:m4a -S vcodec:avc1
	set typename= mp4
	set thumbnail=--embed-thumbnail
	goto fix


::Choose directory Code
:dirop
	color 06
	cls
	echo Please specify a directory
	echo 1.Default Music
	echo 2.Default Video
	echo 3.Custom
	
	CHOICE /C 123 /M "Enter your choice: "
		if errorlevel 3 goto dircustom
		if errorlevel 2 goto dirvideo
		if errorlevel 1 goto dirmusic

::User Choose custom directory
:dircustom
	cls
	color 02
	set /p input= "Folder Name: "
	set boobs=%defaultmusic%
	set egg="%input%"
	
	IF [%input%]==[] goto nodir
	
	cls
	color 06
	%windir%\System32\choice.exe /m "Open Location?" /c YN
        if %errorlevel%==1 (
            start explorer %egg%
        )
	goto links

::input variable is empty Error
:nodir
	echo ERROR! Please Insert a Directory!
	pause
	goto dircustom

::choose music directory
:dirmusic
	cls
	color 02
	set /p input= "Folder Name: "
	set boobs=%defaultmusic%
	set egg="%boobs%\%input%"
	
	if [%input%] ==[] (
		goto nofolder
	)
	
	cls
	color 06
    %windir%\System32\choice.exe /m "Open Location?" /c YN
        if %errorlevel%==1 (
            start explorer %egg%
        )
	goto links


::choose video directory
:dirvideo
	cls
	color 02
	set /p input= "Folder Name: "
	set boobs=%defaultvideos%
	set egg="%boobs%\%input%"
	
	if [%input%]==[] (
		goto nofolder
	)
	
	
	cls
	color 06
    %windir%\System32\choice.exe /m "Open Location?" /c YN
        if %errorlevel%==1 (
            start explorer %egg%
        )
	goto links

::Code for fixing directory after selected
:dirnew
	color 06
	cls
	echo Please specify a directory
	echo 1.Default Music
	echo 2.Default Video
	echo 3.Custom
	
	CHOICE /C 123 /M "Enter your choice: "
		if errorlevel 3 goto dircustomnew
		if errorlevel 2 goto dirvideonew
		if errorlevel 1 goto dirmusicnew

::Code for fixing directory after selected User made
:dircustomnew
	cls
	color 02    
	set /p input= "Folder Name: "
	set egg=%input%"
	IF [%input%]==[] goto nodirnew
	
	cls
	color 06	
	%windir%\System32\choice.exe /m "Open Location?" /c YN
		if %errorlevel%==1 (
			start explorer %egg% 
		)
	goto fix

::Code for fixing directory after selected input variable is empty Error
:nodirnew
	echo ERROR! Please Insert a Directory!
	pause
	goto dircustomnew


::Code for fixing directory after selected input
:nofoldernew
	cls
	color 06
	set egg=%boobs%
	%windir%\System32\choice.exe /m "Open Location?" /c YN
		if %errorlevel%==1 (
			start explorer %egg%
		)
	goto fix

::Code for fixing directory after selected input variable
:dirmusicnew
	cls
	color 02
	set /p input= "Folder Name: "
	set boobs="%defaultmusic%
	set egg="%boobs%\%input%"
	
	IF [%input%]==[] goto nofoldernew
	
	cls
	color 06
	%windir%\System32\choice.exe /m "Open Location?" /c YN
		if %errorlevel%==1 (
			start explorer %egg%
		)
	goto fix

::Code for fixing directory after selected input variable
:dirvideonew
	cls
	color 02
	set /p input= "Folder Name: "
	set boobs="%defaultvideos%
	set egg="%boobs%\%input%"
	
	IF [%input%]==[] goto nofoldernew
	
	cls
	color 06
	%windir%\System32\choice.exe /m "Open Location?" /c YN
		if %errorlevel%==1 (
			start explorer %egg%
		(
	goto fix

::code That opening incorrect directory
:nofolder
	cls
	color 06
	set egg="%boobs%"
	%windir%\System32\choice.exe /m "Open Location?" /c YN
		if %errorlevel%==1 (
			start explorer %egg%
		)
	goto links

::link code
:links
	cls
	color 0A
	set /p Link= "Link: "
	echo Target Link: %Link%
	goto playlist

::link code to fix after selected
:linknew
	cls
	color 0A
	set /p Link= "Link: "
	echo Target Link: %Link%
	goto fix

::playlsit select code
:playlist
	cls
	color 06
	%windir%\System32\choice.exe /m "Download a Playlist?" /c YN
		if %errorlevel%==1 goto yes
		if %errorlevel%==2 goto no

::link code to fix after selected
:playlistnew
	cls
	color 06	
	%windir%\System32\choice.exe /m "Download a Playlist?" /c YN
		if %errorlevel%==1 goto yesnew
		if %errorlevel%==2 goto nonew

::playlsit select code variables
:yes 
	set plys=--yes-playlist
	echo playlist mode: %plys%
	goto continue

:no
	set plys=--no-playlist
	echo playlist mode: %plys%
	goto continue

:yesnew
	set plys=--yes-playlist
	echo playlist mode: %plys%
	goto fix

:nonew
	set plys=--no-playlist
	echo playlist mode: %plys%
	goto fix

::are you sure confimation window
:continue
	cls
	color 06
	echo ---- INFO --------------
	echo File Type is: %typename%
	echo Target Folder is: %egg%
	echo Target Link: %link%
	echo Playlist Mode: %plys%
	echo ------------------------
	
	%windir%\System32\choice.exe /m "is this correct?" /c YN
		if %errorlevel%==1 goto download
		if %errorlevel%==2 goto fix

::fix incorrect settings code
:fix
	cls
	color 06
	echo ---- INFO --------------
	echo File Type is: %typename%
	echo Target Folder is: %egg%
	echo Target Link: %link%
	echo Playlist Mode: %plys%
	echo ------------------------
	echo What would you like to fix?
	echo 1.File Type
	echo 2.Target Folder
	echo 3.Link
	echo 4.Playlist Mode
	echo 5.Done
	
	CHOICE /C 12345 /M "Enter your choice: "
		if errorlevel 5 goto continue
		if errorlevel 4 goto playlistnew
		if errorlevel 3 goto linknew
		if errorlevel 2 goto dirnew
		if errorlevel 1 goto typenew

::actual yt-dlp code
:download
	cls
	color 02
	break>"%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	echo Downloading Please Wait....
	yt-dlp.exe -P %egg% %type% --add-metadata --compat-options embed-metadata %thumbnail% %plys% %Link% >> "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	goto done
	
::done code exit, etc..
:done
	cls
	echo 1.Download More
	echo 2.Download More Same Settings
	echo 3.Re-Download
	echo 4.Settings Info
	echo 5.Exit
	echo 6.Open Folder
	echo 7.Open Debug.txt
	
	CHOICE /C 1234567 /M "Enter your choice: "
		if errorlevel 7 goto opendebug
		if errorlevel 6 goto opendir
		if errorlevel 5 goto close
		if errorlevel 4 goto info
		if errorlevel 3 goto download
		if errorlevel 2 goto linknew
		if errorlevel 1 goto restart

:opendebug
	start explorer "%HOMEDRIVE%%HOMEPATH%\sKeipts\Kei-dlp\yt-dlp_Debug.txt"
	goto done

:opendir
	start explorer %egg%
	goto done

:close
exit

:info
	cls
	color 02
	echo ---- INFO --------------
	echo File Type is: %typename%
	echo Target Folder is: %egg%
	echo Target Link: %link%
	echo Playlist Mode: %plys%
	echo ------------------------
	echo 1.Download More
	echo 2.Download More Same Settings
	echo 3.Re-Download
	echo 4.Hide Info
	echo 5.Exit
	echo 6.Open Folder
	echo 7.Open Debug.txt
	
	CHOICE /C 1234567 /M "Enter your choice: "
		if errorlevel 7 goto opendebug
		if errorlevel 6 goto opendir
		if errorlevel 5 goto close
		if errorlevel 4 goto done
		if errorlevel 3 goto download
		if errorlevel 2 goto linknew
		if errorlevel 1 goto restart
