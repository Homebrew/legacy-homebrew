require 'formula'

class Lnav < Formula
  homepage 'http://tstack.github.io/lnav/'
  url 'http://lnav.org/downloads/lnav-0.5.0.tar.bz2'
  sha1 '8d68cb8b46878b2a54e9004a1f4994b07772b8b0'

  head 'https://github.com/tstack/lnav.git'

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
