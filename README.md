# SDate
Simple alternative to NSDate, a "pure"ish swift replacement using the C date and time functions found in Darwin / BSD

https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/localtime.3.html

This is very simple and not intended for production. Swift as of 2.0 GM does not have a native time and date type.
NSDate is part of the objc Foundation Library which will not be part of swift open source release. 

This should work with Linux distribution supporting gmtime and timegm.
