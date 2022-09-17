# E2EE in public rooms

Why should you not enable E2EE in public rooms? Some of these reasons are specific to the current implementation of Matrix servers and clients, while others are more general in nature.

* As anyone can join, so can logger bots for the authorities that you want to hide against, so it only provides a false sense of security
* Guests, new members and room preview can't read room history
* Hampering SEO by not being indexed on https://view.matrix.org/
* A member may lose the ability to decode messages while all of their sessions are signed out (e.g., closing an incognito browser window) and until the encryption keys are not recovered manually following a new login (if they didn't forget to set it up)
* Various members regularly report bugs that causes them to lose ability to decode certain messages in private or in large rooms (as recently as 2022-09)
* Can cause confusion if somebody accidentally enabled the setting "Never send encrypted messages to unverified sessions from this session". Especially as the problem only manifests in one direction only, they may not realize this until after a long time had passed.
* It requires constantly exchanging more message events, resulting in increasing latency, data transfer and battery consumption
* Many events are still not encrypted in E2EE rooms: membership and its changes, reactions (along with their content!), metadata of reply chains, editing, kicking, banning, redaction, presence status, read receipts and more
* Power efficient notifications are not possible without server side filtering - including watching for mentions of keywords or our own display name
* It is difficult to implement by third parties, hence many custom bots lack the ability to participate in such rooms
* Searching in the chat log is not possible using Element Web
* Desktop Matrix clients can search the chat log by syncing the whole timeline after joining or at latest when issuing the query. Due to the slowness of a full sync, the latter solution may not be ergonomic in large rooms. Thus, it would greatly increase the load on both HS's and clients if every room was E2EE.
* https://matrix.org/faq/#why-are-large-public-rooms-like-matrixmatrixorg-not-encrypted
