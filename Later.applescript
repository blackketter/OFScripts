(*
	LATER.SCPT
	By Chris Sauve of [pxldot](http://pxldot.com).
	See README for details.
*)


property usesFlagsForScheduling : true -- true or false, true flags any tasks that the script runs on
property methodForScheduling : "Start" -- Options are "Start" or "Due"
property useGrowlForAlerts : true -- true or false
property promptForUserOptions : true -- will change after first run
property timesUsedSinceError : 0

-- Get the selection FIRST and then exit if nothing is selected.
tell application "OmniFocus"
	tell content of first document window of front document
		set tasksSelected to value of (selected trees where (class of its value is not item) and (class of its value is not folder))
		if length of tasksSelected is 0 then
			display alert "You didn't select any OmniFocus tasks."
			return
		end if
	end tell
end tell

if promptForUserOptions then
	display dialog �
		"Would you like to automatically flag the tasks on which you run this script?" buttons {"No, Don't Flag", "Yes, Use Flags"} default button 2 giving up after 60
	set decisionOnFlags to button returned of result
	if decisionOnFlags is "No, Don't Flag" then set usesFlagsForSceduling to false
	
	display dialog "Would you like to use Due or Start dates for scheduling?" buttons {"Due", "Start"} default button 2
	set methodForScheduling to button returned of result
	set promptForUserOptions to false
end if

try
	set inputDialog to "To when would you like to defer this task?"
	if timesUsedSinceError = 0 then set inputDialog to (inputDialog & " Note: you can use relative days (i.e., \"1w 4d 2pm\"), absolute dates (i.e., \"Jan 19 14:00\") or weekdays (i.e., \"Sat 5pm\"), just  as in OmniFocus.")
	display dialog �
		inputDialog default answer "1d 12am"
	set timeDeferred to text returned of result
on error errorText number errorNumber
	if errorNumber is -128 then
		return
	end if
end try

-- Escape to manually choose start and due dates, regardless of the default (start with the input with that word)
set escapeToStart to (timeDeferred starts with "start")
set escapeToDue to (timeDeferred starts with "due")
set escapeToBoth to (timeDeferred contains "start") and (timeDeferred contains "due")
set startFirst to true

if escapeToBoth then
	set startFirst to (offset of "start" in timeDeferred) < (offset of "due" in timeDeferred)
	set my text item delimiters to {"start ", "start", "due ", "due"}
	set adjustedInput to every text item of timeDeferred
	set fixedInput to {}
	repeat with i from 1 to (length of adjustedInput)
		if not ((item i of adjustedInput is "") or (item i of adjustedInput is in "                ")) then
			set the end of fixedInput to item i of adjustedInput
		end if
	end repeat
	if length of fixedInput is not 2 then return
	set desiredDate1 to getDate(item 1 of fixedInput)
	set desiredDate2 to getDate(item 2 of fixedInput)
	if (desiredDate2 is -1) or (desiredDate1 is -1) then return
else
	set desiredDate1 to getDate(timeDeferred)
	if desiredDate1 is -1 then return
end if

-- Do the actual work of setting the date and the flag, if necessary
tell application "OmniFocus"
	repeat with i from 1 to (length of tasksSelected)
		tell item i of tasksSelected
			if escapeToBoth then
				if startFirst then
					set start date of it to desiredDate1
					set due date of it to desiredDate2
				else
					set due date of it to desiredDate1
					set start date of it to desiredDate2
				end if
			else if ((methodForScheduling is "Start") and not escapeToDue) or escapeToStart then
				set start date of it to desiredDate1
			else
				set due date of it to desiredDate1
			end if
			if usesFlagsForScheduling then set its flagged to true
		end tell
	end repeat
end tell


--//////// Understanding the date and time given in plain english ////////--

on englishTime(dateDesired)
	if dateDesired is "0" then return 0
	
	set monthFound to 0
	set weekdayFound to 0
	-- Solves an issue with the treatment of leading zeros for the minutes (i.e., 12:01am)
	set minuteLeadingZero to false
	
	-- Figures out if the user excluded any of the components
	set timeMissing to false
	set daysMissing to false
	set weeksMissing to false
	
	-- Sets up the delimiters for different items
	set timeDelimiters to {"am", "pm", "a", "p", ":"}
	set dayDelimiters to {"days", "day", "d"}
	set weekDelimiters to {"weeks", "week", "w"}
	set monthDelimiters to {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
	set weekdayDelimiters to {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}
	set specialRelativeDayDelimiters to {"Today", "Tomorrow", "at"}
	set otherDelimiters to {" ", "th", "st", "rd", "nd", "start", "due", "both"}
	
	set inThe to "unknown"
	set howManyNumbersInputted to 0
	set numList to {}
	
	-- See if they included AM/PM
	if isNumberIdentifier("a", dateDesired) then set inThe to "AM"
	if isNumberIdentifier("p", dateDesired) then set inThe to "PM"
	
	-- See if they gave an absolute date formatted in YY.MM.DD or some other similar format
	set my text item delimiters to specialRelativeDayDelimiters & otherDelimiters & timeDelimiters
	set checkInput to every text item of dateDesired
	set checkInputCleaned to {}
	repeat with i from 1 to (length of checkInput)
		if item i of checkInput is not "" then
			set the end of checkInputCleaned to item i of checkInput
		end if
	end repeat
	set theDateCheck to item 1 of checkInputCleaned
	if (theDateCheck contains ".") or (theDateCheck contains "-") or (theDateCheck contains "/") then
		set todaysDate to (current date)
		set time of todaysDate to 0
		set targetDate to my understandAbsoluteDate(theDateCheck)
		if targetDate = -1 then return -1
		set my text item delimiters to ""
		if length of checkInputCleaned is 1 then
			return (targetDate - todaysDate) as number
		else
			set theTime to items 2 thru -1 of checkInputCleaned
			set numList to {}
			
			set timeStoreLocation to length of theTime
			repeat while timeStoreLocation > 0
				try
					-- If the minutes have a leading zero, just combine them with the hours
					if (numList = {}) and ((item timeStoreLocation of theTime) starts with "0") then
						set the end of numList to ((item (timeStoreLocation - 1) of theTime) & (item timeStoreLocation of theTime)) as number
						set minuteLeadingZero to true
						set timeStoreLocation to timeStoreLocation - 2
					else
						-- Otherwise, get the numbers only
						set tempNum to (item timeStoreLocation of theTime) as number
						if tempNum � 0 then set the end of numList to tempNum
						set timeStoreLocation to timeStoreLocation - 1
					end if
				end try
			end repeat
			
			set theTime to figureOutTheTime(numList, false, true, true, minuteLeadingZero)
			set theTime to understandTheTime(theTime, inThe, false)
			return (targetDate + theTime - todaysDate) as number
		end if
	end if
	
	-- See if they gave an absolute date, a relative one, or a day of the week
	repeat with i from 1 to (length of monthDelimiters)
		if dateDesired contains (item i of monthDelimiters) then
			set monthFound to i
			exit repeat
		end if
		if i � (length of weekdayDelimiters) then
			if dateDesired contains (item i of weekdayDelimiters) then
				set weekdayFound to i
			end if
		end if
	end repeat
	
	-- Getting rid of all the bits I could imagine being around the numbers
	set text item delimiters to (specialRelativeDayDelimiters & monthDelimiters & weekDelimiters & dayDelimiters & timeDelimiters & otherDelimiters)
	set inputList to every text item of dateDesired
	-- Resetting delimiters
	set text item delimiters to {""}
	
	repeat with i from 1 to (length of inputList)
		if item i of inputList is "-" and (character 1 of item (i + 1) of inputList is in "123456789") then
			set item (i + 1) of inputList to item i of inputList & item (i + 1) of inputList
		end if
	end repeat
	
	-- Count how many numbers were given
	repeat with i from 1 to (length of inputList)
		if (item i of inputList) is not "" then
			try
				set tempItem to (item i of inputList) as integer
				if class of tempItem is integer then set howManyNumbersInputted to howManyNumbersInputted + 1
			end try
		end if
		set tempItem to ""
	end repeat
	
	-- Get the numbers of the input ��start from the back to get the minutes first
	set timeStoreLocation to length of inputList
	repeat while timeStoreLocation > 0
		try
			-- If the minutes have a leading zero, just combine them with the hours
			if (numList = {}) and ((item timeStoreLocation of inputList) starts with "0") then
				set the end of numList to ((item (timeStoreLocation - 1) of inputList) & (item timeStoreLocation of inputList)) as number
				set minuteLeadingZero to true
				set timeStoreLocation to timeStoreLocation - 2
			else
				-- Otherwise, get the numbers only
				try
					set tempNum to (item timeStoreLocation of inputList) as number
					if tempNum � 0 then set the end of numList to tempNum
				end try
				set timeStoreLocation to timeStoreLocation - 1
			end if
		end try
	end repeat
	
	-- Reverse it so the order is from biggest to smallest time increment
	set numList to reverse of numList
	
	if (monthFound is 0) and (weekdayFound is 0) then
		-- If the user gave a relative date...
		tell dateDesired
			set daysMissing to not my isNumberIdentifier("d", it)
			set weeksMissing to not my isNumberIdentifier("w", it)
			if (howManyNumbersInputted - ((not daysMissing) as integer) - ((not weeksMissing) as integer)) = 0 then set timeMissing to true
		end tell
		
		-- Figure out how many weeks
		if not weeksMissing then
			set weeksDeferred to item 1 of numList
		else
			set weeksDeferred to 0
		end if
		
		-- Figure out how many days
		if not daysMissing then
			set daysDeferred to howManyDays(numList, weeksMissing)
		else
			if dateDesired contains "Tomorrow" then
				-- Special case where they put "tomorrow"
				set daysDeferred to 1
			else
				-- If they exclude it entirely or put "Today"
				set daysDeferred to 0
			end if
		end if
		
		-- Figure out the time
		set timeDeferredTemp to figureOutTheTime(numList, timeMissing, daysMissing, weeksMissing, minuteLeadingZero)
		-- Understand the meaning of the time component
		set timeDeferred to understandTheTime(timeDeferredTemp, inThe, timeMissing)
		
		-- Creating the time deferred based on minutes and hours calculated
		if timeDeferred � 0 then
			set totalTimeDeferred to timeDeferred + daysDeferred * days + weeksDeferred * weeks
		else
			set totalTimeDeferred to timeDeferred
		end if
		-- end of relative date-only code
		
	else if (weekdayFound > 0) and (monthFound is 0) then
		if length of numList < 1 then set timeMissing to true
		-- Same as if the day and the week were missing on a relative date
		set timeDeferredTemp to figureOutTheTime(numList, timeMissing, true, true, minuteLeadingZero)
		set timeDeferred to understandTheTime(timeDeferredTemp, inThe, timeMissing)
		set daysDeferred to daysFromTodayToWeekday(weekdayFound)
		if timeDeferred � 0 then
			set totalTimeDeferred to daysDeferred * days + timeDeferred
		else
			set totalTimeDeferred to timeDeferred
		end if
	else
		-- If the user gave an absolute date...
		if length of numList < 2 then set timeMissing to true
		-- Same as if the day were there but week wasn't on a relative date
		set timeDeferredTemp to figureOutTheTime(numList, timeMissing, false, true, minuteLeadingZero)
		set timeDeferred to understandTheTime(timeDeferredTemp, inThe, timeMissing)
		set timeFromTodayUntilDesired to figuringTimeToDesiredDay(monthFound, (item 1 of numList))
		if timeDeferred � 0 then
			set totalTimeDeferred to timeFromTodayUntilDesired + timeDeferred
		else
			set totalTimeDeferred to timeDeferred
		end if
	end if
	
	return totalTimeDeferred
	
end englishTime


on isNumberIdentifier(possibleIdentifier, containerString)
	set numberIdentifier to true
	set identifierIsInContainer to false
	set positionOfLastIdentifier to 0
	set charList to every character of containerString
	
	repeat with i from 1 to (length of charList)
		if (item i of charList) = possibleIdentifier then
			set identifierIsInContainer to true
			set positionOfLastIdentifier to i
		end if
	end repeat
	
	if (positionOfLastIdentifier is 0) or (positionOfLastIdentifier is 1) then
		set numberIdentifier to false
	else
		set characterBefore to character (positionOfLastIdentifier - 1) of containerString
		set numBefore to 0
		try
			set numBefore to characterBefore as integer
		end try
		if (characterBefore is not " ") and (class of numBefore is not integer) then set numberIdentifier to false
	end if
	return numberIdentifier
end isNumberIdentifier


on howManyDays(numList, weeksMissing)
	if not weeksMissing then
		set daysDeferred to item 2 of numList
	else
		set daysDeferred to item 1 of numList
	end if
	return daysDeferred
end howManyDays


on figureOutTheTime(numList, timeMissing, daysMissing, weeksMissing, minuteLeadingZero)
	if not timeMissing then
		if minuteLeadingZero then
			set timeDeferredTemp to item -1 of numList
		else
			set text item delimiters to ""
			set timeDeferredTemp to ((items -1 thru (1 + ((not daysMissing) as integer) + �
				((not weeksMissing) as integer)) of numList) as text) as integer
		end if
	else
		set timeDeferredTemp to 0
	end if
	return timeDeferredTemp
end figureOutTheTime


to understandTheTime(timeDeferredTemp, inThe, timeMissing)
	if timeMissing then
		set timeDeferred to 0
	else
		if timeDeferredTemp > 2400 then
			-- If the time is greater than the 24 hour clock...
			display alert "Please try again: the time you entered was not a valid time of day."
			set timeDeferred to -1
			
		else if timeDeferredTemp = 2400 then
			-- If the time is equal to 2400...
			set timeDeferred to days
			
		else if timeDeferredTemp � 100 then
			-- if they entered the time as a full hour:minute pair (with or without AM/PM and with or without the colon)
			set minutesDeferred to (((characters -2 thru -1 of (timeDeferredTemp as text)) as text) as integer)
			set hoursDeferred to (((characters 1 thru -3 of (timeDeferredTemp as text)) as text) as integer)
			-- Figuring out the minutes and hours in the time given (minutes are last two numbers)
			
			if inThe = "PM" then
				-- For any number specifically designated as PM
				set timeDeferred to ((hoursDeferred + 12) * hours + minutesDeferred * minutes)
			else if hoursDeferred = 12 and inThe = "AM" then
				-- For 12:00AM exactly
				set timeDeferred to minutesDeferred * minutes
			else
				-- For times in the AM (implicit or explicit) and explicit times in the PM (i.e., 16:00)
				set timeDeferred to (hoursDeferred * hours + minutesDeferred * minutes)
			end if
			
		else if timeDeferredTemp > 24 then
			-- If they entered the time as a single number above 24
			display alert "Please try again: the time you entered was not a valid time of day."
			set timeDeferred to -1
			
		else if timeDeferredTemp � 24 then
			-- If the entered the time as a single number (with or without AM/PM)	
			if timeDeferredTemp = 24 then
				-- If they entered 24 hours exactly (treat as a full extra delay)
				set timeDeferred to days
			else if (timeDeferredTemp = 12) and (inThe � "AM") then
				-- If they entered "12" (treat it as 12PM)
				set timeDeferred to 12 * hours
			else if (timeDeferredTemp � 12) or (inThe � "PM") then
				-- For implicit and explicit AM entries and for implicit PM entries
				set timeDeferred to timeDeferredTemp * hours
			else
				-- For explicit PM entries
				set timeDeferred to (timeDeferredTemp + 12) * hours
			end if
		end if
	end if
	return timeDeferred
end understandTheTime


to figuringTimeToDesiredDay(monthDesired, dayDesired)
	set todaysDate to (current date)
	set time of todaysDate to 0
	-- Creating an intial date object
	copy todaysDate to exactDesiredDate
	set (day of exactDesiredDate) to dayDesired
	set (month of exactDesiredDate) to monthDesired
	if exactDesiredDate < (current date) then
		set (year of exactDesiredDate) to ((year of todaysDate) + 1)
	end if
	return (exactDesiredDate - todaysDate)
end figuringTimeToDesiredDay


on daysFromTodayToWeekday(weekdayDesired)
	set currentWeekday to (weekday of (current date)) as integer
	if currentWeekday = weekdayDesired then
		set daysDeferred to 0
	else if currentWeekday < weekdayDesired then
		set daysDeferred to weekdayDesired - currentWeekday
	else
		set daysDeferred to 7 + weekdayDesired - currentWeekday
	end if
	return daysDeferred
end daysFromTodayToWeekday

on understandAbsoluteDate(theText)
	set theDate to (current date)
	set the day of theDate to 1
	set the month of theDate to 2
	set theDate to (theDate - 1 * days)
	set theDate to short date string of theDate
	
	set text item delimiters to {".", "-", "/", "�", "�", "|", "\\"}
	set theDate to every text item of theDate
	set thePositions to {theDay:0, theMonth:0, theYear:0}
	
	-- Checks the positions of the date components based on January 31 of this year
	repeat with i from 1 to (length of theDate)
		tell item i of theDate
			if it is in "01" then
				set (theMonth in thePositions) to i
			else if it is in "31" then
				set (theDay in thePositions) to i
			else
				set (theYear in thePositions) to i
			end if
		end tell
	end repeat
	
	set theText to every text item of theText
	
	set targetDate to (current date)
	set time of targetDate to 0
	if (length of theText is not 2) and (length of theText is not 3) then
		-- If they don't input at 2-3 numbers, return the error
		return -1
	else
		if length of theText is 3 then
			-- If the input has three numbers
			set the year of targetDate to solveTheYear((item (theYear of thePositions) of theText) as number)
		else
			-- If the input has two numbers (left out the year)
			set thePositions to adjustPositionsForNoYear(thePositions)
		end if
		set the month of targetDate to (item (theMonth of thePositions) of theText) as number
		set the day of targetDate to (item (theDay of thePositions) of theText) as number
		if targetDate is less than (current date) then
			set the year of targetDate to (the year of (current date)) + 1
		end if
	end if
	return targetDate
end understandAbsoluteDate

to adjustPositionsForNoYear(thePositions)
	if (theYear in thePositions) is 1 then
		set (theMonth in thePositions) to (theMonth in thePositions) - 1
		set (theDay in thePositions) to (theDay in thePositions) - 1
	else if yearPosition is 2 then
		if (theDay in thePositions) < (theMonth in thePositions) then
			set (theMonth in thePositions) to (theMonth in thePositions) - 1
		else
			set (theDay in thePositions) to (theDay in thePositions) - 1
		end if
	end if
	return thePositions
end adjustPositionsForNoYear

to solveTheYear(num)
	if num � 1000 then
		return num
	else
		return (2000 + num)
	end if
end solveTheYear

to getDate(theInput)
	-- Setting the desired date based on input
	set desiredDate to (current date)
	set time of desiredDate to 0
	set secondsDeferred to englishTime(theInput)
	if secondsDeferred = -1 then
		set timesUsedSinceError to 0
		return -1
	else
		set timesUsedSinceError to timesUsedSinceError + 1
	end if
	return desiredDate + secondsDeferred
end getDate
