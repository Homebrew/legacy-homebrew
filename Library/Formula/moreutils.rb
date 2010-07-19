require 'formula'

class Moreutils <Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://ftp.debian.org/debian/pool/main/m/moreutils/moreutils_0.39.tar.gz'
  md5 '73477f418ea2de81a045019cc71267f3'

  def install
    # Building the man pages requires DocBook, so we skip them.
    scripts = %w[combine ts vidir vipe zrun]
    binaries = %w[isutf8 ifne pee sponge mispipe lckdo parallel]
    # Just `make all` will try to build the man pages.
    system "make", *binaries
    bin.install scripts + binaries
  end
end
