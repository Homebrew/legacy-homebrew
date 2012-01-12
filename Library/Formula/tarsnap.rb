require 'formula'

class Tarsnap < Formula
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.31.tgz'
  homepage 'http://www.tarsnap.com/'
  sha256 '3b461e1e76b92c1538a6322d8dbaa8e5285dae2029b4470357cb57e321625d95'

  depends_on 'xz' => :optional

  fails_with_llvm "Compilation hangs."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end
end
