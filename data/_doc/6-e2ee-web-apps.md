# E2EE security guarantees of web apps vs. desktop apps

## WIP

> Beware that this whole article is work in progress with parts missing, parts needing rewording and parts needing integration from uncommitted local changes!

## Encrypted mailbox providers

A disclaimer is justified for so called "encrypted mailbox providers" in general. Emails are routed basically as clear text around the world and can also be assumed to be stored as such on most nodes. It does not enhance your privacy guarantees sufficiently if the online mailbox provider promises to encrypt individual emails before storing them. Such providers have confessed to opting to deactivate their protections multiple times in the past.

## Failure to generalize

Various articles attempt to generalize this claim and phrase it as if web browser based applications lacked certain security guarantees or as if theoretical basis precluded us from developing secure web apps. Let's try to investigate these claims in detail.

* https://artemislena.eu/posts/2020/12/dont-use-webapps.html

> Do not use webapps in zero-trust designs

* https://github.com/privacyguides/privacyguides.org/pull/1052
* https://github.com/privacyguides/privacyguides.org/pull/1342

## Stealthily switching the frontend

Let's assume that all else is equal: both the desktop app and the web app are FOSS.

A common claim is that the vendor could alter the code for the interface any day without the user having control or even noticing.

## App distribution platforms

It is commonly mentioned that installing software from reputable third party distribution channels independent from the software vendor should guarantee accountability. Examples include the package manager of the Linux distribution or the Windows Store.

Web app distribution platforms also exist of equivalent functionality, such as the Chrome browser market, typically promoted for web extensions or userscripts.

## Vendor hosted software

In certain cases, people install apps from software repositories controlled by the software vendor or a party not affiliated with the OS vendor, such as:

* self-hosted F-droid repository
* external Debian APT repository
* PPA
* OBS
* third party Docker registry
* AppImages
* Flatpak repositories
* GitLab/GitHub releases
* git repositories of submodules
* other self-updating executables downloaded from a website or piped via `curl|bash`
* Hosting a web app from a domain controlled by the vendor

The security guarantees are all similar in the above cases. In an arrangement so called "TOFU" (trust on first use), the user verifies the fingerprint of the repository, website or the initial download and does a cross check on it to make sure it is authentic. Afterwards, assuming it is a FOSS reproducible build and has been reviewed, certain blatant intentional backdoors could be dismissed, assuming the check of signatures is implemented properly during updating.

### Bait and switch

An automated mechanism set up on our device usually checks for and installs software updates found in the vendor repository, especially if it is marked as a security fix. Such checks may happen daily.

The vendor has in most of these cases a means to provide packages with different content to certain targeted subsets of users in a "bait and switch" scheme and possibly switch it back afterwards before detection.

This would apply to any platform, including web, desktop and native mobile apps that support daily updating through its own servers or stores.

### Desktop app trust

When inspecting onboarding workflows at a big tech company in the knows, I have seen how many third party (mostly FOSS) stuff one needs to install on a Windows or Apple computer by hand by visiting dozens of websites, clicking download, install, next, next... This includes Homebrew, but most things were not available from there. Assume a dozen other things were needed as well as a daily driver. This was part of an initial setup process of individuals entrusted with management of their gear. On Linux set up just for secretaries without admin privileges, the sysadmin would surely just clone an image on all hardware and be done with it.

As you visit these dozens of websites to download your installers, you are initiating TOFU (trust on first use). It assumes the same level of trust as installing ("visiting") a modern web app built on a Service Worker from the same domain. The alternative to TOFU would be to meet the developer in person or exchanged a business card containing a QR code with their certificate.

* https://en.wikipedia.org/wiki/Trust_on_first_use

Incidentally, I have seen another company where these exact same installers were already downloaded by an sysadmin and supplied over a local network share. However, it provides little help

* if it's not FOSS,
* if the admins didn't build the installers themselves,
* if they haven't reverse engineered the executables,
* if they can't control or redirect automatic updating to their own builds.

With most Linux distributions, if you aren't looking for some very specialized tool or a trunk version of something, you could get away with just installing everything from the official package manager. This places all trust on your distribution, so it is a different scenario, but not all people have this luxury depending on their occupation.

## HTML email

HTML markup in email is severely restricted since the last decades. They can't run JavaScript. It can't even apply most parts of HTML or CSS freely either, but only a strict subset that varies by client.

* https://www.caniemail.com/

## Solutions

* https://cronokirby.com/posts/2021/06/e2e_in_the_browser/#pinned-versions

They mention some simple workarounds except Service Workers.

It is possible to implement a FOSS webapp which

* a foreign actor can host for you,
* you TOFU them (as you would anyway if you downloaded something from them)
* you could even record the HAR log in network inspector and double check the signature with the business card or an audited CSV within your company
* the app could not be altered in unsafe ways without you noticing or consenting any time in the future (automatically from now on)

A webapp can be implemented in a way so as that the offline part (for example, within a Service Worker) is only ran once, and only pulls in additional resources using SRI or after checking their cryptographic signature (in case of updates). This places trust equivalent to installing a desktop software package from the website of a vendor. The same could have been implemented in various other (more twisted) ways even decades ago, but I better not go into that here.

Web (-Browser based) Apps, especially if FOSS and engineered from the grounds up for offline use via Service Workers, are for most intents and purposes isomorphic to non-browser based apps. It's just another containerization technology and runtime.

It is equivalent to saying that the software vendor of the mobile app or desktop app is untrusted in the exactly same way, along with its update mechanism.

At the same time, nothing keeps you from self-hosting the web apps you use either on a trusted server or even on localhost and review all code changes before running them.

It is unfortunate that very few good and complicated webapps are FOSS or support separation of frontend & backend properly. Being able to self-host Element Web while using an outside Synapse is a rare pattern.

## Vulnerabilities

Programming errors occur frequently in native apps as well (be it email or other messengers) - it is not tied to E2EE web apps. I.e., RetroShare also had a critical remote code execution just recently and it is written in C++ (a language with manual memory management), not JavaScript.

* https://www.theregister.com/2022/05/23/npm_dependencies_vulnerable/
* https://dev.to/andyrichardsonn/how-i-exploited-npm-downloads-and-why-you-shouldn-t-trust-them-4bme
* https://www.bleepingcomputer.com/news/security/npm-supply-chain-attack-impacts-hundreds-of-websites-and-apps/

### Protonmail XSS

* https://medium.com/@ChandSingh/protonmail-xss-stored-b733031ac3b5

> Compose a email to any protonmaail user with Subject:

```
#">&lt;img src=x onerror=prompt(1);&gt;
```

> Send email to victim

* https://www.secu.ninja/2018/12/04/how-to-accidentally-find-a-xss-in-protonmail-ios-app/

> How to accidentally find a XSS in ProtonMail iOS app

```
$body = "&lt;html&gt;&lt;head&gt;"
$body += "&lt;title&gt;test&lt;/title&gt;&lt;/head&gt;"
$body += "test`"&gt;`'&gt;&lt;i&gt;I&lt;/script&gt;&lt;script&gt;alert(1)&lt;/script&gt;testscript&lt;/i&gt;"
$body += "&lt;/body&gt;&lt;/html&gt;"`
```

And neither one was HTML email - they were just plain text!

* https://www.theregister.com/2014/07/07/protonmail_fail_javascript/

> Vid shows how to easily hack 'anti-spy' webmail (sorry, ProtonMail)
> Filtering evil JavaScript is tricky if you're encrypting in the browser
