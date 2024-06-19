# Explanation of properties

## General guidelines

The summary of a cell should fit at most two lines in a full view. It should only contain links if no details text is present. Further information and links should be pushed off to the details field. This is so that the interactive region of toggling the details and activating a link do not overlap.

## Analysis

Textual review that can not be compared objectively through properties. Links to related technical articles.

## Summary

Highlight in a few words why it is interesting. Note that this should be our own phrasing for the purpose of consciously differentiating messenger items from each other. It is usually not a good choice to copy some generic advertising text or heading from the homepage of the messenger. Those both lacks context and usually uses wordy marketing & sales pitch language.

## Screenshots

List URLs in the details. We can generate a gallery widget from this in the future. See:

* #screenshots

## Android Google Play

Most mobile users will prefer to install through their app store included out of the box.

## Google Play version

This facilitates comparing Android API version support and approximate space usage of various messengers. It is only updated once every few months across the whole chart.

## Android F-droid/apk

* yes=f-droid.org
* partial=apk or separate repository has to be configured in the f-droid client

## F-droid version

See note at "Google Play version".

## Other mobile

Alternative phones like KaiStore, Blackberry, OpenStore, PureOS, Microsoft Store

## Other Android

Alternative app stores like Amazon Appstore, Huawei App Gallery, Samsung Galaxy Store, Opera Mobile Store, Aptoide, GetJar, Uptodown, Applivery

## Apple iOS

## Desktop

See:

* #pc-vs-smartphone

## Web

See:

* #e2ee-web-apps

## Languages

The higher the amount of people reachable the better.

* No=1 language,
* partial=2-3,
* yes=many global ones

## Protocol

List the canonical names of the protocols supported.
## Protocol open

* yes=can be implemented based on published detailed specification,
* no=no source published,
* partial=needs reverse engineering based on rough specification documents or free source code

## Server license

## Client license

## Register without app

Is there some alternative way to start using the service without installing an app? This may be achieved with or without another account through another established app, protocol or platform, such as through a web app, IRC, XMPP, Matrix, the Fediverse or email.

## Spell check

Grammar correction as you type, spelling suggestions, how many languages it covers. Whether it is using the OS default service or reimplements it in some way.

## Replies

* no=cite-only (or no cite at all),
* partial=jump to message and deduplicate content by message ID,
* yes=thread sidebar by conversation ID or references

## Group chat

Whether they are persistent between restarts, chat log, file transfer, inline images, offline messaging

## Voice calls

## Video calls

## Group calls

Audio, video

## Voice messages

Ideally push to talk, may be useful where voice call is not supported. Also voice notes

## Screen sharing

Whether multiple participants can share their screen or only one at a time.

## Audio filtering

Noise cancellation, gain control, voice activity detection

## File transfer

Retry, pause, resume, file size or type limit.

## Message formatting

Font size, bold, italic, underline, strike-through, list, blockquote, code, pre, colors, clickable link, table, subscript, superscript, line break, horizontal rule

## Emoticons in message

Deprecated. Please do not fill in this property for new messenger items. Work towards refactoring existing cells into the below new properties instead and then empty this cell. (Was: Compose, show)

## Unicode support

* yes=can both send & receive text containing any valid Unicode code point, usually via utf8mb4,
* partial=does not support 4-byte+ UTF-8, certain characters or combiners

## Emoji composer

* yes=rich dialog with search,
* partial=replaces a few emotes or aliases with Unicode before sending

## Emoji reception

* yes=color Unicode display of all, mention in details if animated,
* partial=monochromatic, only a subset or replaces received emoticons with pictures

## Sticker packs

Whether they are animated. Where is it stored, at each individual or is it available group-wide?

## Link preview

Unfurling: who downloads the page, the sender, the recipient or the server of one or the other

## Inline images

Supported image formats: png, jpeg, gif, webp, avif

## Inline videos

Supported video formats: mp4, webm, av1

## Polls

Multiple choice voting. How seamless is its integration to the client interface: is it more like a bot that you need to converse with or can you click on buttons.

## Reactions

* yes=Various emoji (mention if user submitted pictures or animation is also supported),
* partial=only upvoting

## Read public content without registering

Provides free tasting to look around before committing to install anything or having to remember another pair of credentials. See:

* #fediverse-matrix

## Multiple devices

If the same account can be used at the same time from multiple devices, syncing contacts, messages and notifications.

## Online account replica

If the user lost all of their devices, can they continue from where they left off after purchasing a new one and at most by typing in a password? Manually cloning the internal storage of the device externally every day and restoring it on a new one is expected to produce a similar result, except if the app locks itself down via DRM (hardware credential store, eSIM, serial number, etc.). Hence, concentrate on features of the messenger that makes full restoration possible without such external manual workarounds.

* yes=everything available in the cloud from any device,
* partial=not all of credentials, keys, profile, settings, contacts, conversations or attachments

## Multiple accounts

If you can stay logged in with multiple accounts on the same device and application without external isolation techniques. Notifications shouldn't interfere either.

## Application locking

Unlock the account or certain chats with a PIN code, passphrase or biometrics such as (fingerprints or facial likeness)

## Remote message removal

Also called redaction, retraction or deletion. Used if you sent the message to the wrong chat, to hide stale information or by moderators to hide spam from others so as few will have to read it as possible.

> Note: An adversary can always use the analog loophole of taking photographs of the display. Hence, we can assume that such a feature caters to cooperative peers.

## Remote message correction

Also called editing. The main use case is to fix typos or to better summarize stale information resulting from further discussion if later comments invalidate some of the former ones.

See the note at remote message removal.

## Message expiration

Also called retention time, disappearing/ephemeral/self-destructing messages. The main use case is to keep your chat log clean, to publish limited time offers or requests and to help maintain as few copies of sensitive information as possible on the long term.

See the note at remote message removal.

## Presence status

Whether it is supported and how many levels can be differentiated. A user may signal towards another whether they are online (available for chat) or offline (busy, away, do not disturb, hidden, stealth, custom status message).

Presence of another user may be shown within either direct messages or group chats.

## Presence not mandatory

If it has presence broadcasting, can you hide the fact that you are online from another user?

Tinfoil persona may consider it a threat to anonymity if one can log behavior patterns of another such as what time of day the user is connected to the network, travelling, attend classes or what custom messages they are using. They may correlate such activities across accounts.

A messenger may not allow the user to override presence, instead substituting it with recent activity based status detection. The messenger could independently provide for scheduled or bot based authorized message delivery delegation, so such an option may still provide for privacy advantages.

This can also provide for improvement to quality of life and work-life balance of a layperson. One could for example allocate 30 minutes of active chat time in front of their device when they initiate conversation and another 30 minutes where they switch their status to "do not disturb". The latter would provide an opportunity to reply to any new incoming message about topics being followed while signalling to all peers that they would prefer not to engage in further requests until the next working day.

## Typing indication

Whether sending and showing is supported. Mention in the explanation whether it can be disabled and its default state.

## Read receipts

Whether sending and showing is supported.

## Receipts not mandatory

* yes=they can be disabled, note default value and if there are any constraints

## Themes

Appearance, dark scheme, night mode, OLED, prefers contrast, reduced motion, color blind, custom base color, large fonts, visual style presets, automatic switching

* no=1,
* partial=2,
* yes=more

## Landing page

Introductory website maintained by vendor, may use SaaS subdomain, URL

## Manual

Knowledge base maintained by the vendor, user manual, tutorial, extensive FAQ, URL

## Vendor can't curate content

* no=vendor can influence who can access which content, censor, remove spam and vandalism

Otherwise users need to moderate their content themselves based on peer to peer power structures.

## Spam protection

If it gained worldwide adoption

## Account deactivation after device compromise

Solvable with centralized or federated servers or with revocation certificates in P2P.

## Account recovery after device compromise

Solvable with centralized or federated servers or with subkeys, revocation and secret sharing in P2P.

## CPU idle

* no=Proof of work,
* partial=sluggish due to idling too little in foreground or measurable amount of processing in background,
* yes=otherwise

## Power saving

Ensure that device wakes up as few times as possible, filters and batches events on the remote side, no sockets kept open indefinitely, delegated peer tracking

## Bandwidth frugal

Conservation by lazy loading, previews, adaptive detail, incremental sync, fewer round trips, tokenization, batching transfers to improve compression, tweaked key schedule, multicasting hubs

## Disallow screenshots

* partial=Only for yourself,
* yes=Ask peers to not take screenshots of message or conversation. Also called screen security

## Logo

Avatar, prefer FOSS, externally hosted, Wikimedia URL

## Threat model

* yes=maintainers have made the threat model accessible and/or obvious from its documentation and landing page

* #threat_model
* #security_guides

## End-to-end encryption

This is more important for closed or non-self hosted servers. See:

* #mls
* #public_room_e2ee

## E2EE keys shielded from operator

Regardless of this, certain OS vendors might also have access to your keys

## Deniability

Deny sending a message, repudiability

## Replay prevention

Of third party buffering nodes

## Downgrade resistance

Mitigation against downgrade attacks

## Contact list confidential

If the client never sends over its contact list to the server

## Metadata protection

## Perfect forward secrecy

## Security team

yes=regularly scanning for vulnerabilities proactively, found bugs inspected for security implications, partial=reported vulnerabilities promptly fixed and released

## Large bug bounty

## Reproducible builds

## Audits

## Usage without phone number

## Transparent financing

yes=it is clear how the project can operate indefinitely, no=we know nothing, partial=public statements were made but not convincing

## No-cost tier

## Payment choices

* yes=cryptocurrency or some other anonymous,
* partial=lots of inexpensive choices

## Active development

* yes=developer availability is not a bottleneck for progress,
* partial=occasional hobby development or basic maintenance work,
* no=no development or only ensuring it builds

## Multi-party development

* no=one-man show,
* yes=highest level contributors are exchangeable, equal drivers,
* partial=regular contributions from multiple people

## Isolated self-hosting

It can be deployed on-premise in a LAN without internet

## User can extend network with node

Improving the scaling of the system and communicate with anyone (i.e., if P2P or federated)

## Identity not controlled by vendor

Will the system still work if the developer goes bankrupt

## Open documentation

Copyleft, editable by users through a wiki or source code repository, URL

## Web forum

Publicly readable, URL

It is a web site (web page) accessible through the Internet using a web browser without having to install special software or register an account. Both potential and existing users can ask questions here about the item and answer topics of one another. It should have a search facility to find FAQ without having to ask the same things all over again. Web search engines and archives must be able to index it. This would provide a nudge to use the given system.

Common examples of backends include phpBB, FluxBB, Discourse, Friendica, Hubzilla, Lemmy, mailing lists, NNTP, CMS comment threads. Further CMS-based alternatives would be possible to implement.

You can access and search a mailing list archive from a web browser. Even netcat could suffice if the page is frugal, such as in case of Mailman 2. However, we can assume that a user will possess at least Netscape 2.0 or a gemiweb0 browser or implement it themselves if they want to read such web pages.

In contrast, a community group chat room accessible over the given messenger protocol, even if it provides for limited chat log, usually does not qualify as `Web forum`, but rather as a `Contact` method.

## Contact

URI including the scheme prefix, preferably of official group chat, such as matrix: acct: xmpp: msrp: news: mailto: irc: sip: mumble: ssh:

## Syndication

URL of RSS, Atom, twtxt or gemini text feed

## Offline

* no=Not useful if disconnected.
* partial=Only read a few buffered messages or compose new ones.
* yes=Reboot, add new contacts, past logs, search, cache list of groups or users, settings.

## Servers required

List all server software or instance by name that are mandatory to keep this network running or to host it in isolation

## Servers optional

List all server software or instance by name that can provide extra features when using this network

## Serverless WAN mode

If communicating over the internet might scale without (a vast amount of) dedicated servers, i.e. by supernode promotion and DHT. See:

* #wan_crowdsourcing

## Serverless LAN mode

If you can communicate without an internet connection and a server. See:

* #lan_messenger

## Network store and forward

You can compose messages to your peer even if the two of you aren't online at the same time

## Wireless mode

Built-in support for peering with nearby nodes over ISM wireless either to sync or as part of a mesh. See:

* #pan_mesh_dtn

## IP shielded from peers

See:

* #vpn

## Proxy support

HTTP, Tor, SOCKS5

## Third party clients

* yes=Multiple full featured clients available
* no=Terms of service prohibits access to vendor operated network

See:

* #third-party-clients

## Bots available

* no=banned,
* yes=several available possibly from a built-in gallery

## User addons

Apps, widgets, integrations by third party developers or users themselves

## Hosted bots and addons

Optionally provided so that a user need not maintain a separate server

## Tor access of vendor operated network

* yes=Without involving Tor exit nodes,
* no=Tor exit nodes blocked,
* partial=otherwise

See:

* #tor

## IPv6 access of vendor operated network

Still green if only registration is limited to IPv4

## Vendor operated network inaccessible from countries

If it is illegal or blocked here or if the vendor prohibits usage or its infrastructure blocks users from here. Encryption itself is outlawed in many countries, do not list these.

## Vendor legal entity kind

Individual, entrepreneur, non-profit company, single-person for-profit, multi-party for-profit

## Transparency reports

## Vendor jurisdiction

## Infrastructure jurisdiction

## Infrastructure provider

## Good ToSDR grade

* yes=A,B,
* partial=C,D,
* no=E,F

## Domain

Currently delegated to the vendor, signals sustainability and commitment, URL including protocol

## First release

* yes=mature, large masses have tested it for years,
* no=only released recently

## Public issue tracker

* yes=Whether outstanding bugs can be viewed by the public through a dedicated system.
* partial=approximated via forum

## Support team

yes=Dedicated, friendly, sufficient compared to user base

## No past DDoS

no=denial of service happened against vendor operated network

## No past client vulnerabilities

no=security exploits in client or server side

## No past server vulnerabilities

no=exploits in self-hostable server or data leaks by vendor

## No past financing hiccups

no=development can intermittently stop due to lack of funds

## Ethical financing in the past

no=tax evasion

## Ethical business in the past

no=anti-trust investigations, bribes, hurting customers in other way

## No past conflicts of interest

no=shady ownership changes, investor may benefit from breaching privacy or project failure

## No past privacy glitches

no=uncovered cases when vendor secretly exploited user data

## Server hosted until

date of vendor instance discontinuation

## Server development until

date of abandoning maintenance

## Client development until

date of abandoning maintenance

## Wikipedia

Passes notability, URL

## Wikidata

May not be reliable due to anonymous edits, URL
