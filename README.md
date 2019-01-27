# resizer.bash Helper Script #

This script works in conjunction with macOS’s [`sips(1)` utility](https://ss64.com/osx/sips.html) to resize images.

## Usage ##

    Usage: resizer.bash [-h] [-s newSize] file [file ...]
    
    This script will resize, in place, any number of supplied image files, such 
    that afterwards, their largest edge will be equal to the value specified by -s 
    or 1024, if the -s option is skipped.
