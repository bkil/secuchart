# SecuChart: Comprehensive and interactive software comparison

## Framework

* Evaluate the quality of
* a certain number of items
* based on a certain number of properties
* and share the reasoning

## SecuChart interactive messenger comparison

* Which messenger is the best for your security and privacy?
* Depends on your threat model and use case
* Decouple objective truth from value judgment ("goodness")

## Persona identified so far

## Possible future persona

## Licensing

* Import referenced data from Wikipedia
* Goal: generate table views for Wikipedia

## Competition: types

* Marketing material for a new application
* Tinfoil hobby groups

## Competition takeaway: mobile friendliness

* Almost none of them are mobile friendly as-is
* Top and left side headers are usually not sticky
* Fonts are tiny
* Parts of the table can be chopped off
* Cell size varies a lot depending on explanation

## Competition: takeaways

* Wouldn't be usable even on desktop computers if scaled up to include all major messenger choices
* Sometimes the scrollbar is hidden
* Usually compare a small number of messengers and tweak the layout to that (e.g., Full HD or greater)
* References are never linked for each cell
* Reasoning of colorization is not transparent
* Doesn't run without JavaScript, images, external fonts
* Explanation and references are sometimes present in the footer, but usually not clickable in place

## Competition: IM, DSNS, VoIP, messaging on Wikipedia

https://en.wikipedia.org/wiki/Comparison_of_cross-platform_instant_messaging_clients

https://en.wikipedia.org/wiki/Comparison_of_software_and_protocols_for_distributed_social_networking

https://en.wikipedia.org/wiki/Comparison_of_instant_messaging_protocols

https://en.wikipedia.org/wiki/Comparison_of_VoIP_software

https://en.wikipedia.org/wiki/Comparison_of_user_features_of_messaging_platforms

## Competition: Wikipedia takeaway

* Tries to split the comparison to separate articles and even subtables by aspects
* Reviews random subsets of messengers and properties in each table according to popularity at time of creation
* Some of the tables aren't comfortable even in Full HD
* The top headers might be set to sticky if logging in with an account (in theory)

## Competition: SecureMessagingApps.com

https://securemessagingapps.com/

## Competition: Messenger-Matrix

English:

https://messenger-matrix.de/messenger-matrix-en.html

German:

https://messenger-matrix.de/messenger-matrix.html

## Competition: SecureChatGuide

https://securechatguide.org/featuresmatrix.html

## Competition: docs

https://docs.google.com/spreadsheets/d/1-UlA4-tslROBDS9IqHalWVztqZo7uxlCeKPQ-8uoFOU/htmlview

https://github.com/dessalines/Messaging-Services-Comparison

https://gitlab.com/dessalines/Messaging-Services-Comparison

## Competition: Berty advertising FAQ

https://berty.tech/faq#what-are-the-advantages-of-berty-compared-to-the-other-messengers

## Competition: freie-messenger

https://freie-messenger.de/systemvergleich/

## Competition: Threema advertising FAQ

https://threema.ch/en/messenger-comparison

## Competition: eylenburg

https://eylenburg.github.io/im_comparison.htm

## Competition: SignalUsers fans wiki

https://community.signalusers.org/t/wiki-in-depth-feature-comparison-between-private-messaging-apps/12238

## Competition: JayXT

https://jayxt.github.io/MessengerComparison/en/

https://github.com/JayXT/MessengerComparison

> Q: Can you add messenger "A", etc.?
> Each new messenger will add one more column, which will make mobile table browsing experience worse. Presence of more than five messengers will noticably deteriorate desktop browsing experience.

## Competition: Wiki of Tox clients

https://wiki.tox.chat/include/clients_features

## Competition: PrivacyGuides

https://privacyguides.org/real-time-communication/

## Competition: DivestOS

The only tabular one that is usable on mobile!

https://divestos.org/index.php?page=messengers

## Competition: SecuShare

https://secushare.org/comparison

https://secushare.org/features

## Competition: bitmessage wiki

https://wiki.bitmessage.org/index.php/FAQ#How_does_Bitmessage_compare_to_other_messaging_methods

## Competition: PrivacyTests browsers

https://privacytests.org/

## Competition: digdeeper browsers

https://digdeeper.neocities.org/ghost/browsers.html

## Competition: acz shadow browsers

https://tilde.club/~acz/shadow_wiki/browsers.xhtml

## References

* Each cell value should be backed up by one or more URL
* To verify truthfulness
* Update after software is updated
* Reassess in case we want to split or reword the property
* Source for introducing new properties

## Features: Property and value details

* Each cell has a color status: green=good, yellow=intermediary, orange=bad
* May also have a few more words about specifics
* Should not stretch the cells layout too much
* You can expand a cell to see explanation and references

## Features: Dark mode

* If the browser indicates dark mode (or user clicks debug checkbox)
* Color scheme makes background darker and reduces contrast
* Lesson learned: test with forced night mode in Firefox

## Features: High contrast

* If the browser indicates high contrast mode (or user click debug checkbox)
* Everything turns black & white with bold typeface
* Status colors are replaced by consistent character markers: +, -, ~
* Desirable for the visual impaired and the color blind
* May be useful for printing as well

## Features: Restricted item comparison

* When no items (=messengers) are selected, all of them are displayed
* If one or more items are selected, only those columns are displayed in the table

## Features: Permalink

* If a single item is selected, an anchored permalink is also visible
* The permalink can be opened from another browser and will filter on the selected item
* Then all items can be shown by clicking a link at the top

## Features: Item category filter

* Shorthand presets to only display items within certain categories
* Could be extended, but at present: FOSS, Matrix, XMPP
* TODO: SIP, email, Tox, ActivityPub, ...

## Features: Sticky headers

* Both the column and the row headers stay visible when scrolling the table horizontally and vertically
* TODO: the control panel will also need work to be sticky and collapsible

## Features: Mobile friendly

* Explicit support for mobiles
* Headers remain sticky: this isn't trivial due to how the virtual viewport works
* Fonts remain legible
* The size of the headers and cells stay bounded to fit even the smallest screen
* Lesson learned: test with mobile mode of the Chromium developer tools

## Features: Abbreviated mode overview

* Hide content of every cell
* Only show colors and a single status character
* Rotate labels of the top headers by 45 degrees to fit more text
* Many more times of information is visible at a time
* TODO: should activate by default on small screens

## Features: Abbreviated mode hover

* Hovering over an abbreviated cell will reveal the details
* Expanding detailed explanations also works
* Touching a cell also works on touch screens
* Needed a little juggling to not obscure part of the content with the pointer

## Features: Transposed table

* Exchanges functionality of rows and columns
* TODO: Its stickiness broke just recently
* TODO: Will be integrated into property comparison mode

## Features: Property-judgment mapping

* The database contains objective applicability: fully, partially, none
* Visualization is based on subjective judgment: good, intermediary, bad
* Not all of the properties (rows) are interesting to everyone

## Features: Persona

* Model behavior of well defined subsets of users
* Determine which properties should be hidden for them
* Determine how important a given applicability is to them
* I.e., if a development related property only _partially_ applies, a less strict persona may still consider it "good" (green)

## Features: FOSS persona

## Features: Tinfoil persona

## Features: Layperson persona

## Features: Other suggested persona

* Private, Community, Public
* students and teachers within primary school education
* children of primary school age with friends & family
* teleworkers within colleagues and the company
* friends collaborating in the context of a shared interest group

## Features: Edit via JavaScript

* Viewing is full featured with CSS
* Changes shown as a raw textual patch diff
* Can be copy & pasted by a developer for publishing

## Implementation: Property syntax

CSV columns:

* property name
* detailed definition of meaning
* list of persona where it is mandatory (yes=good)
* list of persona where it is beneficial (>=partial=good)
* list of persona where it is informative (colorless)

## Implementation: Item syntax

CSV columns:

* property name
* status: yes, partial or no
* a few words of display mnemonics: URL's clickable
* detailed explanation: opens on interaction, URL's clickable

## Implementation: Command line helpers

* check-props.sh, check-item.sh: syntax
* new-item.sh: create new empty item listing all property keys
* extend-item.sh: add all property keys to existing item for extension
* reduce-item.sh: remove properties without value filled in
* generate-site.sh: produce HTML

## Implementation: Fixed HTML template

* Empty skeleton
* With manual CSS
* Some of the checkboxes and labels
* Detailed persona explanation
* An about page with developer notes and links to similar charts

## Implementation: Fixed styles

* For switching between the chart and the about page
* State based coloring, dark and high contrast mode
* Stickiness
* Alternating rows
* Transposition, explanation expansion

## Implementation: Generated HTML input fields

* Item filters controls and rules
* Permalinks

## Implementation: Generated table

## Implementation: Generated styles

* Item category filters
* TODO: move persona filter generation here

## Implementation: Abbreviated mode

* Chop overflow and make whitespace:nowrap in headers
* Undo some of the min-width details settings and alternation
* Hide original text and empty lines with font-size:0 and nowrap
* Prepend status character with padding
* Hover with z-index, position:absolute, padding, whitespace, background-color

## Implementation: GitLab CI

* call generate-site.sh
* compress with gzip and brotli

## Future: Item scoring

## Future: Item ranking, tiers

## Future: Rewrite in faster language

## Future: git API JavaScript editor

* Backup in LocalStorage
* Send in a change via integration with GitLab, GitHub, gitea

## Future: Data caching via JavaScript

* Using LocalStorage and client side generation
* Partial update based on separate files for items and properties

https://bkil.github.io/openscope-dict-eng-hun/

## Future: Pro & con view

* Present the same information in a different form
* For each item, gather all green properties in one section, all red in another

## Future: Property subset comparison

* Individual filters for each property
* Transpose table when only a few properties are selected

## Future: SCSS rewrite

## Future: Start evaluating remaining messengers

## Future: Generalize for other comparisons

* Social network services
* Web Browsers
* Email clients
* Content management systems
* ...
