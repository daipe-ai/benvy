# Development environment initialization

for the [Daipe stack](https://docs.daipe.ai/)

### What it does:

* Extends the [Pyfony dev environment initialization](https://github.com/pyfony/penvy)
* Downloads Hadoop's `winutils.exe` and puts it into the project's `.venv` directory (Windows only) 
* Downloads **Java 1.8** binaries and puts them into the `~/.databricks-connect-java` dir
* Creates the empty `~/.databricks-connect` file
