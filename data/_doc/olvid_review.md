# Olvid

## TODO

https://www.olvid.io/assets/documents/2020-12-15_Olvid-specifications.pdf

## 2022-03-28 trackers

https://matrix.to/#/!sOLQNHloevPHIEWcYN:matrix.org/$-RvqSCyOvxk3PAYFKpJptizTLlHUoPETydYgaunwL40?via=matrix.org&via=tchncs.de&via=midov.pl&via=grin.hu&systemtest.tk&via=altillimity.com

> Olvid does not have a built-in tracker but in the Android version of Olvid and only in it, what is detected as OpenTelemetry by the app analysis tools is in fact an OpenCensus library which is a dependency of the Google Drive connection library. Olvid doesn't bring up any telemetry data, but some components of the library are used for communications with Google Drive, including automatic cloud backup with Google Drive, as described here. So: Olvid cannot remove the dependency as long as Olvid provides the ability to do automatic cloud backups with Google Drive, as described here. If you do not enable automatic cloud backups with Google Drive, no lines of code from this library will be executed within Olvid. If you enable automatic backups to the cloud with Google Drive, some lines of code from this library will be used, but not for telemetry data retrieval.

* https://olvid.io/faq/about-backup/
* https://olvid.io/faq/automatic-backup/
