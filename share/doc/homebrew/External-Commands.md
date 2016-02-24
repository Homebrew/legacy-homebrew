# External Commands
Homebrew, like Git, supports *external commands*. This lets you create new commands that can be run like:

```shell
$ brew mycommand --option1 --option3 formula
```

without modifying Homebrew's internals.

## COMMAND TYPES
External commands come in two flavors: Ruby commands and shell scripts.

In both cases, the command file should be executable (`chmod +x`) and live somewhere in `$PATH`.

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
		<td>Where Homebrew caches downloaded tarballs to, typically <code>/Library/Caches/Homebrew</code>. </td>
	</tr>
  <tr>
    <td>HOMEBREW_CELLAR</td>
		<td>The location of the Homebrew Cellar, where software is staged. This will be <code>$HOMEBREW_PREFIX/Cellar</code> if that directory exists, or <code>$HOMEBREW_REPOSITORY/Cellar</code> otherwise.</td>
  </tr>
  <tr>
    <td>HOMEBREW_LIBRARY_PATH</td>
		<td>The directory containing Homebrew’s own application code.</td>
	</tr>
  <tr>
    <td>HOMEBREW_PREFIX</td>
		<td>Where Homebrew installs software. This is always the grandparent directory of the `brew` executable, <code>/usr/local</code> by default.</td>
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

### brew-livecheck
> Check if there is a new upstream version of a formula.
>
> See the [`README`](https://github.com/youtux/homebrew-livecheck/blob/master/README.md) for more info and usage.
>
> Install using:
> ```
> $ brew tap youtux/livecheck
> ```

### brew-cask

>Install .app and other "Drag to install" packages from Homebrew.
>
> https://github.com/caskroom/homebrew-cask
>
> Install using:
> ```
  $ brew tap caskroom/cask
> ```

### brew-gem
>Install any gem package into a self-contained Homebrew cellar location: <https://github.com/sportngin/brew-gem>
>
>*Note:* This can also be installed with `brew install brew-gem`.

### brew-growl
>Get Growl notifications for Homebrew https://github.com/secondplanet/brew-growl

### brew-more
>Scrapes a formula's homepage to get more information: [https://gist.github.com/475200](https://gist.github.com/475200)

### brew-services
>Simple support to start formulae using launchctl, has out of the box support for any formula which defines `startup_plist` (e.g. mysql, postgres, redis u.v.m.): [https://github.com/gapple/homebrew-services](https://github.com/gapple/homebrew-services)

> Install using:
> ```
  $ brew tap gapple/services
> ```

## SEE ALSO
Homebrew Docs: <https://github.com/Homebrew/homebrew/tree/master/share/doc/homebrew>
