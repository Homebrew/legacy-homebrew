require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/archive/v0.6.0.tar.gz'
  sha1 '5844c4da02842b059d4f969aa47d1f089926a096'

  head 'https://github.com/tstack/lnav.git'

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
