require 'formula'

class Mpop < Formula
  homepage 'http://mpop.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mpop/mpop/1.0.27/mpop-1.0.27.tar.bz2'
  sha1 'ea9e190d8b7172e8c4c100e3f90d1840f3f8a259'

  depends_on 'pkg-config' => :build

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
