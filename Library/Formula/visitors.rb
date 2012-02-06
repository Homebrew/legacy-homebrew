require 'formula'

class Visitors < Formula
  url 'http://www.hping.org/visitors/visitors-0.7.tar.gz'
  homepage 'http://www.hping.org/visitors/'
  md5 '32ede76af83c6b1b7d2cdc5fe5178f6d'

  def install
    system "make"

    # There is no "make install", so do it manually
    bin.install "visitors"
    man1.install "visitors.1"
  end
end
