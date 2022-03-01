# Client communication without mandated custom intermediaries

Keywords (imprecise buzzwords): serverless, P2P, decentralized, distributed.

This is a mistake that many make. `Tor network` is not made out of `thin air`, similarly how you don't `purchase internet (access) at home`, you lease a certain path towards reaching certain other servers.. If torproject went defunct tomorrow (or was just blocked), so much for your "serverless" network. `Serverless WAN mode` may be also a confusing property key that we might want to change. Surely being a `server` vs. `client` is just an implementation details that is only interesting for developers. What liberty advocates really need to know is whether there are any intermediaries involved who we don't control on our communication path.

Tox is more decentralized than Briar. All nodes all full featured and you could preload peer lists into the installer. The fact that they aren't doing that properly right now (and keeping an updated list based on health & popularity) is more a shortcoming of their PM than it is of their protocol. They even mention this in their wiki.

I.e., as I mentioned already here (and also in the table I think), you can actually have a sustainable P2P/F2F communication platform without relying on any kind of additional, project or purpose specific server whose demise could lead to the downfall of the messenger in question. It is unfortunate that no such P2P messenger exists to this day, but it would actually be feasible if people really wanted it (but they clearly don't )


I haven't looked this up, but I think the above would itself still deserved some research - how peer ilsts could be "curated" and preloaded by some kind of mechanism that still ensured integrity and scalability within the network.


By the way, After reviewing so many messengers, I have yet to encounter a single one that did not discount the importance or complexity of such bottleneck with a little hand waving. Heck, I've even seen one where they didn't even bother to mention this part of their protocol at all! (Probably raising too many questions which are not comfortable to answer)

You can scan a QR in Jami, Tox or RetroShare as well, and the invitation also usually includes the peer address, this is pretty standard I think.

And maybe my phrasing was not clear, but it does not **depend** on the preloaded peer list, it also takes advantage of it. It also support peer list exchange between peers (along with bootstrap servers as well similar to how most DHT solutions work).

DHT bootstrap nodes ("the servers") cache the node lists, not host them. In some of the networks, they also offer further services, like monitoring, health checks (as in Tor), abuse control, censorship or web of trust.



Usually yes. It can gather that either
- via multicast DNS within a LAN
- hypothetically via wireless
- peer exchange after hopping onto the network
- a persisted offline cache that the node itself has built up from its previous peer exchanges
- a possible public rendezvous host that is not a full blown complicated peer node itself but the only thing it can do is to facilitate exchanging such contacts (i.e., a mostly static web server with a few lines of PHP tops)
- and as a last resort, the preloaded list of IP's that the software comes with when you install it from your store of choice (or via Blueetooth from your peer in case of f-droid)

I have yet to see a messenger that puts all of the above to good use. Doing this is the minimal bar of effort that I count as doing as much as it can. And then we could do a lot of improvement about peer list curation as hinted at above..


By the way, a rendezvous server could and should actually be piggybacked onto some other popular available server, whatever is common within your community, you can call it a mailing list, forum, matrix chat, bulletin board, git repo, whatever you and at least some of your friends already have access to. Lacking that, you could sometimes even run a tiny dedicated server within some other system, as in:

https://gitlab.com/bkil/freedom-fighters/-/blob/master/hu/service/game-backend.md

You could substitute various preexisting technologies as a randezvous server, for example public DNS records is a common solution to this (or even free dynamic DNS) that is still not dependent on running anything special.

However, anything IPFS-based has the exact same problem with bootstrapping that has not been solved successfully before by anyone. At least compared to Tor, Dat has multicast DNS LAN peer discovery support, but that's just ticking one box instead of another. I have yet to see any implementation that ticks all of these.

IPFS also ships with a hardcoded list of servers:

https://docs.ipfs.io/how-to/modify-bootstrap-list/

Probably financed and operated by the project owners on VPS that cost a lot of money (haven't checked)
Oh, they also pay for a domain name and operate a name resolver as well, increasing the number of bottlenecks from 1 to 3: bootstrap.libp2p.io
Hm. The doc does list one IPv4 one as well, though.
Did you know that most of the world can not use IPFS because it is not capable of traversing NAT?

https://docs.ipfs.io/how-to/nat-configuration/

I mean sure, it has workarounds for those fortunate enough to forward ports, but those could already just as well run an FTP/SFTP/rsync server for the same effort, so I'm hard pressed to find it amusing. 🙁
It probably solves various problems pretty well, like synchronization between your data centers or creating virtual clouds this way, but it is hardly what will solve the problem of decentralizing computation to the hardware of users if it gained worldwide traction.
And solving this isn't rocket science again - Skype did it decades ago with automatic super node promotion, but I have yet to find another messenger (or data sync or social networking service solution) that is capable of anything like that.
Everyone is lazy and just use ICE/TURN/STUN out of the box, but that is recentralizing everything yet again. 😥


Basically what would be a big win if the application was continuously updated within its distribution media (either daily within the app market or possibly minute by minute if you download the package from own web site or repository). I mean, it's just a CSV that needs to be updated (and resigned) within the bundle. For example, as the package for pybitmessages hasn't seen an update since 2018 (and most similar apps are rarely updated more than once every few months and usually manually), such a dynamic list would not work except for listing the mostly-on nodes possibly added manually (that incidentally Tox is also doing, but they admit that it's not enoguh). CI/CD has been a thing for decades now, so it's kind of appalling to see that few FOSS projects are doing it to this day.

By the way, if you use an ISP-optimized scanning strategy and if enough people deployed this solution, that could sort of work. I.e., many ISP's already assign IP ranges in kind of cartographic locality, so it would even provide low latency paths automatically if you scanned in increasing distance from your own WAN IP (and/or its "aliases" over the virtual allocation range). This would of course only work if let's say 1% of the population would have it installed.



Yep, you could be lazy about implementing your messenger if you could outsource implementation of such difficult questions to underlying overlay networks like Tor, Yggdrasil, I2P, Freenet, GNUnet, ... but someone has to pay the piper in the end. I.e., someone will have to operate custom servers and take care of resilient bootstrapping (and/or check the boxes I came up with above)

The basic design flaw as noted is that the only way to reach users who are not publicly routable is through relays, and only a few nodes are TCP relays (optional setting) a lot like if it went over TURN. Rather, this should be the default (and detected during runtime even), and it should be modelled after ICE - select between STUN alternatives and only resort back to something like TURN if there is no solution otherwise. This would reduce the load on relays tenfold at least, but it was clearly not a priority for them.

I think solving store & forward in a decentralized system is best done through a friend-to-friend topology. I.e., not only your own devices store your messages, but also some owned by your circles. And having to run a separate 24/7 mailbox/relay hardware peripheral isn't going to cut it either (what about e-waste and wasting power - see why shared hosting is the best for the world)

## Push notifications

It would be possible to implement it in a decentralized way via F2F buffering and pushing, but I have never seen this implemented as of now.

## Dat

Cabal also requires servers over the WAN (Dat)
- https://cabal.chat/faq.html

Discovery in the LAN might work through multicast DNS, though:
- https://dat-ecosystem-archive.github.io/how-dat-works/#local-network-discovery

