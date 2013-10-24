require 'formula'

class Tarsnap < Formula
  homepage 'http://www.tarsnap.com/'
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz'
  sha256 '6c9f6756bc43bc225b842f7e3a0ec7204e0cf606e10559d27704e1cc33098c9a'

  depends_on 'xz' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end
end
