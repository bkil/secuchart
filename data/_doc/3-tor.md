# Tor

## Intermediaries

How decentralized is Tor? Is it serverless? Can it continue to operate when its principal vendor loses interest? Can it stay operational without any financing at all?

If you use Tor or an app uses it under the hood, it first connects to 10 servers called "Directory authority nodes" to get a node list. Their IP address are hard coded in the application. They are probably ran by the Tor Foundation.

It then discovers the address of relay servers operated by select volunteers from the public Tor directory and attempts to connect to some of those.

If you are using proxies or bridges, you are using even more intermediate servers:

* the WebRTC Snowflake also needs a central tracker,
* domain fronting additionally relies on Azure CDN and DNS
* more intermediaries may be involved

If your destination lies outside the Tor network, you will also have to discover and utilize exit relays.

The general latency, low offered bandwidth and the constant changing of the network topology also makes supporting voice/video calls unfeasible.

## Topology

The directory authority nodes can be interpreted to form a centralized high-availability core.

Tor relays and exit nodes can be interpreted to be forming a closed internal federation whose services can be utilized without registration. The admittance of their operators is subject to undisclosed criteria of curation by the foundation and automated monitoring.

Not all nodes are equally privileged. Your messenger is only a Tor client, while volunteers or funding is needed to run Tor relays (and other Tor servers) around the globe to keep it running. This separation precludes automatic scaling of the system by growing capacity along with an increasing user base of the client.

Let's trivialize the traffic flowing towards the directory servers. The traffic volume flowing towards the few relays and exits is huge and is amplified sixfold by forming circuits. This means that there exist built-in limiting cost centers - bandwidth choke points not correlated with how many people install the messenger clients themselves.

## Attacks

* https://blog.malwarebytes.com/reports/2021/12/was-threat-actor-kax17-de-anonymizing-the-tor-network/

> Was threat actor KAX17 de-anonymizing the Tor network?

* https://github.com/Attacks-on-Tor/Attacks-on-Tor

> Thirteen Years of Tor Attacks

## References

* https://en.wikipedia.org/wiki/Tor_network#Consensus_blocking
* https://community.torproject.org/relay/types-of-relays/
* https://tb-manual.torproject.org/circumvention/
* https://blog.torproject.org/domain-fronting-critical-open-web/
* https://gitlab.torproject.org/legacy/trac/-/wikis/doc/meek
* https://www.bamsoftware.com/papers/fronting/
* https://wiki.malloc.dog/posts/domain-fronting/
