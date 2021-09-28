# RP

Folder containing material for crunching log files of RP monitors, i.e. files with measurements of ambient dose equivalent.
In the present folder, three types of monitors are supported:
* diodes (REM counters): `diode` files;
* polymaster gamma monitors: `polymaster` files;
* monitors in stationary stations (for both neustrons and photons): `stationary` files.

For each type of monitor, three functions are available:
* `Parse*File.m`: parsing of log file. Typically it returns an array of time stamps and an array of values. If more than a monitor log file is parsed, then timestamps and data are stored in matrices, a column for each monitor;
* `Write*File.m`: write out of log file. Header lines and line format are kept the same, as if the file was really written by the device. A single monitor/data set is dumped per file;
* `ExtractNaturalTimes*.m`: search for "natural acquisition times", i.e. times where most probably the acquisition was stopped and re-started. Given the different logging formats, each monitor has its own rule for guessing.
These functions have basically identical interfaces, no matter the monitor type (few exceptions are anyway there, please check).

Additional functions:
* `ShowDoses.m`: plotting the raw data of log files with dose values;
* `EstimateConvCoeff.m`: function to estimate the counts->dose conversion factor. Basically, the min dose value or the min delta dose is taken as conversion factor.
