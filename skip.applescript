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
			mark dropped it
		end tell
	end repeat
end tell
