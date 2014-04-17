require 'formula'

class When < Formula
  homepage 'http://www.lightandmatter.com/when/when.html'
  url 'http://ftp.de.debian.org/debian/pool/main/w/when/when_1.1.31.orig.tar.gz'
  sha1 '1bd6d8e1cb40ccc30a61ac8b22376d42fe6b2f2b'

  def install
    bin.install 'when'
    man1.install 'when.1'
  end
end
