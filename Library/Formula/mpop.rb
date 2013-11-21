require 'formula'

class Mpop < Formula
  homepage 'http://mpop.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mpop/mpop/1.0.28/mpop-1.0.28.tar.bz2'
  sha1 'bfc2447adb25081aacb6999c5badaf86d5a39741'

  depends_on 'pkg-config' => :build

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
