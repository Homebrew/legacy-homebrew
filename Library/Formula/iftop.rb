require 'formula'

# Version is "pre-release", but is what Debian, MacPorts, etc.
# package, and upstream has not had any movement in a long time.
class Iftop < Formula
  desc "Display an interface's bandwidth usage"
  homepage 'http://www.ex-parrot.com/~pdw/iftop/'
  url 'http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz'
  version '1.0pre4'
  sha1 '7f8e16ea26a0dee37ec9d1cbcef7b27692036572'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    iftop requires root privileges so you will need to run `sudo iftop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
