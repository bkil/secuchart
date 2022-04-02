## IPFS

Bootstrapping is a critical problem with any similar project. IPFS ships with a hardcoded list of servers:

* https://docs.ipfs.io/how-to/modify-bootstrap-list/

They are probably financed and operated by the project owners. Such a VPS usually costs quite a lot of money, but I haven't checked the exact specs.

The documentation does list the IPv4 address of one node, but refers to most through a domain name. The (single) domain name is probably hardcoded in many places and they also have to pay for that and operate a name resolver as well, increasing the number of bottlenecks from 1 to 3: bootstrap.libp2p.io

Most of the world might have trouble reaching IPFS because it is not very good with traversing NAT:

* https://docs.ipfs.io/how-to/nat-configuration/

The workarounds might be good enough for those fortunate enough to be able to forward ports, but those could already just as well run a normal FTP/SFTP/Synching/rsync server for the same effort.

It probably solves various problems pretty well, like synchronization between your data centers or creating virtual clouds this way, but it is hardly what will solve the problem of decentralizing computation to the hardware of users if it gained worldwide traction.
