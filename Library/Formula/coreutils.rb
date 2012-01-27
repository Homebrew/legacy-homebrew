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

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.15.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.15.tar.xz'
  sha256 '837eb377414eae463fee17d0f77e6d76bed79b87bc97ef0c23887710107fd49c'

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make install"

    # create a gnubin dir that has all the commands without program-prefix
    mkdir_p libexec+'gnubin'
    $commands.each do |g|
      ln_sf "../../bin/g#{g}", libexec+"gnubin/#{g}"
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    EOS
  end
end
