# Signal

## Access to contact list

* https://signal.org/blog/private-contact-discovery/

> Technology preview: Private contact discovery for Signal

It details two alternatives:

* a brute forceable truncated hash of the phone numbers and
* an SGX security enclave that places trust on the server hardware equipped with all kinds of backdoors.

* https://signal.org/blog/contact-discovery/

> The Difficulty Of Private Contact Discovery

From that overview of possible implementation alternatives, but somehow discounted encrypted bloom filters citing concerns about bandwidth costs.

However, that would have actually worked perfectly if they updated the set on demand when checking for a new contact number and/or if the database was synced P2P via WebRTC to reduce their bandwidth costs.
And also, as I think 99% of the users only have domestic contacts, sharding by region might actually work.
As such contact discovery can be pretty hard on the server side, federated servers would be great to have here as well.

Note that secure, zero-knowledge contact discovery can be an issue for any alternative system even if it used some other identifier, like an email address (or matrix ID, Friendica profile URL, etc.

Stepping back from a theoretically sound solution to one where you must trust a vendor that also happens to have a sketchy safety record is dubious at best.

## EU hardening guide

* https://twitter.com/CERTEU/status/1499389080387338241
* https://media.cert.europa.eu/static/WhitePapers/TLP-WHITE-CERT-EU_Security_Guidance-22-002_v1_0.pdf

## Server

### Missing source

The storage service and the key backup (which must be hosted in GCP) relies on CDN0 S3 (for uploads of user profile, group v2 avatar, attachment v2 with attributes, stickers) and CDN2 GCS (for uploads of attachments):

* https://github.com/signalapp/Signal-Android/blob/9d8e9a3a14015cc3fbded43e0cfb89af6614ba50/app/build.gradle#L207
* https://github.com/signalapp/Signal-Android/blob/4eddeb74c515453698dc3eebaf1ce512e9706e61/libsignal/service/src/main/java/org/whispersystems/signalservice/internal/push/PushServiceSocket.java#L851
* https://github.com/signalapp/Signal-Android/blob/4eddeb74c515453698dc3eebaf1ce512e9706e61/libsignal/service/src/main/java/org/whispersystems/signalservice/internal/push/PushServiceSocket.java#L1150
* https://github.com/signalapp/Signal-Android/blob/4eddeb74c515453698dc3eebaf1ce512e9706e61/libsignal/service/src/main/java/org/whispersystems/signalservice/internal/push/PushServiceSocket.java#L1164
* https://github.com/signalapp/Signal-Android/blob/4eddeb74c515453698dc3eebaf1ce512e9706e61/libsignal/service/src/main/java/org/whispersystems/signalservice/internal/push/PushServiceSocket.java#L716
* https://github.com/signalapp/Signal-Android/blob/4eddeb74c515453698dc3eebaf1ce512e9706e61/libsignal/service/src/main/java/org/whispersystems/signalservice/internal/push/PushServiceSocket.java#L1190

All components for abuse control:

* https://signal.org/blog/keeping-spam-off-signal/

SGX CDSI (the HSM CDSH development version does have source):

* https://github.com/signalapp/Signal-Android/blob/f63ed8f2698c05c4bb1465c01e0c79353835f6ac/app/src/main/java/org/thoughtcrime/securesms/contacts/sync/ContactDiscoveryRefreshV2.kt#L23
* https://github.com/signalapp/Signal-Android/blob/f63ed8f2698c05c4bb1465c01e0c79353835f6ac/libsignal/service/src/main/proto/CDSI.proto
* https://github.com/signalapp/HsmEnclave

Web service for handling pushing and serving updates.

Scripts and recipes for devops to deploy and monitor a node.

### Edge

Google CloudFunctions and Fastly CDN/DDoS:

* https://github.com/signalapp/Signal-Android/blob/f63ed8f2698c05c4bb1465c01e0c79353835f6ac/app/src/main/java/org/thoughtcrime/securesms/push/SignalServiceNetworkAccess.kt#L72

### AWS lambda

* https://github.com/signalapp/AccountStream

### Google reCAPTCHA

* https://reddit.com/r/StallmanWasRight/comments/fgb1rl/signal_private_messenger_is_using_google_recaptcha/
* https://community.signalusers.org/t/use-something-else-instead-of-google-recaptcha/6289/3
* https://github.com/signalapp/Signal-Android/issues/11053
* https://github.com/signalapp/Signal-Android/commit/02b0800b22e2faaa1f659d34ac3bb2f44eda3631

### Push notification

* https://www.documentcloud.org/documents/24191267-wyden_smartphone_push_notification_surveillance_letter_to_doj_-_signed
* https://9to5mac.com/2023/12/06/push-notification-spying/
* https://www.reuters.com/technology/cybersecurity/governments-spying-apple-google-users-through-push-notifications-us-senator-2023-12-06/
* https://community.signalusers.org/t/apple-reveals-push-notification-spying-by-foreign-governments/57550/15
* https://tuta.com/blog/open-source-email-fdroid

## Opinions

* https://web.archive.org/web/20230116181133/https://dt.gl/the-2022-review-of-messaging-service-providers-signal/
* https://freedombone.net/faq.html

> Why not use Signal for mobile chat?

* https://medium.com/@pepelephew/a-look-at-how-private-messengers-handle-key-changes-5fd4334b809a

> A look at how private messengers handle key changes

* https://tomsguide.com/news/signal-vs-telegram

> Signal vs. Telegram: Which encrypted messaging app wins?

## TLS proxy censorship issue

* https://godecrypt.com/news/security/signal-ignores-proxy-censorship-vulnerability-bans-researchers/
* https://reddit.com/r/cybersecurity/comments/leoz5m/signal_ignores_proxy_censorship_vulnerability/
* https://github.com/net4people/bbs/issues/60
