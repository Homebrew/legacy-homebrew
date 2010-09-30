require 'formula'

class Moreutils <Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.41.tar.gz'
  md5 '598c412bbc452b436becce8bd28df377'

  def install
    # Building the man pages requires DocBook, so we skip them.
    scripts = %w[combine ts vidir vipe zrun]
    binaries = %w[isutf8 ifne pee sponge mispipe lckdo parallel]
    # Just `make all` will try to build the man pages.
    system "make", *binaries
    bin.install scripts + binaries
  end
end
