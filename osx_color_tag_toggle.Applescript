-- This script comes from http://hints.macworld.com/article.php?story=20070602122413306
-- and is used to toggle a red flag on the file
-- look into the osx_autamtor
-- you must have an automator services started with a key. This service is
-- called "call Applescript"
tell application "Finder"
  set thisItem to selection as alias
  if label index of thisItem = 0 then
    set the label index of thisItem to 2 -- 2 = red
  else
    set label index of thisItem to 0 -- 0 = no label
  end if
end tell

