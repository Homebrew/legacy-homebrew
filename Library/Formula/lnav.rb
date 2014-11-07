require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/releases/download/v0.7.1/lnav-0.7.1.tar.gz'
  sha1 'c7ba019afd40742437211e4173e2a19f8971eb7f'

  head 'https://github.com/tstack/lnav.git'

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
