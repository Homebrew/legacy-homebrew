require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.47.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.47.tar.gz'
  sha1 '0459608fdb37bc59605d7a476717693afd133e00'

  def install
    # Building the man pages requires DocBook, so we skip them.
    scripts = %w[chronic combine ts vidir vipe zrun]
    binaries = %w[isutf8 ifne pee sponge mispipe lckdo parallel]
    # Just `make all` will try to build the man pages.
    system "make", *binaries
    bin.install scripts + binaries
  end
end
