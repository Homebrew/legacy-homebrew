# External Commands
Homebrew, like Git, supports *external commands*. This lets you create new commands that can be run like:

```
$ brew mycommand --option1 --option3 formula
```

without modifying Homebrew's internals.

## COMMAND TYPES
External commands come in two flavors: Ruby commands and shell scripts.

In both cases, the command file should be `chmod +x` (executable) and live somewhere in `$PATH`.

Internally, Homebrew finds commands with `which`(1).

### RUBY COMMANDS
An external command `extcmd` implemented as a Ruby command should be named `brew-extcmd.rb`. The command is executed by doing a `require` on the full pathname. As the command is `require`d, it has full access to the Homebrew "environment", i.e. all global variables and modules that any internal command has access to.

The command may `Kernel.exit` with a status code if it needs to; if it doesn't explicitly exit then Homebrew will return 0.

### SHELL SCRIPTS
A shell script for an command named `extcmd` should be named `brew-extcmd`. This file will be run via `exec` with some Homebrew variables set as environmental variables, and passed any additional command-line arguments.

<table>
  <tr>
    <td><strong>Variable</strong></td>
    <td><strong>Description</strong></td>
	</tr>
  <tr>
    <td>HOMEBREW_CACHE</td>
		<td>Where Homebrew caches downloaded tarballs to, typically <code>~/Library/Caches/Homebrew</code>. </td>
	</tr>
  <tr>
    <td>HOMEBREW_CELLAR</td>
		<td>The location of the Homebrew Cellar, where software is staged, by default <code>/usr/local/Cellar</code>.</td>
  </tr>
  <tr>
    <td>HOMEBREW_LIBRARY_PATH</td>
		<td>The directory containing Homebrew’s own application code.</td>
	</tr>
  <tr>
    <td>HOMEBREW_PREFIX</td>
		<td>Where Homebrew installs software to, by default <code>/usr/local</code>.</td>
	</tr>
  <tr>
    <td>HOMEBREW_REPOSITORY</td>
		<td>If installed from a Git clone, the repo directory (i.e., where Homebrew’s <code>.git</code> directory lives).</td>
  </tr>
</table>

Note that the script itself can use any suitable shebang (`#!`) line, so an external “shell script” can be written for sh, bash, Ruby, or anything else.

## USER-SUBMITTED COMMANDS
These commands have been contributed by Homebrew users but are not included in the main Homebrew repository, nor are they installed by the installer script. You can install them manually, as outlined above.

>*NOTE:* They are largely untested, and as always, be careful about running untested code on your machine.

### brew-cask

>Install .app and other "Drag to install" packages from Homebrew.
>
> https://github.com/caskroom/homebrew-cask
>
> Install using:
> ```
  $ brew tap caskroom/cask
  $ brew install brew-cask
> ```

### brew-desc
>Get short descriptions for Homebrew formulae or search formulae by description: [https://github.com/telemachus/brew-desc](https://github.com/telemachus/homebrew-desc)

>You can install manually or using `brew tap`:
> ```
> $ brew install telemachus/desc/brew-desc
> ```

### brew-gem and brew-pip
>Install any gem pip package into a self-contained Homebrew cellar location
>
>[https://github.com/josh/brew-gem](https://github.com/josh/brew-gem), [https://github.com/josh/brew-pip](https://github.com/josh/brew-pip)
>
>*Note:* These can also be installed with `brew install brew-gem` and `brew install brew-pip`

### brew-growl
>Get Growl notifications for Homebrew https://github.com/secondplanet/brew-growl

### brew-more
>Scrapes a formula's homepage to get more information: [https://gist.github.com/475200](https://gist.github.com/475200)

### brew-services
>Simple support to start formulae using launchctl, has out of the box support for any formula which defines `startup_plist` (e.g. mysql, postgres, redis u.v.m.): [https://gist.github.com/766293](https://gist.github.com/766293)

## SEE ALSO
Homebrew Docs: <https://github.com/Homebrew/homebrew/tree/master/share/doc/homebrew>

`brew`(1), `which`(1), `grep`(1), [`ronn`(1)](http://rtomayko.github.com/ronn/)
