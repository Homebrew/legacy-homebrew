require 'formula'

class Tarsnap < Formula
  homepage 'http://www.tarsnap.com/'
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.33.tgz'
  sha256 '0c0d825a8c9695fc8d44c5d8c3cd17299c248377c9c7b91fdb49d73e54ae0b7d'

  depends_on 'xz' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end
end
