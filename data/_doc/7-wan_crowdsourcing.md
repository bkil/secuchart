# Crowdsourced citizen science WAN messengers

## Goals

* strive for sustainability (via FOSS) even after every major player went bankrupt
* separate resource providers (donating hardware and bandwidth) from authority (abuse control, moderation and peer discovery)
* scale through friend to friend networking and/or through best effort reputation, web of trust and elected supernode promotion
* The protocol and architecture should _support_ future implementation of most trendy features or lightweight alternatives (e.g., slideshows and push-to-talk)
* Privacy, security and quality guarantees of the implementation are secondary if it can be improved later on
* #persona

## Bottlenecks

* where a user installs the software from
* where a user receives software updates from
* documentation
* tech support
* IP ASN
* DNS
* certificate authority, TLS certificates
* directory for user names
* account replica (online backup and sync between devices)
* account recovery and deactivation in case of exploit
* ephemeral buffering of direct messages
* persistent group hosting
* abuse reduction: account registration via proof of work, CAPTCHA, verified email, phone, other account, IP blocklists
* ICE: STUN, TURN
* mapping of reachable nodes: friends, DHT, bootstrapping this structure
* power saving push notification delivery

## Why not fix an existing solution

Compare this to how Torrent was adapted to WebRTC as WebTorrent.

It is a use case that was much more desirable for users. PeerTube is also built on top of it.

* Support for it is scarce.
* Dedicated FOSS clients that are dual-stack (FOSS WebTorrent & Torrent) are rare. The best approximation is running the inefficient web version on nodeJS.
* Its CPU consumption is much higher
* Even the developers recommend just operating a webseed instead on a server if possible.
* Adapting video sharing (bug free) by a payed team to such a system took years

Now consider doing something like this to another well known protocol, like Tor, I2P, Freenet, GNUnet, Secure Scuttlebutt or Dat.

* It would not take less effort
* After you are finished, you would still need to implement the rest of the messenger on top as well
* Web technology restrictions would reduce some of the anonymity and decentralization related guarantees that the original ones had

See also:

* #tor
* #ipfs
