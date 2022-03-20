# Ideas for the interface design

* `(x)`bright mode, `(_)`dark mode, `(_)`high contrast
* <em>(Perhaps some other comparison tables, e.g. Android forks, browsers)</em>
* Use case: `(x)`FOSS, `(_)`tinfoil, `(_)`layperson, `(_)`crowd, `[x]`all properties, `[_]`expand explanations, `[_]`abbreviated, `[_]`pro & con
* Protocol filter: `[_]`Matrix, `[_]`XMPP, `[_]`SIP, `[_]`email, `[_]`Tox, `[_]`ActivityPub
* License filter: `[_]`FOSS, `[_]`proprietary
* Topology filter: `[_]`anonymization, `[_]`DHT, `[_]`F2F, `[_]`cryptocurrency, `[_]`federated, `[_]`centralized
* Other filter: `[_]`non-textual only
* Compare messengers: `[_]` ... <em>(properties = rows, items = columns)</em>
* Compare properties: `[_]` ... <em>(properties = columns, items = rows if all messengers displayed)</em>
* This options panel should be sticky and have a minimize checkbox as well
* A JavaScript based editor that sends in a MR after you click in a cell
* default to abbreviated mode on mobile, e.g., &lt;576px
* Ranking: average of colors of the properties according to current view, green=100%, yellow=60%, red=10%, empty=0%, multiply by 0.5 if link missing
* Provide a way through which we can track when each cell was last reviewed and by which editors (could be tracked via a character using git history, a separate full review log CSV or a table of reviewer name vs. cell ID showing last review date)
