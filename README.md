<div>
<h2>README</h2>

<p>Members of the <a href="https://www.oasis-open.org/committees/virtio/">OASIS Virtual I/O Device (VIRTIO) TC</a> create and manage technical content in this TC GitHub repository ( <a href="https://github.com/oasis-tcs/virtio-spec">https://github.com/oasis-tcs/virtio-spec</a> ) as part of the TC's chartered work (<i>i.e.</i>, the program of work and deliverables described in its <a href="https://www.oasis-open.org/committees/virtio/charter.php">charter</a>).</p>

<p>OASIS TC GitHub repositories, as described in <a href="https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work">GitHub Repositories for OASIS TC Members' Chartered Work</a>, are governed by the OASIS <a href="https://www.oasis-open.org/policies-guidelines/tc-process">TC Process</a>, <a href="https://www.oasis-open.org/policies-guidelines/ipr">IPR Policy</a>, and other policies, similar to TC Wikis, TC JIRA issues tracking instances, TC SVN/Subversion repositories, etc.  While they make use of public GitHub repositories, these TC GitHub repositories are distinct from <a href="https://www.oasis-open.org/resources/open-repositories">OASIS Open Repositories</a>, which are used for development of open source <a href="https://www.oasis-open.org/resources/open-repositories/licenses">licensed</a> content.</p>
</div>

<div>
<h3>Description</h3>

<p>This repository includes the <a href="https://github.com/oasis-tcs/virtio-spec/releases">authoritative source</a> of the VIRTIO (Virtual I/O) Specification document. VIRTIO document describes the specifications of the "virtio" family of devices. These devices are found in virtual environments, yet by design they look like physical devices to the guest within the virtual machine &mdash; and this document treats them as such. This similarity allows the guest to use standard drivers and discovery mechanisms. </p>

<p>The purpose of virtio and this specification is that virtual environments and guests should have a straightforward, efficient, standard and extensible mechanism for virtual devices, rather than boutique per-environment or per-OS mechanisms.</p>
</div>

<div>
<h3>Contributions</h3>
<p>As stated in this repository's <a href="https://github.com/oasis-tcs/virtio-spec/blob/master/CONTRIBUTING.md">CONTRIBUTING file</a>, contributors to this repository are expected to be Members of the OASIS virtio TC, for any substantive change requests.  Anyone wishing to contribute to this GitHub project and <a href="https://www.oasis-open.org/join/participation-instructions">participate</a> in the TC's technical activity is invited to join as an OASIS TC Member.  Public feedback is also accepted, subject to the terms of the <a href="https://www.oasis-open.org/policies-guidelines/ipr#appendixa">OASIS Feedback License</a>.</p>
</div>



<div>
<h3>Licensing</h3>
<p>Please see the <a href="https://github.com/oasis-tcs/virtio-spec/blob/master/LICENSE.md">LICENSE</a> file for description of the license terms and OASIS policies applicable to the TC's work in this GitHub project. Content in this repository is intended to be part of the virtio TC's permanent record of activity, visible and freely available for all to use, subject to applicable OASIS policies, as presented in the repository <a href="https://github.com/oasis-tcs/virtio-spec/blob/master/LICENSE.md">LICENSE</a> file.</p>
</div>

<div>

<h3>Further Description of this Repository</h3>
<h4>Building Instructions</h4>
Authoritative version of the specification is maintained in the
TeX document format. PDF and HTML versions are made available for
ease of use and review.
In order to build the HTML and PDF versions of the spec you will need the
TeX document production system.
The easiest way to get it up and running is probably by installing
<a href="https://www.tug.org/texlive/">Tex-Live</a>.

<dl>Installation cheat sheet:
<dt>Fedora:</dt>
<dd>
<code>
sudo dnf install texlive-scheme-full
</code></dd>
<dt>
Ubuntu and other Debian derivatives:
</dt>
<dd>
<code>
sudo apt-get install texlive-full
</code></dd>
<dt>OSX:<dt>
<dd>OSX users don't need to install Tex-Live because they already have
<a href="http://www.tug.org/mactex/">MacTeX</a> installed.
</dd>
</dl>
<dl>The build process generates a ZIP package file including the
original TeX sources, as well as HTML and PDF formatted
versions of the specification.
<dt>To generate the ZIP package, run:<dt>
<dd>
<code>
./makeall.sh
</code>
</dd>
<dt>Troubleshooting notes:</dt>
<dd> PDFs of the specification can be generated with
either MicroSoft's Core fonts for the Web: Arial and Courier New,
or Liberation fonts: Liberation Sans and Liberation Mono.
Most systems come with one of these two variants included:
should you get an error message about missing fonts,
you will need to downloads and install one of the above
font packages.
<dd>
</dl>
<h4>Providing Feedback</h4>
Feedback must be provided the <strong>virtio-comment</strong> mailing list,
and archived in the mailing list archives.
<p>See <A
HREF="https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=virtio#feedback">
https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=virtio#feedback</A>
<p>Note that only plain text part of the message is archived, and all
attachments are stripped. Accordingly, messages sent to the
mailing list should use text/plain encoding and not
have any attachments.
<p>The preferred form of providing feedback is in form of a patch.
A patch can be generated and sent by cloning the spec repository,
creating a commit, formatting it as a patch and then sending it.
For example:
<code>
<p>
git clone https://github.com/oasis-tcs/virtio-spec.git<br>
... edit spec text, and save ...<br>
<p>
git commit -a<br>
... describe the proposed change, in the following format:<br>
single line summary<br>
<br>
detailed description, including motivation for the change<br>
<br>
Signed-off-by: Name &lt;email&gt;<br>
... then save and close the editor ... <br>
<p>
git format-patch -o proposal1/ HEAD~1..<br>
... generates a new directory proposal1/ and a file starting with 0001- ...<br>
<p>
git send-email --to=virtio-comment@lists.oasis-open.org proposal1/0001-*
</code>
<h4>Note for TC Members</h4>
<p>TC Members should review TC specific
process rules under "Further Description of this Repository"
in <A
HREF="https://github.com/oasis-tcs/virtio-admin">https://github.com/oasis-tcs/virtio-admin</A>.

</div>
<h4>Use of github issues</h4>
Note: according to the virtio TC rules, all official TC communication
is taking place on one of the TC mailing lists.
In particular, all comments must be provided on
one of the TC mailing lists. Accordingly, the TC will not respond
to comments provided in github issues: github issues are
used solely to track integration of comments into the
specification.<p>
To request a TC vote on resolving a specific comment:
<ol>
<li>Create a github issue, or edit an existing issue, with
a short summary of the comment.
The issue MUST specify
the link to the latest proposal in the TC mailing list
archives. <em>Note:</em> the link MUST be in the issue description itself -
<em>not</em> in the comments.</li>
<li>Reply by email to the comment email, requesting that the TC vote
on resolving the issue.
The mail requesting the vote should include the following, on a line by itself:<br>
<code>
Fixes: https://github.com/oasis-tcs/virtio-spec/issues/NNN
</code>
(NNN is the issue number)</li>
<li>Please make sure to allow time for review between posting a comment
and asking for a vote. </li>
</ol>
<h4>TC standing rules</h4>
The TC adopted the following standing rule:
<p>
<em>
Minor cleanups, including editorial formatting changes, spelling
and typo fixes can be committed directly into git for approval as
part of the next specification approval ballot.
</em>
<ol>
<li>To request such a commit, reply by email to the comment email, requesting that the
issue is resolved under the minor cleanups standing rule.
</li>
<li>Please make sure to allow time for review between posting a comment
and asking for a commit. </li>
</ol>

<h3>Contact</h3>
<p>Please send questions or comments about <a href="https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work">OASIS TC GitHub repositories</a> to <a href="mailto:robin@oasis-open.org">Robin Cover</a> and <a href="mailto:chet.ensign@oasis-open.org">Chet Ensign</a>.  For questions about content in this repository, please contact the TC Chair or Co-Chairs as listed on the the virtio TC's <a href="https://www.oasis-open.org/committees/virtio/">home page</a>.</p>
</div>
