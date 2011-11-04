require 'formula'

def use_default_names?
  ARGV.include? '--default-names'
end

def coreutils_aliases
  s = "brew_prefix=`brew --prefix`\n"

  %w{
    base64 basename cat chcon chgrp chmod chown chroot cksum comm cp csplit
    cut date dd df dir dircolors dirname du echo env expand expr factor false
    fmt fold groups head hostid id install join kill link ln logname ls md5sum
    mkdir mkfifo mknod mktemp mv nice nl nohup od paste pathchk pinky pr
    printenv printf ptx pwd readlink rm rmdir runcon seq sha1sum sha225sum
    sha256sum sha384sum sha512sum shred shuf sleep sort split stat stty sum
    sync tac tail tee test touch tr true tsort tty uname unexpand uniq unlink
    uptime users vdir wc who whoami yes
    }.each do |g|
    s += "alias #{g}=\"$brew_prefix/bin/g#{g}\"\n"
  end

  s += "alias '['=\"$brew_prefix/bin/g\\[\"\n"

  return s
end

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.12.tar.gz'
  sha256 '9e233a62c98a3378a7b0483d2ae3d662dbaf6cd3917d3830d3514665e12a85c8'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" unless use_default_names?

    system "./configure", *args
    system "make install"

    (prefix+'aliases').write(coreutils_aliases)
  end

  def caveats
    unless use_default_names?; <<-EOS
All commands have been installed with the prefix 'g'.

A file that aliases these commands to their normal names is available
and may be used in your bashrc like:

    source #{prefix}/aliases

But note that sourcing these aliases will cause them to be used instead
of Bash built-in commands, which may cause problems in shell scripts.
The Bash "printf" built-in behaves differently than gprintf, for instance,
which is known to cause problems with "bash-completion".

The man pages are still referenced with the g-prefix.
    EOS
    else
      <<-EOS
Installing coreutils using the default names will cause the utilities to
shadow system-provided BSD tools if /usr/local/bin is ahead of /usr/bin in
the path.

This can cause problems in shell scripts.

Some software in Homebrew expects the system-provided tools to be first in
the path, and builds may fail if the coreutils verions are used instead.
      EOS
    end
  end
end
