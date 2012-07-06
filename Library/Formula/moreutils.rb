require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.46.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.46.tar.gz'
  md5 '658f9cc6b6dcc0b50dcff714e13b22dc'

  def install
    # Building the man pages requires DocBook, so we skip them.
    scripts = %w[chronic combine ts vidir vipe zrun]
    binaries = %w[isutf8 ifne pee sponge mispipe lckdo parallel]
    # Just `make all` will try to build the man pages.
    system "make", *binaries
    bin.install scripts + binaries
  end
end
