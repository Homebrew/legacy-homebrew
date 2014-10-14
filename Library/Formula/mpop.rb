require 'formula'

class Mpop < Formula
  homepage 'http://mpop.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mpop/mpop/1.0.29/mpop-1.0.29.tar.bz2'
  sha1 '489ff6ae4d662af4179d9affc86e79db94ed95b5'

  depends_on 'pkg-config' => :build

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
