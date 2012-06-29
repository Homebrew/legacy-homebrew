require 'formula'

class Libcmph < Formula
  homepage 'http://cmph.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz'
  sha1 'eabdd4cd9f9bb2fed6773caac8d91638ad2d02b7'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
