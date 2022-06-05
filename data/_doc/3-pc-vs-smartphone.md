# PC vs. smartphone threat level

## PC advantages

A PC is a platform where:

* you receive daily updates
* on which you can keep installing major OS releases (or different alternatives) for at least 15-20 years without the ongoing generosity of the manufacturer
* on which you have full control (i.e., are root), influencing on how your RAM, storage and other hardware is being utilized
* where only your imagination limits what you can or will install and not the battery longevity, data conservation or whether you have 8GB or 16GB storage
* where you only usually have software and hardware backdoors and trackers if you are threatened (vs. everyone in case of mobiles)
* of which a meaningful proportion of parts can be cheaply swapped out for fixes or when upgrading to improve its performance over time
* where supporting productivity is a default, not an extension (keyboard, pointing device and various connectors for peripheral and communication)

## Google Play

Drawbacks (compared to F-droid):

* censors (corporation only cares about profit or currying favour with the sitting government/potential profit)
* may allow for centralized operations/backdoors or listening in against targeted individuals (since the 90's if you are not from the US, your communication will be wiretapped whenever possible)
* single point of failure (can also be throttled or limited by country and/or in times of unrest)
* monopolizes advertising and some other services in your apps
* has a one-time developer registration fee
* tracks you as a developer and collect various data
* has built-in incentives and a legal framework that favors apps that are maintained by a single company, not one which can be collaboratively improved by many
* attempts to justify that trading in private data for free services is okay
* tracks you as a user through as many channels as possible (install, updates, sync, backup, notifications, network based location, misc, ...)

Google advantages:

* virus scanner

## Former mobile exploits

If you are using an out of date version of a mobile OS, because perhaps the vendor did not produce as update for you, you may still be affected by some of these.

### 2016 Surreptitious Sharing

This could also be interpreted as a flaw within each vulnerable application itself as well.

* https://threatpost.com/surreptitious-sharing-android-api-flaw-leaks-data-private-keys/117174/

> ‘Surreptitious Sharing’ Android API Flaw Leaks Data, Private Keys: vulnerability in messaging apps [using the API] like Skype and perhaps Signal, and Telegram, that could lead to privilege escalation and data loss, including private keys. The attackers were able to get Threema, and another encrypted messaging app, Signal, to share its database as an audio recording. The researchers claim they were able to retrieve the file, save it, and open it as a database file. The two claim Signal was vulnerable – chiefly because of the way it processed the file – and crashed for them on each start.

### 2017 Broadcom wifi over the air

* https://googleprojectzero.blogspot.com/2017/04/over-air-exploiting-broadcoms-wi-fi_11.html

> Over The Air: Exploiting Broadcom’s Wi-Fi Stack (Part 2)

* https://googleprojectzero.blogspot.com/2017/10/over-air-vol-2-pt-3-exploiting-wi-fi.html

> Over The Air - Vol. 2, Pt. 3: Exploiting The Wi-Fi Stack on Apple Devices
> In this blog post we’ll complete our goal of achieving remote kernel code execution on the iPhone 7, by means of Wi-Fi communication alone.
> Posted by Gal Beniamini, Project Zero

### 2022 UNISOC

* https://tenable.com/cve/CVE-2022-27250
* https://kryptowire.com/news/kryptowire-identifies-vulnerability-in-unisoc-chipset/

> Kryptowire Identifies Security and Privacy Vulnerability in Mobile Device Chipset from China [...] allows malicious actors to take control over user data and device functionality.

* https://research.checkpoint.com/2022/vulnerability-within-the-unisoc-baseband/
* https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-20210

> found a vulnerability which can be used to disrupt the device’s radio communication through a malformed packet.
