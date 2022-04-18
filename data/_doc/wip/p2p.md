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

##

You could be lazy about implementing your messenger if you could outsource implementation of such difficult questions to underlying overlay networks like Tor, Yggdrasil, I2P, Freenet, GNUnet, ... but someone has to pay the piper in the end. I.e., someone will have to operate custom servers and take care of resilient bootstrapping (and/or check the boxes I came up with above)

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
