require 'formula'

class Atf < Formula
  homepage 'https://github.com/jmmv/atf'
  url 'https://github.com/jmmv/atf/releases/download/atf-0.20/atf-0.20.tar.gz'
  sha1 '398baa9733f9136bb78c27d10a8fffd7810e678a'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system 'make'
    ENV.j1
    system 'make install'
  end
end
