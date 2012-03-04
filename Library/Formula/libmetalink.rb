require 'formula'

class Libmetalink < Formula
  homepage 'https://launchpad.net/libmetalink/'
  url 'https://launchpad.net/libmetalink/trunk/0.0.3/+download/libmetalink-0.0.3.tar.bz2'
  sha1 'a6b46d375791ebc2b478698a4268c4cbf2317706'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
