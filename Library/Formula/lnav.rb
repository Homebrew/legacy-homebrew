require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/releases/download/v0.7.0/lnav-0.7.0.tar.gz'
  sha1 '49334f3ffea752b9d7ce846757fc6ff78f123eb5'

  head 'https://github.com/tstack/lnav.git'

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
