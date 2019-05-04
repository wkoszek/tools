--
-- that's an amazing script from
-- http://stackoverflow.com/questions/36611477/osx-photos-applescript-loop-through-moments
--
-- which I'm backing up, since it saved me tons of time. I run it from
-- Script Editor by pasting and playing it there
--


on run
	tell application "Photos"
		set mediaItems to every media item
		repeat with mediaItem in mediaItems
			set mdate to (date of mediaItem) -- get the date of the file
			set yearName to year of mdate as string -- year of the file
			set YrFolder to my yearFolder(yearName) -- make the year folder
			
			set mmonth to month of mdate -- month of the file
			set monthName to my monthNum(mmonth as string) -- month name as a number
			set SubFold to my subFolder(monthName, YrFolder) -- make the month number folder
			
			set mday to day of mdate -- day of the file
			set dayName to my dayNum(mday as string) -- get the day as a two digit number
			set albumName to yearName & "-" & monthName & "-" & dayName as string -- create the album name
			set finalAlbum to my makeAlbum(albumName, SubFold) -- make the album
			
			add {mediaItem} to finalAlbum -- put the item in the album
		end repeat
	end tell
	
end run


on dayNum(mday)
	if (count of characters in mday) = 1 then
		return "0" & mday as string
	else
		return mday as string
	end if
end dayNum

on monthNum(mmonth)
	if mmonth = "January" then
		set num to "01"
	else if mmonth = "February" then
		set num to "02"
	else if mmonth = "March" then
		set num to "03"
	else if mmonth = "April" then
		set num to "04"
	else if mmonth = "May" then
		set num to "05"
	else if mmonth = "June" then
		set num to "06"
	else if mmonth = "July" then
		set num to "07"
	else if mmonth = "August" then
		set num to "08"
	else if mmonth = "September" then
		set num to "09"
	else if mmonth = "October" then
		set num to "10"
	else if mmonth = "November" then
		set num to "11"
	else if mmonth = "December" then
		set num to "12"
	end if
	return num
end monthNum


on makeAlbum(albName, theFolder)
	tell application "Photos"
		set yrFold to name of parent of theFolder
		if exists container albName of container (name of theFolder) of container yrFold then
			return (container albName of container (name of theFolder) of container yrFold)
		else
			return make new album named albName at theFolder
		end if
	end tell
end makeAlbum


on subFolder(subName, YrFolder)
	tell application "Photos"
		if exists container subName of container (name of YrFolder) then
			return container subName of container (name of YrFolder)
		else
			return make new folder named subName at YrFolder
		end if
	end tell
end subFolder

on yearFolder(yearName)
	tell application "Photos"
		if container named yearName exists then
			return container named yearName
		else
			try
				return make new folder named yearName
			on error
				return ""
			end try
		end if
	end tell
end yearFolder
