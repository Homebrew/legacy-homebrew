require 'formula'

class Obby < Formula
  url 'http://releases.0x539.de/obby/obby-0.4.7.tar.gz'
  homepage 'http://gobby.0x539.de'
  md5 '33fac4228c1efc1a1635bacf6480dc31'

  depends_on 'pkg-config' => :build
  depends_on 'net6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
