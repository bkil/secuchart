# Using VPN services

## Advantages

* If you or someone within your friends, family and special interest trust circle hosts it
* If you can't control or know the first hop in any way (e.g., free public wifi)
* If your ISP does not grant you a dynamically changing IP address
* Your coarse location can be kept confidential: the same could be achieved via routing shady sites over cellular broadband.
* If your ISP (or country) blocks accessing a certain site
* If a certain site blocks your ISP (or country)

## Disadvantages

It is possible to detect and block Tor/VPN users either by the target website or the ISP.

If you intersperse your clearnet vs. Tor/VPN access patterns, one with a bird's eye view can actually correlate it pretty easily (i.e., state actors and funded malicious organizations). If you are using certain sites for longer stretches or even register on some, this can even be achieved purely with local inference.

You place ultimate trust in what a VPN provider says because there is no way to verify it, except after the fact if they were exploited. You can't influence whether they use encryption or turn off logging for example.

In case of going through a VPN, your local ISP can still log the timing & size metadata of packets (along with DNS, NTP and other leaking things if not set up correctly on any of your nodes). The ISP of the VPN provider can also log (and MITM) everything that could have been logged in the first place.

At least with your local ISP, you have a signed contract and you kind of know who they are (usually a local company), whereas in case of a VPN provider, they are almost always the NSA. You also support the local economy by using local services instead of foreign ones.

## References

- http://tilde.club/wiki/vpnwhy.html

> DON'T USE VPN SERVICES. Why not?
> No, seriously, don't. You're probably reading this because you've asked what VPN service to use, and this is the answer.

- https://arstechnica.com/gadgets/2021/07/vpn-servers-seized-by-ukrainian-authorities-werent-encrypted/

> VPN servers seized by Ukrainian authorities weren't encrypted
> On the disk of those two servers was an OpenVPN server certificate and its private key [...] the company also uses data compression to improve network performance. [...] an attack known as Voracle, [...] uses clues left behind in compression to decrypt data protected by OpenVPN-based VPNs

- https://vice.com/en/article/jg84yy/data-brokers-netflow-data-team-cymru

> How Data Brokers Sell Access to the Backbone of the Internet.
> ISPs are quietly distributing "netflow" data that can, among other things, trace traffic through VPNs.

- https://twitter.com/josephmenn/status/1437885720169836544

> The at least until recently CIO of big VPN ExpressVPN is one of the three former U.S. intelligence operatives who agreed today not to fight charges they illegally helped UAE hack people. Kind of makes you think.

- https://techradar.com/news/new-research-reveals-surfshark-turbovpn-vyprvpn-are-installing-risky-root-certificates

> New research reveals Surfshark, TurboVPN, VyprVPN are installing risky root certificates - TechRadar
> Security design flaw paves the way for surveillance or man-in-the-middle attacks
