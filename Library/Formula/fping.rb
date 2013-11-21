require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'http://fping.org/dist/fping-3.8.tar.gz'
  sha1 '1aad76c065d4049ca6c5c1b4de82c13f4529a201'

  head 'https://github.com/schweikert/fping.git'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ipv6"
    system "make install"
  end

end
