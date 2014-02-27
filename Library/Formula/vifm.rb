require 'formula'

class Vifm < Formula
  homepage 'http://vifm.sourceforge.net/index.html'
  url 'https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.7.6.tar.bz2'
  sha1 '2c9a57ec80a0c389c2807b5e86f25c2b8dd1c0cd'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
