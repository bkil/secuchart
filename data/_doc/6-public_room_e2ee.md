# E2EE in public rooms

Why should you not enable E2EE in public rooms? Some of these reasons are specific to the current implementation of Matrix servers and clients, while others are more general in nature.

* Once you enable E2EE in a given room, you can't undo it except with a costly room upgrade
* As anyone can join, so can logger bots for the authorities that you want to hide against, so it only provides a false sense of security
* Guests, new members and room preview for one browsing through the room directory or clicking on personal room recommendations can't read room history, so they will hesitate to join
* Hampering SEO by not being indexed on https://view.matrix.org/
* A member may lose the ability to decode messages while all of their sessions are signed out. This can also happen if you close an incognito browser window or clear cookies. You can only read messages sent after you log in again. You need to set up E2EE key recovery for the account and restore the keys immediately after you sign in. Otherwise you won't be able to read any old messages - even ones that you could decode in the past!
* Various members regularly report bugs that causes them to lose ability to decode certain messages in private or in large rooms (as recently as 2022-11)
* As present server implementations handle key exchange messages in a separately capped (to-device) stream within transactions, it could happen in case of a loaded server or network that everything works except E2EE decryption. This may also provide a potential for further bugs and denial of service https://matrix.to/#/#matrix:matrix.org/$Lm0NKMDdiwbxH47falot7LMeGhXndllRmlOdI_tYE5Y?via=matrix.org&via=libera.chat&via=privacytools.io
* Can cause confusion if somebody accidentally enabled the setting "Never send encrypted messages to unverified sessions from this session". Especially as the problem only manifests in one direction only, they may not realize this until after a long time had passed.
* It requires constantly exchanging more message events, resulting in increasing latency, data transfer and battery consumption. This also applies to those who are not using E2EE rooms, as device change events are streamed to us by our HS coming from any user who has a room in common with us.
* Periodic rekeying of the ratchet means that every once in a while, sending a message could take much longer in mid-sized rooms - up to a minute. This happens after every 100 message, 1 week of elapsed time or when somebody joins, leaves or changes their device (e.g., logs in anew). https://matrix.org/docs/guides/end-to-end-encryption-implementation-guide/#handling-membership-changes https://github.com/matrix-org/matrix-js-sdk/blob/cbcf47d5c01b6799f85f8499124a042bdd37c061/src/crypto/algorithms/megolm.ts#L253
* Many events are still not encrypted in E2EE rooms: membership and its changes, reactions (along with their content!), metadata of reply chains, editing, kicking, banning, redaction, presence status, read receipts, typing indicator and more
* Power efficient notifications are not possible without server side filtering such as watching for mentions of keywords or our own display name
* It is difficult to implement by third parties, hence many custom bots lack the ability to participate in such rooms
* Searching in the chat log is not possible using Element Web (and possibly some other clients)
* Desktop Matrix clients can search the chat log by syncing the whole timeline when they join or at latest when issuing the query. Due to the slowness of a full sync, the latter solution may not be ergonomic in large rooms. Thus, it would greatly increase the load on both HS's and clients if every room was E2EE by default.
* https://matrix.org/faq/#why-are-large-public-rooms-like-matrixmatrixorg-not-encrypted
