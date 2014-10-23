require 'formula'

class Atf < Formula
  homepage 'https://github.com/jmmv/atf'
  url 'https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz'
  sha1 '7cc9d3703f7c0e00bb8ec801f7ac65ac9dc898d7'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system 'make'
    ENV.j1
    system 'make install'
  end
end
