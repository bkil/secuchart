# Crowdsourced citizen science WAN messengers

It would be feasible to implement a hybrid P2P/F2F system where as much roles would be delegated to supernodes and friends as possible and the only remaining duty of the central server would be to sign new releases & the peer database pyramid before they get injected to the P2P storage network. I postulate that you could serve the whole world from even a VPS costing a few dollars (or a free PaaS even) if implemented right.

Parent article:

* #p2p

## Goals

* strive for sustainability (via FOSS) even after every major player went bankrupt
* separate resource providers (donating hardware and bandwidth) from authority (abuse control, moderation and peer discovery)
* scale through friend to friend networking and/or through best effort reputation, web of trust and elected supernode promotion
* The protocol and architecture should _support_ future implementation of most trendy features or lightweight alternatives (e.g., voice messages, push-to-talk and slideshows)
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
* persistent group hosting, forwarding of messages
* abuse reduction: account registration via proof of work, CAPTCHA, verified email, phone, other account, IP blocklists
* ICE: STUN, TURN
* mapping of reachable nodes: friends, DHT, bootstrapping this structure
* power saving push notification delivery

## Why not fix an existing solution

As an empirical data point about such a development project, consider how Torrent was adapted to WebRTC as WebTorrent. It is a use case that was much more desirable for users. PeerTube is also built on top of it. However:

* Support for it is still scarce.
* Dedicated FOSS clients that are dual-stack (FOSS WebTorrent & Torrent) are rare. The best approximation is running the inefficient web version on nodeJS.
* Its CPU consumption is much higher
* Even the developers recommend just operating a webseed instead on a server if possible.
* Adapting video sharing (bug free) by a payed team to such a system took years

Now consider doing something like this to another well known protocol, like Tor, I2P, Freenet, GNUnet, Secure Scuttlebutt or Dat.

* It would not take less effort
* After you are finished, you would still need to implement the rest of the messenger on top as well
* Web technology restrictions would reduce some of the anonymity and decentralization related guarantees that the original ones had

Some of the privacy-focused overlay routing networks also provide too low bandwidth, too high latency, setup latency or regular circuit switching to be comfortable for live voice & video calling and many use cases for screen sharing. See also:

* #tor
* #ipfs

## Peer exchange

* via multicast DNS within a LAN
* hypothetically via short range direct wireless
* peer exchange between nodes after successfully hopping onto the network
* a persistent offline cache that the node itself has built up
* Rendezvous host
* the preloaded list of IP's that the software comes bundled with when you install it from your store of choice (or via Bluetooth from your peer in case of f-droid)

Basically what would be a big win if the application was continuously updated within its distribution media (either daily within the app market or possibly minute by minute if you download the package from its own web site or repository). It's just a CSV that needs to be updated (and resigned) within the bundle.

For example, as the package for pybitmessages hasn't seen an update since 2018 (and most similar apps are rarely updated more than once every few months and usually manually), such a dynamic list would not work except for listing the mostly-on nodes possibly added manually (that incidentally Tox is also doing, but they admit that it's not enough). CI/CD has been a thing for decades now, so it's kind of appalling to see that few FOSS projects are doing it to this day.

## Peer discovery

It might be feasible to infrequently scan neighboring IPs for possible peers on well known ports. Many ISPs already assign IP ranges in a kind of cartographic locality, so it would provide low latency paths automatically if you scanned in increasing distance from your own WAN IP (and/or its "aliases" over the virtual allocation range). This would only be feasible if a sizable proportion of the population would have it installed, let's say 1%, otherwise it's considered spamming.

## Rendezvous server

A rendezvous server helps peers find each other by exchanging introductions, facilitating peer event signalling or hosting pointer invitations. It should be publicly reachable. It need not be a full blown complicated peer node itself.

A mostly static web server with a few lines of PHP or CGI could suffice. You could substitute various preexisting technologies, for example public DNS records (or even free dynamic DNS), git repository, static web hosting of each member that can be updated through an API.

A custom rendezvous server could also be replaced by a bot connecting to some other popular available server, whatever is common within a given community: a mailing list, forum, matrix chat, bulletin board, whatever you and at least some of your friends already have access to. Lacking that, you could sometimes even run a tiny dedicated server piggybacked onto some other system, as in:

https://gitlab.com/bkil/freedom-fighters/-/blob/master/hu/service/game-backend.md

## Friend-to-Friend topology

Existing messengers advertised as P2P always use a supporting underlying network of dedicated servers that are pretty expensive to maintain, hence why 90% of the new alternatives that pop up always involve a cryptocurrency for monetization.

F2F would be an alternative as a way for users to maintain reputation among each other and to refrain from committing abuse without consequences.

Consider that if you only ever link to your friends directly and you trust them, metadata collection (it terms of keeping logs or deleting expired or retracted messages according to gentleman's agreement) wouldn't be an issue at all.

* https://en.wikipedia.org/wiki/Citizen_science
* https://en.wikipedia.org/wiki/Friend_to_friend
* https://pdos.csail.mit.edu/~jinyang/pub/iptps-f2f.pdf
* https://en.wikipedia.org/wiki/Gentlemen%27s_agreement

It could be useful for:

* NAT traversal
* store and forward buffering
* push notifications

## NAT traversal

In the framework of WebRTC/ICE, STUN & TURN are used together, because STUN itself can only connect a subset of nodes (up to 90%, but it's much worse among mobiles). And bandwidth (CPU?) costs at TURN relays can be quite significant, hence why it is a central point of failure.

But nothing would keep a hypothetical real P2P network from building up a spanning tree via F2F to forward packets and distribute routes among static volunteers and/or dynamically established pairs. And STUN/TURN is kind of an anonymous, stateless service. With global deployment, it needs either funding, or credentials to access it and/or F2F authorization. It also requires an independent signalling path via which you forward peer invites, and that is also usually some kind of central server on presently implemented systems.

Skype did it decades ago with automatic super node promotion, but I have yet to find another messenger (or data sync or social networking service solution) that is capable of anything like that.

The basic design flaw of many messengers is that the only way to reach users who are not publicly routable is through relays, and only a few nodes are TCP relays (optional setting) a lot like if it went over TURN. Rather, this should be the default (and detected during runtime even), and it should be modelled after ICE - select between STUN alternatives and only resort back to something like TURN if there is no solution otherwise. This would reduce the load on relays tenfold at least.

## Store and forward buffering

I think solving store & forward in a decentralized system is best done through a friend-to-friend topology. I.e., not only your own devices store your messages, but also some owned by your circles. And having to run a separate 24/7 mailbox/relay hardware peripheral isn't going to cut it either (what about e-waste and wasting power - see why shared hosting is the best for the world)
