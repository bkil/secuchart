# TODO

`Tor network` is not made out of `thin air`

You don't `purchase internet (access) at home`, rather you lease a certain path towards reaching certain other servers.

If torproject went defunct tomorrow (or was just blocked), so much for your "serverless" network.

What liberty advocates really need to know is whether there are any intermediaries involved who we don't control on our communication path.

Tox is more decentralized than Briar. All nodes all full featured and you could preload peer lists into the installer. The fact that they aren't doing that properly right now (and keeping an updated list based on health & popularity) is more a shortcoming of their PM than it is of their protocol. They even mention this in their wiki.

And maybe my phrasing was not clear, but it does not **depend** on the preloaded peer list, it also takes advantage of it. It also support peer list exchange between peers (along with bootstrap servers as well similar to how most DHT solutions work).

DHT bootstrap nodes ("the servers") cache the node lists, not host them. In some of the networks, they also offer further services, like monitoring, health checks (as in Tor), abuse control, censorship or web of trust.

I haven't looked this up, but I think the above would itself still deserved some research - how peer lists could be "curated" and preloaded by some kind of mechanism that still ensured integrity and scalability within the network.

Do not discount the importance or complexity of the overlay routing network that you build on as a bottleneck.

You can scan a QR in Jami, Tox or RetroShare as well, and the invitation also usually includes the peer address, this is pretty standard I think.

## New project

You can actually have a sustainable P2P/F2F communication platform without relying on any kind of additional project or purpose specific server whose demise could lead to the downfall of the messenger in question. It is unfortunate that no such P2P messenger exists to this day, but it would actually be feasible if people really wanted it.

Usually yes. It can gather that either

* via multicast DNS within a LAN
* hypothetically via wireless
* peer exchange after hopping onto the network
* a persisted offline cache that the node itself has built up from its previous peer exchanges
* a possible public rendezvous host that is not a full blown complicated peer node itself but the only thing it can do is to facilitate exchanging such contacts (i.e., a mostly static web server with a few lines of PHP tops)
* and as a last resort, the preloaded list of IP's that the software comes with when you install it from your store of choice (or via Blueetooth from your peer in case of f-droid)

I have yet to see a messenger that puts all of the above to good use. Doing this is the minimal bar of effort that I count as doing as much as it can. And then we could do a lot of improvement about peer list curation as hinted at above..


By the way, a rendezvous server could and should actually be piggybacked onto some other popular available server, whatever is common within your community, you can call it a mailing list, forum, matrix chat, bulletin board, git repo, whatever you and at least some of your friends already have access to. Lacking that, you could sometimes even run a tiny dedicated server within some other system, as in:

https://gitlab.com/bkil/freedom-fighters/-/blob/master/hu/service/game-backend.md

You could substitute various preexisting technologies as a randezvous server, for example public DNS records is a common solution to this (or even free dynamic DNS) that is still not dependent on running anything special.

And solving this isn't rocket science again - Skype did it decades ago with automatic super node promotion, but I have yet to find another messenger (or data sync or social networking service solution) that is capable of anything like that.
Everyone is lazy and just use ICE/TURN/STUN out of the box, but that is recentralizing everything yet again. 😥

Basically what would be a big win if the application was continuously updated within its distribution media (either daily within the app market or possibly minute by minute if you download the package from own web site or repository). I mean, it's just a CSV that needs to be updated (and resigned) within the bundle. For example, as the package for pybitmessages hasn't seen an update since 2018 (and most similar apps are rarely updated more than once every few months and usually manually), such a dynamic list would not work except for listing the mostly-on nodes possibly added manually (that incidentally Tox is also doing, but they admit that it's not enoguh). CI/CD has been a thing for decades now, so it's kind of appalling to see that few FOSS projects are doing it to this day.

By the way, if you use an ISP-optimized scanning strategy and if enough people deployed this solution, that could sort of work. I.e., many ISP's already assign IP ranges in kind of cartographic locality, so it would even provide low latency paths automatically if you scanned in increasing distance from your own WAN IP (and/or its "aliases" over the virtual allocation range). This would of course only work if let's say 1% of the population would have it installed.



Yep, you could be lazy about implementing your messenger if you could outsource implementation of such difficult questions to underlying overlay networks like Tor, Yggdrasil, I2P, Freenet, GNUnet, ... but someone has to pay the piper in the end. I.e., someone will have to operate custom servers and take care of resilient bootstrapping (and/or check the boxes I came up with above)

The basic design flaw as noted is that the only way to reach users who are not publicly routable is through relays, and only a few nodes are TCP relays (optional setting) a lot like if it went over TURN. Rather, this should be the default (and detected during runtime even), and it should be modelled after ICE - select between STUN alternatives and only resort back to something like TURN if there is no solution otherwise. This would reduce the load on relays tenfold at least, but it was clearly not a priority for them.

I think solving store & forward in a decentralized system is best done through a friend-to-friend topology. I.e., not only your own devices store your messages, but also some owned by your circles. And having to run a separate 24/7 mailbox/relay hardware peripheral isn't going to cut it either (what about e-waste and wasting power - see why shared hosting is the best for the world)



##

You can find WebRTC examples in a couple of lines for P2P voice calls (this is literally the most common example you can find on the net) I have outlined solutions that would be much better some weeks ago.


Minimalistic serverless communication apps are non-existent. The present solutions always use a supporting underlying network of dedicated servers that are pretty expensive to maintain, hence why 90% of the new alternatives that pop up always involve a cryptocurrency for monetization (and "direct" P2P isn't a thing either). What _would_ be possible however is to implement an hybrid P2P/F2F system where as much roles would be delegated to supernodes and friends as possible and the only remaining duty of the central server would be to sign new releases & the peer database pyramid before they get injected to the P2P storage network. I postulate that you could serve the whole world from even a VPS costing a few dollars (or a free PaaS even) if implemented right. That's something I haven't seen before

You can find WebRTC examples in a couple of lines for P2P voice calls (this is literally the most common example you can find on the net)

You must always add the complexity and its limitations of the underlying privacy network when discussing alternatives. E.g., IPFS doesn't even traverse the NAT...

I postulate, that it should be possible to implement a communication solution with a backend complexity less than 1kSLOC and frontend/mobile complexity also <1kSLOC that could have at least the most minimal set of features. If we aimed lower and tried to implement the absolute minimum (serverless support, buffering, voice calls), I think it would be a pretty low hanging fruit even as a hobby implementation.

##

Note that in the framework of WebRTC/ICE, STUN & TURN are used together, because STUN itself can only connect a subset of nodes (like 90% or something, but much lower ratio among mobiles). And bandwidth (CPU?) costs at TURN relays can be quite significant, hence why it is a central point of failure.

But a nothing would keep a hypothetical real P2P network from building up a spanning tree via F2F to forward packets and distribute routes among volunteers and/or establishable pairs, but nobody bothered to set that up as of now. And STUN/TURN is kind of an anonymous, stateless service. With global deployment, it needs either funding, or credentials to access it and/or F2F authorization. It also requires an independent signalling path via which you forward peer invites, and that is also usually some kind of central server on presently implemented systems.

Some of the overlay routing networks provide too low bandwidth, too high latency, setup latency or regular circuit switching to be comfortable for live voice & video calling and many use cases for screen sharing. Sending voice messages is a non-issue, and push-to-talk with a slight delay would also work, along with delayed screenshot slideshows (useful for presentations on conferences), but most solutions today don't focus on such use cases because they went out of fashion.

Do you also consider your friends as enemy or can you trust them enough to let them speak to you directly and forward for you? Is the system meant to support public discussions or only keeping in touch with ephemeral peers in private?

## vs self-hosted solutions

keeping a reputation and web of trust (if anonymous operation can be made opt-in).

But if you just look at the number of self-hosted instances around the world of various federated platforms (e.g., email, XMPP, The Fediverse, Matrix), you will notice that in practice, not many really self host to make this sustainable, because software are usually designed by sysadmins for sysadmins, and I don't think this as a good enough compromise from the standpoint of project management/community management.

I.e., the model of self-hosting usually only scales worldwide if everyone would be hosting for their friend, family and common interest circles, and that usually is at most 1000 users per operator. You can even make such an instance invite-only in this case. However, if you do the math, that would mean that we ought to see millions of instances around the world....

Actually, F2F was a big thing back a few decades ago, but then somehow more trendy things came along. It's disturbing how various seemingly good solutions come and go like fashion items 😱

* https://en.wikipedia.org/wiki/Citizen_science
* https://en.wikipedia.org/wiki/Friend_to_friend
* https://pdos.csail.mit.edu/~jinyang/pub/iptps-f2f.pdf

F2F is not only beneficial for storage use cases. Consider that if you only ever link to your friends directly and you trust them, metadata collection (it terms of keeping logs or deleting expired or retracted messages according to gentleman's agreement) wouldn't be an issue at all.

* https://en.wikipedia.org/wiki/Gentlemen%27s_agreement

## Push notifications

It would be possible to implement it in a decentralized way via F2F buffering and pushing, but I have never seen this implemented as of now.

## Dat

Cabal also requires servers over the WAN (Dat)

* https://cabal.chat/faq.html

Discovery in the LAN might also work through multicast DNS:

* https://dat-ecosystem-archive.github.io/how-dat-works/#local-network-discovery
