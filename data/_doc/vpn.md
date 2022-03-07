# Using VPN services

You place ultimate trust in what a VPN provider says because there is no way to verify it, except after the fact if they were exploited. You can't influence whether they use encryption or turn off logging for example.

In case of going through a VPN, your ISP can still log the timing & size metadata (along with DNS, NTP and other leaking things if not set up correctly on any of your nodes), and then the ISP of the VPN can log (and MITM) everything that could have been logged in the first place.

At least with your own ISP, you have a signed contract and you kind of know who they are (usually a local company), whereas in case of a VPN provider, they are almost always the NSA.

## References

- http://tilde.club/wiki/vpnwhy.html

> DON’T USE VPN SERVICES. Why not?
> No, seriously, don’t. You’re probably reading this because you’ve asked what VPN service to use, and this is the answer.

- https://arstechnica.com/gadgets/2021/07/vpn-servers-seized-by-ukrainian-authorities-werent-encrypted/

> VPN servers seized by Ukrainian authorities weren’t encrypted
> On the disk of those two servers was an OpenVPN server certificate and its private key [...] the company also uses data compression to improve network performance. [...] an attack known as Voracle, [...] uses clues left behind in compression to decrypt data protected by OpenVPN-based VPNs

- https://www.vice.com/en/article/jg84yy/data-brokers-netflow-data-team-cymru

> How Data Brokers Sell Access to the Backbone of the Internet.
> ISPs are quietly distributing "netflow" data that can, among other things, trace traffic through VPNs.

- https://twitter.com/josephmenn/status/1437885720169836544

> The at least until recently CIO of big VPN ExpressVPN is one of the three former U.S. intelligence operatives who agreed today not to fight charges they illegally helped UAE hack people. Kind of makes you think.
