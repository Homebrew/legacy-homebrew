require 'formula'

class Visitors < Formula
  homepage 'http://www.hping.org/visitors/'
  url 'http://www.hping.org/visitors/visitors-0.7.tar.gz'
  sha1 'cdccdfb82001c7c3dadf68456574cac1a5d941e3'

  def install
    system "make"

    # There is no "make install", so do it manually
    bin.install "visitors"
    man1.install "visitors.1"
  end
end
