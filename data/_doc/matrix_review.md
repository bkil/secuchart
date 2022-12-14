# Matrix

## Feature support of various clients

https://matrix.org/clients-matrix/

## E2EE in public rooms

This section was migrated to #public_room_e2ee

## Algorithms

* https://blog.jabberhead.tk/2019/03/10/a-look-at-matrix-orgs-olm-megolm-encryption-protocol/

* https://gitlab.matrix.org/matrix-org/olm/-/blob/2f23d9942402a8e250bb20bbf0dc81f6898e4e11/docs/megolm.md#user-content-partial-forward-secrecy

> Megolm group ratchet: Partial Forward Secrecy

* https://soundcloud.com/user-98066669/205-five-shows-in-one

> XMPP with OMEMO is similar to Matrix MEGOLM for E2EE

* https://matrix.org/faq/#why-are-large-public-rooms-like-matrixmatrixorg-not-encrypted

> Why are large public rooms not encrypted?

## Plans

We should not copy & paste each and every blog post they broadcast, but may want to link to things that are frequently asked.

* https://arewep2pyet.com/

> Are We P2P Yet?

## Opinions

* https://web.archive.org/web/20210804205638/https://serpentsec.1337.cx/matrix

> Matrix metadata leaks

* https://hackea.org/notas/matrix.html

> Matrix? No, thanks.

* https://github.com/libremonde-org/paper-research-privacy-matrix.org

> Privacy research on Matrix.org

* https://gist.github.com/maxidorius/5736fd09c9194b7a6dc03b6b8d7220d0

> Notes on privacy and data collection of Matrix.org

* https://gitlab.com/libremonde-org/papers/research/privacy-matrix.org

Reasoning Why Disroot went back to XMPP in 2018:

* https://disroot.org/en/blog/matrix-closure

> Matrix Closure

* https://anarc.at/blog/2022-06-17-matrix-notes/

> Matrix notes - anarcat

* https://www.aminda.eu/blog/english/2021/08/03/matrix-perfect-privacy-not.html#you-mentioned-privacy
* https://www.aminda.eu/blog/english/2021/12/05/matrix-community-abuse-security-by-obscurity.html
* https://www.aminda.eu/discuss.html#a-couple-of-words-on-protocols

> Aminda

### Novaburst

https://dimension.sh/~novaburst/ac3bf733.htm

> Matrix - The Mossad Facade that fooled the privacy community

Replies:

* 1/a & 4/a: It is "bloated" because their explicit goal was for Matrix to act as a sufficient intermediary protocol to bridge all other chat systems transparently, and you necessarily will need to provide a superset of their features. Certain parts of the S2S and C2S specs are clearly marked as optional with well defined return code for unsupported operations. Since Matrix started in 2014, XMPP actually picked up a few ideas from Matrix and other messengers on popular demand.
* 4/b: I would call Slack more of an inspiration for Matrix Element than Discord - the former was started 1 year before them, while the latter in the following year.
* 1/b: Anyone can contribute extensions via the spec proposal process https://github.com/matrix-org/matrix-spec-proposals/
* 1/c: Full and global defederation is not likely (it doesn't even have code to do this). Certain single rooms may choose to place a server ACL against you if you either produce spam or don't comply with authorization rules. If you have implemented an earlier room version vulnerable to certain abuse (e.g., v1) only your server would be in trouble so others wouldn't care anyway and only in the single room in question.
* 2/a: Yes. PRs welcome.
* 2/b: Dendrite and Conduit are already beta.
* 2/c: Not a supercomputer, actually. About 50GB of storage and ~4GB RAM should be sufficient for light use (according to the documentation, recommends 1GB RAM free other than what your database daemon uses). Its architecture is vastly different from XMPP or IRC that mainly act as a networking hub of connecting participants. It is more about event and state replication similar to git, Secure Scuttlebutt, RetroShare and the like.
* 3/a: You can find some not using JavaScript: https://matrix.org/clients
* 3/b: What do you call full featured? There exist a bunch of ones supporting E2EE already (what most consider as a landmark in compatibility)
* 3/c: Element Web works on Firefox for me, it was possibly some intermittent regression you've seen due to less testing done there. I think you won't find many realtime chat apps that don't require JavaScript (except for PoC). Not sure what "issue" you talk here that a fork could fix, though.
* 3/d: Other than bugs, the official Mobile client is actually considered practically full featured. I acknowledge it was not like that around the full rewrite last year or so. The faster you progress the more mistakes you will make - life is like that. And I hear good things about third party mobile clients as well.
* 5: Yes, it's always like that, see the user distribution on The Fediverse or Yarn. The more difficult a server is set up, the less of it you will see deployed, so there could be work done. But why would you want to ditch the kid with the bathwater instead of just putting in an effort? Quite a few HS had been deployed over the years, the-federation lists 1684 today, second only to "The" most hyped server ever: https://the-federation.info/#protocols
* https://matrix-org.github.io/synapse/latest/setup/installation.html#installing-as-a-python-module-from-pypi
* https://matrix-org.github.io/synapse/latest/usage/administration/admin_faq.html#help-synapse-is-slow-and-eats-all-my-ramcpu

## Deployment

* https://sifted.eu/articles/element-germany-deal/

> German states of Schleswig-Holstein and Hamburg deploy a Matrix-based solution for 500,000 users across public offices and education

* https://sifted.eu/articles/european-armies-matrix/

> Bundeswehr developed Bwmessenger, a chat service that’s built on Matrix’s software, and 50,000 from the force are now using the service.

* https://lukesmith.xyz/articles/matrix-vs-xmpp

> What are XMPP and Matrix and what makes them special?

* https://joinjabber.org/faqs/advanced/#faq-advanced-matrix

> XMPP vs. Matrix

* https://www.cr-online.de/blog/2022/06/02/ein-fehler-in-der-matrix/

> Ein Fehler in der Matrix (German lawyer regarding GDPR compliance)

## Protocol utilization

* https://github.com/opentower/populus-viewer

> Populus-Viewer is a tool for decentralized social annotation, built on pdfjs, wavesurfer.js and the Matrix protocol. You can use it to read PDFs, listen to audio, or watch videos, and have rich discussions in the margins, with your friends, classmates, or scholarly collaborators.

* https://gitlab.com/minestrix/minestrix-flutter
* https://gitlab.com/minestrix/minestrix-doc

> A privacy focused social media based on Matrix

* https://github.com/yousefED/matrix-crdt

> Matrix-CRDT enables you to use Matrix as a backend for distributed, real-time collaborative web applications that sync automatically. The MatrixProvider is a sync provider for Yjs, a proven, high performance CRDT implementation.

## History

2014-08-12 Synapse server v0.1 with integrated webclient (+48k SLOC imported from unknown source):

* https://github.com/matrix-org/synapse/commit/4f475c7697722e946e39e42f38f3dd03a95d8765
* https://github.com/matrix-org/synapse/tree/4f475c7697722e946e39e42f38f3dd03a95d8765/webclient
* https://github.com/matrix-org/syutil/commit/90500bfb6d7dbdd9f93ec1534cb129942f3ee749

It debuted with a `Twisted>=14.0.0` dependency that was released on 2014-05-12

* https://labs.twistedmatrix.com/2014/05/twisted-1400-released.html

2014-09-03 Public announcement:

* https://matrix.org/blog/2014/09/03/hello-world/

2014-09-30 Riot Android SDK:

* https://github.com/matrix-org/matrix-android-sdk/commit/18506e179e02925619bf86cc04fa1e8b392ee413

2015-06-02 Riot Android, probably forked from the Android SDK (+14k SLOC imported)

* https://github.com/vector-im/riot-android/commit/d8dde0c78b2a4dea1de61e9ee0e105d4f3ff9f58

2015-06-09 Riot Web (React JS SDK):

* https://github.com/vector-im/element-web/commit/c42733ec951e1492bec746ebf337d3ec5f538e8d

2016-06-09 Vector (Android)

* https://medium.com/@RiotChat/say-hello-to-vector-2d33b23a787

## Financing

2018-01-29 $5M investment by Jarrad Hope's Status:

* https://venturebeat.com/2018/01/29/status-invests-5-million-in-matrix-to-create-a-blockchain-messaging-superpower/

> to expand its team significantly over the course of 2018 and continue development of both the Matrix protocol and improving the Riot.im client
> create a bridge between Matrix and Whisper — Ethereum’s own real-time communication protocol — and allow Status dApps to be integrated as widgets within Riot.im. It also allows the Status Network token to be used, enabling cryptocurrency payment mechanisms in Riot.im.
> Status migrated its community from Slack to Riot.im last year,

2019-10-10 $8.5M investment by Notion Capital, Dawn Capital and European seed fund Firstminute Capital:

* https://web.archive.org/web/20210707191110/https://techcrunch.com/2019/10/10/new-vector-scores-8-5m-to-plug-more-users-into-its-open-decentralized-messaging-matrix/

> improving the user experience in Riot for the app to be, as Hodgson puts it, “properly mainstream” — aka: “a genuine alternative to WhatsApp and Slack for groups who need secure communication which is entirely within their control, rather than run by Facebook or Slack”.
> they’ll be turning on end-to-end encryption by default for all private conversations.
> building out their flagship Matrix hosting platform (Modular.im) and building it into Riot — “so that groups of users can easily hop onto their own self-sovereign servers”.
> they intend to work on combating abuse [...] the question of how you moderate hateful communications could easily get overlooked.

2020-05-21 $5M investment by Automattic (WordPress.com)

* https://matrix.org/blog/2020/05/21/welcoming-automattic-to-matrix/

> Automattic just opened up a role for a Matrix.org/WordPress Integrations Engineer
> we should expect to see Automattic’s communities migrating over to Matrix in the coming months
> Imagine if every WP site automatically came with its own Matrix room or community?
> Imagine if all content in WP automatically was published into Matrix as well as the Web?
> Imagine there was an excellent Matrix client available as a WordPress plugin for embedding realtime chat into your site?
> Imagine if Tumblr became decentralised!?

2021-07-27 $30M investment by Protocol Labs and Metaplanet (Jaan Tallinn of Skype and Kazaa):

* https://matrix.org/blog/2021/07/27/element-raises-30-m-to-boost-matrix/

> transforming the Element app
> finish building out P2P Matrix and get it live (including finishing Dendrite)
> implement native decentralised E2EE voip/video conferencing for Matrix
> fully build out our relative decentralised reputation system in order to combat abuse in Matrix.
> getting Spaces out of beta
> adding Threading to Element
> speeding up room joins over federation
> creating 'sync v3' to lazy-load all content and make the API super-snappy
> lots of little long-overdue fun bits and pieces (yes, custom emoji, we're looking at you).

Amount of cryptocurrency donations:

* https://blockchain.com/eth/address/0xA5f9a4f9E024F6D727f7afdA9257e22329A97485
* https://blockchain.com/btc/address/1LxowEgsquZ3UPZ68wHf8v2MDZw82dVmAE

Financial statements of company:

* https://find-and-update.company-information.service.gov.uk/company/10873661/filing-history
