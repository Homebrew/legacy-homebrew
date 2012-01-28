require 'formula'

$commands = %w{
    base64 basename cat chcon chgrp chmod chown chroot cksum comm cp csplit
    cut date dd df dir dircolors dirname du echo env expand expr factor false
    fmt fold groups head hostid id install join kill link ln logname ls md5sum
    mkdir mkfifo mknod mktemp mv nice nl nohup od paste pathchk pinky pr
    printenv printf ptx pwd readlink rm rmdir runcon seq sha1sum sha225sum
    sha256sum sha384sum sha512sum shred shuf sleep sort split stat stty sum
    sync tac tail tee test touch tr true tsort tty uname unexpand uniq unlink
    uptime users vdir wc who whoami yes
    }

def coreutils_aliases
  s = "brew_prefix=`brew --prefix`\n"

  $commands.each do |g|
    s += "alias #{g}=\"$brew_prefix/bin/g#{g}\"\n"
  end

  s += "alias '['=\"$brew_prefix/bin/g\\[\"\n"

  return s
end

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.14.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.14.tar.xz'
  sha256 '0d120817c19292edb19e92ae6b8eac9020e03d51e0af9cb116cf82b65d18b02d'

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make install"

    # write an aliases file for shell
    (prefix+'aliases').write(coreutils_aliases)

    # create a gnubin dir that has all the commands without program-prefix
    mkdir_p libexec+'gnubin'
    $commands.each do |g|
      ln_sf "../../bin/g#{g}", libexec+"gnubin/#{g}"
    end
  end

  def caveats
    <<-EOS
All commands have been installed with the prefix 'g'.

If you really need to use these commands with their normal names, you
can add a "gnubin" directory to your PATH from your bashrc like:

    PATH="`brew --prefix coreutils`/libexec/gnubin:$PATH"

Previously, this was partially done with aliases but they are limited to
your shell and any script that requires GNU coreutils were broken.  This
file is provided not to break any bashrc of those who already uses it.

A file that aliases these commands to their normal names is available
and may be used in your bashrc like:

    source #{prefix}/aliases

But note that sourcing these aliases will cause them to be used instead
of Bash built-in commands, which may cause problems in shell scripts.
The Bash "printf" built-in behaves differently than gprintf, for instance,
which is known to cause problems with "bash-completion".

The man pages are still referenced with the g-prefix.
    EOS
  end
end
