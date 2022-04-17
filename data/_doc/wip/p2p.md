# TODO

`Tor network` is not made out of `thin air`

You don't `purchase internet (access) at home`, rather you lease a certain path towards reaching certain other servers.

If torproject went defunct tomorrow (or was just blocked), so much for your "serverless" network.

What liberty advocates really need to know is whether there are any intermediaries involved who we don't control on our communication path.

Tox is more decentralized than Briar. All nodes are full featured and you could preload peer lists into the installer. The fact that they aren't doing that properly right now (and keeping an updated list based on health & popularity) is more a shortcoming of their PM than it is of their protocol. They even mention this in their wiki.

And maybe my phrasing was not clear, but it does not **depend** on the preloaded peer list, it also takes advantage of it. It also support peer list exchange between peers (along with bootstrap servers as well, similarly how most DHT solutions work).

DHT bootstrap nodes ("the servers") _cache_ the node lists, not host them. In some of the networks, they also offer further services, like monitoring, health checks (as in Tor), abuse control, censorship or web of trust.

I haven't looked this up, but I think the above would itself still deserve some research - how peer lists could be "curated" and preloaded by some kind of mechanism that still ensured integrity and scalability within the network.

Do not discount the importance or complexity of the overlay routing network that you build on as a bottleneck.

You can scan a QR in Jami, Tox or RetroShare as well, and the invitation also usually includes the peer address, this is pretty standard I think.

## New project

You can actually have a sustainable P2P/F2F communication platform without relying on any kind of additional server specific to the given project or purpose whose demise could lead to the downfall of the whole network and all messengers in question.

## NAT traversal

In the framework of WebRTC/ICE, STUN & TURN are used together, because STUN itself can only connect a subset of nodes (like 90% or something, but much lower ratio among mobiles). And bandwidth (CPU?) costs at TURN relays can be quite significant, hence why it is a central point of failure.

But nothing would keep a hypothetical real P2P network from building up a spanning tree via F2F to forward packets and distribute routes among static volunteers and/or dynamically established pairs. And STUN/TURN is kind of an anonymous, stateless service. With global deployment, it needs either funding, or credentials to access it and/or F2F authorization. It also requires an independent signalling path via which you forward peer invites, and that is also usually some kind of central server on presently implemented systems.

ICE, STUN, TURN

Skype did it decades ago with automatic super node promotion, but I have yet to find another messenger (or data sync or social networking service solution) that is capable of anything like that.
Everyone is lazy and just use ICE/TURN/STUN out of the box, but that is recentralizing everything yet again.

Yep, you could be lazy about implementing your messenger if you could outsource implementation of such difficult questions to underlying overlay networks like Tor, Yggdrasil, I2P, Freenet, GNUnet, ... but someone has to pay the piper in the end. I.e., someone will have to operate custom servers and take care of resilient bootstrapping (and/or check the boxes I came up with above)

The basic design flaw as noted is that the only way to reach users who are not publicly routable is through relays, and only a few nodes are TCP relays (optional setting) a lot like if it went over TURN. Rather, this should be the default (and detected during runtime even), and it should be modelled after ICE - select between STUN alternatives and only resort back to something like TURN if there is no solution otherwise. This would reduce the load on relays tenfold at least, but it was clearly not a priority for them.

I think solving store & forward in a decentralized system is best done through a friend-to-friend topology. I.e., not only your own devices store your messages, but also some owned by your circles. And having to run a separate 24/7 mailbox/relay hardware peripheral isn't going to cut it either (what about e-waste and wasting power - see why shared hosting is the best for the world)

It would be theoretically possible to implement push notifications in a decentralized way via F2F buffering and pushing.

## Friend-to-Friend topology

F2F was a big thing a few decades ago, but then somehow more trendy things came along. It's disturbing how various seemingly good solutions come and go like fashion items.

* https://en.wikipedia.org/wiki/Citizen_science
* https://en.wikipedia.org/wiki/Friend_to_friend
* https://pdos.csail.mit.edu/~jinyang/pub/iptps-f2f.pdf

F2F is not only beneficial for storage use cases. Consider that if you only ever link to your friends directly and you trust them, metadata collection (it terms of keeping logs or deleting expired or retracted messages according to gentleman's agreement) wouldn't be an issue at all.

* https://en.wikipedia.org/wiki/Gentlemen%27s_agreement

##

You can find WebRTC examples in a couple of lines for P2P voice calls (this is literally the most common example you can find on the net)

Minimalistic serverless communication apps are non-existent. The present solutions always use a supporting underlying network of dedicated servers that are pretty expensive to maintain, hence why 90% of the new alternatives that pop up always involve a cryptocurrency for monetization (and "direct" P2P isn't a thing either). What _would_ be possible however is to implement a hybrid P2P/F2F system where as much roles would be delegated to supernodes and friends as possible and the only remaining duty of the central server would be to sign new releases & the peer database pyramid before they get injected to the P2P storage network. I postulate that you could serve the whole world from even a VPS costing a few dollars (or a free PaaS even) if implemented right. That's something I haven't seen before

You can find WebRTC examples in a couple of lines for P2P voice calls (this is literally the most common example you can find on the net)

You must always add the complexity and its limitations of the underlying privacy network when discussing alternatives. E.g., IPFS doesn't even traverse the NAT...

I postulate, that it should be possible to implement a communication solution with a backend complexity less than 1kSLOC and frontend/mobile complexity also <1kSLOC that could have at least the most minimal set of features. If we aimed lower and tried to implement the absolute minimum (serverless support, buffering, voice calls), I think it would be a pretty low hanging fruit even as a hobby implementation.

##

Sending voice messages is a non-issue, and push-to-talk with a slight delay would also work, along with delayed screenshot slideshows (useful for presentations on conferences), but most solutions today don't focus on such use cases because they went out of fashion.

Do you also consider your friends as enemy or can you trust them enough to let them speak to you directly and forward for you? Is the system meant to support public discussions or only keeping in touch with ephemeral peers in private?

## vs self-hosted solutions

keeping a reputation and web of trust (if anonymous operation can be made opt-in).

But if you just look at the number of self-hosted instances around the world of various federated platforms (e.g., email, XMPP, The Fediverse, Matrix), you will notice that in practice, not enough volunteers self host to make this sustainable, because software are usually designed by sysadmins for sysadmins, and I don't think this as a good enough compromise from the standpoint of project management/community management.

I.e., the model of self-hosting usually only scales worldwide if everyone would be hosting for their friends, family and common interest circles, and that usually is at most 1000 users per operator. You can even make such an instance invite-only in this case. However, if you do the math, that would mean that we ought to see millions of instances around the world...

## Dat

Cabal also requires servers over the WAN (Dat)

* https://cabal.chat/faq.html

Discovery in the LAN might also work through multicast DNS:

* https://dat-ecosystem-archive.github.io/how-dat-works/#local-network-discovery
