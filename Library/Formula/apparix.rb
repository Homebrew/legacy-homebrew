require 'formula'

class Apparix < Formula
  url 'http://micans.org/apparix/src/apparix-11-062.tar.gz'
  homepage 'http://micans.org/apparix/'
  sha1 '44bb22cbaf33719e69d3aea2cdf2fd985fee4647'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
