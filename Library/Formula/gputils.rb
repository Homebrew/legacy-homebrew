require 'formula'

class Gputils < Formula
  homepage 'http://gputils.sourceforge.net/'
  url 'http://sourceforge.net/projects/gputils/files/gputils/1.1.0/gputils-1.1.0.tar.gz'
  sha1 'c74105c93d0dee76e90e874b58d67235b00512f1'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
