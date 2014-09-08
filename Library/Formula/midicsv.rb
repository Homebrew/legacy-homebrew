require 'formula'

class Midicsv < Formula
  homepage 'http://www.fourmilab.ch/webtools/midicsv'
  url 'http://www.fourmilab.ch/webtools/midicsv/midicsv-1.1.tar.gz'
  sha1 '1f34b6b874c26652ec4791701e5bfdccbbb35370'

  def install
    system "make"
    system "make", "check"
    system "make", "install", "INSTALL_DEST=#{prefix}"
    share.install prefix/'man'
  end

  test do
    system "#{bin}/midicsv", "-u"
  end
end
