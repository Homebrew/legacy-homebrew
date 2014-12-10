require 'formula'

class When < Formula
  homepage 'http://www.lightandmatter.com/when/when.html'
  url 'http://ftp.de.debian.org/debian/pool/main/w/when/when_1.1.33.orig.tar.gz'
  sha1 'e314a64d74f79be07da1ade6d39a1fc51205f81d'

  def install
    bin.install 'when'
    man1.install 'when.1'
  end
end
