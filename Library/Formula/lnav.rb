require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/releases/download/v0.6.2/lnav-0.6.2.tar.gz'
  sha1 'b3669fedffc724854e709750c0fd38d3930d0022'

  head 'https://github.com/tstack/lnav.git'

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
