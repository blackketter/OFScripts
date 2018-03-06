-- Get the selection FIRST and then exit if nothing is selected.
tell application "OmniFocus"
	tell content of first document window of front document
		set tasksSelected to value of (selected trees where (class of its value is not item) and (class of its value is not folder))
		if length of tasksSelected is 0 then
			--			display alert "You didn't select any OmniFocus tasks."
			return
		end if
	end tell
end tell
-- Do the actual work of setting the date and the flag, if necessary
tell application "OmniFocus"
	repeat with i from 1 to (length of tasksSelected)
		tell item i of tasksSelected
			set oneday to (24 * 60 * 60)
			
			set manana to (current date) + oneday
			set time of manana to 0
			
			set olddue to due date of it
			if olddue is not missing value then
				set duet to manana
				set time of duet to (time of olddue)
				set due date of it to duet
			end if
			
			
			set olddefer to defer date of it
			if olddefer is missing value then
				set defer date of it to manana
			else
				set defert to manana
				set time of defert to (time of olddefer)
				set defer date of it to defert			
			end if
			
			
		end tell
	end repeat
end tell
