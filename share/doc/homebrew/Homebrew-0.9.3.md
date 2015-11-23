# Homebrew 0.9.3
## What is Superenv?

**Superenv** is an attempt to improve build-reliability and end-build-quality. It is:

* The user’s `PATH` is ignored. Thus, only tools we authorize can be used during builds<sup>[1](#_1)</sup>.
* `PATH` is reconstructed. For example: `/usr/local/Library/$ENV/4.3:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`.
* `/usr/local/Library/$ENV/4.3` (`superbin`<sup>[2](#_2)</sup>) contains wrapper-scripts for `cc`, etc.)
* We unset all build-related `ENV` variables.
* Build systems now pick their preferred compilers from `superbin`.
* `superbin` scripts are smart. They forcibly insert all include-paths and library-paths that Homebrew formulae need to compile, as well as remove flags that break builds.


## Rationale & Benefits

Because we are working with a practically virgin environment, we are essentially giving build-systems the kind of environments that the developers are using to build with. This makes them more reliable. By stepping  into the toolchain between the build-system and the compiler, we have complete control over the toolchain. We can prevent a good deal of breakage, and it ensures that Homebrew uses the same executables that the compiler sees (and not those bundled with the system).

So:

* We no longer worry about MacPorts/Fink being installed<sup>[0](#_0)</sup>
* We no longer worry about system duplicates<sup>[0](#_0)</sup>
* We override common tools and fix them—we no longer have to do so with workarounds in affected formula, waiting for a fix from Apple.
* Builds are forcibly optimized how we want, and debug info forcibly removed.

----

## Footnotes
<div style="color: #555; font-size: 85%">
  <ul>
    <li><a id="_0"><sup>0</sup></a>: Nearly as much, anyway.</li>
    <li><a id="_1"><sup>1</sup></a>: Formula can opt-into re-adding the user’s <code>PATH</code> again. Some formulae need this.</li>
    <li><a id="_2"><sup>2</sup></a>: Indeed; this is selected based on Xcode version.</li>
  </ul>
</div>
